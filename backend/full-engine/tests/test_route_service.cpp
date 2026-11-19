#include <iostream>
#include <cassert>
#include <cmath>
#include <vector>
#include <string>
#include "raasta/graph/transport_graph.hpp"
#include "raasta/services/route_service.hpp"
#include "raasta/services/fare_service.hpp"
#include "raasta/services/graph_builder_service.hpp"
#include "raasta/repository/db_connection.hpp"

using namespace raasta;

int main() {
    std::cout << "[test_route_service] Running RouteService focused tests...\n";

    auto& db = repository::DbConnection::instance();
    auto fare_svc = std::make_shared<services::FareService>(db);

    // Build a test graph with known structure
    auto graph = std::make_shared<graph::TransportGraph>();

    // Station 1: Source
    models::Station s1{1, "Station A", "SA", 28.6, 77.2, 1, 1, "metro_station"};
    // Station 2: Intermediate with fare available
    models::Station s2{2, "Station B", "SB", 28.6, 77.2, 1, 1, "metro_station"};
    // Station 3: Destination - reachable via valid fare
    models::Station s3{3, "Station C", "SC", 28.6, 77.2, 1, 1, "metro_station"};
    // Station 4: Destination via unavailable fare path
    models::Station s4{4, "Station D", "SD", 28.6, 77.2, 1, 1, "metro_station"};
    // Station 5: Destination via zero-fare leg (transfer)
    models::Station s5{5, "Station E", "SE", 28.6, 77.2, 1, 1, "metro_station"};

    graph->addStation(s1);
    graph->addStation(s2);
    graph->addStation(s3);
    graph->addStation(s4);
    graph->addStation(s5);

    // Metro edge 1->2 (fare available)
    graph::GraphEdge e12;
    e12.to_station_id = 2;
    e12.line_id = 1;
    e12.transport_type_id = 1; // metro
    e12.distance_km = 5.0;
    e12.travel_time_min = 8.0;
    e12.line_name = "Test Metro Line";
    e12.line_color = "#FF0000";
    e12.fare = 20.0;
    graph->addEdge(1, e12);

    // Metro edge 2->3 (fare available, destination via valid fare)
    graph::GraphEdge e23;
    e23.to_station_id = 3;
    e23.line_id = 1;
    e23.transport_type_id = 1;
    e23.distance_km = 5.0;
    e23.travel_time_min = 8.0;
    e23.line_name = "Test Metro Line";
    e23.line_color = "#FF0000";
    e23.fare = 20.0;
    graph->addEdge(2, e23);

    // Metro edge 2->4 (fare UNAVAILABLE - operator 99)
    graph::GraphEdge e24;
    e24.to_station_id = 4;
    e24.line_id = 2;
    e24.transport_type_id = 99; // Unknown transport type -> unavailable fare
    e24.distance_km = 5.0;
    e24.travel_time_min = 8.0;
    e24.line_name = "Unavailable Fare Line";
    e24.line_color = "#000000";
    e24.fare = -1.0;
    graph->addEdge(2, e24);

    // Transfer edge 1->5 (zero fare)
    graph::GraphEdge e15;
    e15.to_station_id = 5;
    e15.line_id = 0;
    e15.transport_type_id = 0; // transfer
    e15.distance_km = 0.1;
    e15.travel_time_min = 5.0;
    e15.is_transfer = true;
    e15.line_name = "Transfer";
    e15.fare = 0.0;
    graph->addEdge(1, e15);

    // Metro edge 5->3 (fare available, destination via zero-fare transfer + valid fare)
    graph::GraphEdge e53;
    e53.to_station_id = 3;
    e53.line_id = 1;
    e53.transport_type_id = 1;
    e53.distance_km = 5.0;
    e53.travel_time_min = 8.0;
    e53.line_name = "Test Metro Line";
    e53.line_color = "#FF0000";
    e53.fare = 20.0;
    graph->addEdge(5, e53);

    // Create route service
    services::RouteService route_svc(graph, fare_svc);

    std::cout << "[test_route_service] Test 1: Cheapest route with unavailable fare must not return ₹0\n";
    {
        services::RouteRequest req;
        req.source_station_id = 1;
        req.destination_station_id = 4; // Via unavailable fare edge 2->4
        req.criteria = "cheapest";
        req.fare_class = "standard";
        req.day_type = "weekday";
        req.departure_time = "10:00";
        req.is_smart_card = false;

        auto res = route_svc.findRoute(req);
        assert(!res.found && "Route with unavailable fare should not be found by cheapest search");
        std::cout << "  PASS: Unavailable fare route correctly rejected\n";
    }

    std::cout << "[test_route_service] Test 2: Route with valid fare remains selectable\n";
    {
        services::RouteRequest req;
        req.source_station_id = 1;
        req.destination_station_id = 3; // Via valid fare edges 1->2->3
        req.criteria = "cheapest";
        req.fare_class = "standard";
        req.day_type = "weekday";
        req.departure_time = "10:00";
        req.is_smart_card = false;

        auto res = route_svc.findRoute(req);
        assert(res.found && "Route with valid fare should be found");
        assert(res.total_fare > 0.0 && "Valid fare should be > 0");
        assert(std::isfinite(res.total_fare) && "Fare should be finite");
        std::cout << "  PASS: Valid fare route correctly selected with fare " << res.total_fare << "\n";
    }

    std::cout << "[test_route_service] Test 3: Legitimate zero-fare route (transfer) remains eligible\n";
    {
        // Path 1->5 (transfer, zero fare) -> 3 (valid fare)
        services::RouteRequest req;
        req.source_station_id = 1;
        req.destination_station_id = 3; // Via 1->5 (transfer) -> 3
        req.criteria = "cheapest";
        req.fare_class = "standard";
        req.day_type = "weekday";
        req.departure_time = "10:00";
        req.is_smart_card = false;

        auto res = route_svc.findRoute(req);
        assert(res.found && "Route with zero-fare transfer leg should be found");
        assert(res.total_fare > 0.0 && "Total fare should be > 0 (only the metro leg has fare)");
        // Path: 1->5 (transfer, 0 fare) + 5->3 (metro, 20.0) = 20.0
        assert(std::abs(res.total_fare - 20.0) < 0.01 && "Total fare should be 20.0 (only metro leg)");
        std::cout << "  PASS: Zero-fare transfer leg correctly handled, total fare = " << res.total_fare << "\n";
    }

    std::cout << "[test_route_service] Test 4: Fastest/shortest/min-stops routing works despite unavailable fare\n";
    {
        // Fastest routing should work regardless of fare availability
        services::RouteRequest req_fast;
        req_fast.source_station_id = 1;
        req_fast.destination_station_id = 4;
        req_fast.criteria = "fastest";

        auto res_fast = route_svc.findRoute(req_fast);
        assert(res_fast.found && "Fastest routing should work despite unavailable fare");

        // Shortest routing
        services::RouteRequest req_short;
        req_short.source_station_id = 1;
        req_short.destination_station_id = 4;
        req_short.criteria = "shortest";

        auto res_short = route_svc.findRoute(req_short);
        assert(res_short.found && "Shortest routing should work despite unavailable fare");

        // Min stops routing
        services::RouteRequest req_stops;
        req_stops.source_station_id = 1;
        req_stops.destination_station_id = 4;
        req_stops.criteria = "min_stops";

        auto res_stops = route_svc.findRoute(req_stops);
        assert(res_stops.found && "Min-stops routing should work despite unavailable fare");

        std::cout << "  PASS: Non-fare routing modes work despite unavailable fare data\n";
    }

    std::cout << "[test_route_service] Test 5: Valid fare route selectable over unavailable fare candidate\n";
    {
        // Path 1->2->3 (valid fare = 40) vs 1->2->4 (unavailable fare = infinity)
        // Cheapest should pick the valid fare path even though both exist
        services::RouteRequest req;
        req.source_station_id = 1;
        req.destination_station_id = 3; // Valid fare path
        req.criteria = "cheapest";

        auto res = route_svc.findRoute(req);
        assert(res.found && "Valid fare path should be selected");
        assert(res.total_fare > 0.0 && "Should have valid fare");
        assert(res.total_fare < std::numeric_limits<double>::infinity());
        std::cout << "  PASS: Valid fare path correctly chosen over unavailable fare alternative\n";
    }

    std::cout << "[test_route_service] Test 6: Unavailable fare on intermediate leg handled correctly\n";
    {
        // Test that an intermediate leg with unavailable fare makes completed_fare infinite
        // and the label is not selected as best
        services::RouteRequest req;
        req.source_station_id = 1;
        req.destination_station_id = 4;
        req.criteria = "cheapest";

        auto res = route_svc.findRoute(req);
        assert(!res.found && "Route with intermediate unavailable fare should not be found");
        std::cout << "  PASS: Intermediate unavailable fare correctly rejected\n";
    }

    std::cout << "[test_route_service] All focused tests passed successfully!\n";
    return 0;
}