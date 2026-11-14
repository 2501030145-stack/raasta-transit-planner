# Raasta API Contract & Specification

**Version:** 1.0.0  
**Base URL:** `http://127.0.0.1:8088` (Development) / `https://api.raasta.yourdomain.com` (Production)  
**Standard Response Format:** JSON (`application/json; charset=utf-8`)  
**CORS Policy:** Allows `https://raasta-mpxyck7w.manus.space` (Production) and `http://localhost:*` / `http://127.0.0.1:*` (Development). Wildcard `*` is disabled.

---

## 1. Summary of All Backend Endpoints

| # | Method | Endpoint Path | Auth Required | Purpose |
| :-: | :--- | :--- | :---: | :--- |
| 1 | `GET` | `/health`, `/api/health`, `/api/v1/health` | No | Service health, DB state, in-memory station/edge counts |
| 2 | `GET` | `/api/network/overview`, `/api/v1/network/overview` | No | Network metadata, supported regions, modal capabilities |
| 3 | `GET` | `/api/stations`, `/api/v1/stations` | No | List all stations (supports `type`, `city_id`, `line_id`) |
| 4 | `GET` | `/api/stations/search`, `/api/v1/stations/search` | No | Case-insensitive autocomplete search by station name or code |
| 5 | `GET` | `/api/transport-types`, `/api/v1/transport-types` | No | List transit types (Metro, Bus, Railway, RRTS) |
| 6 | `GET` | `/api/lines`, `/api/v1/lines` | No | List transit lines/corridors (supports `type_id`) |
| 7 | `GET` | `/api/routes`, `/api/v1/routes` | No | High-level corridor route directory |
| 8 | `GET` | `/api/network/connections`, `/api/v1/network/connections` | No | List network connection segments (supports filtering) |
| 9 | `POST` | `/api/route`, `/api/v1/route`, `/api/v1/routes/plan` | No | Compute optimal path by criterion (fastest, shortest, cheapest, min_stops) |
| 10 | `POST` | `/api/route/compare`, `/api/v1/route/compare`, `/api/v1/routes/compare` | No | Simultaneously compute all 4 routing criteria for side-by-side comparison |
| 11 | `POST` | `/api/fare/calculate`, `/api/v1/fare/calculate`, `/api/v1/fares/calculate` | No | Standalone fare calculation engine with discounts and concessions |
| 12 | `POST` | `/api/admin/stations` | **Admin Bearer / Key** | Create new station record |
| 13 | `PUT` | `/api/admin/stations` | **Admin Bearer / Key** | Update existing station record |
| 14 | `DELETE`| `/api/admin/stations` | **Admin Bearer / Key** | Delete station record by ID |
| 15 | `POST` | `/api/admin/connections` | **Admin Bearer / Key** | Create new track/route connection edge |
| 16 | `PUT` | `/api/admin/connections` | **Admin Bearer / Key** | Update existing track/route connection edge |
| 17 | `DELETE`| `/api/admin/connections` | **Admin Bearer / Key** | Delete connection edge by ID |
| 18 | `POST` | `/api/admin/graph/rebuild` | **Admin Bearer / Key** | Trigger full in-memory graph reload from persistence |

---

## 2. Public API Reference & Working cURL Examples

### 2.1 System Health
`GET /health` (or `/api/v1/health`)

#### Description
Returns running service status, scope, database connectivity state, and active in-memory graph counts.

#### Request Example
```bash
curl -s http://127.0.0.1:8088/health
```

#### Response Example (`200 OK`)
```json
{
  "database_connected": false,
  "network": {
    "edges": 778,
    "stations": 355
  },
  "scope": "Delhi, Delhi NCR, Uttar Pradesh",
  "service": "raasta-backend",
  "status": "ok",
  "version": "1.0.0"
}
```

---

### 2.2 Network Overview
`GET /api/v1/network/overview`

#### Description
Provides high-level system metadata, geographic boundaries, active transport modes, and graph density metrics.

#### Request Example
```bash
curl -s http://127.0.0.1:8088/api/v1/network/overview
```

#### Response Example (`200 OK`)
```json
{
  "graph": {
    "total_connections": 778,
    "total_stations": 355
  },
  "scope": {
    "regions": [
      "Delhi",
      "Delhi NCR",
      "Uttar Pradesh"
    ],
    "supported_modes": [
      "Metro",
      "Bus",
      "Indian Railways",
      "Namo Bharat (RRTS)"
    ]
  },
  "success": true
}
```

---

### 2.3 Station Autocomplete & Search
`GET /api/v1/stations/search?q={query}&limit={limit}`

#### Query Parameters
- `q` (string, **required**): Case-insensitive search query matching station name or uppercase code.
- `limit` (integer, optional, default: `20`): Maximum number of stations to return.

