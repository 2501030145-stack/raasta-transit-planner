#include "raasta/graph/transport_graph.hpp"
#include <iostream>
#include <stdexcept>
#include <algorithm>

namespace raasta {
namespace graph {

const std::vector<GraphEdge> TransportGraph::EMPTY_EDGES = {};

void TransportGraph::addStation(const models::Station& station) {
    stations_[station.id] = station;
}

void TransportGraph::addEdge(int from_station_id, const GraphEdge& edge) {
    adjacency_list_[from_station_id].push_back(edge);
}

void TransportGraph::addBidirectionalEdge(int from_id, int to_id, const GraphEdge& edge_template) {
    // Forward edge
    GraphEdge forward = edge_template;
    forward.to_station_id = to_id;
    adjacency_list_[from_id].push_back(forward);
    
    // Reverse edge
    GraphEdge reverse = edge_template;
    reverse.to_station_id = from_id;
    adjacency_list_[to_id].push_back(reverse);
}

const std::vector<GraphEdge>& TransportGraph::getEdges(int station_id) const {
    auto it = adjacency_list_.find(station_id);
    if (it != adjacency_list_.end()) {
        return it->second;
    }
    return EMPTY_EDGES;
}

const models::Station& TransportGraph::getStation(int station_id) const {
    auto it = stations_.find(station_id);
    if (it == stations_.end()) {
        throw std::out_of_range("Station not found: " + std::to_string(station_id));
    }
    return it->second;
}

bool TransportGraph::hasStation(int station_id) const {
    return stations_.find(station_id) != stations_.end();
}

std::vector<int> TransportGraph::getAllStationIds() const {
    std::vector<int> ids;
    ids.reserve(stations_.size());
    for (const auto& pair : stations_) {
        ids.push_back(pair.first);
    }
    return ids;
}

size_t TransportGraph::stationCount() const {
    return stations_.size();
}

size_t TransportGraph::edgeCount() const {
    size_t count = 0;
    for (const auto& pair : adjacency_list_) {
        count += pair.second.size();
    }
    return count;
}

std::vector<GraphEdge> TransportGraph::getFilteredEdges(int station_id, const std::set<int>& allowed_types) const {
    const auto& edges = getEdges(station_id);
    
    // Empty allowed_types means allow all
    if (allowed_types.empty()) {
        return edges;
    }
    
    std::vector<GraphEdge> filtered;
    for (const auto& edge : edges) {
        if (allowed_types.count(edge.transport_type_id) > 0) {
            filtered.push_back(edge);
        }
    }
    return filtered;
}

void TransportGraph::clear() {
    adjacency_list_.clear();
    stations_.clear();
}

void TransportGraph::printStats() const {
    std::cout << "=== Transport Graph Stats ===" << std::endl;
    std::cout << "Stations: " << stationCount() << std::endl;
    std::cout << "Edges: " << edgeCount() << std::endl;
    
    // Breakdown by transport type
    std::unordered_map<int, size_t> type_counts;
    std::unordered_map<int, std::string> type_names;
    for (const auto& pair : adjacency_list_) {
        for (const auto& edge : pair.second) {
            type_counts[edge.transport_type_id]++;
            if (type_names.find(edge.transport_type_id) == type_names.end() &&
                !edge.transport_type_name.empty()) {
                type_names[edge.transport_type_id] = edge.transport_type_name;
            }
        }
    }
    
    std::cout << "Edges by transport type:" << std::endl;
    for (const auto& pair : type_counts) {
        std::string name = type_names.count(pair.first) ? type_names[pair.first] : "type_" + std::to_string(pair.first);
        std::cout << "  " << name << " (id=" << pair.first << "): " << pair.second << " edges" << std::endl;
    }
    std::cout << "=============================" << std::endl;
}

} // namespace graph
} // namespace raasta
