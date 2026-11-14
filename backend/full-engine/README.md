# Raasta — Public Transport Route Optimization System

> **High-Performance C++17 Multimodal Transport Route Optimization & Fare Engine**  
> Serving **Delhi**, **Delhi NCR**, and **Uttar Pradesh** across Metro, Bus, Indian Railways, and Namo Bharat (RRTS).

---

## 1. System Overview

**Raasta** is a modular public transit routing backend built to compute optimal travel paths across diverse, interconnected transit networks. It provides real-time graph traversal, mode-specific fare computation, and REST API services for web and mobile frontends (such as the existing Manus frontend at `https://raasta-mpxyck7w.manus.space`).

### Technology Stack
- **Language**: C++17 (compiled with AppleClang / GCC)
- **HTTP Framework**: [cpp-httplib](https://github.com/yhirose/cpp-httplib) (header-only, multi-threaded)
- **JSON Serialization**: [nlohmann/json](https://github.com/nlohmann/json)
- **Database**: MySQL 8.x + MySQL Client Connector (with offline/in-memory fallback mode)
- **Build System**: CMake 3.16+
- **Routing Algorithms**: Custom Dijkstra (Fastest, Shortest, Lowest Fare) + BFS (Minimum Stops)

---

## 2. Architecture & Directory Structure

```text
raasta-backend/
├── CMakeLists.txt              # Top-level CMake configuration
├── .env.example                # Template for environment configuration
├── .env                        # Local runtime environment
├── README.md                   # System documentation
├── DATA_COVERAGE_REPORT.md     # Verified data coverage audit
│
├── include/raasta/
│   ├── algorithms/             # Traversal algorithms
│   │   ├── routing_algorithm.hpp # IRoutingAlgorithm interface & criteria
│   │   ├── dijkstra_router.hpp   # Dijkstra implementation
│   │   └── bfs_router.hpp        # BFS minimum-stops implementation
│   ├── api/
│   │   └── server.hpp          # REST API server & router definitions
│   ├── config/
│   │   └── config.hpp          # Environment & runtime configuration
│   ├── graph/
│   │   └── transport_graph.hpp # In-memory adjacency list multimodal graph
│   ├── models/                 # Domain entity models (with JSON serialization)
│   │   ├── station.hpp
│   │   ├── connection.hpp
│   │   ├── line.hpp
│   │   ├── transport.hpp
│   │   ├── fare.hpp
│   │   └── route_result.hpp
│   ├── repository/             # Database access layer
│   │   ├── db_connection.hpp   # Thread-safe MySQL connection pool
│   │   ├── station_repository.hpp
│   │   └── connection_repository.hpp
│   └── services/               # Core business services
│       ├── fare_service.hpp    # Mode-specific fare calculation engine
│       ├── route_service.hpp   # Routing criteria coordinator
│       └── graph_builder_service.hpp # Graph database synchronization
│
├── src/                        # Implementations matching include/
│   ├── algorithms/
│   ├── api/
│   ├── config/
│   ├── graph/
│   ├── models/
│   ├── repository/
│   ├── services/
│   └── main.cpp                # Server entrypoint
│
├── migrations/                 # Idempotent SQL schema and seed migrations
│   ├── 001_core_schema.sql     # Stations, connections, lines, trips, provenance
│   ├── 002_fare_schema.sql     # Slabs, rules, transfer penalties
│   ├── 003_admin_auth.sql      # Admin users & access control
│   ├── 004_seed_reference_data.sql # States, operators, transport types
│   ├── 005_import_metro_seed.sql   # DMRC, NMRC, UPMRC seed
│   ├── 006_import_rrts_seed.sql    # NCRTC Namo Bharat seed
│   ├── 007_import_railway_seed.sql # Indian Railways seed
│   └── 008_import_bus_seed.sql     # Bus network seed
│
├── data/                       # Verified raw transport datasets & GTFS
│   ├── metro/                  # DMRC, NMRC, UPMRC stations & connections
│   ├── namo_bharat/            # NCRTC Delhi-Ghaziabad-Meerut corridor
│   ├── railway/                # Northern & North Central Railway stations
│   └── bus/                    # DTC / Cluster / UPSRTC GTFS feeds & stops
│
├── scripts/                    # Automated ingestion and maintenance scripts
│   ├── setup_db.sh             # Full database initialization runner
│   ├── import_metro.py         # Metro ingestion pipeline
│   ├── import_namo_bharat.py   # RRTS ingestion pipeline
│   ├── import_railway.py       # Indian Railways ingestion pipeline
│   ├── import_bus_gtfs.py      # Bus / GTFS ingestion pipeline
│   └── generate_coverage_report.py # Coverage analysis tool
│
└── tests/                      # Automated CTest test suite
    ├── CMakeLists.txt
    ├── test_graph.cpp          # Adjacency list & edge filtering test
    ├── test_dijkstra.cpp       # Shortest, fastest, cheapest routing test
    ├── test_bfs.cpp            # Minimum stops test
    ├── test_fare.cpp           # Mode-specific fare engine test
    ├── test_multimodal.cpp     # Metro-to-railway transfer journey test
    └── test_api_server.cpp     # HTTP API integration test
```

---

## 3. Quick Start & Build Instructions

### Prerequisites (macOS via Homebrew)
```bash
brew install cmake cpp-httplib nlohmann-json
# Optional for direct MySQL connectivity:
brew install mysql-client
```

### Compiling with CMake
```bash
cd raasta-backend
mkdir -p build && cd build
cmake ..
make -j4
```

### Running Automated Tests
```bash
ctest --output-on-failure
```
All 6 test suites test:
1. `test_graph`: In-memory multimodal adjacency graph operations.
2. `test_dijkstra`: Multi-criteria Dijkstra optimization.
3. `test_bfs`: Minimum stops breadth-first search.
4. `test_fare`: Mode-specific fare calculation algorithms.
5. `test_multimodal`: Intermodal transfers and walking links.
6. `test_api_server`: Server routing and API response structures.

### Running the Backend Server
```bash
./build/raasta-server
```
The server will bind to `0.0.0.0:8088` (or the port specified in `.env`) and load the graph.

---

## 4. Database Setup & Dataset Ingestion

1. **Configure `.env`**:
   ```bash
   cp .env.example .env
   # Edit DB_HOST, DB_USER, DB_PASSWORD, DB_NAME, SERVER_PORT
   ```

2. **Run all database migrations and seeds**:
   ```bash
   bash scripts/setup_db.sh
   ```

3. **Re-run automated import pipelines at any time**:
   ```bash
   python3 scripts/import_metro.py
   python3 scripts/import_namo_bharat.py
   python3 scripts/import_railway.py
   python3 scripts/import_bus_gtfs.py
   python3 scripts/generate_coverage_report.py
   ```

---

## 5. REST API Documentation

### Public Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/health` | Health check, scope, and live graph station/edge counts |
| `GET` | `/api/stations` | List active stations (supports `?type=`, `?city_id=`, `?line_id=`) |
| `GET` | `/api/stations/search?q={query}` | Search stations and aliases by keyword |
| `GET` | `/api/transport-types` | List supported transport modes (Metro, Bus, Railway, RRTS) |
| `GET` | `/api/lines` | List operational lines and colors (supports `?type_id=`) |
| `POST` | `/api/route` | Compute optimal route based on criteria |
| `POST` | `/api/route/compare` | Compare all 4 routing criteria for a single OD pair |
| `POST` | `/api/fare/calculate` | Mode-specific fare calculator for a segment |
| `GET` | `/api/network/overview` | High-level network summary & database counts |
| `GET` | `/api/network/connections` | Retrieve transport connections |

### Route Optimization Request Format (`POST /api/route`)

```json
{
  "source_station_id": 1,
  "destination_station_id": 4,
  "criteria": "fastest",
  "transport_modes": ["metro", "railway"],
  "departure_date": "2026-11-14",
  "fare_class": "general"
}
```

### Route Optimization Response Format

```json
{
  "success": true,
  "route": {
    "total_distance_km": 27.0,
    "estimated_time_min": 44.0,
    "total_fare": 30.0,
    "fare_status": "estimated",
    "number_of_stops": 4,
    "number_of_transfers": 1,
    "algorithm": "dijkstra",
    "criteria": "fastest",
    "segments": [
      {
        "from_station_id": 1,
        "from_station_name": "Rajiv Chowk Metro",
        "to_station_id": 2,
        "to_station_name": "New Delhi Metro",
        "line_name": "Yellow Line",
        "transport_type_name": "Metro",
        "distance_km": 1.8,
        "travel_time_min": 4.0,
        "is_transfer": false,
        "fare": {
          "amount": 10.0,
          "currency": "INR",
          "status": "estimated"
        }
      },
      {
        "from_station_id": 2,
        "from_station_name": "New Delhi Metro",
        "to_station_id": 3,
        "to_station_name": "New Delhi Railway",
        "line_name": "Interchange Transfer",
        "transport_type_name": "Interchange",
        "distance_km": 0.2,
        "travel_time_min": 5.0,
        "is_transfer": true,
        "fare": {
          "amount": 0.0,
          "currency": "INR",
          "status": "estimated"
        }
      }
    ],
    "stations": [...]
  }
}
```

### Admin Endpoints (Requires `Authorization: Bearer <ADMIN_JWT_SECRET>`)

- `POST /api/admin/stations`: Add new station
- `PUT /api/admin/stations`: Update existing station
- `DELETE /api/admin/stations?id={id}`: Remove station
- `POST /api/admin/connections`: Add connection
- `PUT /api/admin/connections`: Update connection
- `DELETE /api/admin/connections?id={id}`: Remove connection
- `POST /api/admin/graph/rebuild`: Reload graph into memory from database

---

## 6. Frontend Integration Guidelines

The deployed Manus UI at `https://raasta-mpxyck7w.manus.space` connects to this backend via standard REST JSON APIs.
- Set `CORS_ORIGIN=https://raasta-mpxyck7w.manus.space` in your `.env`.
- Ensure the backend reverse-proxy or tunnel (e.g. cloud host, ngrok, or domain) points to port `8088`.
- No frontend visual changes, styling, or layouts are altered.

---

## 7. Transport Coverage & Provenance

Verified operational datasets are documented in `DATA_COVERAGE_REPORT.md`:
- **Delhi Metro (DMRC)**: All 10 lines + Airport Express
- **Noida Metro (NMRC)**: Aqua Line
- **Gurugram Rapid Metro**: Phase 1 & 2
- **UP Metro (UPMRC)**: Lucknow, Kanpur, and Agra
- **Namo Bharat (RRTS)**: Delhi–Ghaziabad–Meerut Corridor
- **Indian Railways (IR)**: Delhi NCR & UP trunk network
- **Bus Networks**: DTC & Cluster GTFS feeds via Open Transit Data Delhi (`https://otd.delhi.gov.in`)

