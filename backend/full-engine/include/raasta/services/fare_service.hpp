#pragma once

#include <vector>
#include <unordered_map>
#include <memory>
#include <string>
#include "raasta/models/fare.hpp"
#include "raasta/models/route_result.hpp"

namespace raasta {
namespace repository { class DbConnection; }
namespace services {

struct FareContext {
    double distance_km = 0.0;
    int stops_count = 0;
    int from_station_id = 0;
    int to_station_id = 0;
    std::string from_station_code;
    std::string to_station_code;
    int operator_id = 0;
    std::string line_code;
    std::string fare_class = "general"; // ac, non_ac, 2S, SL, CC, 3A, 2A, 1A, standard, premium
    std::string day_type = "weekday";   // weekday, weekend, sunday, holiday
    std::string departure_time = "";    // HH:MM for non-peak discount
    bool is_smart_card = false;
};

class IFareCalculator {
public:
    virtual ~IFareCalculator() = default;
    
    virtual models::FareResult calculateFare(const FareContext& ctx) const = 0;
    
    virtual models::FareResult calculateFare(
        double distance_km, int operator_id = 0,
        const std::string& fare_class = "general",
        const std::string& day_type = "weekday"
    ) const {
        FareContext ctx;
        ctx.distance_km = distance_km;
        ctx.operator_id = operator_id;
        ctx.fare_class = fare_class;
        ctx.day_type = day_type;
        return calculateFare(ctx);
    }
    
    virtual std::string transportTypeCode() const = 0;
};

class MetroFareCalculator : public IFareCalculator {
public:
    MetroFareCalculator();
    void loadFareRules(const std::vector<models::FareRule>& rules);
    models::FareResult calculateFare(const FareContext& ctx) const override;
    std::string transportTypeCode() const override { return "metro"; }

private:
    struct FareSlab { double max_km; double fare; double sunday_fare; };
    std::vector<FareSlab> dmrc_slabs_;
    
    // Station-count slabs for Noida, Lucknow, Kanpur, Agra
    struct StationCountSlab { int max_stations; double fare; };
    std::vector<StationCountSlab> nmrc_slabs_;
    std::vector<StationCountSlab> upmrc_lucknow_slabs_;
    std::vector<StationCountSlab> upmrc_kanpur_slabs_;
    std::vector<StationCountSlab> upmrc_agra_slabs_;
    
    bool isNonPeakHour(const std::string& time_hhmm) const;
};

class BusFareCalculator : public IFareCalculator {
public:
    BusFareCalculator();
    void loadFareRules(const std::vector<models::FareRule>& rules);
    models::FareResult calculateFare(const FareContext& ctx) const override;
    std::string transportTypeCode() const override { return "bus"; }

private:
    struct FareSlab { double max_km; double fare; };
    std::vector<FareSlab> dtc_non_ac_slabs_;
    std::vector<FareSlab> dtc_ac_slabs_;
};

class RailwayFareCalculator : public IFareCalculator {
public:
    RailwayFareCalculator();
    void loadFareRules(const std::vector<models::FareRule>& rules);
    models::FareResult calculateFare(const FareContext& ctx) const override;
    std::string transportTypeCode() const override { return "railway"; }

private:
    struct RailClassFare {
        double min_fare;
        double base_fare;
        double per_km_rate;
        double reservation_fee;
        double superfast_surcharge;
    };
    std::unordered_map<std::string, RailClassFare> class_fares_;
};

class RRTSFareCalculator : public IFareCalculator {
public:
    RRTSFareCalculator();
    void loadFareRules(const std::vector<models::FareRule>& rules);
    models::FareResult calculateFare(const FareContext& ctx) const override;
    std::string transportTypeCode() const override { return "rrts"; }

private:
    struct FareSlab { double max_km; double standard_fare; double premium_fare; };
    std::vector<FareSlab> rrts_slabs_;
};

class FareService {
public:
    explicit FareService(repository::DbConnection& db);
    
    models::FareResult calculateSegmentFare(
        int transport_type_id,
        double distance_km,
        int operator_id = 0,
        const std::string& fare_class = "general",
        const std::string& day_type = "weekday"
    ) const;

    models::FareResult calculateFare(
        int transport_type_id,
        const FareContext& ctx
    ) const;

    // Route-level fare calculation across continuous legs
    models::FareResult calculateRouteFare(
        const models::RouteResult& route,
        const FareContext& base_ctx = FareContext()
    ) const;

    void applyFaresToRoute(
        models::RouteResult& route,
        const FareContext& base_ctx = FareContext()
    ) const;

    void reloadFareRules();
    const IFareCalculator* getCalculator(const std::string& type_code) const;

private:
    repository::DbConnection& db_;
    std::unordered_map<std::string, std::unique_ptr<IFareCalculator>> calculators_;
    std::unordered_map<int, std::string> type_id_to_code_;

    void initializeDefaultFares();
    void loadFareRulesFromDb();
};

} // namespace services
} // namespace raasta
