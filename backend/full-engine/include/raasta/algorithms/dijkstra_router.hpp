#pragma once

#include "raasta/algorithms/routing_algorithm.hpp"
#include <unordered_map>

namespace raasta {
namespace algorithms {

class DijkstraRouter : public IRoutingAlgorithm {
public:
    explicit DijkstraRouter(RoutingCriteria criteria);

    models::RouteResult findRoute(
        const graph::TransportGraph& graph,
        int source_id,
        int destination_id,
        const std::set<int>& allowed_transport_types = {}
    ) override;

    std::string name() const override;
    RoutingCriteria criteria() const override;

private:
    RoutingCriteria criteria_;

    double getEdgeWeight(const graph::GraphEdge& edge) const;

    models::RouteResult reconstructRoute(
        const graph::TransportGraph& graph,
        int source_id,
        int destination_id,
        const std::unordered_map<int, int>& prev_station,
        const std::unordered_map<int, graph::GraphEdge>& prev_edge,
        const std::unordered_map<int, double>& dist
    ) const;
};

} // namespace algorithms
} // namespace raasta

