#include "raasta/algorithms/dijkstra_router.hpp"
#include <queue>
#include <limits>
#include <algorithm>
#include <iostream>

namespace raasta {
namespace algorithms {

// ── Free functions (declared in routing_algorithm.hpp) ────────

std::string criteriaToString(RoutingCriteria c) {
    switch (c) {
        case RoutingCriteria::SHORTEST_DISTANCE: return "shortest";
        case RoutingCriteria::FASTEST:            return "fastest";
        case RoutingCriteria::CHEAPEST:           return "cheapest";
        case RoutingCriteria::MIN_STOPS:          return "min_stops";
        default:                                  return "unknown";
    }
}

RoutingCriteria stringToCriteria(const std::string& s) {
    if (s == "shortest"  || s == "distance") return RoutingCriteria::SHORTEST_DISTANCE;
    if (s == "fastest"   || s == "time")     return RoutingCriteria::FASTEST;
    if (s == "cheapest"  || s == "fare" || s == "cost") return RoutingCriteria::CHEAPEST;
    if (s == "min_stops" || s == "stops" || s == "hops") return RoutingCriteria::MIN_STOPS;
    return RoutingCriteria::SHORTEST_DISTANCE;
}

// ── DijkstraRouter ───────────────────────────────────────────

DijkstraRouter::DijkstraRouter(RoutingCriteria criteria)
    : criteria_(criteria) {}

double DijkstraRouter::getEdgeWeight(const graph::GraphEdge& edge) const {
    switch (criteria_) {
        case RoutingCriteria::SHORTEST_DISTANCE:
            return edge.distance_km > 0 ? edge.distance_km : 0.001;
        case RoutingCriteria::FASTEST:
            return edge.travel_time_min > 0 ? edge.travel_time_min : 0.1;
        case RoutingCriteria::CHEAPEST:
            return edge.fare > 0 ? edge.fare : 0.01;
        default:
            return edge.distance_km > 0 ? edge.distance_km : 0.001;
    }
}

models::RouteResult DijkstraRouter::findRoute(
    const graph::TransportGraph& graph,
    int source_id,
    int destination_id,
    const std::set<int>& allowed_transport_types)
{
    models::RouteResult result;
    result.algorithm_used = name();
    result.criteria = criteriaToString(criteria_);

    if (!graph.hasStation(source_id) || !graph.hasStation(destination_id)) {
        result.found = false;
        return result;
    }

    if (source_id == destination_id) {
        result.found = true;
        result.stations.push_back(graph.getStation(source_id));
        return result;
    }

    // Priority queue: (cost, station_id)
    using PQEntry = std::pair<double, int>;
    std::priority_queue<PQEntry, std::vector<PQEntry>, std::greater<PQEntry>> pq;

    std::unordered_map<int, double> dist;
    std::unordered_map<int, int>    prev_station;
    std::unordered_map<int, graph::GraphEdge> prev_edge;

    constexpr double INF = std::numeric_limits<double>::infinity();

    for (int sid : graph.getAllStationIds()) {
        dist[sid] = INF;
    }

    dist[source_id] = 0.0;
    pq.push({0.0, source_id});

    while (!pq.empty()) {
        auto [d, u] = pq.top();
        pq.pop();

        if (d > dist[u]) continue;
        if (u == destination_id) break;

        const auto& edges = allowed_transport_types.empty()
            ? graph.getEdges(u)
            : graph.getFilteredEdges(u, allowed_transport_types);

        for (const auto& edge : edges) {
            double w = getEdgeWeight(edge);

            // Dynamic transfer penalty for travel-time optimization
            if (criteria_ == RoutingCriteria::FASTEST) {
                auto prev_it = prev_edge.find(u);
                if (prev_it != prev_edge.end()) {
                    const auto& last_e = prev_it->second;
                    if (!edge.is_transfer && !last_e.is_transfer) {
                        if (last_e.transport_type_id != edge.transport_type_id && last_e.transport_type_id > 0) {
                            w += 8.0; // Intermodal transfer penalty
                        } else if (last_e.line_id != edge.line_id && last_e.line_id > 0 && edge.line_id > 0) {
                            w += 4.0; // Same-mode line transfer penalty
                        }
                    }
                }
            }

            double new_dist = dist[u] + w;

            if (new_dist < dist[edge.to_station_id]) {
                dist[edge.to_station_id]         = new_dist;
                prev_station[edge.to_station_id] = u;
                prev_edge[edge.to_station_id]    = edge;
                pq.push({new_dist, edge.to_station_id});
            }
        }
    }

    if (dist.find(destination_id) == dist.end() ||
        dist[destination_id] >= INF) {
        result.found = false;
        return result;
    }

    return reconstructRoute(graph, source_id, destination_id,
                            prev_station, prev_edge, dist);
}

models::RouteResult DijkstraRouter::reconstructRoute(
    const graph::TransportGraph& graph,
    int source_id,
    int destination_id,
    const std::unordered_map<int, int>& prev_station,
    const std::unordered_map<int, graph::GraphEdge>& prev_edge,
    const std::unordered_map<int, double>& /*dist*/) const
{
    models::RouteResult result;
    result.found          = true;
    result.algorithm_used = name();
    result.criteria       = criteriaToString(criteria_);

    // Reconstruct path
    std::vector<int> path;
    int current = destination_id;
    while (current != source_id) {
        path.push_back(current);
        auto it = prev_station.find(current);
        if (it == prev_station.end()) {
            result.found = false;
            return result;
        }
        current = it->second;
    }
    path.push_back(source_id);
    std::reverse(path.begin(), path.end());

    // Build segments
    int current_line_id = -1;
    result.total_distance_km   = 0;
    result.estimated_time_min  = 0;
    result.total_fare          = 0;
    result.number_of_stops     = static_cast<int>(path.size());
    result.number_of_transfers = 0;

    for (size_t i = 0; i + 1 < path.size(); ++i) {
        int from = path[i];
        int to   = path[i + 1];

        auto it = prev_edge.find(to);
        if (it == prev_edge.end()) continue;
        const auto& edge = it->second;

        models::RouteSegment seg;
        seg.from_station_id    = from;
        seg.to_station_id      = to;
        seg.from_station_name  = graph.getStation(from).name;
        seg.to_station_name    = graph.getStation(to).name;
        seg.line_id            = edge.line_id;
        seg.transport_type_id  = edge.transport_type_id;
        seg.line_name          = edge.line_name;
        seg.transport_type_name = edge.transport_type_name;
        seg.line_color         = edge.line_color;
        seg.distance_km        = edge.distance_km;
        seg.travel_time_min    = edge.travel_time_min;
        seg.is_transfer        = edge.is_transfer;
        seg.fare.amount        = edge.fare;
        seg.fare.status        = "verified";

        result.total_distance_km  += edge.distance_km;
        result.estimated_time_min += edge.travel_time_min;
        result.total_fare         += edge.fare;

            // Line change detection & transfer time accounting
            if (edge.is_transfer) {
                result.number_of_transfers++;
                current_line_id = -1;
            } else {
                if (current_line_id != -1 && edge.line_id > 0 && edge.line_id != current_line_id) {
                    result.number_of_transfers++;
                    result.estimated_time_min += 4.0; // Transfer platform walk & headway wait
                }
                if (edge.line_id > 0) current_line_id = edge.line_id;
            }

        result.segments.push_back(std::move(seg));
    }

    result.total_distance_km = std::round(result.total_distance_km * 10.0) / 10.0;
    result.estimated_time_min = std::round(result.estimated_time_min);

    // Collect stations on the path
    for (int sid : path) {
        result.stations.push_back(graph.getStation(sid));
    }

    return result;
}

std::string DijkstraRouter::name() const { return "dijkstra"; }

RoutingCriteria DijkstraRouter::criteria() const { return criteria_; }

} // namespace algorithms
} // namespace raasta
