#include <iostream>
#include <cassert>
#include "raasta/graph/transport_graph.hpp"
#include "raasta/algorithms/dijkstra_router.hpp"

using namespace raasta;

int main() {
    std::cout << "[test_dijkstra] Running Dijkstra algorithm tests...\n";

    graph::TransportGraph g;

    // Create 4 stations:
    // 1 -> 2 -> 3 (Metro line 1: fast, higher distance)
    // 1 -> 4 -> 3 (Bus line 2: slower, shorter distance, lower fare)
    models::Station s1{1, "Station A", "STA", 28.6, 77.2, 1, 1, "metro_station"};
    models::Station s2{2, "Station B", "STB", 28.65, 77.22, 1, 1, "metro_station"};
    models::Station s3{3, "Station C", "STC", 28.7, 77.25, 1, 1, "metro_station"};
    models::Station s4{4, "Station D", "STD", 28.62, 77.21, 1, 1, "bus_stop"};
    models::Station s5{5, "Station E (Isolated)", "STE", 28.8, 77.3, 1, 1, "bus_stop"};

    g.addStation(s1);
    g.addStation(s2);
    g.addStation(s3);
    g.addStation(s4);
    g.addStation(s5);

    // Path via Metro: 1 -> 2 -> 3
    // 1 -> 2: dist 10km, time 10min, fare 30
    graph::GraphEdge e12;
    e12.to_station_id = 2; e12.line_id = 1; e12.transport_type_id = 1;
    e12.distance_km = 10.0; e12.travel_time_min = 10.0; e12.fare = 30.0;
    g.addEdge(1, e12);

    // 2 -> 3: dist 10km, time 10min, fare 30
    graph::GraphEdge e23;
    e23.to_station_id = 3; e23.line_id = 1; e23.transport_type_id = 1;
    e23.distance_km = 10.0; e23.travel_time_min = 10.0; e23.fare = 30.0;
    g.addEdge(2, e23);

    // Path via Bus: 1 -> 4 -> 3
    // 1 -> 4: dist 4km, time 25min, fare 10
    graph::GraphEdge e14;
    e14.to_station_id = 4; e14.line_id = 2; e14.transport_type_id = 2;
    e14.distance_km = 4.0; e14.travel_time_min = 25.0; e14.fare = 10.0;
    g.addEdge(1, e14);

    // 4 -> 3: dist 4km, time 25min, fare 10
    graph::GraphEdge e43;
    e43.to_station_id = 3; e43.line_id = 2; e43.transport_type_id = 2;
    e43.distance_km = 4.0; e43.travel_time_min = 25.0; e43.fare = 10.0;
    g.addEdge(4, e43);

    // 1. Test Fastest Route: should pick Metro (20 min vs 50 min)
    algorithms::DijkstraRouter fast_router(algorithms::RoutingCriteria::FASTEST);
    auto fast_res = fast_router.findRoute(g, 1, 3);
    assert(fast_res.found);
    assert(fast_res.estimated_time_min == 20.0);
    assert(fast_res.stations.size() == 3);
    assert(fast_res.stations[1].id == 2); // passes through Station B

    // 2. Test Shortest Distance: should pick Bus (8 km vs 20 km)
    algorithms::DijkstraRouter short_router(algorithms::RoutingCriteria::SHORTEST_DISTANCE);
    auto short_res = short_router.findRoute(g, 1, 3);
    assert(short_res.found);
    assert(short_res.total_distance_km == 8.0);
    assert(short_res.stations.size() == 3);
    assert(short_res.stations[1].id == 4); // passes through Station D

    // 3. Test Cheapest Route: should pick Bus (fare 20 vs 60)
    algorithms::DijkstraRouter cheap_router(algorithms::RoutingCriteria::CHEAPEST);
    auto cheap_res = cheap_router.findRoute(g, 1, 3);
    assert(cheap_res.found);
    assert(cheap_res.total_fare == 20.0);
    assert(cheap_res.stations[1].id == 4);

    // 4. Test Unreachable: to station 5
    auto unreach_res = fast_router.findRoute(g, 1, 5);
    assert(!unreach_res.found);

    // 5. Test Invalid station ID
    auto invalid_res = fast_router.findRoute(g, 1, 999);
    assert(!invalid_res.found);

    std::cout << "[test_dijkstra] All tests passed!\n";
    return 0;
}

