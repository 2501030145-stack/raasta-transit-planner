#include "raasta/models/station.hpp"
#include <cmath>

namespace raasta {
namespace models {

nlohmann::json Station::to_json() const {
    nlohmann::json j;
    j["id"] = id;
    j["name"] = name;
    j["code"] = code;
    j["latitude"] = latitude;
    j["longitude"] = longitude;
    j["city_id"] = city_id;
    j["state_id"] = state_id;
    j["station_type"] = station_type;
    j["address"] = address;
    j["is_interchange"] = is_interchange;
    j["is_active"] = is_active;
    j["data_status"] = data_status;
    
    if (!city_name.empty()) j["city_name"] = city_name;
    if (!state_name.empty()) j["state_name"] = state_name;
    if (!aliases.empty()) j["aliases"] = aliases;
    if (!line_ids.empty()) j["line_ids"] = line_ids;
    
    return j;
}

Station Station::from_json(const nlohmann::json& j) {
    Station s;
    if (j.contains("id")) s.id = j["id"].get<int>();
    if (j.contains("name")) s.name = j["name"].get<std::string>();
    if (j.contains("code")) s.code = j.value("code", "");
    if (j.contains("latitude")) s.latitude = j["latitude"].get<double>();
    if (j.contains("longitude")) s.longitude = j["longitude"].get<double>();
    if (j.contains("city_id")) s.city_id = j.value("city_id", 0);
    if (j.contains("state_id")) s.state_id = j.value("state_id", 0);
    if (j.contains("station_type")) s.station_type = j["station_type"].get<std::string>();
    if (j.contains("address")) s.address = j.value("address", "");
    if (j.contains("is_interchange")) s.is_interchange = j.value("is_interchange", false);
    if (j.contains("is_active")) s.is_active = j.value("is_active", true);
    if (j.contains("data_status")) s.data_status = j.value("data_status", "estimated");
    if (j.contains("city_name")) s.city_name = j.value("city_name", "");
    if (j.contains("state_name")) s.state_name = j.value("state_name", "");
    if (j.contains("aliases") && j["aliases"].is_array()) {
        s.aliases = j["aliases"].get<std::vector<std::string>>();
    }
    return s;
}

double Station::distanceTo(const Station& other) const {
    const double R = 6371.0; // Earth radius in km
    double lat1 = latitude * M_PI / 180.0;
    double lat2 = other.latitude * M_PI / 180.0;
    double dlat = (other.latitude - latitude) * M_PI / 180.0;
    double dlon = (other.longitude - longitude) * M_PI / 180.0;
    
    double a = std::sin(dlat / 2) * std::sin(dlat / 2) +
               std::cos(lat1) * std::cos(lat2) *
               std::sin(dlon / 2) * std::sin(dlon / 2);
    double c = 2 * std::atan2(std::sqrt(a), std::sqrt(1 - a));
    
    return R * c;
}

} // namespace models
} // namespace raasta
