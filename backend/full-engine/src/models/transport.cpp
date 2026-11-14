#include "raasta/models/transport.hpp"

namespace raasta {
namespace models {

// TransportType

nlohmann::json TransportType::to_json() const {
    nlohmann::json j;
    j["id"] = id;
    j["name"] = name;
    j["code"] = code;
    j["description"] = description;
    return j;
}

TransportType TransportType::from_json(const nlohmann::json& j) {
    TransportType t;
    if (j.contains("id")) t.id = j["id"].get<int>();
    if (j.contains("name")) t.name = j["name"].get<std::string>();
    if (j.contains("code")) t.code = j.value("code", "");
    if (j.contains("description")) t.description = j.value("description", "");
    return t;
}

// Operator

nlohmann::json Operator::to_json() const {
    nlohmann::json j;
    j["id"] = id;
    j["name"] = name;
    j["code"] = code;
    j["transport_type_id"] = transport_type_id;
    j["website"] = website;
    j["region"] = region;
    j["is_active"] = is_active;
    return j;
}

Operator Operator::from_json(const nlohmann::json& j) {
    Operator o;
    if (j.contains("id")) o.id = j["id"].get<int>();
    if (j.contains("name")) o.name = j["name"].get<std::string>();
    if (j.contains("code")) o.code = j.value("code", "");
    if (j.contains("transport_type_id")) o.transport_type_id = j.value("transport_type_id", 0);
    if (j.contains("website")) o.website = j.value("website", "");
    if (j.contains("region")) o.region = j.value("region", "");
    if (j.contains("is_active")) o.is_active = j.value("is_active", true);
    return o;
}

} // namespace models
} // namespace raasta
