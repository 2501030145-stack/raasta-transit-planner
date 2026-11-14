#include "raasta/models/route_result.hpp"

namespace raasta {
namespace models {

nlohmann::json RouteSegment::to_json() const {
    nlohmann::json j;
    j["from_station_id"] = from_station_id;
    j["to_station_id"] = to_station_id;
    j["from_station_name"] = from_station_name;
    j["to_station_name"] = to_station_name;
    j["line_id"] = line_id;
    j["transport_type_id"] = transport_type_id;
    j["line_name"] = line_name;
    j["transport_type_name"] = transport_type_name;
    j["line_color"] = line_color;
    j["distance_km"] = distance_km;
    j["travel_time_min"] = travel_time_min;
    j["fare"] = fare.to_json();
    j["is_transfer"] = is_transfer;
    return j;
}

nlohmann::json RouteResult::to_json() const {
    nlohmann::json j;
    j["found"] = found;
    j["total_distance_km"] = total_distance_km;
    j["estimated_time_min"] = estimated_time_min;
    j["total_fare"] = total_fare;
    j["fare_status"] = fare_status;
    j["number_of_stops"] = number_of_stops;
    j["number_of_transfers"] = number_of_transfers;
    j["algorithm_used"] = algorithm_used;
    j["criteria"] = criteria;
    
    nlohmann::json segs = nlohmann::json::array();
    for (const auto& seg : segments) {
        segs.push_back(seg.to_json());
    }
    j["segments"] = segs;
    
    nlohmann::json stats = nlohmann::json::array();
    for (const auto& st : stations) {
        stats.push_back(st.to_json());
    }
    j["stations"] = stats;
    
    return j;
}

nlohmann::json RouteResult::to_api_response() const {
    nlohmann::json response;
    
    if (!found) {
        response["success"] = false;
        response["error"] = "No route found";
        return response;
    }
    
    response["success"] = true;
    
    nlohmann::json route;
    route["total_distance_km"] = total_distance_km;
    route["estimated_time_min"] = estimated_time_min;
    route["total_fare"] = total_fare;
    route["fare_status"] = fare_status;
    route["number_of_stops"] = number_of_stops;
    route["number_of_transfers"] = number_of_transfers;
    route["algorithm"] = algorithm_used;
    route["criteria"] = criteria;
    
    nlohmann::json segs = nlohmann::json::array();
    for (const auto& seg : segments) {
        segs.push_back(seg.to_json());
    }
    route["segments"] = segs;
    
    nlohmann::json stats = nlohmann::json::array();
    for (const auto& st : stations) {
        stats.push_back(st.to_json());
    }
    route["stations"] = stats;
    
    response["route"] = route;
    return response;
}

} // namespace models
} // namespace raasta
