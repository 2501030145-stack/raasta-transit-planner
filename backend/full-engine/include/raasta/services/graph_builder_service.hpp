#pragma once

#include <string>
#include "raasta/graph/transport_graph.hpp"
#include "raasta/repository/db_connection.hpp"

namespace raasta {
namespace services {

class GraphBuilderService {
public:
    explicit GraphBuilderService(repository::DbConnection& db);
    
    // Build the complete transport graph (from database or CSV fallback)
    void buildGraph(graph::TransportGraph& graph, const std::string& data_dir = "./data");
    
    // Rebuild graph (clear and rebuild)
    void rebuildGraph(graph::TransportGraph& graph, const std::string& data_dir = "./data");

    // Load directly from verified CSV files in data/
    void loadFromCsv(graph::TransportGraph& graph, const std::string& data_dir);

private:
    repository::DbConnection& db_;
    
    void loadStations(graph::TransportGraph& graph);
    void loadConnections(graph::TransportGraph& graph);
    void loadInterchanges(graph::TransportGraph& graph);
};

} // namespace services
} // namespace raasta

