# Raasta: Frontend–Backend Integration Guide

**Target Frontend:** `https://raasta-mpxyck7w.manus.space`  
**Backend Engine:** C++17 Modular Server (`raasta-server`) on port 8088  
**Design Preservation Guarantee:** Zero alterations to existing CSS styles, DOM hierarchy, Leaflet map canvas, or typography.

---

## 1. Overview & Current Frontend Workflow

The existing Manus frontend operates via `app.js` using an in-browser sample network:
1. `boot()` fetches a static JSON bundle from `/data/network.json` containing 20 demo stations.
2. `shortestPath()` runs a client-side Dijkstra/BFS in JavaScript across illustrative edges.
3. `findRoutes()` displays cards and draws route polylines on the Leaflet map.

### Live Backend Upgrade
By pointing the frontend to the live Raasta engine:
- The network expands from 20 demo records to **355 verified operational stations** and **778 transit edges**.
- Route calculation shifts from simplistic single-edge weights to the **Dijkstra & BFS multi-operator engine** with line-transfer penalties and interchange walking travel times.
- Fares switch from illustrative guesses to **official DMRC, NMRC, UPMRC, NCRTC, DTC, and Indian Railways tariff matrices** (including off-peak discounts, Sunday slabs, and NCMC loyalty benefits).

---

## 2. Environment Configuration

### Client Environment Setup
In the frontend hosting environment (e.g. Manus environment variables or `.env.production`):

```bash
# Production API Gateway
VITE_RAASTA_API_URL="https://api.raasta.yourdomain.com"

# Local Development Fallback
# VITE_RAASTA_API_URL="http://127.0.0.1:8088"
```

In vanilla JavaScript (`app.js`), define a resilient base URL selector:

```javascript
const API_BASE_URL = 
  (typeof window !== 'undefined' && window.RAASTA_API_URL) ||
  (typeof process !== 'undefined' && process.env?.VITE_RAASTA_API_URL) ||
  'http://127.0.0.1:8088';
```

---

## 3. Recommended Frontend API Client (`raastaService.js`)

Create a modular API service layer to interface with the C++ backend:

```javascript
// services/raastaService.js

const API_BASE = 
  (typeof window !== 'undefined' && window.RAASTA_API_URL) ||
  'http://127.0.0.1:8088';

export const raastaService = {
  /**
   * Health check
   */
  async getHealth() {
    const res = await fetch(`${API_BASE}/health`);
    if (!res.ok) throw new Error(`Health check failed: ${res.statusText}`);
    return res.json();
  },

  /**
   * Network overview statistics
   */
  async getNetworkOverview() {
    const res = await fetch(`${API_BASE}/api/v1/network/overview`);
    if (!res.ok) throw new Error(`Network overview failed: ${res.statusText}`);
    return res.json();
  },

  /**
   * Search stations by name or code
   */
  async searchStations(query, limit = 20) {
    if (!query?.trim()) return { stations: [], count: 0 };
    const res = await fetch(`${API_BASE}/api/v1/stations/search?q=${encodeURIComponent(query)}&limit=${limit}`);
    if (!res.ok) throw new Error(`Search failed: ${res.statusText}`);
    return res.json();
  },

  /**
   * Fetch all stations for map markers & selector dropdowns
   */
  async getAllStations() {
    const res = await fetch(`${API_BASE}/api/v1/stations`);
    if (!res.ok) throw new Error(`Failed to load stations: ${res.statusText}`);
    return res.json();
  },

  /**
   * Single-criterion route planning
   */
  async planRoute({ sourceStationId, destinationStationId, criteria = 'fastest', isSmartCard = false, transportModes = [] }) {
    const payload = {
      source_station_id: Number(sourceStationId),
      destination_station_id: Number(destinationStationId),
      criteria,
      is_smart_card: Boolean(isSmartCard),
      transport_modes: transportModes
    };

    const res = await fetch(`${API_BASE}/api/v1/routes/plan`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });

    if (!res.ok) {
      const err = await res.json().catch(() => ({}));
      throw new Error(err.error || `Route calculation failed with HTTP ${res.status}`);
    }
    return res.json();
  },

  /**
   * Compare all 4 routing criteria simultaneously
   */
  async compareRoutes({ sourceStationId, destinationStationId, isSmartCard = false, transportModes = [] }) {
    const payload = {
      source_station_id: Number(sourceStationId),
      destination_station_id: Number(destinationStationId),
      is_smart_card: Boolean(isSmartCard),
      transport_modes: transportModes
    };

    const res = await fetch(`${API_BASE}/api/v1/routes/compare`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });

    if (!res.ok) {
      const err = await res.json().catch(() => ({}));
      throw new Error(err.error || `Route comparison failed with HTTP ${res.status}`);
    }
    return res.json();
  },

  /**
   * Fare calculation helper
   */
  async calculateFare(context) {
    const res = await fetch(`${API_BASE}/api/v1/fares/calculate`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(context)
    });
    if (!res.ok) throw new Error(`Fare calculation error: ${res.statusText}`);
    return res.json();
  }
};
```

---

## 4. Frontend-to-Backend Field Mapping Matrix

