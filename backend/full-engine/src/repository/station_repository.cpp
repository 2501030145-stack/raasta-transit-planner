#include "raasta/repository/station_repository.hpp"
#include <sstream>
#include <iostream>

namespace raasta {
namespace repository {

StationRepository::StationRepository(DbConnection& db) : db_(db) {}

models::Station StationRepository::rowToStation(const Row& row) {
    models::Station s;
    auto get = [&](const std::string& key) -> std::string {
        auto it = row.find(key);
        return (it != row.end()) ? it->second : "";
    };
    auto getInt = [&](const std::string& key) -> int {
        auto v = get(key);
        return v.empty() ? 0 : std::stoi(v);
    };
    auto getDbl = [&](const std::string& key) -> double {
        auto v = get(key);
        return v.empty() ? 0.0 : std::stod(v);
    };

    s.id             = getInt("id");
    s.name           = get("name");
    s.code           = get("code");
    s.latitude       = getDbl("latitude");
    s.longitude      = getDbl("longitude");
    s.city_id        = getInt("city_id");
    s.state_id       = getInt("state_id");
    s.station_type   = get("station_type");
    s.address        = get("address");
    s.is_interchange = get("is_interchange") == "1";
    s.is_active      = get("is_active") != "0";
    s.data_status    = get("data_status");
    s.city_name      = get("city_name");
    s.state_name     = get("state_name");
    return s;
}

int StationRepository::create(const models::Station& station) {
    std::ostringstream sql;
    sql << "INSERT INTO stations (name, code, latitude, longitude, city_id, state_id, "
        << "station_type, address, is_interchange, is_active, data_status) VALUES ('"
        << db_.escape(station.name) << "', '"
        << db_.escape(station.code) << "', "
        << station.latitude << ", " << station.longitude << ", "
        << station.city_id << ", " << station.state_id << ", '"
        << db_.escape(station.station_type) << "', '"
        << db_.escape(station.address) << "', "
        << (station.is_interchange ? 1 : 0) << ", "
        << (station.is_active ? 1 : 0) << ", '"
        << db_.escape(station.data_status) << "')";
    return db_.executeInsert(sql.str());
}

bool StationRepository::update(const models::Station& station) {
    std::ostringstream sql;
    sql << "UPDATE stations SET "
        << "name='" << db_.escape(station.name) << "', "
        << "code='" << db_.escape(station.code) << "', "
        << "latitude=" << station.latitude << ", "
        << "longitude=" << station.longitude << ", "
        << "city_id=" << station.city_id << ", "
        << "state_id=" << station.state_id << ", "
        << "station_type='" << db_.escape(station.station_type) << "', "
        << "address='" << db_.escape(station.address) << "', "
        << "is_interchange=" << (station.is_interchange ? 1 : 0) << ", "
        << "is_active=" << (station.is_active ? 1 : 0) << ", "
        << "data_status='" << db_.escape(station.data_status) << "' "
        << "WHERE id=" << station.id;
    return db_.execute(sql.str());
}

bool StationRepository::remove(int station_id) {
    return db_.execute("DELETE FROM stations WHERE id=" + std::to_string(station_id));
}

std::optional<models::Station> StationRepository::findById(int id) {
    auto rows = db_.query(
        "SELECT s.*, c.name AS city_name, st.name AS state_name "
        "FROM stations s "
        "LEFT JOIN cities c ON s.city_id = c.id "
        "LEFT JOIN states st ON s.state_id = st.id "
        "WHERE s.id=" + std::to_string(id));
    if (rows.empty()) return std::nullopt;
    auto station = rowToStation(rows[0]);
    station.aliases = getAliases(id);
    return station;
}

std::vector<models::Station> StationRepository::findAll(bool active_only) {
    std::string sql =
        "SELECT s.*, c.name AS city_name, st.name AS state_name "
        "FROM stations s "
        "LEFT JOIN cities c ON s.city_id = c.id "
        "LEFT JOIN states st ON s.state_id = st.id";
    if (active_only) sql += " WHERE s.is_active = 1";
    sql += " ORDER BY s.name";

    auto rows = db_.query(sql);
    std::vector<models::Station> result;
    result.reserve(rows.size());
    for (const auto& row : rows) {
        result.push_back(rowToStation(row));
    }
    return result;
}

std::vector<models::Station> StationRepository::search(const std::string& query, int limit) {
    std::string escaped = db_.escape(query);
    std::ostringstream sql;
    sql << "SELECT s.*, c.name AS city_name, st.name AS state_name "
        << "FROM stations s "
        << "LEFT JOIN cities c ON s.city_id = c.id "
        << "LEFT JOIN states st ON s.state_id = st.id "
        << "WHERE s.is_active = 1 AND ("
        << "s.name LIKE '%" << escaped << "%' "
        << "OR s.code LIKE '%" << escaped << "%' "
        << "OR s.id IN (SELECT station_id FROM station_aliases WHERE alias_name LIKE '%"
        << escaped << "%')"
        << ") ORDER BY "
        << "CASE WHEN s.name LIKE '" << escaped << "%' THEN 0 "
        << "WHEN s.name LIKE '%" << escaped << "%' THEN 1 ELSE 2 END, "
        << "s.name LIMIT " << limit;
    auto rows = db_.query(sql.str());
    std::vector<models::Station> result;
    for (const auto& row : rows) result.push_back(rowToStation(row));
    return result;
}

std::vector<models::Station> StationRepository::findByType(const std::string& station_type) {
    auto rows = db_.query(
        "SELECT s.*, c.name AS city_name, st.name AS state_name "
        "FROM stations s "
        "LEFT JOIN cities c ON s.city_id = c.id "
        "LEFT JOIN states st ON s.state_id = st.id "
        "WHERE s.station_type='" + db_.escape(station_type) + "' AND s.is_active=1 "
        "ORDER BY s.name");
    std::vector<models::Station> result;
    for (const auto& row : rows) result.push_back(rowToStation(row));
    return result;
}

std::vector<models::Station> StationRepository::findByCity(int city_id) {
    auto rows = db_.query(
        "SELECT s.*, c.name AS city_name, st.name AS state_name "
        "FROM stations s "
        "LEFT JOIN cities c ON s.city_id = c.id "
        "LEFT JOIN states st ON s.state_id = st.id "
        "WHERE s.city_id=" + std::to_string(city_id) + " AND s.is_active=1 ORDER BY s.name");
    std::vector<models::Station> result;
    for (const auto& row : rows) result.push_back(rowToStation(row));
    return result;
}

std::vector<models::Station> StationRepository::findByLine(int line_id) {
    auto rows = db_.query(
        "SELECT s.*, c.name AS city_name, st.name AS state_name "
        "FROM stations s "
        "JOIN station_lines sl ON s.id = sl.station_id "
        "LEFT JOIN cities c ON s.city_id = c.id "
        "LEFT JOIN states st ON s.state_id = st.id "
        "WHERE sl.line_id=" + std::to_string(line_id) + " AND s.is_active=1 "
        "ORDER BY sl.sequence_order");
    std::vector<models::Station> result;
    for (const auto& row : rows) result.push_back(rowToStation(row));
    return result;
}

bool StationRepository::addAlias(int station_id, const std::string& alias,
                                  const std::string& alias_type) {
    return db_.execute(
        "INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type) VALUES ("
        + std::to_string(station_id) + ", '"
        + db_.escape(alias) + "', '"
        + db_.escape(alias_type) + "')");
}

std::vector<std::string> StationRepository::getAliases(int station_id) {
    auto rows = db_.query(
        "SELECT alias_name FROM station_aliases WHERE station_id="
        + std::to_string(station_id));
    std::vector<std::string> aliases;
    for (const auto& row : rows) {
        auto it = row.find("alias_name");
        if (it != row.end()) aliases.push_back(it->second);
    }
    return aliases;
}

int StationRepository::countAll(bool active_only) {
    std::string sql = "SELECT COUNT(*) AS cnt FROM stations";
    if (active_only) sql += " WHERE is_active=1";
    auto rows = db_.query(sql);
    if (!rows.empty()) {
        auto it = rows[0].find("cnt");
        if (it != rows[0].end()) return std::stoi(it->second);
    }
    return 0;
}

int StationRepository::countByType(const std::string& station_type) {
    auto rows = db_.query(
        "SELECT COUNT(*) AS cnt FROM stations WHERE station_type='"
        + db_.escape(station_type) + "' AND is_active=1");
    if (!rows.empty()) {
        auto it = rows[0].find("cnt");
        if (it != rows[0].end()) return std::stoi(it->second);
    }
    return 0;
}

} // namespace repository
} // namespace raasta

