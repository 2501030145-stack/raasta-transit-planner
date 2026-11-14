#pragma once

#include <string>
#include <nlohmann/json.hpp>

namespace raasta {
namespace models {

struct Connection {
    int id = 0;
    int from_station_id = 0;
    int to_station_id = 0;
    int line_id = 0;
    int transport_type_id = 0;
    double distance_km = 0.0;
    double estimated_travel_time_min = 0.0;
    bool is_bidirectional = true;
    bool is_active = true;
    std::string data_status = "estimated";
    
    // Denormalized
    std::string from_station_name;
    std::string to_station_name;
    std::string line_name;
    std::string transport_type_name;
    
    nlohmann::json to_json() const;
    static Connection from_json(const nlohmann::json& j);
};

struct InterchangeConnection {
    int id = 0;
    int from_station_id = 0;
    int to_station_id = 0;
    int from_line_id = 0;
    int to_line_id = 0;
    double transfer_time_min = 5.0;
    int walking_distance_m = 0;
    bool is_verified = false;
    bool is_active = true;
    
    nlohmann::json to_json() const;
    static InterchangeConnection from_json(const nlohmann::json& j);
};

} // namespace models
} // namespace raasta
