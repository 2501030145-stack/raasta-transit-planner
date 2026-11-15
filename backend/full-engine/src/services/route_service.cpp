#include "raasta/services/route_service.hpp"

#include "raasta/algorithms/dijkstra_router.hpp"
#include "raasta/algorithms/bfs_router.hpp"

#include <algorithm>
#include <cmath>
#include <chrono>
#include <bitset>
#include <iostream>
#include <limits>
#include <map>
#include <queue>
#include <tuple>
#include <utility>

namespace raasta {
namespace services {
namespace {

constexpr size_t MAX_STATION_ID = 511;
using VisitedBits = std::bitset<MAX_STATION_ID + 1>;

struct FareLabel {
    int station = 0;
    size_t parent_label = std::numeric_limits<size_t>::max();
    size_t incoming_edge_index = 0;
    double completed_fare = 0.0;
    int active_type = 0;
    std::string active_line;
    double leg_distance = 0.0;
    int leg_stops = 0;
    VisitedBits visited_bits;
    unsigned short visited_count = 0;
    bool active = true;
};

using FareStateKey = std::tuple<int, int, std::string>;

FareContext makeLegContext(
    const FareContext& base,
    const FareLabel& label
) {
    FareContext ctx = base;
    ctx.distance_km = label.leg_distance;
    ctx.stops_count = label.leg_stops;
    ctx.line_code = label.active_line;
    return ctx;
}

double activeLegFare(
    const FareLabel& label,
    const FareService& fare_service,
    const FareContext& base
) {
    if (label.active_type <= 0 || label.leg_stops == 0) {
        return 0.0;
    }

    const auto fare = fare_service.calculateFare(
        label.active_type,
        makeLegContext(base, label)
    );

    return fare.status == "unavailable" ? 0.0 : fare.amount;
}

bool containsStation(const FareLabel& label, int station) {
    return station >= 0 &&
           static_cast<size_t>(station) <= MAX_STATION_ID &&
           label.visited_bits.test(static_cast<size_t>(station));
}

bool visitedSubset(
    const FareLabel& a,
    const FareLabel& b
) {
    // A subset cannot contain more stations than the set it is contained in.
    // Check this cheap invariant before comparing the full bitset.
    return a.visited_count <= b.visited_count &&
           (a.visited_bits & b.visited_bits) == a.visited_bits;
}

bool dominates(const FareLabel& a, const FareLabel& b) {
    constexpr double EPS = 1e-9;

    return a.completed_fare <= b.completed_fare + EPS &&
           a.leg_distance <= b.leg_distance + EPS &&
           a.leg_stops <= b.leg_stops &&
           visitedSubset(a, b);
}

models::RouteResult buildFareRoute(
    const graph::TransportGraph& graph,
    const std::vector<int>& visited,
    const std::vector<graph::GraphEdge>& edges
) {
    models::RouteResult result;
    result.found = true;
    result.algorithm_used = "fare_aware_search";
    result.criteria = "cheapest";
    result.number_of_stops = static_cast<int>(visited.size());

    int current_line_id = -1;

    for (size_t i = 0; i < edges.size(); ++i) {
        const auto& edge = edges[i];
        const int from = visited[i];
        const int to = edge.to_station_id;

        models::RouteSegment segment;
        segment.from_station_id = from;
        segment.to_station_id = to;
        segment.from_station_name = graph.getStation(from).name;
        segment.to_station_name = graph.getStation(to).name;
        segment.line_id = edge.line_id;
        segment.transport_type_id = edge.transport_type_id;
        segment.line_name = edge.line_name;
        segment.transport_type_name = edge.transport_type_name;
        segment.line_color = edge.line_color;
        segment.distance_km = edge.distance_km;
        segment.travel_time_min = edge.travel_time_min;
        segment.is_transfer = edge.is_transfer;
        segment.fare.amount = edge.fare;
        segment.fare.status = "estimated";

        result.total_distance_km += edge.distance_km;
        result.estimated_time_min += edge.travel_time_min;

        if (edge.is_transfer) {
            ++result.number_of_transfers;
            current_line_id = -1;
        } else {
            if (current_line_id != -1 &&
                edge.line_id > 0 &&
                edge.line_id != current_line_id) {
                ++result.number_of_transfers;
                result.estimated_time_min += 4.0;
            }

            if (edge.line_id > 0) {
                current_line_id = edge.line_id;
            }
        }

        result.segments.push_back(std::move(segment));
    }

    result.total_distance_km =
        std::round(result.total_distance_km * 10.0) / 10.0;
    result.estimated_time_min = std::round(result.estimated_time_min);

    for (int station_id : visited) {
        result.stations.push_back(graph.getStation(station_id));
    }

    return result;
}


models::RouteResult buildFareRoute(
    const graph::TransportGraph& graph,
    const std::vector<FareLabel>& labels,
    size_t target_label
) {
    std::vector<int> visited;
    std::vector<graph::GraphEdge> edges;
    std::vector<size_t> chain;

    for (size_t id = target_label;
         id != std::numeric_limits<size_t>::max() && id < labels.size();
         id = labels[id].parent_label) {
        chain.push_back(id);
    }

    std::reverse(chain.begin(), chain.end());
    visited.reserve(chain.size());
    if (!chain.empty()) edges.reserve(chain.size() - 1);

    for (size_t i = 0; i < chain.size(); ++i) {
        const FareLabel& label = labels[chain[i]];
        visited.push_back(label.station);

        if (i > 0) {
            const FareLabel& parent = labels[label.parent_label];
            const auto& parent_edges = graph.getEdges(parent.station);

            if (label.incoming_edge_index >= parent_edges.size()) {
                return models::RouteResult{};
            }

            edges.push_back(parent_edges[label.incoming_edge_index]);
        }
    }

    return buildFareRoute(graph, visited, edges);
}

models::RouteResult findFareAwareRoute(
    const graph::TransportGraph& graph,
    const FareService& fare_service,
    const RouteRequest& request,
    const std::set<int>& allowed_types
) {
    models::RouteResult not_found;
    not_found.found = false;
    not_found.criteria = "cheapest";
    not_found.algorithm_used = "fare_aware_search";

    const int source = request.source_station_id;
    const int destination = request.destination_station_id;

    if (!graph.hasStation(source) || !graph.hasStation(destination)) {
        return not_found;
    }

    if (source == destination) {
        not_found.found = true;
        not_found.stations.push_back(graph.getStation(source));
        not_found.number_of_stops = 1;
        return not_found;
    }

    FareContext base;
    base.fare_class = request.fare_class;
    base.day_type = request.day_type;
    base.departure_time = request.departure_time;
    base.is_smart_card = request.is_smart_card;

    std::vector<FareLabel> labels;
    std::priority_queue<
        std::pair<double, size_t>,
        std::vector<std::pair<double, size_t>>,
        std::greater<std::pair<double, size_t>>
    > queue;

    std::map<FareStateKey, std::vector<size_t>> state_labels;

    FareLabel initial;
    initial.station = source;
    if (source < 0 || static_cast<size_t>(source) > MAX_STATION_ID)
        return not_found;
    initial.visited_bits.set(static_cast<size_t>(source));
    initial.visited_count = 1;
    labels.push_back(std::move(initial));
    queue.push({0.0, 0});

    double best_fare = std::numeric_limits<double>::infinity();
    size_t best_label = std::numeric_limits<size_t>::max();

    
    const auto diagnostic_start = std::chrono::steady_clock::now();
    size_t expanded_labels = 0;
    size_t generated_labels = 1;
    size_t dominance_checks = 0;
    size_t max_queue_size = queue.size();
    constexpr double EPS = 1e-9;

    while (!queue.empty()) {
        const auto [lower_bound, label_id] = queue.top();
        queue.pop();

        if (lower_bound > best_fare + EPS) break;

        if (label_id >= labels.size() || !labels[label_id].active) {
            continue;
        }

        ++expanded_labels;

        if (expanded_labels % 10000 == 0) {
            const auto elapsed = std::chrono::duration_cast<
                std::chrono::milliseconds
            >(
                std::chrono::steady_clock::now() - diagnostic_start
            ).count();

            std::cerr << "[fare_search_progress]"
                      << " expanded=" << expanded_labels
                      << " generated=" << generated_labels
                      << " labels=" << labels.size()
                      << " queue=" << queue.size()
                      << " dominance_checks=" << dominance_checks
                      << " elapsed_ms=" << elapsed
                      << std::endl;
        }

        const FareLabel current = labels[label_id];

        if (current.station == destination) {
            const double total =
                current.completed_fare +
                activeLegFare(current, fare_service, base);

            if (total < best_fare) {
                best_fare = total;
                best_label = label_id;
            }
            continue;
        }

        const auto& edges = graph.getEdges(current.station);
        for (size_t edge_index = 0; edge_index < edges.size(); ++edge_index) {
            const auto& edge = edges[edge_index];
            if (!allowed_types.empty() &&
                allowed_types.count(edge.transport_type_id) == 0) {
                continue;
            }
            if (!graph.hasStation(edge.to_station_id)) continue;

            // A cheapest path never needs to revisit a station:
            // removing a cycle cannot add a fare leg or reduce its fare.
            if (containsStation(current, edge.to_station_id)) {
                continue;
            }

            FareLabel next = current;
            next.station = edge.to_station_id;
            next.parent_label = label_id;
            next.incoming_edge_index = edge_index;
            if (edge.to_station_id < 0 ||
                static_cast<size_t>(edge.to_station_id) > MAX_STATION_ID)
                continue;
            next.visited_bits.set(static_cast<size_t>(edge.to_station_id));
            ++next.visited_count;

            if (edge.is_transfer) {
                next.completed_fare +=
                    activeLegFare(next, fare_service, base);
                next.active_type = 0;
                next.active_line.clear();
                next.leg_distance = 0.0;
                next.leg_stops = 0;
            } else {
                if (next.active_type > 0 &&
                    next.active_type != edge.transport_type_id) {
                    next.completed_fare +=
                        activeLegFare(next, fare_service, base);
                    next.active_type = 0;
                    next.active_line.clear();
                    next.leg_distance = 0.0;
                    next.leg_stops = 0;
                }

                if (next.active_type == 0) {
                    next.active_type = edge.transport_type_id;
                    next.active_line = edge.line_name;
                }

                next.leg_distance += edge.distance_km;
                ++next.leg_stops;
            }

            const FareStateKey key{
                next.station,
                next.active_type,
                next.active_line
            };

            auto& bucket = state_labels[key];
            bool rejected = false;

            for (size_t existing_id : bucket) {
                if (existing_id < labels.size() &&
                    labels[existing_id].active &&
                    (++dominance_checks, dominates(labels[existing_id], next))) {
                    rejected = true;
                    break;
                }
            }

            if (rejected) continue;

            for (size_t existing_id : bucket) {
                if (existing_id < labels.size() &&
                    labels[existing_id].active &&
                    (++dominance_checks, dominates(next, labels[existing_id]))) {
                    labels[existing_id].active = false;
                }
            }

            bucket.erase(
                std::remove_if(
                    bucket.begin(), bucket.end(),
                    [&](size_t id) {
                        return id >= labels.size() || !labels[id].active;
                    }
                ),
                bucket.end()
            );

            const double estimate =
                next.completed_fare +
                activeLegFare(next, fare_service, base);

            const size_t next_id = labels.size();
            labels.push_back(std::move(next));
            bucket.push_back(next_id);
            queue.push({estimate, next_id});
            ++generated_labels;
            max_queue_size = std::max(max_queue_size, queue.size());
        }
    }

    const auto diagnostic_end = std::chrono::steady_clock::now();
    const auto diagnostic_ms =
        std::chrono::duration_cast<std::chrono::milliseconds>(
            diagnostic_end - diagnostic_start
        ).count();

    std::cerr << "[fare_search_diagnostics]"
              << " expanded=" << expanded_labels
              << " generated=" << generated_labels
              << " dominance_checks=" << dominance_checks
              << " max_queue=" << max_queue_size
              << " elapsed_ms=" << diagnostic_ms
              << std::endl;

    if (best_label == std::numeric_limits<size_t>::max()) {
        return not_found;
    }

    return buildFareRoute(graph, labels, best_label);
}

} // namespace

RouteService::RouteService(
    std::shared_ptr<graph::TransportGraph> graph,
    std::shared_ptr<FareService> fare_service
) : graph_(std::move(graph)), fare_service_(std::move(fare_service)) {
    initModeMapping();
}

void RouteService::initModeMapping() {
    mode_to_id_["metro"] = 1;
    mode_to_id_["bus"] = 2;
    mode_to_id_["railway"] = 3;
    mode_to_id_["rrts"] = 4;
}

std::set<int> RouteService::resolveTransportModes(
    const std::vector<std::string>& modes
) const {
    std::set<int> ids;

    for (const auto& mode : modes) {
        auto it = mode_to_id_.find(mode);
        if (it != mode_to_id_.end()) {
            ids.insert(it->second);
        }
    }

    return ids;
}

void RouteService::setGraph(
    std::shared_ptr<graph::TransportGraph> graph
) {
    graph_ = std::move(graph);
}

models::RouteResult RouteService::findRoute(
    const RouteRequest& request
) const {
    if (!graph_) {
        models::RouteResult result;
        result.found = false;
        return result;
    }

    const std::set<int> allowed_types =
        resolveTransportModes(request.transport_modes);

    const auto criteria =
        algorithms::stringToCriteria(request.criteria);

    models::RouteResult result;

    if (criteria == algorithms::RoutingCriteria::CHEAPEST &&
        fare_service_) {
        result = findFareAwareRoute(
            *graph_,
            *fare_service_,
            request,
            allowed_types
        );
    } else {
        std::unique_ptr<algorithms::IRoutingAlgorithm> router;

        if (criteria == algorithms::RoutingCriteria::MIN_STOPS) {
            router = std::make_unique<algorithms::BFSRouter>();
        } else {
            router = std::make_unique<algorithms::DijkstraRouter>(criteria);
        }

        result = router->findRoute(
            *graph_,
            request.source_station_id,
            request.destination_station_id,
            allowed_types
        );
    }

    if (result.found && fare_service_) {
        FareContext ctx;
        ctx.fare_class = request.fare_class;
        ctx.day_type = request.day_type;
        ctx.departure_time = request.departure_time;
        ctx.is_smart_card = request.is_smart_card;
        fare_service_->applyFaresToRoute(result, ctx);
    }

    return result;
}

std::vector<models::RouteResult> RouteService::compareRoutes(
    const RouteRequest& request
) const {
    std::vector<models::RouteResult> results;
    const std::vector<std::string> criteria_list = {
        "fastest", "shortest", "cheapest", "min_stops"
    };

    for (const auto& criterion : criteria_list) {
        RouteRequest req = request;
        req.criteria = criterion;
        results.push_back(findRoute(req));
    }

    return results;
}

} // namespace services
} // namespace raasta
