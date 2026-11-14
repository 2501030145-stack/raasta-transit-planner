#pragma once

#include <string>
#include <vector>
#include <nlohmann/json.hpp>

namespace raasta {
namespace models {

struct Station {
    int id = 0;
    std::string name;
    std::string code;
    double latitude = 0.0;
    double longitude = 0.0;
    int city_id = 0;
    int state_id = 0;
    std::string station_type;  // metro_station, bus_stop, railway_station, rrts_station
    std::string address;
    bool is_interchange = false;
    bool is_active = true;
    std::string data_status = "estimated";  // verified, estimated, unavailable
    
    // Denormalized fields for API responses
    std::string city_name;
    std::string state_name;
    std::vector<std::string> aliases;
    std::vector<int> line_ids;
    
    nlohmann::json to_json() const;
    static Station from_json(const nlohmann::json& j);
    
    // Haversine distance to another station in km
    double distanceTo(const Station& other) const;
};

} // namespace models
} // namespace raasta
