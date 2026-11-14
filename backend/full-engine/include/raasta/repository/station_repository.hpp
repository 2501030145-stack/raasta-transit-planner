#pragma once

#include <vector>
#include <string>
#include <optional>
#include "raasta/models/station.hpp"
#include "raasta/repository/db_connection.hpp"

namespace raasta {
namespace repository {

class StationRepository {
public:
    explicit StationRepository(DbConnection& db);

    // CRUD
    int create(const models::Station& station);
    bool update(const models::Station& station);
    bool remove(int station_id);

    // Queries
    std::optional<models::Station> findById(int id);
    std::vector<models::Station> findAll(bool active_only = true);
    std::vector<models::Station> search(const std::string& query, int limit = 20);
    std::vector<models::Station> findByType(const std::string& station_type);
    std::vector<models::Station> findByCity(int city_id);
    std::vector<models::Station> findByLine(int line_id);

    // Aliases
    bool addAlias(int station_id, const std::string& alias,
                  const std::string& alias_type = "alternate");
    std::vector<std::string> getAliases(int station_id);

    // Counts
    int countAll(bool active_only = true);
    int countByType(const std::string& station_type);

private:
    DbConnection& db_;
    models::Station rowToStation(const Row& row);
};

} // namespace repository
} // namespace raasta

