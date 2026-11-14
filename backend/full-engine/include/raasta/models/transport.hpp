#pragma once

#include <string>
#include <nlohmann/json.hpp>

namespace raasta {
namespace models {

struct TransportType {
    int id = 0;
    std::string name;
    std::string code;  // metro, bus, railway, rrts
    std::string description;
    
    nlohmann::json to_json() const;
    static TransportType from_json(const nlohmann::json& j);
};

struct Operator {
    int id = 0;
    std::string name;
    std::string code;
    int transport_type_id = 0;
    std::string website;
    std::string region;
    bool is_active = true;
    
    nlohmann::json to_json() const;
    static Operator from_json(const nlohmann::json& j);
};

} // namespace models
} // namespace raasta
