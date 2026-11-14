#include "raasta/algorithms/bfs_router.hpp"
#include <queue>
#include <unordered_map>
#include <unordered_set>
#include <algorithm>

namespace raasta {
namespace algorithms {

models::RouteResult BFSRouter::findRoute(
    const graph::TransportGraph& graph,
    int source_id,
    int destination_id,
    const std::set<int>& allowed_transport_types)
{
    models::RouteResult result;
    result.algorithm_used = "bfs";
    result.criteria       = "min_stops";

    if (!graph.hasStation(source_id) || !graph.hasStation(destination_id)) {
        result.found = false;
        return result;
    }

    if (source_id == destination_id) {
        result.found = true;
        result.number_of_stops = 1;
        result.stations.push_back(graph.getStation(source_id));
        return result;
    }

    // BFS
    std::queue<int> q;
    std::unordered_set<int> visited;
    std::unordered_map<int, int> prev_station;
    std::unordered_map<int, graph::GraphEdge> prev_edge;

    q.push(source_id);
    visited.insert(source_id);

    bool found = false;

    while (!q.empty() && !found) {
        int u = q.front();
        q.pop();

        const auto& edges = allowed_transport_types.empty()
            ? graph.getEdges(u)
            : graph.getFilteredEdges(u, allowed_transport_types);

        for (const auto& edge : edges) {
            int v = edge.to_station_id;
            if (visited.count(v)) continue;

            visited.insert(v);
            prev_station[v] = u;
            prev_edge[v]    = edge;

            if (v == destination_id) {
                found = true;
                break;
            }
            q.push(v);
        }
    }

    if (!found) {
        result.found = false;
        return result;
    }

    // Reconstruct path
    std::vector<int> path;
    int current = destination_id;
    while (current != source_id) {
        path.push_back(current);
        current = prev_station[current];
    }
    path.push_back(source_id);
    std::reverse(path.begin(), path.end());

    result.found              = true;
    result.number_of_stops    = static_cast<int>(path.size());
    result.total_distance_km  = 0;
    result.estimated_time_min = 0;
    result.total_fare         = 0;
    result.number_of_transfers = 0;

    int current_line_id = -1;

    for (size_t i = 0; i + 1 < path.size(); ++i) {
        int from = path[i];
        int to   = path[i + 1];

        auto it = prev_edge.find(to);
        if (it == prev_edge.end()) continue;
        const auto& edge = it->second;

        models::RouteSegment seg;
        seg.from_station_id     = from;
        seg.to_station_id       = to;
        seg.from_station_name   = graph.getStation(from).name;
        seg.to_station_name     = graph.getStation(to).name;
        seg.line_id             = edge.line_id;
        seg.transport_type_id   = edge.transport_type_id;
        seg.line_name           = edge.line_name;
        seg.transport_type_name = edge.transport_type_name;
        seg.line_color          = edge.line_color;
        seg.distance_km         = edge.distance_km;
        seg.travel_time_min     = edge.travel_time_min;
        seg.is_transfer         = edge.is_transfer;
        seg.fare.amount         = edge.fare;
        seg.fare.status         = "estimated";

        result.total_distance_km  += edge.distance_km;
        result.estimated_time_min += edge.travel_time_min;
        result.total_fare         += edge.fare;

        if (edge.is_transfer) {
            result.number_of_transfers++;
            current_line_id = -1;
        } else {
            if (current_line_id != -1 && edge.line_id > 0 && edge.line_id != current_line_id) {
                result.number_of_transfers++;
            }
            if (edge.line_id > 0) current_line_id = edge.line_id;
        }

        result.segments.push_back(std::move(seg));
    }

    for (int sid : path) {
        result.stations.push_back(graph.getStation(sid));
    }

    return result;
}

} // namespace algorithms
} // namespace raasta