#### Request Example (Station Search for "Kashmere")
```bash
curl -s "http://127.0.0.1:8088/api/v1/stations/search?q=Kashmere&limit=5"
```

#### Response Example (`200 OK`)
```json
{
  "count": 2,
  "query": "Kashmere",
  "stations": [
    {
      "address": "",
      "city_id": 0,
      "city_name": "Delhi",
      "code": "DTC_KG",
      "data_status": "verified",
      "id": 347,
      "is_active": true,
      "is_interchange": true,
      "latitude": 28.669,
      "longitude": 77.228,
      "name": "Kashmere Gate ISBT",
      "state_id": 0,
      "station_type": "bus_stop"
    },
    {
      "address": "",
      "city_id": 0,
      "city_name": "Delhi",
      "code": "DEL_KG",
      "data_status": "verified",
      "id": 14,
      "is_active": true,
      "is_interchange": true,
      "latitude": 28.6675,
      "longitude": 77.2285,
      "name": "Kashmere Gate",
      "state_id": 0,
      "station_type": "metro_station"
    }
  ],
  "success": true
}
```

#### Error Response (`400 Bad Request`)
```json
{
  "error": "Query parameter 'q' is required",
  "success": false
}
```

---

### 2.4 Station Directory Listing
`GET /api/v1/stations`

#### Description
Returns all stations currently loaded in the rapid transit atlas.

#### Request Example
```bash
curl -s "http://127.0.0.1:8088/api/v1/stations" | jq '{total: .count, sample: .stations[0]}'
```

#### Response Sample (`200 OK`)
```json
{
  "total": 355,
  "sample": {
    "address": "",
    "city_id": 0,
    "city_name": "Delhi",
    "code": "DEL_RTH",
    "data_status": "verified",
    "id": 1,
    "is_active": true,
    "is_interchange": false,
    "latitude": 28.7208,
    "longitude": 77.1072,
    "name": "Rithala",
    "state_id": 0,
    "station_type": "metro_station"
  }
}
```

---

### 2.5 Route Planning Engine
`POST /api/v1/routes/plan` (Aliases: `/api/route`, `/api/v1/route`)

#### Request Schema
```json
{
  "source_station_id": 4,             // Required: Integer ID of origin station
  "destination_station_id": 322,      // Required: Integer ID of destination station
  "criteria": "fastest",              // Optional: "fastest", "shortest", "cheapest", "min_stops"
  "transport_modes": ["metro", "rrts"], // Optional: subset filter; omit or empty for all modes
  "departure_time": "09:00",          // Optional: "HH:MM" (used for peak/non-peak fare evaluation)
  "day_type": "weekday",              // Optional: "weekday", "weekend", "sunday", "holiday"
  "fare_class": "standard",           // Optional: "standard", "premium", "ac", "non_ac", "SL", "3A"
  "is_smart_card": false              // Optional: boolean (applies 10-20% DMRC, NMRC, RRTS loyalty discounts)
}
```

---

#### A. Fastest Route Example
```bash
curl -s -X POST http://127.0.0.1:8088/api/v1/routes/plan \
  -H "Content-Type: application/json" \
  -d '{
    "source_station_id": 1,
    "destination_station_id": 10,
    "criteria": "fastest"
  }'
```

#### Response (`200 OK`)
```json
{
  "route": {
    "algorithm": "dijkstra",
    "criteria": "fastest",
    "estimated_time_min": 22.0,
    "fare_status": "verified",
    "number_of_stops": 10,
    "number_of_transfers": 0,
    "segments": [
      {
        "distance_km": 1.0,
        "fare": {
          "amount": 30.0,
          "currency": "INR",
          "details": "",
          "discount_applied": 0.0,
          "fare_class": "general",
          "fare_type": "distance_slab",
          "operator_name": "Delhi Metro (DMRC)",
          "original_amount": 30.0,
          "source": "DMRC Official Fare Structure",
          "status": "verified"
        },
        "from_station_id": 1,
        "from_station_name": "Rithala",
        "is_transfer": false,
        "line_color": "",
        "line_id": 0,
        "line_name": "DMRC_RED",
        "to_station_id": 2,
        "to_station_name": "Rohini West",
        "transport_type_id": 1,
        "transport_type_name": "Metro",
        "travel_time_min": 2.4
      }
    ],
    "stations": [ ... ],
    "total_distance_km": 9.8,
    "total_fare": 30.0
  },
  "success": true
}
```

---

#### B. Shortest Route Example
```bash
curl -s -X POST http://127.0.0.1:8088/api/v1/routes/plan \
  -H "Content-Type: application/json" \
  -d '{
    "source_station_id": 4,
    "destination_station_id": 14,
    "criteria": "shortest"
  }'
```

---

