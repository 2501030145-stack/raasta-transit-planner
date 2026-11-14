#pragma once

#include <string>
#include <unordered_map>

namespace raasta {
namespace config {

struct Config {
    // Server
    int server_port = 8080;
    std::string cors_origin = "*";
    
    // Database
    std::string db_host = "127.0.0.1";
    int db_port = 3306;
    std::string db_user = "raasta";
    std::string db_password = "";
    std::string db_name = "raasta_db";
    
    // Admin
    std::string admin_jwt_secret = "default_secret_change_me";
    std::string admin_default_user = "admin";
    std::string admin_default_password = "admin";
    
    // Data
    std::string data_dir = "./data";
    std::string log_level = "info";
    
    // Load from .env file
    static Config load(const std::string& env_file = ".env");
    
private:
    static std::unordered_map<std::string, std::string> parseEnvFile(const std::string& path);
};

} // namespace config
} // namespace raasta
