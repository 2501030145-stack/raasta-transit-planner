# Raasta

A route-planning MVP for a curated Delhi NCR / Uttar Pradesh demonstration network. Raasta recommends and compares routes; it does not sell tickets.

## What works in this MVP

- Map-based planner with source/destination search, four route criteria, route comparison, timeline expansion, highlighted map paths, map-layer switching and view presets.
- Shortest distance, fastest time and lowest fare use Dijkstra. Fewest stops uses BFS over expanded unit segments, minimizing the sum of configured connection `stops` values in `data/network.json`; these values are illustrative, not verified intermediate-stop counts from operators.
- The Network Explorer, planner station selectors and geographic station markers use records from the configurable `GET /api/v1/stations` service. The bundled sample graph remains separate for route weights; station API data is not silently substituted with sample records when the backend is unavailable.
- Admin page provides a clearly marked demonstration interface for network editing and login flow. It is not production authentication and does not persist changes to MySQL.
- `backend/` contains C++ API source using cpp-httplib and nlohmann/json, with graph algorithms and JSON endpoints; `sql/` contains a MySQL schema and representative seed data.

## Demo data and geographic accuracy

The small curated graph is an illustrative sample, not an authoritative or complete timetable, routing feed, fare schedule, or live service. Costs and travel durations are example planning weights. A connection's coordinates use the station's approximate real-world location and are for map display only; they are not service-specific GPS data. The app identifies this limitation on the planner. It does not invent roads, state boundaries, rivers or terrain overlays. Cab and bike are omitted because no configured route data supports them.

The map uses Leaflet and two user-selectable raster layers: OpenStreetMap standard tiles and OpenTopoMap. Visible attribution is retained. OpenStreetMap is open data under ODbL, but its public standard tile service is best-effort, has no SLA and requires proper attribution, normal browser Referer, cache respect and no bulk/offline prefetch; high-volume production deployments should choose a provider under an appropriate service agreement or self-host. OpenTopoMap is a community tile provider with its own usage limits and no availability guarantee; its published usage guidance permits web embedding with visible attribution while avoiding server overload. No tiles are bulk downloaded. This MVP uses only normal interactive viewport requests. The map shows station pins with approximate sample positions. Highlighted connectors are schematic graph links between stations, not surveyed route/track polylines; they are labeled as such and must not be used for turn-by-turn navigation. Source policies: [OSM tile usage](https://operations.osmfoundation.org/policies/tiles/), [OSM copyright and license](https://www.openstreetmap.org/copyright), and [OpenTopoMap usage and attribution](https://opentopomap.org/about).

## Run the frontend

Requirements: Node.js 18 or newer. No npm dependencies are needed for the frontend or same-origin station API proxy.

```sh
npm start
```

Run the route-algorithm regression tests with `npm test` and the station-service response/mapping tests with `node tests/api-service.test.js`.

By default the Node server listens on `0.0.0.0:3000`; override with `PORT` if required. The station API target defaults to `http://127.0.0.1:8088`; override it with the non-secret Node environment variable `RAASTA_API_BASE_URL`, for example `RAASTA_API_BASE_URL=http://127.0.0.1:8088 npm start`. Browser calls use the server's narrowly scoped same-origin proxy, so the API does not need browser CORS headers. The expected station route is `GET /api/v1/stations`. If the service is down, the existing alert treatment explains the failure, selectors stay empty, and mock stations are not presented as API data. The map itself requires browser internet access to load Leaflet from its CDN and map tiles from the selected provider; if map assets fail, an explicit map-unavailable notice is shown.

This Phase 2 slice intentionally stops at station data: selectors use numeric backend station IDs and markers use backend coordinates, but route calculation is still based on the existing bundled sample graph and has not been connected to those IDs. The local API at port 8088 was unavailable in the implementation environment, so the expected 355-record live response could not be verified here.

## Container deployment

The root `Dockerfile` packages the Node frontend server, installs its lockfile dependencies, honors `PORT` (default `3000`), and serves `/_app/health` as an unauthenticated readiness endpoint. The published container runs the same frontend with its bundled sample-data adapter. It does not compile or proxy the separate C++ API or connect to MySQL; do not interpret a successful site publish as verification of those components.

Published demo: [raasta-mpxyck7w.manus.space](https://raasta-mpxyck7w.manus.space) — version `651902b8e6acbf7291ff5d116fc2834b16041979`.

## Build and run the C++ API

Requirements: a C++17 compiler, CMake 3.20+, `pkg-config`, MySQL-compatible client development headers, and internet access for CMake FetchContent to retrieve cpp-httplib and nlohmann/json. The API source and CMake file are separate from the frontend demo. From `backend/`:

```sh
cmake -S . -B build
cmake --build build
./build/raasta-api
```

The service reads `API_PORT` (default 8080) and explicit `MYSQL_HOST`, `MYSQL_PORT`, `MYSQL_USER`, `MYSQL_PASSWORD` and `MYSQL_DATABASE` values at runtime. `GET /api/health` reports the selected data source and loaded sample counts; `GET /api/stations` and `POST /api/routes` serve the loaded MySQL rows or the explicitly selected file demo. This existing C++ demo API is not the separately supplied Phase 2 service contract (`GET /api/v1/stations` on port 8088) and was not changed. It has not been compiled or verified against that service. Use `.env.example` as a reference; never put real credentials in it.

MySQL schema and sample records are in `sql/schema.sql` and `sql/seed.sql`. Review them before applying to any database. The seed is for a fresh database; it is not an automatic production migration. **The generated seed currently deletes records in the sample tables before inserting the curated sample.** It is destructive to existing records in those tables and must only be run against an intentionally empty/demo database after review.

## API and admin boundary

The C++ API implements health, station-list and route-calculation endpoints. Persistent HTTP station/connection CRUD and admin-login endpoints are not implemented. Production admin access requires real identity, password hashing, session handling, CSRF protection, role controls, database transactions and secret management. No default administrator account/password is provided. The browser's admin controls demonstrate temporary in-memory station and connection CRUD only. The C++ API source has not been compiled in this sandbox because CMake and MySQL client development headers were unavailable; treat the documented build command as the next integration step, not as a verified executable.

## Files

- `index.html`, `styles.css`, `app.js`: user interface and client-side routing demo.
- `api-service.mjs`: reusable station fetch, validation, field mapping and client-side search.
- `server.js`: static file server, application health route and same-origin stations-only API proxy.
- `data/network.json`: sample station/line/connection graph.
- `backend/`: separate C++ backend source.
- `sql/`: MySQL DDL and seed.
- `.env.example`: non-secret environment variable names and defaults.

OpenTopoMap is the default layer because its tiles rendered in the captured preview while OSM standard tiles returned a 403 policy page in that automated screenshot environment. The OSM layer remains available as an alternate. Neither public tile service is assumed to provide an SLA; verify provider terms before production use.
