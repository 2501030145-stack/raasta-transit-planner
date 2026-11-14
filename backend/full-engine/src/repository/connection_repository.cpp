#include "raasta/repository/connection_repository.hpp"
#include "raasta/models/line.hpp"
#include <sstream>

namespace raasta {
namespace repository {

// ── ConnectionRepository ─────────────────────────────

ConnectionRepository::ConnectionRepository(DbConnection& db) : db_(db) {}

models::Connection ConnectionRepository::rowToConnection(const Row& row) {
    models::Connection c;
    auto get = [&](const std::string& key) -> std::string {
        auto it = row.find(key); return (it != row.end()) ? it->second : "";
    };
    auto getInt = [&](const std::string& k) { auto v = get(k); return v.empty() ? 0 : std::stoi(v); };
    auto getDbl = [&](const std::string& k) { auto v = get(k); return v.empty() ? 0.0 : std::stod(v); };

    c.id                     = getInt("id");
    c.from_station_id        = getInt("from_station_id");
    c.to_station_id          = getInt("to_station_id");
    c.line_id                = getInt("line_id");
    c.transport_type_id      = getInt("transport_type_id");
    c.distance_km            = getDbl("distance_km");
    c.estimated_travel_time_min = getDbl("estimated_travel_time_min");
    c.is_bidirectional       = get("is_bidirectional") != "0";
    c.is_active              = get("is_active") != "0";
    c.data_status            = get("data_status");
    c.from_station_name      = get("from_station_name");
    c.to_station_name        = get("to_station_name");
    c.line_name              = get("line_name");
    c.transport_type_name    = get("transport_type_name");
    return c;
}

int ConnectionRepository::create(const models::Connection& conn) {
    std::ostringstream sql;
    sql << "INSERT INTO connections (from_station_id, to_station_id, line_id, "
        << "transport_type_id, distance_km, estimated_travel_time_min, "
        << "is_bidirectional, is_active, data_status) VALUES ("
        << conn.from_station_id << ", " << conn.to_station_id << ", "
        << conn.line_id << ", " << conn.transport_type_id << ", "
        << conn.distance_km << ", " << conn.estimated_travel_time_min << ", "
        << (conn.is_bidirectional ? 1 : 0) << ", "
        << (conn.is_active ? 1 : 0) << ", '"
        << db_.escape(conn.data_status) << "')";
    return db_.executeInsert(sql.str());
}

bool ConnectionRepository::update(const models::Connection& conn) {
    std::ostringstream sql;
    sql << "UPDATE connections SET "
        << "from_station_id=" << conn.from_station_id << ", "
        << "to_station_id=" << conn.to_station_id << ", "
        << "line_id=" << conn.line_id << ", "
        << "transport_type_id=" << conn.transport_type_id << ", "
        << "distance_km=" << conn.distance_km << ", "
        << "estimated_travel_time_min=" << conn.estimated_travel_time_min << ", "
        << "is_bidirectional=" << (conn.is_bidirectional ? 1 : 0) << ", "
        << "is_active=" << (conn.is_active ? 1 : 0) << ", "
        << "data_status='" << db_.escape(conn.data_status) << "' "
        << "WHERE id=" << conn.id;
    return db_.execute(sql.str());
}

bool ConnectionRepository::remove(int connection_id) {
    return db_.execute("DELETE FROM connections WHERE id=" + std::to_string(connection_id));
}

std::optional<models::Connection> ConnectionRepository::findById(int id) {
    auto rows = db_.query(
        "SELECT c.*, fs.name AS from_station_name, ts.name AS to_station_name, "
        "tl.name AS line_name, tt.name AS transport_type_name "
        "FROM connections c "
        "LEFT JOIN stations fs ON c.from_station_id = fs.id "
        "LEFT JOIN stations ts ON c.to_station_id = ts.id "
        "LEFT JOIN transport_lines tl ON c.line_id = tl.id "
        "LEFT JOIN transport_types tt ON c.transport_type_id = tt.id "
        "WHERE c.id=" + std::to_string(id));
    if (rows.empty()) return std::nullopt;
    return rowToConnection(rows[0]);
}

std::vector<models::Connection> ConnectionRepository::findAll(bool active_only) {
    std::string sql =
        "SELECT c.*, fs.name AS from_station_name, ts.name AS to_station_name, "
        "tl.name AS line_name, tt.name AS transport_type_name "
        "FROM connections c "
        "LEFT JOIN stations fs ON c.from_station_id = fs.id "
        "LEFT JOIN stations ts ON c.to_station_id = ts.id "
        "LEFT JOIN transport_lines tl ON c.line_id = tl.id "
        "LEFT JOIN transport_types tt ON c.transport_type_id = tt.id";
    if (active_only) sql += " WHERE c.is_active = 1";
    auto rows = db_.query(sql);
    std::vector<models::Connection> result;
    for (const auto& r : rows) result.push_back(rowToConnection(r));
    return result;
}

std::vector<models::Connection> ConnectionRepository::findByStation(int station_id) {
    auto rows = db_.query(
        "SELECT c.*, fs.name AS from_station_name, ts.name AS to_station_name, "
        "tl.name AS line_name, tt.name AS transport_type_name "
        "FROM connections c "
        "LEFT JOIN stations fs ON c.from_station_id = fs.id "
        "LEFT JOIN stations ts ON c.to_station_id = ts.id "
        "LEFT JOIN transport_lines tl ON c.line_id = tl.id "
        "LEFT JOIN transport_types tt ON c.transport_type_id = tt.id "
        "WHERE c.is_active=1 AND (c.from_station_id=" + std::to_string(station_id)
        + " OR c.to_station_id=" + std::to_string(station_id) + ")");
    std::vector<models::Connection> result;
    for (const auto& r : rows) result.push_back(rowToConnection(r));
    return result;
}

std::vector<models::Connection> ConnectionRepository::findByLine(int line_id) {
    auto rows = db_.query(
        "SELECT c.*, fs.name AS from_station_name, ts.name AS to_station_name, "
        "tl.name AS line_name, tt.name AS transport_type_name "
        "FROM connections c "
        "LEFT JOIN stations fs ON c.from_station_id = fs.id "
        "LEFT JOIN stations ts ON c.to_station_id = ts.id "
        "LEFT JOIN transport_lines tl ON c.line_id = tl.id "
        "LEFT JOIN transport_types tt ON c.transport_type_id = tt.id "
        "WHERE c.line_id=" + std::to_string(line_id) + " AND c.is_active=1 "
        "ORDER BY c.id");
    std::vector<models::Connection> result;
    for (const auto& r : rows) result.push_back(rowToConnection(r));
    return result;
}

std::vector<models::Connection> ConnectionRepository::findByTransportType(int type_id) {
    auto rows = db_.query(
        "SELECT c.*, fs.name AS from_station_name, ts.name AS to_station_name, "
        "tl.name AS line_name, tt.name AS transport_type_name "
        "FROM connections c "
        "LEFT JOIN stations fs ON c.from_station_id = fs.id "
        "LEFT JOIN stations ts ON c.to_station_id = ts.id "
        "LEFT JOIN transport_lines tl ON c.line_id = tl.id "
        "LEFT JOIN transport_types tt ON c.transport_type_id = tt.id "
        "WHERE c.transport_type_id=" + std::to_string(type_id) + " AND c.is_active=1");
    std::vector<models::Connection> result;
    for (const auto& r : rows) result.push_back(rowToConnection(r));
    return result;
}

int ConnectionRepository::countAll(bool active_only) {
    std::string sql = "SELECT COUNT(*) AS cnt FROM connections";
    if (active_only) sql += " WHERE is_active=1";
    auto rows = db_.query(sql);
    if (!rows.empty()) {
        auto it = rows[0].find("cnt");
        if (it != rows[0].end()) return std::stoi(it->second);
    }
    return 0;
}

// ── LineRepository ───────────────────────────────────

LineRepository::LineRepository(DbConnection& db) : db_(db) {}

std::vector<models::TransportLine> LineRepository::findAll(bool active_only) {
    std::string sql =
        "SELECT tl.*, tt.name AS transport_type_name, o.name AS operator_name "
        "FROM transport_lines tl "
        "LEFT JOIN transport_types tt ON tl.transport_type_id = tt.id "
        "LEFT JOIN operators o ON tl.operator_id = o.id";
    if (active_only) sql += " WHERE tl.is_active = 1";
    sql += " ORDER BY tl.transport_type_id, tl.name";

    auto rows = db_.query(sql);
    std::vector<models::TransportLine> result;
    for (const auto& row : rows) {
        models::TransportLine line;
        auto get = [&](const std::string& k) -> std::string {
            auto it = row.find(k); return (it != row.end()) ? it->second : "";
        };
        line.id = get("id").empty() ? 0 : std::stoi(get("id"));
        line.name = get("name");
        line.code = get("code");
        line.color = get("color");
        line.transport_type_id = get("transport_type_id").empty() ? 0 : std::stoi(get("transport_type_id"));
        line.operator_id = get("operator_id").empty() ? 0 : std::stoi(get("operator_id"));
        line.is_active = get("is_active") != "0";
        line.transport_type_name = get("transport_type_name");
        line.operator_name = get("operator_name");
        result.push_back(std::move(line));
    }
    return result;
}

std::optional<models::TransportLine> LineRepository::findById(int id) {
    auto all = findAll(false);
    for (auto& l : all) {
        if (l.id == id) return l;
    }
    return std::nullopt;
}

std::vector<models::TransportLine> LineRepository::findByTransportType(int type_id) {
    auto all = findAll(true);
    std::vector<models::TransportLine> result;
    for (auto& l : all) {
        if (l.transport_type_id == type_id) result.push_back(std::move(l));
    }
    return result;
}

} // namespace repository
} // namespace raasta