#### C. Lowest Fare (Cheapest) Example
```bash
curl -s -X POST http://127.0.0.1:8088/api/v1/routes/plan \
  -H "Content-Type: application/json" \
  -d '{
    "source_station_id": 4,
    "destination_station_id": 14,
    "criteria": "cheapest"
  }'
```

---

#### D. Minimum Stops Example (BFS Optimization)
```bash
curl -s -X POST http://127.0.0.1:8088/api/v1/routes/plan \
  -H "Content-Type: application/json" \
  -d '{
    "source_station_id": 4,
    "destination_station_id": 14,
    "criteria": "min_stops"
  }'
```

---

#### E. Multimodal Journey Example (Sarai Kale Khan -> Modipuram via Namo Bharat)
```bash
curl -s -X POST http://127.0.0.1:8088/api/v1/routes/plan \
  -H "Content-Type: application/json" \
  -d '{
    "source_station_id": 307,
    "destination_station_id": 322,
    "criteria": "fastest",
    "is_smart_card": true
  }'
```

#### Response (`200 OK`)
```json
{
  "route": {
    "algorithm": "dijkstra",
    "criteria": "fastest",
    "estimated_time_min": 67.0,
    "fare_status": "verified",
    "number_of_stops": 16,
    "number_of_transfers": 0,
    "total_distance_km": 82.2,
    "total_fare": 189.0,
    "segments": [
      {
        "distance_km": 5.2,
        "fare": {
          "amount": 189.0,
          "currency": "INR",
          "details": "Namo Bharat Standard Coach (10% NCMC / RRTS Connect Loyalty discount applied; published tariff incorporates the 35% statutory base fare concession)",
          "discount_applied": 21.0,
          "fare_class": "standard",
          "fare_type": "distance_slab",
          "operator_name": "NCRTC (Namo Bharat)",
          "original_amount": 210.0,
          "source": "NCRTC Official Published Tariff (Gazette effective 2026-02-22)",
          "status": "verified"
        },
        "from_station_id": 307,
        "from_station_name": "Sarai Kale Khan",
        "is_transfer": false,
        "line_color": "",
        "line_id": 0,
        "line_name": "Delhi–Meerut RRTS",
        "to_station_id": 308,
        "to_station_name": "New Ashok Nagar",
        "transport_type_id": 4,
        "transport_type_name": "Namo Bharat (RRTS)",
        "travel_time_min": 4.0
      }
    ]
  },
  "success": true
}
```

---

### 2.6 Route Comparison Engine
`POST /api/v1/routes/compare` (Aliases: `/api/route/compare`, `/api/v1/route/compare`)

#### Description
Calculates all 4 optimization criteria (`fastest`, `shortest`, `cheapest`, `min_stops`) in a single round-trip call, providing the front-end with ranked alternatives for immediate rendering.

#### Request Example
```bash
curl -s -X POST http://127.0.0.1:8088/api/v1/routes/compare \
  -H "Content-Type: application/json" \
  -d '{
    "source_station_id": 4,
    "destination_station_id": 14
  }'
```

#### Response Structure (`200 OK`)
```json
{
  "comparisons": {
    "fastest": {
      "algorithm_used": "dijkstra",
      "criteria": "fastest",
      "estimated_time_min": 11.2,
      "fare_status": "verified",
      "found": true,
      "number_of_stops": 6,
      "number_of_transfers": 0,
      "total_distance_km": 4.8,
      "total_fare": 20.0,
      "segments": [ ... ]
    },
    "shortest": {
      "algorithm_used": "dijkstra",
      "criteria": "shortest",
      "estimated_time_min": 11.2,
      "fare_status": "verified",
      "found": true,
      "number_of_stops": 6,
      "number_of_transfers": 0,
      "total_distance_km": 4.8,
      "total_fare": 20.0,
      "segments": [ ... ]
    },
    "cheapest": {
      "algorithm_used": "dijkstra",
      "criteria": "cheapest",
      "estimated_time_min": 11.2,
      "fare_status": "verified",
      "found": true,
      "number_of_stops": 6,
      "number_of_transfers": 0,
      "total_distance_km": 4.8,
      "total_fare": 20.0,
      "segments": [ ... ]
    },
    "min_stops": {
      "algorithm_used": "bfs",
      "criteria": "min_stops",
      "estimated_time_min": 11.2,
      "fare_status": "verified",
      "found": true,
      "number_of_stops": 6,
      "number_of_transfers": 0,
      "total_distance_km": 4.8,
      "total_fare": 20.0,
      "segments": [ ... ]
    }
  },
  "success": true
}
```

---

### 2.7 Fare Calculation Engine
`POST /api/v1/fares/calculate` (Aliases: `/api/fare/calculate`, `/api/v1/fare/calculate`)