| Manus Frontend Field (`app.js`) | Backend JSON Equivalent | Type | Notes & Transformation |
| :--- | :--- | :--- | :--- |
| `station.id` (slug, e.g. `'rajiv-chowk'`) | `station.id` (integer, e.g. `4`) or `station.code` (`"DEL_RC"`) | Integer / String | Use backend numeric ID for routing calls; keep code or slug as secondary key. |
| `station.name` | `station.name` | String | Matches directly (e.g. `"Rajiv Chowk"`) |
| `station.lat`, `station.lng` | `station.latitude`, `station.longitude` | Float | `lat: s.latitude, lng: s.longitude` for Leaflet marker plotting. |
| `station.city` | `station.city_name` | String | e.g. `"Delhi"`, `"Noida"`, `"Meerut"` |
| `station.modes` | `station.station_type` | Array / String | Maps `"metro_station"` -> `"Metro"`, `"rrts_station"` -> `"Namo Bharat (RRTS)"`, `"railway_station"` -> `"Indian Railways"`, `"bus_stop"` -> `"Bus"`. |
| `route.minutes` | `route.estimated_time_min` | Float | Rendered in route card: `Math.round(route.estimated_time_min)` min. |
| `route.distanceKm` | `route.total_distance_km` | Float | Rendered in route card: `route.total_distance_km.toFixed(1)` km. |
| `route.fareInr` | `route.total_fare` | Float | Rendered as `₹${Math.round(route.total_fare)}`. |
| `route.stops` | `route.number_of_stops` | Integer | Total stations visited along the itinerary. |
| `route.transfers` | `route.number_of_transfers` | Integer | Number of line or modal interchange events. |
| `route.stationIds` | `route.stations[].id` | Array of Int | Map coordinates derived from `route.stations.map(s => [s.latitude, s.longitude])`. |
| `route.edges[].line` | `segment.line_name` | String | e.g. `"Yellow Line"`, `"Delhi–Meerut RRTS"`, `"Transfer"` |
| `segment.is_transfer` | `segment.is_transfer` | Boolean | `true` denotes physical interchange (walk/skywalk/FOB). |

---

## 5. UI State Management (Loading, Empty & Errors)

### A. Loading State
When the user clicks **"Find routes"** (`#find-routes`), show a non-intrusive loading skeleton inside `#route-list`:

```javascript
function setRouteListLoading() {
  $('#results-title').textContent = 'Calculating optimal routes...';
  $('#route-list').innerHTML = `
    <div class="empty-routes" style="animation: pulse 1.5s infinite;">
      <b>Computing multimodal routing...</b>
      <span>Querying Dijkstra and BFS engines across 355 stations.</span>
    </div>
  `;
}
```

### B. Empty & Disconnected States
If the user selects two stations between which no continuous path exists:

```javascript
function renderNoRouteFound(originName, destinationName) {
  $('#route-count').textContent = '00';
  $('#route-summary').innerHTML = `
    <div class="summary-line">
      <span>${escapeHtml(originName.toUpperCase())}</span>
      <span>TO&nbsp; ${escapeHtml(destinationName.toUpperCase())}</span>
    </div>
    <p>No contiguous public transit connection found between these points.</p>
  `;
  $('#route-list').innerHTML = `
    <div class="empty-routes">
      <b>No transit route available.</b>
      <span>These stations belong to disjoint networks or require an unsupported transit mode.</span>
    </div>
  `;
}
```

### C. Unavailable Fare Handling
If a route contains an unverified or approximate segment:

```javascript
function formatFareDisplay(fareAmount, fareStatus) {
  if (fareStatus === 'unavailable' || fareAmount < 0) {
    return 'Fare unverified';
  }
  if (fareStatus === 'approximate') {
    return `~₹${Math.round(fareAmount)}*`;
  }
  return `₹${Math.round(fareAmount)}`;
}
```

---

## 6. Drop-In Integration for `app.js`

To connect the Manus frontend without modifying HTML or CSS:

```javascript
// Replace local allRoutes() in app.js with live backend comparison:
async function findRoutes() {
  const originId = $('#origin').value;
  const destinationId = $('#destination').value;

  if (originId === destinationId) {
    $('#route-list').innerHTML = '<div class="empty-routes"><b>Choose two different stations.</b><span>Route origin and destination must differ.</span></div>';
    return;
  }

  setRouteListLoading();

  try {
    const data = await raastaService.compareRoutes({
      sourceStationId: originId,
      destinationStationId: destinationId,
      isSmartCard: false
    });

    if (!data.success || !data.comparisons) {
      renderNoRouteFound(stationById(originId)?.name, stationById(destinationId)?.name);
      return;
    }

    // Convert comparisons object to list
    const criteriaKeys = ['fastest', 'shortest', 'cheapest', 'min_stops'];
    const labels = { fastest: 'FASTEST', shortest: 'SHORTEST', cheapest: 'LOWEST FARE', min_stops: 'FEWEST STOPS' };

    const validRoutes = criteriaKeys
      .filter(k => data.comparisons[k] && data.comparisons[k].found)
      .map(k => ({
        criterion: k,
        route: data.comparisons[k]
      }));

    if (validRoutes.length === 0) {
      renderNoRouteFound(stationById(originId)?.name, stationById(destinationId)?.name);
      return;
    }

    // Render results
    $('#results-title').textContent = 'Your journey';
    $('#route-count').textContent = String(validRoutes.length).padStart(2, '0');
    
    // Sort according to user preference
    const ranked = [...validRoutes].sort((a, b) => 
      (a.criterion === state.selectedCriterion ? -1 : b.criterion === state.selectedCriterion ? 1 : 0)
    );

    $('#route-list').innerHTML = ranked.map(({ criterion, route }) => 
      renderBackendRouteCard(criterion, route, labels[criterion])
    ).join('');

    selectRoute(ranked[0].criterion);
  } catch (err) {
    console.error('[Raasta] Route plan error:', err);
    $('#route-list').innerHTML = `
      <div class="empty-routes">
        <b>Server connection error.</b>
        <span>Could not communicate with the routing engine (${escapeHtml(err.message)}).</span>
      </div>
    `;
  }
}
```

