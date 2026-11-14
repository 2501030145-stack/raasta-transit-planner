#pragma once

#include "raasta/algorithms/routing_algorithm.hpp"

namespace raasta {
namespace algorithms {

class BFSRouter : public IRoutingAlgorithm {
public:
    BFSRouter() = default;

    models::RouteResult findRoute(
        const graph::TransportGraph& graph,
        int source_id,
        int destination_id,
        const std::set<int>& allowed_transport_types = {}
    ) override;

    std::string name() const override { return "bfs"; }
    RoutingCriteria criteria() const override { return RoutingCriteria::MIN_STOPS; }
};

} // namespace algorithms
} // namespace raasta

