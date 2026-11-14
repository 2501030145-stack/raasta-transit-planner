#pragma once

#include <string>
#include <vector>
#include <nlohmann/json.hpp>
#include "raasta/models/station.hpp"
#include "raasta/models/fare.hpp"

namespace raasta {
namespace models {

struct RouteSegment {
    int from_station_id = 0;
    int to_station_id = 0;
    std::string from_station_name;
    std::string to_station_name;
    int line_id = 0;
    int transport_type_id = 0;
    std::string line_name;
    std::string transport_type_name;
    std::string line_color;
    double distance_km = 0.0;
    double travel_time_min = 0.0;
    FareResult fare;
    bool is_transfer = false;
    
    nlohmann::json to_json() const;
};

struct RouteResult {
    bool found = false;
    double total_distance_km = 0.0;
    double estimated_time_min = 0.0;
    double total_fare = 0.0;
    std::string fare_status = "estimated";
    int number_of_stops = 0;
    int number_of_transfers = 0;
    std::vector<RouteSegment> segments;
    std::vector<Station> stations;
    std::string algorithm_used;
    std::string criteria;
    
    nlohmann::json to_json() const;
    
    // API response format
    nlohmann::json to_api_response() const;
};

} // namespace models
} // namespace raasta
