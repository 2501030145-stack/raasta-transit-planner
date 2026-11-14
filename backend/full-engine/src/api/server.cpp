#include "raasta/api/server.hpp"
#include "raasta/repository/station_repository.hpp"
#include "raasta/repository/connection_repository.hpp"
#include "raasta/services/graph_builder_service.hpp"
#include <nlohmann/json.hpp>
#include <iostream>

using json = nlohmann::json;

namespace raasta {
namespace api {

Server::Server(
    const config::Config& config,
    repository::DbConnection& db,
    graph::TransportGraph& graph,
    std::shared_ptr<services::RouteService> route_service,
    std::shared_ptr<services::FareService> fare_service
) : config_(config),
    db_(db),
    graph_(graph),
    route_service_(std::move(route_service)),
    fare_service_(std::move(fare_service)) {
    setupCors();
    registerRoutes();
}

Server::~Server() {
    stop();
}

void Server::setupCors() {
    svr_.set_pre_routing_handler([this](const httplib::Request& req, httplib::Response& res) {
        std::string origin = req.get_header_value("Origin");
        std::string allowed_origin = config_.cors_origin;

        // Production origin for Manus frontend
        const std::string manus_origin = "https://raasta-mpxyck7w.manus.space";

        if (origin == manus_origin) {
            allowed_origin = manus_origin;
        } else if (origin.find("http://localhost:") == 0 || origin.find("http://127.0.0.1:") == 0 ||
                   origin == "http://localhost" || origin == "http://127.0.0.1") {
            // Allow localhost origins for local development
            allowed_origin = origin;
        } else if (!config_.cors_origin.empty() && config_.cors_origin != "*") {
            allowed_origin = config_.cors_origin;
        } else {
            allowed_origin = manus_origin;
        }

        res.set_header("Access-Control-Allow-Origin", allowed_origin);
        res.set_header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        res.set_header("Access-Control-Allow-Headers", "Content-Type, Authorization, X-Requested-With, X-Admin-Key");
        res.set_header("Access-Control-Max-Age", "86400");
        res.set_header("Vary", "Origin");

        if (req.method == "OPTIONS") {
            res.status = 204;
            return httplib::Server::HandlerResponse::Handled;
        }
        return httplib::Server::HandlerResponse::Unhandled;
    });
}

bool Server::authenticateAdmin(const httplib::Request& req, httplib::Response& res) {
    std::string auth_header = req.get_header_value("Authorization");
    std::string expected_bearer = "Bearer " + config_.admin_jwt_secret;
    std::string key_header = req.get_header_value("X-Admin-Key");

    if (auth_header == expected_bearer || key_header == config_.admin_jwt_secret) {
        return true;
    }

    // Also allow if admin_jwt_secret is default during local development
    if (config_.admin_jwt_secret == "default_secret_change_me" &&
        (auth_header == "Bearer admin" || key_header == "admin")) {
        return true;
    }

    json err;
    err["success"] = false;
    err["error"] = "Unauthorized. Admin authentication required.";
    res.status = 401;
    res.set_content(err.dump(), "application/json");
    return false;
}

void Server::registerRoutes() {
    // ── Health Check ───────────────────────────────────────
    auto health_handler = [this](const httplib::Request&, httplib::Response& res) {
        json j;
        j["status"] = "ok";
        j["service"] = "raasta-backend";
        j["version"] = "1.0.0";
        j["scope"] = "Delhi NCR";
        j["database_connected"] = db_.isConnected();
        j["network"]["stations"] = graph_.stationCount();
        j["network"]["edges"] = graph_.edgeCount();
        res.set_content(j.dump(), "application/json");
    };

    svr_.Get("/health", health_handler);
    svr_.Get("/api/health", health_handler);
    svr_.Get("/api/v1/health", health_handler);

    // ── Stations Endpoints ─────────────────────────────────
    auto stations_handler = [this](const httplib::Request& req, httplib::Response& res) {
        json j;
        if (db_.isConnected()) {
            repository::StationRepository repo(db_);
            std::vector<models::Station> stations;
            if (req.has_param("type")) {
                stations = repo.findByType(req.get_param_value("type"));
            } else if (req.has_param("city_id")) {
                stations = repo.findByCity(std::stoi(req.get_param_value("city_id")));
            } else if (req.has_param("line_id")) {
                stations = repo.findByLine(std::stoi(req.get_param_value("line_id")));
            } else {
                stations = repo.findAll(true);
            }

            json arr = json::array();
            for (const auto& s : stations) {
                arr.push_back(s.to_json());
            }
            j["success"] = true;
            j["count"] = arr.size();
            j["stations"] = arr;
        } else {
            // Fall back to in-memory graph stations
            json arr = json::array();
            for (int sid : graph_.getAllStationIds()) {
                arr.push_back(graph_.getStation(sid).to_json());
            }
            j["success"] = true;
            j["count"] = arr.size();
            j["stations"] = arr;
        }
        res.set_content(j.dump(), "application/json");
    };
    svr_.Get("/api/stations", stations_handler);
    svr_.Get("/api/v1/stations", stations_handler);

    auto stations_search_handler = [this](const httplib::Request& req, httplib::Response& res) {
        std::string query = req.get_param_value("q");
        int limit = req.has_param("limit") ? std::stoi(req.get_param_value("limit")) : 20;

        json j;
        if (query.empty()) {
            j["success"] = false;
            j["error"] = "Query parameter 'q' is required";
            res.status = 400;
            res.set_content(j.dump(), "application/json");
            return;
        }

        if (db_.isConnected()) {
            repository::StationRepository repo(db_);
            auto matches = repo.search(query, limit);
            json arr = json::array();
            for (const auto& s : matches) {
                arr.push_back(s.to_json());
            }
            j["success"] = true;
            j["count"] = arr.size();
            j["query"] = query;
            j["stations"] = arr;
        } else {
            // In-memory case-insensitive search
            std::string q_lower = query;
            std::transform(q_lower.begin(), q_lower.end(), q_lower.begin(), ::tolower);
            json arr = json::array();
            for (int sid : graph_.getAllStationIds()) {
                const auto& s = graph_.getStation(sid);
                std::string name_lower = s.name;
                std::transform(name_lower.begin(), name_lower.end(), name_lower.begin(), ::tolower);
                std::string code_lower = s.code;
                std::transform(code_lower.begin(), code_lower.end(), code_lower.begin(), ::tolower);
                if (name_lower.find(q_lower) != std::string::npos || code_lower.find(q_lower) != std::string::npos) {
                    arr.push_back(s.to_json());
                    if (static_cast<int>(arr.size()) >= limit) break;
                }
            }
            j["success"] = true;
            j["count"] = arr.size();
            j["query"] = query;
            j["stations"] = arr;
        }
        res.set_content(j.dump(), "application/json");
    };
    svr_.Get("/api/stations/search", stations_search_handler);
    svr_.Get("/api/v1/stations/search", stations_search_handler);

    // ── Transport Types & Lines ────────────────────────────
    auto transport_types_handler = [this](const httplib::Request&, httplib::Response& res) {
        json j;
        if (db_.isConnected()) {
            auto rows = db_.query("SELECT * FROM transport_types ORDER BY id");
            json arr = json::array();
            for (const auto& r : rows) {
                json item;
                for (const auto& [k, v] : r) item[k] = v;
                arr.push_back(item);
            }
            j["success"] = true;
            j["transport_types"] = arr;
        } else {
            json arr = json::array({
                {{"id", 1}, {"name", "Metro"}, {"code", "metro"}, {"description", "Urban metro rail systems"}},
                {{"id", 2}, {"name", "Bus"}, {"code", "bus"}, {"description", "City and intercity bus services"}},
                {{"id", 3}, {"name", "Indian Railways"}, {"code", "railway"}, {"description", "Indian Railways train services"}},
                {{"id", 4}, {"name", "Namo Bharat (RRTS)"}, {"code", "rrts"}, {"description", "Regional Rapid Transit System"}}
            });
            j["success"] = true;
            j["transport_types"] = arr;
        }
        res.set_content(j.dump(), "application/json");
    };
    svr_.Get("/api/transport-types", transport_types_handler);
    svr_.Get("/api/v1/transport-types", transport_types_handler);

    auto lines_handler = [this](const httplib::Request& req, httplib::Response& res) {
        json j;
        if (db_.isConnected()) {
            repository::LineRepository repo(db_);
            std::vector<models::TransportLine> lines;
            if (req.has_param("type_id")) {
                lines = repo.findByTransportType(std::stoi(req.get_param_value("type_id")));
            } else {
                lines = repo.findAll(true);
            }
            json arr = json::array();
            for (const auto& l : lines) arr.push_back(l.to_json());
            j["success"] = true;
            j["count"] = arr.size();
            j["lines"] = arr;
        } else {
            j["success"] = true;
            j["count"] = 0;
            j["lines"] = json::array();
        }
        res.set_content(j.dump(), "application/json");
    };
    svr_.Get("/api/lines", lines_handler);
    svr_.Get("/api/v1/lines", lines_handler);

    // ── Routes Overview ────────────────────────────────────
    auto routes_overview_handler = [this](const httplib::Request&, httplib::Response& res) {
        json j;
        if (db_.isConnected()) {
            repository::LineRepository repo(db_);
            auto lines = repo.findAll(true);
            json arr = json::array();
            for (const auto& l : lines) arr.push_back(l.to_json());
            j["success"] = true;
            j["routes"] = arr;
        } else {
            j["success"] = true;
            j["routes"] = json::array();
        }
        res.set_content(j.dump(), "application/json");
    };
    svr_.Get("/api/routes", routes_overview_handler);
    svr_.Get("/api/v1/routes", routes_overview_handler);

    // ── Routing Engine Endpoints ───────────────────────────
    auto route_handler = [this](const httplib::Request& req, httplib::Response& res) {
        try {
            auto body = json::parse(req.body);
            services::RouteRequest rreq;

            if (!body.contains("source_station_id") || !body.contains("destination_station_id")) {
                json err;
                err["success"] = false;
                err["error"] = "source_station_id and destination_station_id are required";
                res.status = 400;
                res.set_content(err.dump(), "application/json");
                return;
            }

            rreq.source_station_id = body["source_station_id"].get<int>();
            rreq.destination_station_id = body["destination_station_id"].get<int>();
            rreq.criteria = body.value("criteria", "fastest");
            rreq.departure_date = body.value("departure_date", "");
            rreq.departure_time = body.value("departure_time", "09:00");
            rreq.day_type = body.value("day_type", "weekday");
            rreq.fare_class = body.value("fare_class", "general");
            rreq.is_smart_card = body.value("is_smart_card", false);

            if (body.contains("transport_modes") && body["transport_modes"].is_array()) {
                rreq.transport_modes = body["transport_modes"].get<std::vector<std::string>>();
            }

            models::RouteResult route = route_service_->findRoute(rreq);
            res.set_content(route.to_api_response().dump(), "application/json");
        } catch (const std::exception& e) {
            json err;
            err["success"] = false;
            err["error"] = std::string("Invalid request format: ") + e.what();
            res.status = 400;
            res.set_content(err.dump(), "application/json");
        }
    };
    svr_.Post("/api/route", route_handler);
    svr_.Post("/api/v1/route", route_handler);
    svr_.Post("/api/v1/routes/plan", route_handler);

    auto route_compare_handler = [this](const httplib::Request& req, httplib::Response& res) {
        try {
            auto body = json::parse(req.body);
            services::RouteRequest rreq;

            if (!body.contains("source_station_id") || !body.contains("destination_station_id")) {
                json err;
                err["success"] = false;
                err["error"] = "source_station_id and destination_station_id are required";
                res.status = 400;
                res.set_content(err.dump(), "application/json");
                return;
            }

            rreq.source_station_id = body["source_station_id"].get<int>();
            rreq.destination_station_id = body["destination_station_id"].get<int>();
            rreq.departure_date = body.value("departure_date", "");
            rreq.departure_time = body.value("departure_time", "09:00");
            rreq.day_type = body.value("day_type", "weekday");
            rreq.fare_class = body.value("fare_class", "general");
            rreq.is_smart_card = body.value("is_smart_card", false);

            if (body.contains("transport_modes") && body["transport_modes"].is_array()) {
                rreq.transport_modes = body["transport_modes"].get<std::vector<std::string>>();
            }

            auto results = route_service_->compareRoutes(rreq);
            json j;
            j["success"] = true;
            json comparisons = json::object();
            for (const auto& r : results) {
                if (r.found) {
                    comparisons[r.criteria] = r.to_json();
                } else {
                    comparisons[r.criteria] = {{"found", false}};
                }
            }
            j["comparisons"] = comparisons;
            res.set_content(j.dump(), "application/json");
        } catch (const std::exception& e) {
            json err;
            err["success"] = false;
            err["error"] = std::string("Invalid request: ") + e.what();
            res.status = 400;
            res.set_content(err.dump(), "application/json");
        }
    };
    svr_.Post("/api/route/compare", route_compare_handler);
    svr_.Post("/api/v1/route/compare", route_compare_handler);
    svr_.Post("/api/v1/routes/compare", route_compare_handler);

    // ── Fare Calculation Endpoint ──────────────────────────
    auto fare_calc_handler = [this](const httplib::Request& req, httplib::Response& res) {
        try {
            auto body = json::parse(req.body);
            services::FareContext ctx;
            ctx.distance_km = body.value("distance_km", 0.0);
            ctx.stops_count = body.value("stops_count", 0);
            ctx.operator_id = body.value("operator_id", 0);
            ctx.line_code = body.value("line_code", "");
            ctx.fare_class = body.value("fare_class", "general");
            ctx.day_type = body.value("day_type", "weekday");
            ctx.departure_time = body.value("departure_time", "09:00");
            ctx.is_smart_card = body.value("is_smart_card", false);

            int transport_type_id = body.value("transport_type_id", 1);

            models::FareResult fare = fare_service_->calculateFare(transport_type_id, ctx);

            json j;
            j["success"] = true;
            j["fare"] = fare.to_json();
            res.set_content(j.dump(), "application/json");
        } catch (const std::exception& e) {
            json err;
            err["success"] = false;
            err["error"] = std::string("Invalid request: ") + e.what();
            res.status = 400;
            res.set_content(err.dump(), "application/json");
        }
    };
    svr_.Post("/api/fare/calculate", fare_calc_handler);
    svr_.Post("/api/v1/fare/calculate", fare_calc_handler);
    svr_.Post("/api/v1/fares/calculate", fare_calc_handler);

    // ── Network Overview ───────────────────────────────────
    auto network_overview_handler = [this](const httplib::Request&, httplib::Response& res) {
        json j;
        j["success"] = true;
        j["scope"] = {
            {"regions", {"Delhi NCR"}},
            {"supported_modes", {"Metro", "Bus", "Indian Railways", "Namo Bharat (RRTS)"}}
        };
        j["graph"] = {
            {"total_stations", graph_.stationCount()},
            {"total_connections", graph_.edgeCount()}
        };

        if (db_.isConnected()) {
            repository::StationRepository s_repo(db_);
            repository::ConnectionRepository c_repo(db_);
            repository::LineRepository l_repo(db_);

            j["database"] = {
                {"active_stations", s_repo.countAll(true)},
                {"active_connections", c_repo.countAll(true)},
                {"active_lines", l_repo.findAll(true).size()}
            };
        }
        res.set_content(j.dump(), "application/json");
    };
    svr_.Get("/api/network/overview", network_overview_handler);
    svr_.Get("/api/v1/network/overview", network_overview_handler);

    auto network_conns_handler = [this](const httplib::Request& req, httplib::Response& res) {
        json j;
        if (db_.isConnected()) {
            repository::ConnectionRepository repo(db_);
            std::vector<models::Connection> conns;
            if (req.has_param("station_id")) {
                conns = repo.findByStation(std::stoi(req.get_param_value("station_id")));
            } else if (req.has_param("line_id")) {
                conns = repo.findByLine(std::stoi(req.get_param_value("line_id")));
            } else if (req.has_param("type_id")) {
                conns = repo.findByTransportType(std::stoi(req.get_param_value("type_id")));
            } else {
                conns = repo.findAll(true);
            }
            json arr = json::array();
            for (const auto& c : conns) arr.push_back(c.to_json());
            j["success"] = true;
            j["count"] = arr.size();
            j["connections"] = arr;
        } else {
            j["success"] = true;
            j["count"] = 0;
            j["connections"] = json::array();
        }
        res.set_content(j.dump(), "application/json");
    };
    svr_.Get("/api/network/connections", network_conns_handler);
    svr_.Get("/api/v1/network/connections", network_conns_handler);

    // ── Admin Endpoints (Station CRUD) ─────────────────────
    svr_.Post("/api/admin/stations", [this](const httplib::Request& req, httplib::Response& res) {
        if (!authenticateAdmin(req, res)) return;
        try {
            auto body = json::parse(req.body);
            models::Station s = models::Station::from_json(body);
            if (db_.isConnected()) {
                repository::StationRepository repo(db_);
                int new_id = repo.create(s);
                s.id = new_id;
                graph_.addStation(s);

                json resp;
                resp["success"] = true;
                resp["message"] = "Station created successfully";
                resp["station"] = s.to_json();
                res.status = 201;
                res.set_content(resp.dump(), "application/json");
            } else {
                json err;
                err["success"] = false;
                err["error"] = "Database not connected";
                res.status = 503;
                res.set_content(err.dump(), "application/json");
            }
        } catch (const std::exception& e) {
            json err;
            err["success"] = false;
            err["error"] = e.what();
            res.status = 400;
            res.set_content(err.dump(), "application/json");
        }
    });

    svr_.Put("/api/admin/stations", [this](const httplib::Request& req, httplib::Response& res) {
        if (!authenticateAdmin(req, res)) return;
        try {
            auto body = json::parse(req.body);
            models::Station s = models::Station::from_json(body);
            if (s.id <= 0) {
                json err;
                err["success"] = false;
                err["error"] = "Valid station id is required";
                res.status = 400;
                res.set_content(err.dump(), "application/json");
                return;
            }
            if (db_.isConnected()) {
                repository::StationRepository repo(db_);
                bool ok = repo.update(s);
                if (ok) {
                    graph_.addStation(s);
                    json resp;
                    resp["success"] = true;
                    resp["message"] = "Station updated successfully";
                    resp["station"] = s.to_json();
                    res.set_content(resp.dump(), "application/json");
                } else {
                    json err;
                    err["success"] = false;
                    err["error"] = "Failed to update station in database";
                    res.status = 500;
                    res.set_content(err.dump(), "application/json");
                }
            } else {
                res.status = 503;
                res.set_content("{\"success\":false,\"error\":\"Database not connected\"}", "application/json");
            }
        } catch (const std::exception& e) {
            json err;
            err["success"] = false;
            err["error"] = e.what();
            res.status = 400;
            res.set_content(err.dump(), "application/json");
        }
    });

    svr_.Delete("/api/admin/stations", [this](const httplib::Request& req, httplib::Response& res) {
        if (!authenticateAdmin(req, res)) return;
        int station_id = 0;
        if (req.has_param("id")) {
            station_id = std::stoi(req.get_param_value("id"));
        } else if (!req.body.empty()) {
            auto body = json::parse(req.body);
            station_id = body.value("id", 0);
        }

        if (station_id <= 0) {
            json err;
            err["success"] = false;
            err["error"] = "station id is required";
            res.status = 400;
            res.set_content(err.dump(), "application/json");
            return;
        }

        if (db_.isConnected()) {
            repository::StationRepository repo(db_);
            bool ok = repo.remove(station_id);
            json resp;
            resp["success"] = ok;
            resp["message"] = ok ? "Station deleted" : "Failed to delete station";
            res.set_content(resp.dump(), "application/json");
        } else {
            res.status = 503;
            res.set_content("{\"success\":false,\"error\":\"Database not connected\"}", "application/json");
        }
    });

    // ── Admin Endpoints (Connection CRUD) ──────────────────
    svr_.Post("/api/admin/connections", [this](const httplib::Request& req, httplib::Response& res) {
        if (!authenticateAdmin(req, res)) return;
        try {
            auto body = json::parse(req.body);
            models::Connection conn = models::Connection::from_json(body);
            if (db_.isConnected()) {
                repository::ConnectionRepository repo(db_);
                int new_id = repo.create(conn);
                conn.id = new_id;

                graph::GraphEdge edge;
                edge.to_station_id = conn.to_station_id;
                edge.connection_id = new_id;
                edge.transport_type_id = conn.transport_type_id;
                edge.line_id = conn.line_id;
                edge.distance_km = conn.distance_km;
                edge.travel_time_min = conn.estimated_travel_time_min;
                edge.fare = 0.0;
                edge.is_transfer = false;

                if (conn.is_bidirectional) {
                    graph_.addBidirectionalEdge(conn.from_station_id, conn.to_station_id, edge);
                } else {
                    graph_.addEdge(conn.from_station_id, edge);
                }

                json resp;
                resp["success"] = true;
                resp["message"] = "Connection created successfully";
                resp["connection"] = conn.to_json();
                res.status = 201;
                res.set_content(resp.dump(), "application/json");
            } else {
                res.status = 503;
                res.set_content("{\"success\":false,\"error\":\"Database not connected\"}", "application/json");
            }
        } catch (const std::exception& e) {
            json err;
            err["success"] = false;
            err["error"] = e.what();
            res.status = 400;
            res.set_content(err.dump(), "application/json");
        }
    });

    svr_.Put("/api/admin/connections", [this](const httplib::Request& req, httplib::Response& res) {
        if (!authenticateAdmin(req, res)) return;
        try {
            auto body = json::parse(req.body);
            models::Connection conn = models::Connection::from_json(body);
            if (conn.id <= 0) {
                res.status = 400;
                res.set_content("{\"success\":false,\"error\":\"Valid connection id required\"}", "application/json");
                return;
            }
            if (db_.isConnected()) {
                repository::ConnectionRepository repo(db_);
                bool ok = repo.update(conn);
                json resp;
                resp["success"] = ok;
                resp["message"] = ok ? "Connection updated" : "Failed to update connection";
                res.set_content(resp.dump(), "application/json");
            } else {
                res.status = 503;
                res.set_content("{\"success\":false,\"error\":\"Database not connected\"}", "application/json");
            }
        } catch (const std::exception& e) {
            json err;
            err["success"] = false;
            err["error"] = e.what();
            res.status = 400;
            res.set_content(err.dump(), "application/json");
        }
    });

    svr_.Delete("/api/admin/connections", [this](const httplib::Request& req, httplib::Response& res) {
        if (!authenticateAdmin(req, res)) return;
        int conn_id = 0;
        if (req.has_param("id")) {
            conn_id = std::stoi(req.get_param_value("id"));
        } else if (!req.body.empty()) {
            auto body = json::parse(req.body);
            conn_id = body.value("id", 0);
        }

        if (conn_id <= 0) {
            res.status = 400;
            res.set_content("{\"success\":false,\"error\":\"connection id required\"}", "application/json");
            return;
        }

        if (db_.isConnected()) {
            repository::ConnectionRepository repo(db_);
            bool ok = repo.remove(conn_id);
            json resp;
            resp["success"] = ok;
            resp["message"] = ok ? "Connection deleted" : "Failed to delete connection";
            res.set_content(resp.dump(), "application/json");
        } else {
            res.status = 503;
            res.set_content("{\"success\":false,\"error\":\"Database not connected\"}", "application/json");
        }
    });

    // ── Admin Graph Rebuild ────────────────────────────────
    svr_.Post("/api/admin/graph/rebuild", [this](const httplib::Request& req, httplib::Response& res) {
        if (!authenticateAdmin(req, res)) return;
        if (db_.isConnected()) {
            services::GraphBuilderService builder(db_);
            builder.rebuildGraph(graph_);
            json resp;
            resp["success"] = true;
            resp["message"] = "Graph rebuilt successfully";
            resp["stations_count"] = graph_.stationCount();
            resp["edges_count"] = graph_.edgeCount();
            res.set_content(resp.dump(), "application/json");
        } else {
            res.status = 503;
            res.set_content("{\"success\":false,\"error\":\"Database not connected\"}", "application/json");
        }
    });
}

void Server::start() {
    std::cout << "[server] Listening on 0.0.0.0:" << config_.server_port << "...\n";
    std::cout << "[server] Ready to handle requests. Press Ctrl+C to stop.\n";
    bool ok = svr_.listen("0.0.0.0", config_.server_port);
    if (!ok) {
        std::cerr << "[server] ERROR: Failed to bind to port " << config_.server_port << "!\n";
        std::cerr << "[server] The port is already in use by another process (e.g. Docker on 8080).\n";
        std::cerr << "[server] Please configure SERVER_PORT in .env (e.g. SERVER_PORT=8088).\n";
    }
}

void Server::stop() {
    if (svr_.is_running()) {
        std::cout << "[server] Stopping HTTP server...\n";
        svr_.stop();
    }
}

} // namespace api
} // namespace raasta