#### Request Schema
```json
{
  "transport_type_id": 1,         // 1 = Metro, 2 = Bus, 3 = Railway, 4 = RRTS
  "distance_km": 15.0,            // Trip distance in kilometers
  "stops_count": 5,               // Optional: number of stations (used for NMRC & UPMRC)
  "line_code": "DMRC_YELLOW",     // Optional: line identifier (e.g. DMRC_AIRPORT, NMRC_AQUA, MM_LINE1)
  "departure_time": "14:00",      // Optional: "HH:MM" (evaluates peak vs off-peak discounts)
  "day_type": "weekday",          // Optional: "weekday", "sunday", "holiday"
  "fare_class": "standard",       // Optional: "standard", "premium", "ac", "non_ac", "SL", "3A"
  "is_smart_card": true           // Optional: boolean
}
```

#### Example 1: DMRC Off-Peak Smart Card (20% Discount)
```bash
curl -s -X POST http://127.0.0.1:8088/api/v1/fares/calculate \
  -H "Content-Type: application/json" \
  -d '{
    "transport_type_id": 1,
    "distance_km": 15.0,
    "line_code": "DMRC_YELLOW",
    "departure_time": "14:00",
    "day_type": "weekday",
    "is_smart_card": true
  }'
```
**Response (`200 OK`)**:
```json
{
  "fare": {
    "amount": 32.0,
    "currency": "INR",
    "details": "20% DMRC Smart Card non-peak discount applied",
    "discount_applied": 8.0,
    "fare_class": "general",
    "fare_type": "distance_slab",
    "operator_name": "Delhi Metro (DMRC)",
    "original_amount": 40.0,
    "source": "DMRC Official Fare Structure",
    "status": "verified"
  },
  "success": true
}
```

#### Example 2: Namo Bharat Full-Corridor Standard with NCMC Loyalty
```bash
curl -s -X POST http://127.0.0.1:8088/api/v1/fares/calculate \
  -H "Content-Type: application/json" \
  -d '{
    "transport_type_id": 4,
    "distance_km": 82.15,
    "fare_class": "standard",
    "is_smart_card": true
  }'
```
**Response (`200 OK`)**:
```json
{
  "fare": {
    "amount": 189.0,
    "currency": "INR",
    "details": "Namo Bharat Standard Coach (10% NCMC / RRTS Connect Loyalty discount applied; published tariff incorporates the 35% statutory base fare concession)",
    "discount_applied": 21.0,
    "fare_class": "standard",
    "fare_type": "distance_slab",
    "operator_name": "NCRTC (Namo Bharat)",
    "original_amount": 210.0,
    "source": "NCRTC Official Published Tariff (Gazette effective 2026-02-22)",
    "status": "verified"
  },
  "success": true
}
```

---

## 3. Protected Admin API Reference

All `/api/admin/*` endpoints require authentication via either:
- HTTP Header `Authorization: Bearer <ADMIN_JWT_SECRET>`
- HTTP Header `X-Admin-Key: <ADMIN_JWT_SECRET>`

#### Unauthorized Error (`401 Unauthorized`)
```json
{
  "error": "Unauthorized. Admin authentication required.",
  "success": false
}
```

### 3.1 Create Station
`POST /api/admin/stations`
```bash
curl -s -X POST http://127.0.0.1:8088/api/admin/stations \
  -H "Content-Type: application/json" \
  -H "X-Admin-Key: raasta_admin_secret_key_2026" \
  -d '{
    "name": "Noida Sector 142",
    "code": "NOI_S142",
    "latitude": 28.5021,
    "longitude": 77.4215,
    "station_type": "metro_station",
    "city_name": "Noida",
    "is_interchange": true
  }'
```

### 3.2 Update Station
`PUT /api/admin/stations`
```bash
curl -s -X PUT http://127.0.0.1:8088/api/admin/stations \
  -H "Content-Type: application/json" \
  -H "X-Admin-Key: raasta_admin_secret_key_2026" \
  -d '{
    "id": 105,
    "name": "Noida Sector 142 Terminal",
    "code": "NOI_S142",
    "latitude": 28.5021,
    "longitude": 77.4215
  }'
```

### 3.3 Delete Station
`DELETE /api/admin/stations?id={station_id}`
```bash
curl -s -X DELETE "http://127.0.0.1:8088/api/admin/stations?id=105" \
  -H "X-Admin-Key: raasta_admin_secret_key_2026"
```

### 3.4 Create / Update / Delete Connection
`POST /api/admin/connections`, `PUT /api/admin/connections`, `DELETE /api/admin/connections?id={connection_id}`

### 3.5 Rebuild Graph
`POST /api/admin/graph/rebuild`
```bash
curl -s -X POST http://127.0.0.1:8088/api/admin/graph/rebuild \
  -H "X-Admin-Key: raasta_admin_secret_key_2026"
```

