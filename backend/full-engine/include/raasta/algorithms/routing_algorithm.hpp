#pragma once

#include <string>
#include <set>
#include "raasta/graph/transport_graph.hpp"
#include "raasta/models/route_result.hpp"

namespace raasta {
namespace algorithms {

enum class RoutingCriteria {
    SHORTEST_DISTANCE,
    FASTEST,
    CHEAPEST,
    MIN_STOPS
};

std::string criteriaToString(RoutingCriteria c);
RoutingCriteria stringToCriteria(const std::string& s);

class IRoutingAlgorithm {
public:
    virtual ~IRoutingAlgorithm() = default;

    virtual models::RouteResult findRoute(
        const graph::TransportGraph& graph,
        int source_id,
        int destination_id,
        const std::set<int>& allowed_transport_types = {}
    ) = 0;

    virtual std::string name() const = 0;
    virtual RoutingCriteria criteria() const = 0;
};

} // namespace algorithms
} // namespace raasta

