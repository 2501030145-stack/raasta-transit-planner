#include "raasta/config/config.hpp"
#include <fstream>
#include <sstream>
#include <iostream>
#include <algorithm>
#include <cstdlib>

namespace raasta {
namespace config {

std::unordered_map<std::string, std::string> Config::parseEnvFile(const std::string& path) {
    std::unordered_map<std::string, std::string> env;
    std::ifstream file(path);
    
    if (!file.is_open()) {
        std::cerr << "[config] Warning: Could not open " << path << ", using defaults\n";
        return env;
    }
    
    std::string line;
    while (std::getline(file, line)) {
        // Skip comments and empty lines
        if (line.empty() || line[0] == '#') continue;
        
        auto eq_pos = line.find('=');
        if (eq_pos == std::string::npos) continue;
        
        std::string key = line.substr(0, eq_pos);
        std::string value = line.substr(eq_pos + 1);
        
        // Trim whitespace
        key.erase(0, key.find_first_not_of(" \t"));
        key.erase(key.find_last_not_of(" \t") + 1);
        value.erase(0, value.find_first_not_of(" \t\"'"));
        value.erase(value.find_last_not_of(" \t\"'\r\n") + 1);
        
        if (!key.empty()) {
            env[key] = value;
        }
    }
    
    return env;
}

Config Config::load(const std::string& env_file) {
    Config cfg;
    
    // Check current directory, then parent directory (e.g. when run from build/)
    std::string path = env_file;
    std::ifstream check(path);
    if (!check.is_open()) {
        std::string parent_path = "../" + env_file;
        std::ifstream check_parent(parent_path);
        if (check_parent.is_open()) {
            path = parent_path;
        }
    }
    
    auto env = parseEnvFile(path);
    
    auto get = [&](const std::string& key, const std::string& default_val) -> std::string {
        // Environment variable takes precedence
        const char* env_val = std::getenv(key.c_str());
        if (env_val) return std::string(env_val);
        auto it = env.find(key);
        return (it != env.end()) ? it->second : default_val;
    };
    
    cfg.server_port = std::stoi(get("PORT", get("SERVER_PORT", "8088")));
    cfg.cors_origin = get("CORS_ORIGIN", "https://raasta-mpxyck7w.manus.space");
    
    cfg.db_host = get("DB_HOST", "127.0.0.1");
    cfg.db_port = std::stoi(get("DB_PORT", "3306"));
    cfg.db_user = get("DB_USER", "raasta");
    cfg.db_password = get("DB_PASSWORD", "");
    cfg.db_name = get("DB_NAME", "raasta_db");
    
    cfg.admin_jwt_secret = get("ADMIN_JWT_SECRET", "default_secret_change_me");
    cfg.admin_default_user = get("ADMIN_DEFAULT_USER", "admin");
    cfg.admin_default_password = get("ADMIN_DEFAULT_PASSWORD", "admin");
    
    cfg.data_dir = get("DATA_DIR", "./data");
    cfg.log_level = get("LOG_LEVEL", "info");
    
    std::cout << "[config] Loaded configuration from " << path << " (server_port=" << cfg.server_port << ")\n";
    return cfg;
}

} // namespace config
} // namespace raasta
