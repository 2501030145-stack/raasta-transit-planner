#pragma once

#include <string>
#include <nlohmann/json.hpp>

namespace raasta {
namespace models {

struct TransportLine {
    int id = 0;
    std::string name;
    std::string code;
    std::string color;
    int transport_type_id = 0;
    int operator_id = 0;
    bool is_active = true;
    
    // Denormalized
    std::string transport_type_name;
    std::string operator_name;
    
    nlohmann::json to_json() const;
    static TransportLine from_json(const nlohmann::json& j);
};

} // namespace models
} // namespace raasta
