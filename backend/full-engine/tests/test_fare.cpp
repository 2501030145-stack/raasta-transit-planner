#include <iostream>
#include <cassert>
#include <cmath>
#include "raasta/services/fare_service.hpp"
#include "raasta/repository/db_connection.hpp"

using namespace raasta;

int main() {
    std::cout << "[test_fare] Running Comprehensive FareService tests...\n";

    auto& db = repository::DbConnection::instance();
    services::FareService fare_svc(db);

    // 1. Standard DMRC Metro fare tests (transport_type_id = 1)
    // 0-2 km: Rs 10
    auto f_metro_short = fare_svc.calculateSegmentFare(1, 1.5);
    assert(f_metro_short.amount == 10.0);
    assert(f_metro_short.currency == "INR");
    assert(f_metro_short.status == "verified");

    // 2-5 km: Rs 20
    auto f_metro_5km = fare_svc.calculateSegmentFare(1, 4.0);
    assert(f_metro_5km.amount == 20.0);

    // 5-12 km: Rs 30
    auto f_metro_10km = fare_svc.calculateSegmentFare(1, 10.0);
    assert(f_metro_10km.amount == 30.0);

    // >32 km: Rs 60
    auto f_metro_long = fare_svc.calculateSegmentFare(1, 45.0);
    assert(f_metro_long.amount == 60.0);

    // 2. DMRC Sunday / National Holiday Discounted Slabs
    services::FareContext ctx_sun;
    ctx_sun.distance_km = 4.0;
    ctx_sun.line_code = "DMRC_YELLOW";
    ctx_sun.day_type = "sunday";
    auto f_dmrc_sun = fare_svc.calculateFare(1, ctx_sun);
    assert(f_dmrc_sun.amount == 10.0); // Sunday slab 2-5km is Rs 10 (down from Rs 20)
    assert(f_dmrc_sun.details.find("Sunday") != std::string::npos);

    // 3. DMRC Smart Card Discounts (Peak 10%, Non-Peak 20%)
    // Peak hour (e.g. 10:00 AM) - 10% off Rs 20 = Rs 18
    services::FareContext ctx_card_peak;
    ctx_card_peak.distance_km = 4.0;
    ctx_card_peak.line_code = "DMRC_YELLOW";
    ctx_card_peak.is_smart_card = true;
    ctx_card_peak.departure_time = "10:00";
    ctx_card_peak.day_type = "weekday";
    auto f_card_peak = fare_svc.calculateFare(1, ctx_card_peak);
    assert(f_card_peak.amount == 18.0);
    assert(f_card_peak.discount_applied == 2.0);

    // Non-peak hour (e.g. 14:00 PM) - 20% off Rs 20 = Rs 16
    services::FareContext ctx_card_offpeak;
    ctx_card_offpeak.distance_km = 4.0;
    ctx_card_offpeak.line_code = "DMRC_YELLOW";
    ctx_card_offpeak.is_smart_card = true;
    ctx_card_offpeak.departure_time = "14:00";
    ctx_card_offpeak.day_type = "weekday";
    auto f_card_offpeak = fare_svc.calculateFare(1, ctx_card_offpeak);
    assert(f_card_offpeak.amount == 16.0);
    assert(f_card_offpeak.discount_applied == 4.0);

    // 4. Airport Express Line
    services::FareContext ctx_airport;
    ctx_airport.distance_km = 15.0;
    ctx_airport.line_code = "DMRC_AIRPORT";
    auto f_airport = fare_svc.calculateFare(1, ctx_airport);
    assert(f_airport.amount == 50.0);
    assert(f_airport.fare_type == "airport_express_slab");

    // 5. NMRC Aqua Line (Noida Metro) Station-Count Slabs
    // 2 stations = Rs 15
    services::FareContext ctx_nmrc;
    ctx_nmrc.distance_km = 2.5;
    ctx_nmrc.operator_id = 2;
    ctx_nmrc.line_code = "NMRC_AQUA";
    ctx_nmrc.stops_count = 2;
    auto f_nmrc = fare_svc.calculateFare(1, ctx_nmrc);
    assert(f_nmrc.amount == 15.0);
    assert(f_nmrc.operator_name == "Noida Metro (NMRC)");

    // 6. Rapid Metro Gurugram Flat Fare
    services::FareContext ctx_rm;
    ctx_rm.distance_km = 6.0;
    ctx_rm.operator_id = 3;
    ctx_rm.line_code = "RM_GURUGRAM";
    auto f_rm = fare_svc.calculateFare(1, ctx_rm);
    assert(f_rm.amount == 20.0);
    assert(f_rm.fare_type == "flat");

    // 7. Bus Fare Tests (transport_type_id = 2)
    // 0-4 km Non-AC: Rs 5 (DTC Non-AC 0-4km slab is Rs 5)
    auto f_bus_nonac = fare_svc.calculateSegmentFare(2, 3.0, 0, "non_ac");
    assert(f_bus_nonac.amount == 5.0);

    // 4-10 km Non-AC: Rs 10
    auto f_bus_nonac_mid = fare_svc.calculateSegmentFare(2, 7.0, 0, "non_ac");
    assert(f_bus_nonac_mid.amount == 10.0);

    // >10 km Non-AC: Rs 15
    auto f_bus_nonac_long = fare_svc.calculateSegmentFare(2, 14.0, 0, "non_ac");
    assert(f_bus_nonac_long.amount == 15.0);

    // 4-8 km AC: Rs 15
    auto f_bus_ac = fare_svc.calculateSegmentFare(2, 7.0, 0, "ac");
    assert(f_bus_ac.amount == 15.0);

    // 8. Indian Railways Fare Tests (transport_type_id = 3)
    // Sleeper: base 120 + 0.40 * 100km (40) + reservation fee (20) = 180
    auto f_rail_sl = fare_svc.calculateSegmentFare(3, 100.0, 0, "SL");
    assert(f_rail_sl.amount == 180.0);
    assert(f_rail_sl.status == "approximate"); // Explicitly marked as linearized approximation

    // AC 3-Tier: base 450 + 0.90 * 100km (90) + reservation fee (40) + superfast (45) = 625
    auto f_rail_3a = fare_svc.calculateSegmentFare(3, 100.0, 0, "3A");
    assert(f_rail_3a.amount == 625.0);
    assert(f_rail_3a.status == "approximate");

    // Unavailable fare test: must return status 'unavailable' and amount < 0 (never represented as zero)
    auto f_unavail = fare_svc.calculateSegmentFare(99, 10.0);
    assert(f_unavail.status == "unavailable");
    assert(f_unavail.amount < 0.0);

    // 9. Namo Bharat / RRTS Fare Tests (transport_type_id = 4)
    // Standard class <= 8km: Rs 20
    auto f_rrts_std = fare_svc.calculateSegmentFare(4, 7.0, 0, "standard");
    assert(f_rrts_std.amount == 20.0);

    // Premium class <= 8km: Rs 40 (2x standard)
    auto f_rrts_prem = fare_svc.calculateSegmentFare(4, 7.0, 0, "premium");
    assert(f_rrts_prem.amount == 40.0);

    // Full corridor Sarai Kale Khan to Modipuram (~82.15 km)
    // Standard class: Rs 210
    auto f_rrts_full_std = fare_svc.calculateSegmentFare(4, 82.15, 0, "standard");
    assert(f_rrts_full_std.amount == 210.0);

    // Premium class full corridor: Rs 250
    auto f_rrts_full_prem = fare_svc.calculateSegmentFare(4, 82.15, 0, "premium");
    assert(f_rrts_full_prem.amount == 250.0);

    // Namo Bharat Loyalty Program (10% NCMC / App discount)
    services::FareContext ctx_rrts_loyalty;
    ctx_rrts_loyalty.distance_km = 82.15;
    ctx_rrts_loyalty.fare_class = "standard";
    ctx_rrts_loyalty.is_smart_card = true;
    auto f_rrts_loyalty = fare_svc.calculateFare(4, ctx_rrts_loyalty);
    assert(f_rrts_loyalty.amount == 189.0); // 210 - 21 = 189
    assert(f_rrts_loyalty.discount_applied == 21.0);
    assert(f_rrts_loyalty.details.find("35%") != std::string::npos); // Documents the 35% statutory concession

    // Meerut Metro Local Fare
    services::FareContext ctx_mm;
    ctx_mm.distance_km = 10.0;
    ctx_mm.line_code = "MM_LINE1";
    auto f_mm = fare_svc.calculateFare(1, ctx_mm);
    assert(f_mm.amount == 40.0); // 8-12 km slab = Rs 40
    assert(f_mm.operator_name.find("Meerut") != std::string::npos);

    // Meerut Metro with NCMC discount (10% off Rs 40 = Rs 36)
    ctx_mm.is_smart_card = true;
    auto f_mm_card = fare_svc.calculateFare(1, ctx_mm);
    assert(f_mm_card.amount == 36.0);
    assert(f_mm_card.discount_applied == 4.0);

    // 10. Test Contiguous Journey Grouping in applyFaresToRoute
    // Scenario: Two consecutive DMRC metro hops (3 km and 4 km)
    // Separate hop calculation would give 20 + 20 = Rs 40.
    // Unified contiguous journey of 7 km (5-12km slab) correctly yields Rs 30!
    models::RouteResult route;
    models::RouteSegment s1;
    s1.transport_type_id = 1;
    s1.line_name = "Yellow Line";
    s1.distance_km = 3.0;
    route.segments.push_back(s1);

    models::RouteSegment s2;
    s2.transport_type_id = 1;
    s2.line_name = "Blue Line"; // Interchanged to Blue Line within DMRC
    s2.distance_km = 4.0;
    route.segments.push_back(s2);

    models::RouteSegment s3;
    s3.transport_type_id = 2; // Bus segment afterwards
    s3.distance_km = 3.0;     // Fare = Rs 5
    route.segments.push_back(s3);

    services::FareContext base_ctx;
    base_ctx.departure_time = "10:00";
    base_ctx.day_type = "weekday";
    base_ctx.fare_class = "standard";

    fare_svc.applyFaresToRoute(route, base_ctx);
    // Metro unified: 7.0 km => Rs 30
    // Bus: 3.0 km => Rs 5 (non_ac)
    // Total fare: 30 + 5 = Rs 35
    assert(route.total_fare == 35.0);
    assert(route.segments[0].fare.amount == 30.0); // Unified on the first segment
    assert(route.segments[1].fare.amount == 0.0);  // Covered by contiguous metro journey
    assert(route.segments[2].fare.amount == 5.0);  // Bus segment

    std::cout << "[test_fare] All tests passed successfully!\n";
    return 0;
}
