#pragma once

#include <memory>
#include <string>
#include <httplib.h>
#include "raasta/config/config.hpp"
#include "raasta/repository/db_connection.hpp"
#include "raasta/graph/transport_graph.hpp"
#include "raasta/services/route_service.hpp"
#include "raasta/services/fare_service.hpp"

namespace raasta {
namespace api {

class Server {
public:
    Server(
        const config::Config& config,
        repository::DbConnection& db,
        graph::TransportGraph& graph,
        std::shared_ptr<services::RouteService> route_service,
        std::shared_ptr<services::FareService> fare_service
    );
    ~Server();

    void start();
    void stop();

    httplib::Server& getHttpServer() { return svr_; }

private:
    void registerRoutes();
    void setupCors();
    bool authenticateAdmin(const httplib::Request& req, httplib::Response& res);

    config::Config config_;
    repository::DbConnection& db_;
    graph::TransportGraph& graph_;
    std::shared_ptr<services::RouteService> route_service_;
    std::shared_ptr<services::FareService> fare_service_;
    httplib::Server svr_;
};

} // namespace api
} // namespace raasta

