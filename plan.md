# Raasta — implementation and design plan

## Product and implementation

Raasta is a route-optimization demonstrator for Delhi NCR and Uttar Pradesh, not a booking system. The framework-free HTML/CSS/JavaScript application now has a separate station API service for `GET /api/v1/stations`; the Node static server proxies that single GET route to `RAASTA_API_BASE_URL` (default `http://127.0.0.1:8088`) to avoid browser CORS requirements. API station rows provide the explorer, station selectors and map markers. The bundled sample graph remains separate for the not-yet-integrated route algorithms; this Phase 2 task does not connect the station API to routing. The separately runnable C++/cpp-httplib source and MySQL schema/seed remain an independent backend package with their own existing endpoints; they are not modified or claimed as the supplied 8088 service. No live GPS, traffic, tracking, schedule, ML or booking features.

The map uses Leaflet with visible attribution, OpenTopoMap as the default terrain layer and OpenStreetMap standard tiles as an alternate. It shows approximate station locations, panning/zooming and highlighted dashed schematic graph connectors; these links are not surveyed rail/bus geometry. Views jump between India, NCR/UP and city scales. If map assets fail, an honest unavailability notice appears while non-map interactions remain. Tile and coordinate source/licensing caveats are documented. State-boundary and river overlays remain deferred until suitable geographic data is provided. Sample stations/edges are not an authoritative timetable or complete network.

## Structure and behavior

- `index.html`: app shell and semantic navigation for landing, planner, explorer and admin.
- `styles.css`: responsive editorial/dark GIS design system and mobile navigation.
- `app.js`: view transitions, accessible planner/explorer/admin-demo controls, rendering and interactions.
- `api-service.mjs`: reusable station fetch, response validation, backend-field normalization and client-side station search.
- `server.js`: dependency-light Node static server, route manifest, `/_app/health`, and a single-route same-origin station API proxy; honors `PORT` and `RAASTA_API_BASE_URL`.
- `Dockerfile`, `package.json`, `package-lock.json`: production container contract and reproducible npm dependency install (no runtime package dependencies).
- `data/network.json`: labeled demonstration stations, lines, modes and network edges with coordinates/weights.
- `backend/server.cpp`, `backend/CMakeLists.txt`: C++ adjacency-list graph algorithms and HTTP JSON API source/build setup.
- `sql/schema.sql`, `sql/seed.sql`: MySQL schema and curated sample records.
- `scripts/generate_seed.py`: deterministic SQL generation from the sample network JSON.
- `public/manus-routes.json`, `public/raasta-logo.svg`: route manifest and site wordmark asset; generated hero art is held in Manus Storage.
- `tests/routes.test.js`, `tests/api-service.test.js`: dependency-free routing and station API regression tests.
- `README.md`, `.env.example`: requirements, environment variables, build/run instructions, API and feature status.

The requested publish path is a single Node container serving the working frontend and its local demo-data adapter. It uses the root Dockerfile, honors `PORT`, and exposes an unauthenticated application health endpoint. This container deliberately does not compile or proxy the separate, unverified C++ API and does not connect to MySQL; the admin remains a demo interface and the backend source documents integration boundaries.

## Design system

### Three candidate styles

- Neo-metropolitan transit atlas: 0.06
- Warm brutalist civic terminal: 0.04
- Minimalist alpine route ledger: 0.03

### Chosen: Neo-metropolitan transit atlas

**Design Movement:** Neo-futurist editorial cartography, pairing a cinematic city-at-night hero with an instrument-like GIS planner.

**Core Principles:** Geography over generic dashboard chrome; vivid route color used as data, not decoration; editorial scale balanced with compact precision; every sample/data limitation stated plainly.

**Color Philosophy:** #0B0B0E and #171920 evoke a night map and make the network legible; #F2F0E9 is warm, high-contrast text; orange #FF7139 and amber #FF9B48 communicate motion and selected routes; cyan #77D5E8 marks connecting/secondary lines; muted green #A1C78B signals network context and completion. Borders are subtle and illumination restrained.

**Layout Paradigm:** A full-bleed, asymmetrical city cover opens into a map-dominant instrument panel: narrow route controls on the left, large geographic canvas in the center, and a compact, collapsible results rail. On mobile, the map becomes the canvas and controls/results become bottom sheets.

**Signature Elements:** Fine luminous linework connecting station nodes; oversized all-caps editorial headline; small amber coordinate/route readouts and numbered transfer markers.

**Interaction Philosophy:** Direct manipulation: station selection, route choice and map emphasis remain synchronized; views glide rather than reset; only selected routes receive strong glow.

**Animation:** Restrained 250–500 ms fades/slides and subtle line-draw/marker pulses; hero parallax only when reduced motion is not requested; no perpetual noisy motion.

**Typography System:** Space Grotesk for display and headings, IBM Plex Mono for coordinates/metrics, system sans for body; compact mono labels are uppercase and tracked, body copy stays readable.

**Brand Essence:** A night-map guide for people moving across NCR; precise, assured, exploratory.

**Brand Voice:** Confident, concise and directional. Examples: “THE CITY IS YOURS TO NAVIGATE.” and “Four ways across. One route that fits.”

**Wordmark & Logo:** A custom inline SVG wayfinding knot: two interlocking station nodes, one orange branch and one cyan branch, paired with a tracked RAasta wordmark.

**Signature Brand Color:** Transit orange #FF7139.

## Technical boundaries

The preview will serve on the initialized port 3000 and expose a static `/manus-routes.json`. Leaflet and geographic tiles use their public CDN/tile endpoints in the browser and are separately credited. User-facing map tiles are not stored or rediscovered through a proxy. If the managed MySQL environment or C++ compiler/toolchain is not present, no mock data will be labeled as live; a demo adapter is the working path. Admin login is demonstration-only until a deployment-ready identity/password policy and protected runtime are configured.
