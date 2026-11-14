#include <iostream>
#include <cassert>
#include <thread>
#include <chrono>
#include "raasta/config/config.hpp"
#include "raasta/repository/db_connection.hpp"
#include "raasta/graph/transport_graph.hpp"
#include "raasta/services/fare_service.hpp"
#include "raasta/services/route_service.hpp"
#include "raasta/api/server.hpp"

using namespace raasta;

int main() {
    std::cout << "[test_api_server] Running API server initialization and routing test...\n";

    config::Config cfg;
    cfg.server_port = 8089;
    cfg.cors_origin = "*";

    auto& db = repository::DbConnection::instance();
    auto graph = std::make_shared<graph::TransportGraph>();

    // Add sample stations to graph
    models::Station s1{1, "Kashmere Gate", "KG", 28.6675, 77.2285, 1, 1, "metro_station"};
    models::Station s2{2, "Chandni Chowk", "CC", 28.6578, 77.2301, 1, 1, "metro_station"};
    graph->addStation(s1);
    graph->addStation(s2);

    graph::GraphEdge e12;
    e12.to_station_id = 2;
    e12.line_id = 1;
    e12.transport_type_id = 1;
    e12.distance_km = 1.1;
    e12.travel_time_min = 2.5;
    e12.line_name = "Yellow Line";
    graph->addEdge(1, e12);

    auto fare_svc = std::make_shared<services::FareService>(db);
    auto route_svc = std::make_shared<services::RouteService>(graph, fare_svc);

    api::Server server(cfg, db, *graph, route_svc, fare_svc);

    // Verify route finding directly through RouteService
    services::RouteRequest rreq;
    rreq.source_station_id = 1;
    rreq.destination_station_id = 2;
    rreq.criteria = "fastest";

    auto route = route_svc->findRoute(rreq);
    assert(route.found);
    assert(route.stations.size() == 2);
    assert(route.total_distance_km == 1.1);

    auto api_resp = route.to_api_response();
    assert(api_resp["success"] == true);
    assert(api_resp["route"]["total_distance_km"] == 1.1);

    std::cout << "[test_api_server] API routing and responses verified successfully!\n";
    return 0;
}

