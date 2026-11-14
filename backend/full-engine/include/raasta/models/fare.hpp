#pragma once

#include <string>
#include <nlohmann/json.hpp>

namespace raasta {
namespace models {

struct FareRule {
    int id = 0;
    int transport_type_id = 0;
    int operator_id = 0;
    int line_id = 0;
    std::string rule_name;
    std::string fare_type = "distance_slab";  // distance_slab, flat, zone, stage
    std::string fare_class = "general";  // general, ac, non_ac, premium, first_class, etc.
    double min_distance_km = 0.0;
    double max_distance_km = 9999.99;
    double base_fare = 0.0;
    double per_km_fare = 0.0;
    double fare_amount = 0.0;
    std::string currency = "INR";
    std::string applies_on = "all_days";
    bool is_smart_card = false;
    double discount_pct = 0.0;
    std::string source;
    std::string data_status = "estimated";
    bool is_active = true;
    
    nlohmann::json to_json() const;
    static FareRule from_json(const nlohmann::json& j);
};

struct FareResult {
    double amount = 0.0;
    double original_amount = 0.0;
    double discount_applied = 0.0;
    std::string currency = "INR";
    std::string status = "verified";  // verified, estimated, unavailable
    std::string operator_name;
    std::string fare_type;
    std::string fare_class = "general";
    std::string source;
    std::string details;
    
    nlohmann::json to_json() const;
    static FareResult from_json(const nlohmann::json& j);
};

} // namespace models
} // namespace raasta
