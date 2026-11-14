#pragma once

#include <memory>
#include <string>
#include <set>
#include <vector>
#include <unordered_map>
#include "raasta/graph/transport_graph.hpp"
#include "raasta/models/route_result.hpp"
#include "raasta/algorithms/routing_algorithm.hpp"
#include "raasta/services/fare_service.hpp"

namespace raasta {
namespace services {

struct RouteRequest {
    int source_station_id = 0;
    int destination_station_id = 0;
    std::string criteria = "fastest";  // shortest, fastest, cheapest, min_stops
    std::vector<std::string> transport_modes;  // metro, bus, railway, rrts (empty = all)
    std::string departure_date;
    std::string departure_time = "09:00";
    std::string day_type = "weekday";          // weekday, weekend, sunday, holiday
    std::string fare_class = "general";        // ac, non_ac, 2S, SL, CC, 3A, 2A, 1A, standard, premium
    bool is_smart_card = false;
};

class RouteService {
public:
    RouteService(
        std::shared_ptr<graph::TransportGraph> graph,
        std::shared_ptr<FareService> fare_service
    );
    
    // Find a single route
    models::RouteResult findRoute(const RouteRequest& request) const;
    
    // Compare routes across all criteria
    std::vector<models::RouteResult> compareRoutes(const RouteRequest& request) const;
    
    // Get available transport type IDs from mode names
    std::set<int> resolveTransportModes(const std::vector<std::string>& modes) const;
    
    // Update graph reference (after rebuild)
    void setGraph(std::shared_ptr<graph::TransportGraph> graph);
    
private:
    std::shared_ptr<graph::TransportGraph> graph_;
    std::shared_ptr<FareService> fare_service_;
    
    // Transport type code -> id mapping
    std::unordered_map<std::string, int> mode_to_id_;
    
    void initModeMapping();
};

} // namespace services
} // namespace raasta
