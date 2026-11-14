#include "raasta/services/graph_builder_service.hpp"
#include "raasta/repository/station_repository.hpp"
#include <iostream>
#include <fstream>
#include <sstream>
#include <unordered_map>
#include <unordered_set>
#include <cmath>

namespace raasta {
namespace services {

static double haversineDistanceKm(double lat1, double lon1, double lat2, double lon2) {
    constexpr double R = 6371.0;
    double dLat = (lat2 - lat1) * M_PI / 180.0;
    double dLon = (lon2 - lon1) * M_PI / 180.0;
    double a = std::sin(dLat / 2.0) * std::sin(dLat / 2.0) +
               std::cos(lat1 * M_PI / 180.0) * std::cos(lat2 * M_PI / 180.0) *
               std::sin(dLon / 2.0) * std::sin(dLon / 2.0);
    double c = 2.0 * std::atan2(std::sqrt(a), std::sqrt(1.0 - a));
    return R * c;
}

static double estimateTravelTimeMin(int transport_type_id, double distance_km) {
    if (transport_type_id == 0) { // Walk
        return std::max(2.0, (distance_km / 4.5) * 60.0);
    } else if (transport_type_id == 1) { // Metro
        return (distance_km / 33.0) * 60.0 + 0.5;
    } else if (transport_type_id == 2) { // Bus
        return (distance_km / 20.0) * 60.0 + 1.0;
    } else if (transport_type_id == 3) { // Rail
        return (distance_km / 55.0) * 60.0 + 2.0;
    } else if (transport_type_id == 4) { // RRTS
        return (distance_km / 95.0) * 60.0 + 0.5;
    }
    return (distance_km / 30.0) * 60.0;
}

GraphBuilderService::GraphBuilderService(repository::DbConnection& db)
    : db_(db) {}

void GraphBuilderService::buildGraph(graph::TransportGraph& graph, const std::string& data_dir) {
    if (db_.isConnected()) {
        std::cout << "[graph_builder] Loading stations from database...\n";
        loadStations(graph);
        
        std::cout << "[graph_builder] Loading connections from database...\n";
        loadConnections(graph);
        
        std::cout << "[graph_builder] Loading interchange connections from database...\n";
        loadInterchanges(graph);
    } else {
        std::cout << "[graph_builder] Database offline. Loading verified datasets directly from " << data_dir << "...\n";
        loadFromCsv(graph, data_dir);
    }
    
    std::cout << "[graph_builder] Graph build complete: "
              << graph.stationCount() << " stations, "
              << graph.edgeCount() << " edges.\n";
}

void GraphBuilderService::rebuildGraph(graph::TransportGraph& graph, const std::string& data_dir) {
    graph.clear();
    buildGraph(graph, data_dir);
}

void GraphBuilderService::loadStations(graph::TransportGraph& graph) {
    repository::StationRepository repo(db_);
    auto stations = repo.findAll(true);
    for (const auto& s : stations) {
        graph.addStation(s);
    }
}

void GraphBuilderService::loadConnections(graph::TransportGraph& graph) {
    std::string sql =
        "SELECT c.*, tl.name AS line_name, tl.color AS line_color, tt.name AS transport_type_name "
        "FROM connections c "
        "LEFT JOIN transport_lines tl ON c.line_id = tl.id "
        "LEFT JOIN transport_types tt ON c.transport_type_id = tt.id "
        "WHERE c.is_active = 1";
        
    auto rows = db_.query(sql);
    for (const auto& r : rows) {
        auto get = [&](const std::string& k) -> std::string {
            auto it = r.find(k);
            return (it != r.end()) ? it->second : "";
        };
        auto getInt = [&](const std::string& k) {
            auto v = get(k); return v.empty() ? 0 : std::stoi(v);
        };
        auto getDbl = [&](const std::string& k) {
            auto v = get(k); return v.empty() ? 0.0 : std::stod(v);
        };

        int from_id = getInt("from_station_id");
        int to_id = getInt("to_station_id");
        bool is_bidi = get("is_bidirectional") != "0";

        graph::GraphEdge edge;
        edge.to_station_id = to_id;
        edge.connection_id = getInt("id");
        edge.transport_type_id = getInt("transport_type_id");
        edge.line_id = getInt("line_id");
        edge.distance_km = getDbl("distance_km");
        edge.travel_time_min = getDbl("estimated_travel_time_min");
        edge.fare = 0.0;
        edge.is_transfer = false;
        edge.line_name = get("line_name");
        edge.transport_type_name = get("transport_type_name");
        edge.line_color = get("line_color");

        if (is_bidi) {
            graph.addBidirectionalEdge(from_id, to_id, edge);
        } else {
            graph.addEdge(from_id, edge);
        }
    }
}

void GraphBuilderService::loadInterchanges(graph::TransportGraph& graph) {
    std::string sql =
        "SELECT ic.*, tl_from.name AS from_line_name, tl_to.name AS to_line_name "
        "FROM interchange_connections ic "
        "LEFT JOIN transport_lines tl_from ON ic.from_line_id = tl_from.id "
        "LEFT JOIN transport_lines tl_to ON ic.to_line_id = tl_to.id "
        "WHERE ic.is_active = 1";
        
    auto rows = db_.query(sql);
    for (const auto& r : rows) {
        auto get = [&](const std::string& k) -> std::string {
            auto it = r.find(k);
            return (it != r.end()) ? it->second : "";
        };
        auto getInt = [&](const std::string& k) {
            auto v = get(k); return v.empty() ? 0 : std::stoi(v);
        };
        auto getDbl = [&](const std::string& k) {
            auto v = get(k); return v.empty() ? 0.0 : std::stod(v);
        };

        int from_id = getInt("from_station_id");
        int to_id = getInt("to_station_id");

        graph::GraphEdge edge;
        edge.to_station_id = to_id;
        edge.connection_id = getInt("id");
        edge.transport_type_id = 0; // Transfer
        edge.line_id = getInt("to_line_id");
        edge.distance_km = getInt("walking_distance_m") / 1000.0;
        edge.travel_time_min = getDbl("transfer_time_min");
        if (edge.travel_time_min <= 0.0) edge.travel_time_min = 5.0;
        edge.fare = 0.0;
        edge.is_transfer = true;
        edge.line_name = "Transfer";
        edge.transport_type_name = "Interchange";
        edge.line_color = "#999999";

        graph.addEdge(from_id, edge);
    }
}

void GraphBuilderService::loadFromCsv(graph::TransportGraph& graph, const std::string& data_dir) {
    // Robust directory resolution
    std::string prefix = data_dir;
    std::vector<std::string> candidates = {
        data_dir,
        "../" + data_dir,
        "data",
        "../data",
        "../../data"
    };
    for (const auto& c : candidates) {
        std::ifstream test(c + "/metro/metro_stations.csv");
        if (test.is_open()) {
            prefix = c;
            break;
        }
    }

    std::unordered_map<std::string, int> code_to_id;
    int next_id = 1;

    auto parseCsvLine = [](const std::string& line) -> std::vector<std::string> {
        std::vector<std::string> tokens;
        std::string token;
        bool in_quotes = false;
        for (char c : line) {
            if (c == '"') {
                in_quotes = !in_quotes;
            } else if (c == ',' && !in_quotes) {
                tokens.push_back(token);
                token.clear();
            } else {
                token += c;
            }
        }
        tokens.push_back(token);
        return tokens;
    };

    // Restrict the CSV network to Delhi NCR cities.
    auto isDelhiNcrCity = [](const std::string& city) {
        static const std::unordered_set<std::string> allowedCities = {
            "Delhi",
            "Noida",
            "Greater Noida",
            "Ghaziabad",
            "Modinagar",
            "Gurugram",
            "Faridabad",
            "Ballabhgarh",
            "Bahadurgarh",
            "Meerut"
        };
        return allowedCities.find(city) != allowedCities.end();
    };

    // 1. Load Metro Stations
    {
        std::ifstream f(prefix + "/metro/metro_stations.csv");
        if (f.is_open()) {
            std::string line;
            std::getline(f, line); // header
            while (std::getline(f, line)) {
                if (line.empty()) continue;
                auto toks = parseCsvLine(line);
                if (toks.size() < 6) continue;
                models::Station s;
                s.id = next_id++;
                s.code = toks[0];
                s.name = toks[1];
                try {
                    s.latitude = std::stod(toks[3]);
                    s.longitude = std::stod(toks[4]);
                } catch (...) { continue; }
                s.station_type = "metro_station";
                s.city_name = toks[5];
                if (!isDelhiNcrCity(s.city_name)) continue;
                s.is_interchange = (toks.size() > 8 && toks[8] == "1");
                s.data_status = "verified";

                code_to_id[s.code] = s.id;
                graph.addStation(s);
            }
        }
    }

    // 2. Load RRTS Stations
    {
        std::ifstream f(prefix + "/namo_bharat/rrts_stations.csv");
        if (f.is_open()) {
            std::string line;
            std::getline(f, line);
            while (std::getline(f, line)) {
                if (line.empty()) continue;
                auto toks = parseCsvLine(line);
                if (toks.size() < 6) continue;
                models::Station s;
                s.id = next_id++;
                s.code = toks[0];
                s.name = toks[1];
                try {
                    s.latitude = std::stod(toks[3]);
                    s.longitude = std::stod(toks[4]);
                } catch (...) { continue; }
                s.station_type = "rrts_station";
                s.city_name = toks[5];
                if (!isDelhiNcrCity(s.city_name)) continue;
                s.is_interchange = (toks.size() > 8 && toks[8] == "1");
                s.data_status = "verified";

                code_to_id[s.code] = s.id;
                graph.addStation(s);
            }
        }
    }

    // 3. Load Railway Stations
    {
        std::ifstream f(prefix + "/railway/railway_stations.csv");
        if (f.is_open()) {
            std::string line;
            std::getline(f, line);
            while (std::getline(f, line)) {
                if (line.empty()) continue;
                auto toks = parseCsvLine(line);
                if (toks.size() < 6) continue;
                models::Station s;
                s.id = next_id++;
                s.code = toks[0];
                s.name = toks[1];
                try {
                    s.latitude = std::stod(toks[3]);
                    s.longitude = std::stod(toks[4]);
                } catch (...) { continue; }
                s.station_type = "railway_station";
                s.city_name = toks[5];
                if (!isDelhiNcrCity(s.city_name)) continue;
                s.is_interchange = (toks.size() > 9 && toks[9] == "1");
                s.data_status = "verified";

                code_to_id[s.code] = s.id;
                graph.addStation(s);
            }
        }
    }

    // 4. Load Bus Stops
    {
        std::ifstream f(prefix + "/bus/bus_stops_sample.csv");
        if (f.is_open()) {
            std::string line;
            std::getline(f, line);
            while (std::getline(f, line)) {
                if (line.empty()) continue;
                auto toks = parseCsvLine(line);
                if (toks.size() < 5) continue;
                models::Station s;
                s.id = next_id++;
                s.code = toks[0];
                s.name = toks[1];
                try {
                    s.latitude = std::stod(toks[2]);
                    s.longitude = std::stod(toks[3]);
                } catch (...) { continue; }
                s.station_type = "bus_stop";
                s.city_name = toks[4];
                if (!isDelhiNcrCity(s.city_name)) continue;
                s.is_interchange = (toks.size() > 7 && toks[7] == "1");
                s.data_status = "verified";

                code_to_id[s.code] = s.id;
                graph.addStation(s);
            }
        }
    }

    int conn_counter = 1;

    // 5. Load Metro Connections
    {
        std::ifstream f(prefix + "/metro/metro_connections.csv");
        if (f.is_open()) {
            std::string line;
            std::getline(f, line);
            while (std::getline(f, line)) {
                if (line.empty()) continue;
                auto toks = parseCsvLine(line);
                if (toks.size() < 5) continue;
                auto f_it = code_to_id.find(toks[0]);
                auto t_it = code_to_id.find(toks[1]);
                if (f_it == code_to_id.end() || t_it == code_to_id.end()) continue;

                graph::GraphEdge edge;
                edge.to_station_id = t_it->second;
                edge.connection_id = conn_counter++;
                edge.transport_type_id = 1; // Metro
                edge.line_name = toks[2];
                edge.transport_type_name = "Metro";
                edge.distance_km = std::stod(toks[3]);
                edge.travel_time_min = std::stod(toks[4]);
                edge.fare = 0.0;
                edge.is_transfer = false;

                bool is_bidi = (toks.size() > 5 && toks[5] == "1");
                if (is_bidi) {
                    graph.addBidirectionalEdge(f_it->second, t_it->second, edge);
                } else {
                    graph.addEdge(f_it->second, edge);
                }
            }
        }
    }

    // 6. Load RRTS Connections
    {
        std::ifstream f(prefix + "/namo_bharat/rrts_connections.csv");
        if (f.is_open()) {
            std::string line;
            std::getline(f, line);
            while (std::getline(f, line)) {
                if (line.empty()) continue;
                auto toks = parseCsvLine(line);
                if (toks.size() < 5) continue;
                auto f_it = code_to_id.find(toks[0]);
                auto t_it = code_to_id.find(toks[1]);
                if (f_it == code_to_id.end() || t_it == code_to_id.end()) continue;

                graph::GraphEdge edge;
                edge.to_station_id = t_it->second;
                edge.connection_id = conn_counter++;
                edge.transport_type_id = 4; // RRTS
                edge.line_name = "Delhi–Meerut RRTS";
                edge.transport_type_name = "Namo Bharat (RRTS)";
                edge.distance_km = std::stod(toks[3]);
                edge.travel_time_min = std::stod(toks[4]);
                edge.fare = 0.0;
                edge.is_transfer = false;

                bool is_bidi = (toks.size() > 5 && toks[5] == "1");
                if (is_bidi) {
                    graph.addBidirectionalEdge(f_it->second, t_it->second, edge);
                } else {
                    graph.addEdge(f_it->second, edge);
                }
            }
        }
    }

    // 7. Load Railway Connections
    {
        std::ifstream f(prefix + "/railway/railway_connections.csv");
        if (f.is_open()) {
            std::string line;
            std::getline(f, line);
            while (std::getline(f, line)) {
                if (line.empty()) continue;
                auto toks = parseCsvLine(line);
                if (toks.size() < 5) continue;
                auto f_it = code_to_id.find(toks[0]);
                auto t_it = code_to_id.find(toks[1]);
                if (f_it == code_to_id.end() || t_it == code_to_id.end()) continue;

                graph::GraphEdge edge;
                edge.to_station_id = t_it->second;
                edge.connection_id = conn_counter++;
                edge.transport_type_id = 3; // Railway
                edge.line_name = toks[2];
                edge.transport_type_name = "Indian Railways";
                edge.distance_km = std::stod(toks[3]);
                edge.travel_time_min = std::stod(toks[4]);
                edge.fare = 0.0;
                edge.is_transfer = false;

                graph.addBidirectionalEdge(f_it->second, t_it->second, edge);
            }
        }
    }

    // 8. Load Bus Connections
    {
        std::ifstream f(prefix + "/bus/bus_connections.csv");
        if (f.is_open()) {
            std::string line;
            std::getline(f, line);
            while (std::getline(f, line)) {
                if (line.empty()) continue;
                auto toks = parseCsvLine(line);
                if (toks.size() < 5) continue;
                auto f_it = code_to_id.find(toks[0]);
                auto t_it = code_to_id.find(toks[1]);
                if (f_it == code_to_id.end() || t_it == code_to_id.end()) continue;

                graph::GraphEdge edge;
                edge.to_station_id = t_it->second;
                edge.connection_id = conn_counter++;
                edge.transport_type_id = 2; // Bus
                edge.line_name = toks[2];
                edge.transport_type_name = "Bus";
                edge.distance_km = std::stod(toks[3]);
                edge.travel_time_min = std::stod(toks[4]);
                edge.fare = 0.0;
                edge.is_transfer = false;

                graph.addBidirectionalEdge(f_it->second, t_it->second, edge);
            }
        }
    }

    // 9. Load Multimodal Interchange Connections
    {
        std::ifstream f(prefix + "/interchanges/interchange_connections.csv");
        if (f.is_open()) {
            std::string line;
            std::getline(f, line);
            while (std::getline(f, line)) {
                if (line.empty()) continue;
                auto toks = parseCsvLine(line);
                if (toks.size() < 4) continue;
                auto f_it = code_to_id.find(toks[0]);
                auto t_it = code_to_id.find(toks[1]);
                if (f_it == code_to_id.end() || t_it == code_to_id.end()) continue;

                graph::GraphEdge edge;
                edge.to_station_id = t_it->second;
                edge.connection_id = conn_counter++;
                edge.transport_type_id = 0; // Walk / Transfer
                edge.line_name = "Interchange Transfer (" + (toks.size() > 4 ? toks[4] : "Walking") + ")";
                edge.transport_type_name = "Transfer";
                edge.distance_km = std::stod(toks[2]);
                edge.travel_time_min = std::stod(toks[3]);
                edge.fare = 0.0;
                edge.is_transfer = true;

                graph.addBidirectionalEdge(f_it->second, t_it->second, edge);
            }
        }
    }
}

} // namespace services
} // namespace raasta
