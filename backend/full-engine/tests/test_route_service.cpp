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

    std::cout << "[test_route_service] Test 5: Valid fare route selectable over unavailable fare candidate (same destination)\n";
    {
        // Create a completely isolated graph for this test to avoid interference from other tests
        auto isolated_graph = std::make_shared<graph::TransportGraph>();
        auto isolated_fare_svc = fare_svc;
        services::RouteService isolated_route_svc(isolated_graph, isolated_fare_svc);

        // Both paths end at station 8 (destination):
        // Path A: 1 -> 2 -> 3 -> 8 (all valid fares)
        // Path B: 1 -> 2 -> 8 (unavailable fare on 2->8)
        // Cheapest should pick the valid path to station 8

        // Build a minimal graph: 1 -> 2 (valid) -> 3 (valid) -> 8 (destination)
        // and 1 -> 2 -> 8 (unavailable fare on 2->8)
        models::Station s1{1, "Station A", "SA", 28.6, 77.2, 1, 1, "metro_station"};
        models::Station s2{2, "Station B", "SB", 28.6, 77.2, 1, 1, "metro_station"};
        models::Station s3{3, "Station C", "SC", 28.6, 77.2, 1, 1, "metro_station"};
        models::Station s8{8, "Destination", "DST", 28.6, 77.2, 1, 1, "metro_station"};


        isolated_graph->addStation(s1);
        isolated_graph->addStation(s2);
        isolated_graph->addStation(s3);
        isolated_graph->addStation(s8);

        // 1 -> 2 (valid fare)
        graph::GraphEdge e12;
        e12.to_station_id = 2;
        e12.line_id = 1;
        e12.transport_type_id = 1;
        e12.distance_km = 5.0;
        e12.travel_time_min = 8.0;
        e12.line_name = "Test Metro Line";
        e12.line_color = "#FF0000";
        e12.fare = 20.0;
        isolated_graph->addEdge(1, e12);

        // 2 -> 3 (valid fare)
        graph::GraphEdge e23;
        e23.to_station_id = 3;
        e23.line_id = 1;
        e23.transport_type_id = 1;
        e23.distance_km = 5.0;
        e23.travel_time_min = 8.0;
        e23.line_name = "Test Metro Line";
        e23.line_color = "#FF0000";
        e23.fare = 20.0;
        isolated_graph->addEdge(2, e23);

        // 3 -> 8 (valid fare, destination)
        graph::GraphEdge e38;
        e38.to_station_id = 8;
        e38.line_id = 1;
        e38.transport_type_id = 1;
        e38.distance_km = 5.0;
        e38.travel_time_min = 8.0;
        e38.line_name = "Test Metro Line";
        e38.line_color = "#FF0000";
        e38.fare = 20.0;
        isolated_graph->addEdge(3, e38);

        // Unavailable edge from 2 to 8 (bypass)
        graph::GraphEdge e28;
        e28.to_station_id = 8;
        e28.line_id = 2;
        e28.transport_type_id = 99; // Unknown -> unavailable fare
        e28.distance_km = 5.0;
        e28.travel_time_min = 8.0;
        e28.line_name = "Unavailable Fare Line";
        e28.line_color = "#000000";
        e28.fare = -1.0;
        isolated_graph->addEdge(2, e28);

        services::RouteRequest req;
        req.source_station_id = 1;
        req.destination_station_id = 8; // Same destination for both paths
        req.criteria = "cheapest";
        req.fare_class = "standard";
        req.day_type = "weekday";
        req.departure_time = "10:00";
        req.is_smart_card = false;

        auto res = isolated_route_svc.findRoute(req);
        assert(res.found && "Valid fare path should be selected");
        assert(res.total_fare > 0.0 && "Should have valid fare");
        // Path 1->2->3->8: 20 + 20 + 20 = 60 (or whatever the fare calculates to)
        assert(std::isfinite(res.total_fare) && "Total fare should be finite");

        // Verify the path taken is 1->2->3->8 (not 1->2->8)
        assert(res.stations.size() == 4 && "Path should have 4 stations (1,2,3,8)");
        assert(res.stations[0].id == 1 && "Start at station 1");
        assert(res.stations[1].id == 2 && "Pass through station 2");
        assert(res.stations[2].id == 3 && "Pass through station 3");
        assert(res.stations[3].id == 8 && "End at station 8");

        std::cout << "  PASS: Valid fare path correctly chosen over unavailable fare alternative, fare = " << res.total_fare << "\n";
    }

    std::cout << "[test_route_service] Test 6: Unavailable fare on intermediate leg handled correctly\n";
    {
        // Path: 1 -> 2 -> X -> 8 where 2->X has unavailable fare (intermediate leg)
        // X is station 7 (intermediate), destination is 8
        // The ONLY path to destination 8 goes through unavailable edge 2->7

        // Create a completely isolated graph for this test to avoid interference from other tests
        auto isolated_graph = std::make_shared<graph::TransportGraph>();
        auto& db = repository::DbConnection::instance();
        auto isolated_fare_svc = std::make_shared<services::FareService>(db);
        services::RouteService isolated_route_svc(isolated_graph, isolated_fare_svc);

        // Build a minimal graph: 1 -> 2 (valid) -> 7 (unavailable) -> 8 (destination)
        models::Station s1{1, "Station A", "SA", 28.6, 77.2, 1, 1, "metro_station"};
        models::Station s2{2, "Station B", "SB", 28.6, 77.2, 1, 1, "metro_station"};
        models::Station sx{7, "Station X", "SX", 28.6, 77.2, 1, 1, "metro_station"};
        models::Station s8{8, "Destination", "DST", 28.6, 77.2, 1, 1, "metro_station"};

        isolated_graph->addStation(s1);
        isolated_graph->addStation(s2);
        isolated_graph->addStation(sx);
        isolated_graph->addStation(s8);

        // 1 -> 2 (valid fare)
        graph::GraphEdge e12;
        e12.to_station_id = 2;
        e12.line_id = 1;
        e12.transport_type_id = 1;
        e12.distance_km = 5.0;
        e12.travel_time_min = 8.0;
        e12.line_name = "Test Metro Line";
        e12.line_color = "#FF0000";
        e12.fare = 20.0;
        isolated_graph->addEdge(1, e12);

        // 2 -> X (unavailable fare) - intermediate leg
        graph::GraphEdge e2x;
        e2x.to_station_id = 7;
        e2x.line_id = 99;
        e2x.transport_type_id = 99;
        e2x.distance_km = 3.0;
        e2x.travel_time_min = 5.0;
        e2x.line_name = "Unavailable Intermediate";
        e2x.line_color = "#000000";
        e2x.fare = -1.0;
        isolated_graph->addEdge(2, e2x);

        // X -> destination (valid fare)
        graph::GraphEdge ex3;
        ex3.to_station_id = 8;
        ex3.line_id = 1;
        ex3.transport_type_id = 1;
        ex3.distance_km = 5.0;
        ex3.travel_time_min = 8.0;
        ex3.line_name = "Test Metro Line";
        ex3.line_color = "#FF0000";
        ex3.fare = 20.0;
        isolated_graph->addEdge(7, ex3);

        services::RouteRequest req;
        req.source_station_id = 1;
        req.destination_station_id = 8;
        req.criteria = "cheapest";
        req.fare_class = "standard";
        req.day_type = "weekday";
        req.departure_time = "10:00";
        req.is_smart_card = false;

        auto res = isolated_route_svc.findRoute(req);
        assert(!res.found && "Route with intermediate unavailable fare should not be found");
        std::cout << "  PASS: Intermediate unavailable fare correctly rejected\n";
    }

    std::cout << "[test_route_service] All focused tests passed successfully!\n";
    return 0;
}