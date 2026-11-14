#include <iostream>
#include <csignal>
#include <memory>

#include "raasta/config/config.hpp"
#include "raasta/repository/db_connection.hpp"
#include "raasta/graph/transport_graph.hpp"
#include "raasta/services/graph_builder_service.hpp"
#include "raasta/services/fare_service.hpp"
#include "raasta/services/route_service.hpp"
#include "raasta/api/server.hpp"

static std::unique_ptr<raasta::api::Server> g_server;

void signalHandler(int signal) {
    std::cout << "\n[main] Received signal " << signal << ", shutting down...\n";
    if (g_server) {
        g_server->stop();
    }
}

int main(int argc, char* argv[]) {
    std::cout << "╔══════════════════════════════════════════════════╗\n";
    std::cout << "║      RAASTA - Public Transport Route Engine     ║\n";
    std::cout << "║      Delhi NCR                ║\n";
    std::cout << "╚══════════════════════════════════════════════════╝\n\n";
    
    // Load configuration
    std::string env_file = ".env";
    if (argc > 1) {
        env_file = argv[1];
    }
    auto config = raasta::config::Config::load(env_file);
    
    // Setup signal handlers
    std::signal(SIGINT, signalHandler);
    std::signal(SIGTERM, signalHandler);
    
    // Initialize database connection
    auto& db = raasta::repository::DbConnection::instance();
    bool db_connected = db.initialize(
        config.db_host, config.db_port,
        config.db_user, config.db_password,
        config.db_name
    );
    
    if (db_connected) {
        std::cout << "[main] Database connected successfully\n";
    } else {
        std::cerr << "[main] Warning: Database connection failed. Running in limited mode.\n";
        std::cerr << "[main] API endpoints requiring database will return errors.\n";
    }
    
    // Build transport graph
    auto graph = std::make_shared<raasta::graph::TransportGraph>();
    
    raasta::services::GraphBuilderService builder(db);
    builder.buildGraph(*graph, config.data_dir);
    std::cout << "[main] Transport graph built: " 
              << graph->stationCount() << " stations, "
              << graph->edgeCount() << " edges\n";
    
    // Initialize services
    auto fare_service = std::make_shared<raasta::services::FareService>(db);
    auto route_service = std::make_shared<raasta::services::RouteService>(graph, fare_service);
    
    // Start HTTP server
    g_server = std::make_unique<raasta::api::Server>(
        config, db, *graph, route_service, fare_service
    );
    
    std::cout << "[main] Starting server on port " << config.server_port << "...\n";
    g_server->start();
    
    std::cout << "[main] Server stopped. Goodbye.\n";
    return 0;
}
