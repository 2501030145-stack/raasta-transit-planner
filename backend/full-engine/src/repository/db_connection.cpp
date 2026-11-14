#include "raasta/repository/db_connection.hpp"
#include <iostream>
#include <sstream>

namespace raasta {
namespace repository {

DbConnection& DbConnection::instance() {
    static DbConnection inst;
    return inst;
}

DbConnection::~DbConnection() {
    disconnect();
}

bool DbConnection::initialize(const std::string& host, int port,
                               const std::string& user, const std::string& password,
                               const std::string& db_name) {
    std::lock_guard<std::mutex> lock(mutex_);
    host_ = host; port_ = port;
    user_ = user; password_ = password;
    db_name_ = db_name;

#if RAASTA_HAS_MYSQL
    conn_ = mysql_init(nullptr);
    if (!conn_) {
        std::cerr << "[db] mysql_init() failed\n";
        return false;
    }

    // Set connection options
    unsigned int timeout = 10;
    mysql_options(conn_, MYSQL_OPT_CONNECT_TIMEOUT, &timeout);
    bool reconnect_flag = true;
    mysql_options(conn_, MYSQL_OPT_RECONNECT, &reconnect_flag);

    if (!mysql_real_connect(conn_, host_.c_str(), user_.c_str(),
                            password_.empty() ? nullptr : password_.c_str(),
                            db_name_.c_str(), port_, nullptr, 0)) {
        std::cerr << "[db] Connection failed: " << mysql_error(conn_) << "\n";
        mysql_close(conn_);
        conn_ = nullptr;
        connected_ = false;
        return false;
    }

    // Force UTF-8
    mysql_set_character_set(conn_, "utf8mb4");

    connected_ = true;
    std::cout << "[db] Connected to " << host_ << ":" << port_
              << "/" << db_name_ << "\n";
    return true;
#else
    std::cerr << "[db] Compiled without MySQL support (RAASTA_HAS_MYSQL=0)\n";
    connected_ = false;
    return false;
#endif
}

bool DbConnection::isConnected() const {
    return connected_;
}

void DbConnection::disconnect() {
#if RAASTA_HAS_MYSQL
    std::lock_guard<std::mutex> lock(mutex_);
    if (conn_) {
        mysql_close(conn_);
        conn_ = nullptr;
    }
    connected_ = false;
#endif
}

ResultSet DbConnection::query(const std::string& sql) {
    ResultSet results;
#if RAASTA_HAS_MYSQL
    std::lock_guard<std::mutex> lock(mutex_);
    if (!conn_ || !connected_) {
        std::cerr << "[db] Not connected — cannot query\n";
        return results;
    }

    if (mysql_query(conn_, sql.c_str()) != 0) {
        std::cerr << "[db] Query error: " << mysql_error(conn_) << "\n";
        std::cerr << "[db] SQL: " << sql.substr(0, 200) << "\n";
        return results;
    }

    MYSQL_RES* res = mysql_store_result(conn_);
    if (!res) {
        // Could be INSERT/UPDATE/DELETE that returns no result set
        return results;
    }

    int num_fields = mysql_num_fields(res);
    MYSQL_FIELD* fields = mysql_fetch_fields(res);

    MYSQL_ROW row;
    while ((row = mysql_fetch_row(res))) {
        Row r;
        unsigned long* lengths = mysql_fetch_lengths(res);
        for (int i = 0; i < num_fields; ++i) {
            std::string col_name = fields[i].name;
            std::string col_val  = row[i] ? std::string(row[i], lengths[i]) : "";
            r[col_name] = col_val;
        }
        results.push_back(std::move(r));
    }

    mysql_free_result(res);
#else
    (void)sql;
    std::cerr << "[db] Compiled without MySQL support\n";
#endif
    return results;
}

bool DbConnection::execute(const std::string& sql) {
#if RAASTA_HAS_MYSQL
    std::lock_guard<std::mutex> lock(mutex_);
    if (!conn_ || !connected_) return false;

    if (mysql_query(conn_, sql.c_str()) != 0) {
        std::cerr << "[db] Execute error: " << mysql_error(conn_) << "\n";
        return false;
    }
    // Consume any result set
    MYSQL_RES* res = mysql_store_result(conn_);
    if (res) mysql_free_result(res);
    return true;
#else
    (void)sql;
    return false;
#endif
}

int DbConnection::executeInsert(const std::string& sql) {
#if RAASTA_HAS_MYSQL
    std::lock_guard<std::mutex> lock(mutex_);
    if (!conn_ || !connected_) return -1;

    if (mysql_query(conn_, sql.c_str()) != 0) {
        std::cerr << "[db] Insert error: " << mysql_error(conn_) << "\n";
        return -1;
    }
    return static_cast<int>(mysql_insert_id(conn_));
#else
    (void)sql;
    return -1;
#endif
}

std::string DbConnection::escape(const std::string& value) {
#if RAASTA_HAS_MYSQL
    if (!conn_) return value;
    std::vector<char> buf(value.size() * 2 + 1);
    mysql_real_escape_string(conn_, buf.data(), value.c_str(),
                             static_cast<unsigned long>(value.size()));
    return std::string(buf.data());
#else
    // Basic escape for safety
    std::string out;
    out.reserve(value.size());
    for (char c : value) {
        if (c == '\'') out += "''";
        else if (c == '\\') out += "\\\\";
        else out += c;
    }
    return out;
#endif
}

bool DbConnection::beginTransaction() {
    return execute("START TRANSACTION");
}

bool DbConnection::commit() {
    return execute("COMMIT");
}

bool DbConnection::rollback() {
    return execute("ROLLBACK");
}

bool DbConnection::ensureConnected() {
#if RAASTA_HAS_MYSQL
    if (connected_ && conn_) {
        if (mysql_ping(conn_) == 0) return true;
        std::cerr << "[db] Connection lost, reconnecting...\n";
    }
    return initialize(host_, port_, user_, password_, db_name_);
#else
    return false;
#endif
}

} // namespace repository
} // namespace raasta

