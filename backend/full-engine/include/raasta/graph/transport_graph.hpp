#pragma once

#include <vector>
#include <unordered_map>
#include <set>
#include <string>
#include "raasta/models/station.hpp"

namespace raasta {
namespace graph {

struct GraphEdge {
    int to_station_id = 0;
    int connection_id = 0;
    int transport_type_id = 0;
    int line_id = 0;
    double distance_km = 0.0;
    double travel_time_min = 0.0;
    double fare = 0.0;
    bool is_transfer = false;
    std::string line_name;
    std::string transport_type_name;
    std::string line_color;
};

class TransportGraph {
public:
    TransportGraph() = default;
    
    // Build graph
    void addStation(const models::Station& station);
    void addEdge(int from_station_id, const GraphEdge& edge);
    void addBidirectionalEdge(int from_id, int to_id, const GraphEdge& edge_template);
    
    // Query graph
    const std::vector<GraphEdge>& getEdges(int station_id) const;
    const models::Station& getStation(int station_id) const;
    bool hasStation(int station_id) const;
    std::vector<int> getAllStationIds() const;
    
    // Stats
    size_t stationCount() const;
    size_t edgeCount() const;
    
    // Filter edges by transport type
    std::vector<GraphEdge> getFilteredEdges(int station_id, const std::set<int>& allowed_types) const;
    
    // Management
    void clear();
    
    // Debug
    void printStats() const;

private:
    std::unordered_map<int, std::vector<GraphEdge>> adjacency_list_;
    std::unordered_map<int, models::Station> stations_;
    static const std::vector<GraphEdge> EMPTY_EDGES;
};

} // namespace graph
} // namespace raasta
