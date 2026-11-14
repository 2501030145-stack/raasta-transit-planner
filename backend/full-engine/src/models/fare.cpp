#include "raasta/models/fare.hpp"

namespace raasta {
namespace models {

// FareRule

nlohmann::json FareRule::to_json() const {
    nlohmann::json j;
    j["id"] = id;
    j["transport_type_id"] = transport_type_id;
    j["operator_id"] = operator_id;
    j["line_id"] = line_id;
    j["rule_name"] = rule_name;
    j["fare_type"] = fare_type;
    j["fare_class"] = fare_class;
    j["min_distance_km"] = min_distance_km;
    j["max_distance_km"] = max_distance_km;
    j["base_fare"] = base_fare;
    j["per_km_fare"] = per_km_fare;
    j["fare_amount"] = fare_amount;
    j["currency"] = currency;
    j["applies_on"] = applies_on;
    j["is_smart_card"] = is_smart_card;
    j["discount_pct"] = discount_pct;
    j["source"] = source;
    j["data_status"] = data_status;
    j["is_active"] = is_active;
    return j;
}

FareRule FareRule::from_json(const nlohmann::json& j) {
    FareRule f;
    if (j.contains("id")) f.id = j["id"].get<int>();
    if (j.contains("transport_type_id")) f.transport_type_id = j.value("transport_type_id", 0);
    if (j.contains("operator_id")) f.operator_id = j.value("operator_id", 0);
    if (j.contains("line_id")) f.line_id = j.value("line_id", 0);
    if (j.contains("rule_name")) f.rule_name = j.value("rule_name", "");
    if (j.contains("fare_type")) f.fare_type = j.value("fare_type", "distance_slab");
    if (j.contains("fare_class")) f.fare_class = j.value("fare_class", "general");
    if (j.contains("min_distance_km")) f.min_distance_km = j.value("min_distance_km", 0.0);
    if (j.contains("max_distance_km")) f.max_distance_km = j.value("max_distance_km", 9999.99);
    if (j.contains("base_fare")) f.base_fare = j.value("base_fare", 0.0);
    if (j.contains("per_km_fare")) f.per_km_fare = j.value("per_km_fare", 0.0);
    if (j.contains("fare_amount")) f.fare_amount = j.value("fare_amount", 0.0);
    if (j.contains("currency")) f.currency = j.value("currency", "INR");
    if (j.contains("applies_on")) f.applies_on = j.value("applies_on", "all_days");
    if (j.contains("is_smart_card")) f.is_smart_card = j.value("is_smart_card", false);
    if (j.contains("discount_pct")) f.discount_pct = j.value("discount_pct", 0.0);
    if (j.contains("source")) f.source = j.value("source", "");
    if (j.contains("data_status")) f.data_status = j.value("data_status", "estimated");
    if (j.contains("is_active")) f.is_active = j.value("is_active", true);
    return f;
}

// FareResult

nlohmann::json FareResult::to_json() const {
    nlohmann::json j;
    j["amount"] = amount;
    if (original_amount > 0.0) j["original_amount"] = original_amount;
    if (discount_applied > 0.0) j["discount_applied"] = discount_applied;
    j["currency"] = currency;
    j["status"] = status;
    if (!operator_name.empty()) j["operator_name"] = operator_name;
    if (!fare_type.empty()) j["fare_type"] = fare_type;
    j["fare_class"] = fare_class;
    if (!source.empty()) j["source"] = source;
    if (!details.empty()) j["details"] = details;
    return j;
}

FareResult FareResult::from_json(const nlohmann::json& j) {
    FareResult f;
    if (j.contains("amount")) f.amount = j.value("amount", 0.0);
    if (j.contains("original_amount")) f.original_amount = j.value("original_amount", 0.0);
    if (j.contains("discount_applied")) f.discount_applied = j.value("discount_applied", 0.0);
    if (j.contains("currency")) f.currency = j.value("currency", "INR");
    if (j.contains("status")) f.status = j.value("status", "verified");
    if (j.contains("operator_name")) f.operator_name = j.value("operator_name", "");
    if (j.contains("fare_type")) f.fare_type = j.value("fare_type", "");
    if (j.contains("fare_class")) f.fare_class = j.value("fare_class", "general");
    if (j.contains("source")) f.source = j.value("source", "");
    if (j.contains("details")) f.details = j.value("details", "");
    return f;
}

} // namespace models
} // namespace raasta
