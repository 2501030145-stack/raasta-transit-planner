#pragma once

#include <string>
#include <vector>
#include <unordered_map>
#include <memory>
#include <mutex>
#include <functional>

#if RAASTA_HAS_MYSQL
#include <mysql/mysql.h>
#endif

namespace raasta {
namespace repository {

// Row = map of column_name → string value
using Row = std::unordered_map<std::string, std::string>;
using ResultSet = std::vector<Row>;

class DbConnection {
public:
    static DbConnection& instance();

    // Initialize connection
    bool initialize(const std::string& host, int port,
                    const std::string& user, const std::string& password,
                    const std::string& db_name);

    // Connection state
    bool isConnected() const;
    void disconnect();

    // Query execution
    ResultSet query(const std::string& sql);
    bool execute(const std::string& sql);
    int executeInsert(const std::string& sql);   // returns last_insert_id

    // Parameterized queries (escapes values)
    std::string escape(const std::string& value);

    // Transaction support
    bool beginTransaction();
    bool commit();
    bool rollback();

    // Reconnect if needed
    bool ensureConnected();

private:
    DbConnection() = default;
    ~DbConnection();
    DbConnection(const DbConnection&) = delete;
    DbConnection& operator=(const DbConnection&) = delete;

#if RAASTA_HAS_MYSQL
    MYSQL* conn_ = nullptr;
#endif
    bool connected_ = false;
    std::mutex mutex_;

    std::string host_, user_, password_, db_name_;
    int port_ = 3306;
};

} // namespace repository
} // namespace raasta

