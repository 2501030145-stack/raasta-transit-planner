#include <iostream>
#include <cassert>
#include "raasta/graph/transport_graph.hpp"
#include "raasta/algorithms/bfs_router.hpp"

using namespace raasta;

int main() {
    std::cout << "[test_bfs] Running BFS algorithm tests...\n";

    graph::TransportGraph g;

    // Create graph where:
    // Path 1 (Direct Express): 1 -> 3 (1 hop, 2 stops)
    // Path 2 (Local stops): 1 -> 2 -> 4 -> 3 (3 hops, 4 stops)
    models::Station s1{1, "Start", "S1", 28.0, 77.0, 1, 1, "metro_station"};
    models::Station s2{2, "Mid1", "S2", 28.1, 77.1, 1, 1, "metro_station"};
    models::Station s3{3, "End", "S3", 28.3, 77.3, 1, 1, "metro_station"};
    models::Station s4{4, "Mid2", "S4", 28.2, 77.2, 1, 1, "metro_station"};
    models::Station s5{5, "Isolated", "S5", 28.5, 77.5, 1, 1, "bus_stop"};

    g.addStation(s1);
    g.addStation(s2);
    g.addStation(s3);
    g.addStation(s4);
    g.addStation(s5);

    // Path 1: 1 -> 3 (Direct Express, high distance)
    graph::GraphEdge e13;
    e13.to_station_id = 3; e13.line_id = 1; e13.transport_type_id = 1;
    e13.distance_km = 30.0; e13.travel_time_min = 25.0;
    g.addEdge(1, e13);

    // Path 2: 1 -> 2 -> 4 -> 3 (Local)
    graph::GraphEdge e12; e12.to_station_id = 2; e12.line_id = 2; e12.transport_type_id = 1;
    g.addEdge(1, e12);
    graph::GraphEdge e24; e24.to_station_id = 4; e24.line_id = 2; e24.transport_type_id = 1;
    g.addEdge(2, e24);
    graph::GraphEdge e43; e43.to_station_id = 3; e43.line_id = 2; e43.transport_type_id = 1;
    g.addEdge(4, e43);

    algorithms::BFSRouter bfs;
    auto res = bfs.findRoute(g, 1, 3);

    assert(res.found);
    assert(res.number_of_stops == 2);
    assert(res.stations.size() == 2);
    assert(res.stations[0].id == 1);
    assert(res.stations[1].id == 3);

    // Test unreachable
    auto unreach = bfs.findRoute(g, 1, 5);
    assert(!unreach.found);

    // Test same source and destination
    auto same = bfs.findRoute(g, 1, 1);
    assert(same.found);
    assert(same.number_of_stops == 1);

    std::cout << "[test_bfs] All tests passed!\n";
    return 0;
}

