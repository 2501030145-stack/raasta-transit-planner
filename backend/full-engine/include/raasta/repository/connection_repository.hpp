#pragma once

#include <vector>
#include <string>
#include <optional>
#include "raasta/models/connection.hpp"
#include "raasta/models/line.hpp"
#include "raasta/repository/db_connection.hpp"

namespace raasta {
namespace repository {

class ConnectionRepository {
public:
    explicit ConnectionRepository(DbConnection& db);

    int create(const models::Connection& conn);
    bool update(const models::Connection& conn);
    bool remove(int connection_id);

    std::optional<models::Connection> findById(int id);
    std::vector<models::Connection> findAll(bool active_only = true);
    std::vector<models::Connection> findByStation(int station_id);
    std::vector<models::Connection> findByLine(int line_id);
    std::vector<models::Connection> findByTransportType(int type_id);

    int countAll(bool active_only = true);

private:
    DbConnection& db_;
    models::Connection rowToConnection(const Row& row);
};

class LineRepository {
public:
    explicit LineRepository(DbConnection& db);

    std::vector<models::TransportLine> findAll(bool active_only = true);
    std::optional<models::TransportLine> findById(int id);
    std::vector<models::TransportLine> findByTransportType(int type_id);

private:
    DbConnection& db_;
};

} // namespace repository
} // namespace raasta

