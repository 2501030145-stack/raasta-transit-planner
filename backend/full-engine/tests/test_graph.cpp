#include <iostream>
#include <cassert>
#include "raasta/graph/transport_graph.hpp"

using namespace raasta;

int main() {
    std::cout << "[test_graph] Running TransportGraph tests...\n";

    graph::TransportGraph g;
    assert(g.stationCount() == 0);
    assert(g.edgeCount() == 0);

    models::Station s1;
    s1.id = 1;
    s1.name = "Rajiv Chowk";
    s1.latitude = 28.6328;
    s1.longitude = 77.2197;
    s1.station_type = "metro_station";

    models::Station s2;
    s2.id = 2;
    s2.name = "Kashmere Gate";
    s2.latitude = 28.6675;
    s2.longitude = 77.2285;
    s2.station_type = "metro_station";

    g.addStation(s1);
    g.addStation(s2);

    assert(g.stationCount() == 2);
    assert(g.hasStation(1));
    assert(g.hasStation(2));
    assert(!g.hasStation(3));

    assert(g.getStation(1).name == "Rajiv Chowk");

    // Add edge
    graph::GraphEdge edge;
    edge.to_station_id = 2;
    edge.line_id = 1;
    edge.transport_type_id = 1;
    edge.distance_km = 4.2;
    edge.travel_time_min = 8.0;

    g.addEdge(1, edge);
    assert(g.edgeCount() == 1);
    assert(g.getEdges(1).size() == 1);
    assert(g.getEdges(2).empty());

    // Add bidirectional edge
    graph::GraphEdge edge2;
    edge2.line_id = 1;
    edge2.transport_type_id = 1;
    edge2.distance_km = 4.2;
    edge2.travel_time_min = 8.0;

    g.addBidirectionalEdge(1, 2, edge2);
    // Note: total edges is now 1 + 2 = 3
    assert(g.edgeCount() == 3);
    assert(g.getEdges(2).size() == 1);

    // Test filtered edges
    std::set<int> allowed_metro = {1};
    std::set<int> allowed_bus = {2};
    assert(g.getFilteredEdges(1, allowed_metro).size() == 2);
    assert(g.getFilteredEdges(1, allowed_bus).empty());

    // Test clear
    g.clear();
    assert(g.stationCount() == 0);
    assert(g.edgeCount() == 0);

    std::cout << "[test_graph] All tests passed!\n";
    return 0;
}

