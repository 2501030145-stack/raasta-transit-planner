cmake_minimum_required(VERSION 3.16)
project(raasta-backend VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# ── Options ───────────────────────────────────────────
option(RAASTA_ENABLE_MYSQL "Enable MySQL database support" ON)
option(RAASTA_BUILD_TESTS  "Build test suite" ON)

# ── Find system-installed dependencies ────────────────
# cpp-httplib (header-only, system installed via brew)
find_path(HTTPLIB_INCLUDE_DIR httplib.h
    PATHS /opt/homebrew/include /usr/local/include /usr/include
)
if(NOT HTTPLIB_INCLUDE_DIR)
    message(FATAL_ERROR "cpp-httplib not found. Install: brew install cpp-httplib")
endif()

# nlohmann/json (header-only, system installed via brew)
find_package(nlohmann_json QUIET)
if(NOT nlohmann_json_FOUND)
    find_path(NLOHMANN_JSON_INCLUDE_DIR nlohmann/json.hpp
        PATHS /opt/homebrew/include /usr/local/include /usr/include
    )
    if(NOT NLOHMANN_JSON_INCLUDE_DIR)
        message(FATAL_ERROR "nlohmann/json not found. Install: brew install nlohmann-json")
    endif()
endif()

# MySQL Connector/C++ (optional)
if(RAASTA_ENABLE_MYSQL)
    find_path(MYSQL_INCLUDE_DIR mysql/mysql.h
        PATHS /opt/homebrew/include /usr/local/include /usr/include
              /opt/homebrew/opt/mysql-client/include
    )
    find_library(MYSQL_LIBRARY
        NAMES mysqlclient
        PATHS /opt/homebrew/lib /usr/local/lib /usr/lib
              /opt/homebrew/opt/mysql-client/lib
    )
    if(MYSQL_INCLUDE_DIR AND MYSQL_LIBRARY)
        message(STATUS "MySQL found: ${MYSQL_LIBRARY}")
        add_definitions(-DRAASTA_HAS_MYSQL=1)
    else()
        message(WARNING "MySQL client not found. Building without database support.")
        message(WARNING "Install: brew install mysql-client")
        set(RAASTA_ENABLE_MYSQL OFF)
        add_definitions(-DRAASTA_HAS_MYSQL=0)
    endif()
else()
    add_definitions(-DRAASTA_HAS_MYSQL=0)
endif()

# ── Collect sources ───────────────────────────────────
file(GLOB_RECURSE RAASTA_SOURCES
    src/*.cpp
)

# ── Main executable ──────────────────────────────────
add_executable(raasta-server ${RAASTA_SOURCES})

target_include_directories(raasta-server PRIVATE
    ${CMAKE_SOURCE_DIR}/include
    ${HTTPLIB_INCLUDE_DIR}
)

# Link the compiled cpp-httplib library when provided by the system.
# Homebrew header-only installations remain supported.
find_library(HTTPLIB_LIBRARY
    NAMES cpp-httplib httplib
)

if(HTTPLIB_LIBRARY)
    message(STATUS "cpp-httplib library found: ${HTTPLIB_LIBRARY}")
    target_link_libraries(raasta-server PRIVATE ${HTTPLIB_LIBRARY})
endif()

if(nlohmann_json_FOUND)
    target_link_libraries(raasta-server PRIVATE nlohmann_json::nlohmann_json)
else()
    target_include_directories(raasta-server PRIVATE ${NLOHMANN_JSON_INCLUDE_DIR})
endif()

if(RAASTA_ENABLE_MYSQL)
    target_include_directories(raasta-server PRIVATE ${MYSQL_INCLUDE_DIR})
    target_link_libraries(raasta-server PRIVATE ${MYSQL_LIBRARY})
endif()

# pthreads for httplib
find_package(Threads REQUIRED)
target_link_libraries(raasta-server PRIVATE Threads::Threads)

# ── Tests ─────────────────────────────────────────────
if(RAASTA_BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()
