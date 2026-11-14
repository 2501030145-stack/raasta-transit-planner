#include "raasta/models/connection.hpp"

namespace raasta {
namespace models {

// Connection

nlohmann::json Connection::to_json() const {
    nlohmann::json j;
    j["id"] = id;
    j["from_station_id"] = from_station_id;
    j["to_station_id"] = to_station_id;
    j["line_id"] = line_id;
    j["transport_type_id"] = transport_type_id;
    j["distance_km"] = distance_km;
    j["estimated_travel_time_min"] = estimated_travel_time_min;
    j["is_bidirectional"] = is_bidirectional;
    j["is_active"] = is_active;
    j["data_status"] = data_status;
    
    if (!from_station_name.empty()) j["from_station_name"] = from_station_name;
    if (!to_station_name.empty()) j["to_station_name"] = to_station_name;
    if (!line_name.empty()) j["line_name"] = line_name;
    if (!transport_type_name.empty()) j["transport_type_name"] = transport_type_name;
    
    return j;
}

Connection Connection::from_json(const nlohmann::json& j) {
    Connection c;
    if (j.contains("id")) c.id = j["id"].get<int>();
    if (j.contains("from_station_id")) c.from_station_id = j.value("from_station_id", 0);
    if (j.contains("to_station_id")) c.to_station_id = j.value("to_station_id", 0);
    if (j.contains("line_id")) c.line_id = j.value("line_id", 0);
    if (j.contains("transport_type_id")) c.transport_type_id = j.value("transport_type_id", 0);
    if (j.contains("distance_km")) c.distance_km = j.value("distance_km", 0.0);
    if (j.contains("estimated_travel_time_min")) c.estimated_travel_time_min = j.value("estimated_travel_time_min", 0.0);
    if (j.contains("is_bidirectional")) c.is_bidirectional = j.value("is_bidirectional", true);
    if (j.contains("is_active")) c.is_active = j.value("is_active", true);
    if (j.contains("data_status")) c.data_status = j.value("data_status", "estimated");
    if (j.contains("from_station_name")) c.from_station_name = j.value("from_station_name", "");
    if (j.contains("to_station_name")) c.to_station_name = j.value("to_station_name", "");
    if (j.contains("line_name")) c.line_name = j.value("line_name", "");
    if (j.contains("transport_type_name")) c.transport_type_name = j.value("transport_type_name", "");
    return c;
}

// InterchangeConnection

nlohmann::json InterchangeConnection::to_json() const {
    nlohmann::json j;
    j["id"] = id;
    j["from_station_id"] = from_station_id;
    j["to_station_id"] = to_station_id;
    j["from_line_id"] = from_line_id;
    j["to_line_id"] = to_line_id;
    j["transfer_time_min"] = transfer_time_min;
    j["walking_distance_m"] = walking_distance_m;
    j["is_verified"] = is_verified;
    j["is_active"] = is_active;
    return j;
}

InterchangeConnection InterchangeConnection::from_json(const nlohmann::json& j) {
    InterchangeConnection ic;
    if (j.contains("id")) ic.id = j["id"].get<int>();
    if (j.contains("from_station_id")) ic.from_station_id = j.value("from_station_id", 0);
    if (j.contains("to_station_id")) ic.to_station_id = j.value("to_station_id", 0);
    if (j.contains("from_line_id")) ic.from_line_id = j.value("from_line_id", 0);
    if (j.contains("to_line_id")) ic.to_line_id = j.value("to_line_id", 0);
    if (j.contains("transfer_time_min")) ic.transfer_time_min = j.value("transfer_time_min", 5.0);
    if (j.contains("walking_distance_m")) ic.walking_distance_m = j.value("walking_distance_m", 0);
    if (j.contains("is_verified")) ic.is_verified = j.value("is_verified", false);
    if (j.contains("is_active")) ic.is_active = j.value("is_active", true);
    return ic;
}

} // namespace models
} // namespace raasta
