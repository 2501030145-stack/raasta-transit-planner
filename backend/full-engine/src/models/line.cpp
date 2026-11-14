#include "raasta/models/line.hpp"

namespace raasta {
namespace models {

nlohmann::json TransportLine::to_json() const {
    nlohmann::json j;
    j["id"] = id;
    j["name"] = name;
    j["code"] = code;
    j["color"] = color;
    j["transport_type_id"] = transport_type_id;
    j["operator_id"] = operator_id;
    j["is_active"] = is_active;
    
    if (!transport_type_name.empty()) j["transport_type_name"] = transport_type_name;
    if (!operator_name.empty()) j["operator_name"] = operator_name;
    
    return j;
}

TransportLine TransportLine::from_json(const nlohmann::json& j) {
    TransportLine l;
    if (j.contains("id")) l.id = j["id"].get<int>();
    if (j.contains("name")) l.name = j["name"].get<std::string>();
    if (j.contains("code")) l.code = j.value("code", "");
    if (j.contains("color")) l.color = j.value("color", "");
    if (j.contains("transport_type_id")) l.transport_type_id = j.value("transport_type_id", 0);
    if (j.contains("operator_id")) l.operator_id = j.value("operator_id", 0);
    if (j.contains("is_active")) l.is_active = j.value("is_active", true);
    if (j.contains("transport_type_name")) l.transport_type_name = j.value("transport_type_name", "");
    if (j.contains("operator_name")) l.operator_name = j.value("operator_name", "");
    return l;
}

} // namespace models
} // namespace raasta
