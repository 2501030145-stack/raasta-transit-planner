const DATA_URL = '/data/network.json';
const $ = (selector, root = document) => root.querySelector(selector);
const $$ = (selector, root = document) => [...root.querySelectorAll(selector)];
const state = { network: null, apiStations: [], stationLoadReport: null, stationDataLoading: true, selectedCriterion: 'time', selectedRoute: null, routeOptions: {}, routeLoading: false, map: null, layers: {}, markerLayer: null, routeLayer: null, networkMap: null, networkMapLayers: [], filtersBound: false, currentView: 'home', adminOpen: false, searchedOrigin: '', searchedDestination: '' };
const lineById = id => state.network.lines.find(line => line.id === id);
const stationById = id => state.network.stations.find(station => String(station.id) === String(id)) || state.apiStations.find(station => String(station.id) === String(id));
const prettyMode = mode => mode === 'Regional rail' ? 'REGIONAL RAIL' : String(mode || '').replaceAll('_', ' ').toUpperCase();

function escapeHtml(value) {
  return String(value ?? '').replace(/[&<>"']/g, ch => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[ch]);
}

function buildGraph() {
  const graph = new Map(state.network.stations.map(station => [station.id, []]));
  for (const edge of state.network.connections) {
    if (!graph.has(edge.from) || !graph.has(edge.to)) continue;
    graph.get(edge.from).push({ ...edge, to: edge.to, direction: 1 });
    graph.get(edge.to).push({ ...edge, from: edge.to, to: edge.from, direction: -1 });
  }
  return graph;
}

function shortestPath(start, goal, criterion) {
  const graph = buildGraph();
  if (!graph.has(start) || !graph.has(goal)) return null;
  if (start === goal) return { stationIds: [start], edges: [], distanceKm: 0, minutes: 0, fareInr: 0, stops: 0, hops: 0, transfers: 0 };
  if (criterion === 'stops') return bfsPath(graph, start, goal);
  const weightKey = criterion === 'distance' ? 'distanceKm' : criterion === 'fare' ? 'fareInr' : 'minutes';
  const costs = new Map([[start, 0]]), previous = new Map(), visited = new Set();
  while (true) {
    let current = null, currentCost = Infinity;
    for (const [id, value] of costs) if (!visited.has(id) && value < currentCost) { current = id; currentCost = value; }
    if (current === null || current === goal) break;
    visited.add(current);
    for (const edge of graph.get(current) || []) {
      if (visited.has(edge.to)) continue;
      const nextCost = currentCost + Number(edge[weightKey]);
      if (nextCost < (costs.get(edge.to) ?? Infinity)) {
        costs.set(edge.to, nextCost);
        previous.set(edge.to, { station: current, edge });
      }
    }
  }
  if (!costs.has(goal)) return null;
  return assemblePath(start, goal, previous, graph);
}

function bfsPath(graph, start, goal) {
  // Expand weighted sample-stop links into unit segments so BFS minimizes total configured stops.
  const expanded = new Map([...graph.keys()].map(id => [id, []]));
  let edgeIndex = 0;
  for (const [from, edges] of graph) for (const edge of edges) {
    const segments = Math.max(1, Math.round(Number(edge.stops) || 1));
    let previousNode = from;
    for (let segment = 1; segment <= segments; segment++) {
      const nextNode = segment === segments ? edge.to : `__sample_stop_${edgeIndex}_${segment}`;
      if (!expanded.has(nextNode)) expanded.set(nextNode, []);
      expanded.get(previousNode).push({ to: nextNode, edge: segment === segments ? edge : null });
      previousNode = nextNode;
    }
    edgeIndex++;
  }
  const queue = [start], previous = new Map(), visited = new Set([start]);
  for (let head = 0; head < queue.length; head++) {
    const current = queue[head];
    if (current === goal) break;
    for (const edge of expanded.get(current) || []) {
      if (visited.has(edge.to)) continue;
      visited.add(edge.to);
      previous.set(edge.to, { station: current, edge: edge.edge });
      queue.push(edge.to);
    }
  }
  if (!visited.has(goal)) return null;
  return assemblePath(start, goal, previous, graph);
}

function assemblePath(start, goal, previous, graph) {
  const ids = [goal], edges = [];
  let cursor = goal;
  while (cursor !== start) {
    const step = previous.get(cursor);
    if (!step) return null;
    if (step.edge) edges.unshift(step.edge);
    cursor = step.station;
    if (graph.has(cursor)) ids.unshift(cursor);
  }
  let distanceKm = 0, minutes = 0, fareInr = 0;
  for (const edge of edges) { distanceKm += +edge.distanceKm; minutes += +edge.minutes; fareInr += +edge.fareInr; }
  const distinctLines = [...new Set(edges.map(edge => edge.line))];
  let transfers = 0, previousLine = null;
  for (const edge of edges) { if (previousLine && previousLine !== edge.line) transfers++; previousLine = edge.line; }
  const stops = edges.reduce((total, edge) => total + Math.max(1, Math.round(Number(edge.stops) || 1)), 0);
  return { stationIds: ids, edges, distanceKm, minutes, fareInr, stops, hops: edges.length, transfers, distinctLines };
}

function allRoutes(origin, destination) {
  return ['time', 'distance', 'fare', 'stops'].map(criterion => ({ criterion, route: shortestPath(origin, destination, criterion) })).filter(item => item.route);
}

function populatePlannerSelectors() {
  const origin = $('#origin'), destination = $('#destination'), stations = state.apiStations;
  if (!stations.length) {
    const message = state.stationDataLoading ? 'Loading stations…' : 'Station data unavailable';
    const option = `<option value="">${escapeHtml(message)}</option>`;
    origin.innerHTML = option; destination.innerHTML = option;
    origin.disabled = true; destination.disabled = true;
    return;
  }
  const options = stations.map(station => `<option value="${station.id}">${escapeHtml(station.name)} · ${escapeHtml(station.city || station.code)}</option>`).join('');
  const previousOrigin = origin.value, previousDestination = destination.value;
  origin.innerHTML = options; destination.innerHTML = options;
  origin.disabled = false; destination.disabled = false;
  const preferredOrigin = stations.find(station => station.name.toLowerCase() === 'rajiv chowk') || stations[0];
  const preferredDestination = stations.find(station => station.name.toLowerCase() === 'meerut south') || stations.find(station => station.id !== preferredOrigin.id) || preferredOrigin;
  origin.value = stations.some(station => String(station.id) === previousOrigin) ? previousOrigin : String(preferredOrigin.id);
  destination.value = stations.some(station => String(station.id) === previousDestination) ? previousDestination : String(preferredDestination.id);
  if (origin.value === destination.value && stations.length > 1) destination.value = String(stations.find(station => String(station.id) !== origin.value).id);
}

function initPlanner() {
  const origin = $('#origin'), destination = $('#destination');
  populatePlannerSelectors();
  origin.addEventListener('change', () => state.searchedOrigin = '');
  destination.addEventListener('change', () => state.searchedDestination = '');
  $$('.criterion').forEach(button => button.addEventListener('click', () => {
    $$('.criterion').forEach(item => item.classList.toggle('selected', item === button));
    state.selectedCriterion = button.dataset.criterion;
    if ($('#route-list .route-card')) findRoutes();
  }));
  $('#swap-stations').addEventListener('click', () => { const value = origin.value; origin.value = destination.value; destination.value = value; findRoutes(); });
  $('#find-routes').addEventListener('click', findRoutes);
  $('#route-list').addEventListener('click', event => {
    const card = event.target.closest('.route-card'); if (!card) return;
    if (event.target.closest('.route-card-head')) card.classList.toggle('expanded');
    selectRoute(card.dataset.criterion);
  });
}

function displayLineName(line, mode, operator) {
  const name = String(line || '');
  const known = {
    DMRC_BLUE_MAIN: 'Delhi Metro · Blue Line',
    DMRC_YELLOW: 'Delhi Metro · Yellow Line'
  };
  if (known[name]) return known[name];
  if (name.startsWith('DMRC_')) return 'Delhi Metro';
  return name || String(mode || operator || 'Transit');
}

function normalizeBackendRoute(route) {
  if (!route || route.found === false) return null;
  const stations = Array.isArray(route.stations) ? route.stations : [];
  const segments = Array.isArray(route.segments) ? route.segments : [];
  const stationIds = stations.map(item => Number(item.id)).filter(Number.isSafeInteger);
  const edges = segments.map(segment => ({
    from: Number(segment.from_station_id ?? segment.from_id),
    to: Number(segment.to_station_id ?? segment.to_id),
    line: displayLineName(segment.line_name, segment.transport_type_name, segment.operator_name),
    lineName: displayLineName(segment.line_name, segment.transport_type_name, segment.operator_name),
    mode: String(segment.transport_type_name || segment.mode || 'Transit'),
    minutes: Number(segment.estimated_time_min ?? segment.travel_time_min ?? segment.time_min ?? 0),
    distanceKm: Number(segment.distance_km ?? segment.distanceKm ?? 0),
    fareInr: Number(segment.fare?.amount ?? segment.fare_amount ?? 0),
    stops: 1,
    transfer: Boolean(segment.is_transfer ?? segment.transfer)
  }));
  const fallbackIds = segments.length ? [Number(segments[0].from_station_id ?? segments[0].from_id), ...segments.map(item => Number(item.to_station_id ?? item.to_id))].filter(Number.isSafeInteger) : [];
  const ids = stationIds.length ? stationIds : fallbackIds;
  if (!ids.length) return null;
  const distinctLines = [...new Set(edges.map(edge => edge.lineName))];
  return {
    stationIds: ids,
    edges,
    minutes: Number(route.estimated_time_min ?? 0),
    distanceKm: Number(route.total_distance_km ?? 0),
    fareInr: Number(route.total_fare ?? -1),
    stops: Number(route.number_of_stops ?? Math.max(0, ids.length - 1)),
    hops: edges.length,
    transfers: Number(route.number_of_transfers ?? edges.filter(edge => edge.transfer).length),
    distinctLines,
    live: true,
    fareStatus: String(route.fare_status || 'unknown')
  };
}

async function findRoutes() {
  const origin = $('#origin').value, destination = $('#destination').value;
  if (!origin || !destination) return;
  if (origin === destination) { $('#route-list').innerHTML = '<div class="empty-routes"><b>Choose two different stations.</b><span>Route origin and destination must differ.</span></div>'; return; }
  const originStation = stationById(origin), destinationStation = stationById(destination);
  if (!originStation || !destinationStation) { $('#route-list').innerHTML = '<div class="empty-routes"><b>Station unavailable.</b><span>Choose stations loaded from the backend.</span></div>'; return; }
  const labels = { time: 'FASTEST', distance: 'SHORTEST', fare: 'LOWEST FARE', stops: 'FEWEST STOPS' };
  $('#route-list').innerHTML = '<div class="empty-routes"><b>Finding live routes…</b><span>Querying the Raasta routing engine.</span></div>';
  $('#route-count').textContent = '…';
  try {
    const api = await import('./route-service.mjs');
    const comparisons = await api.compareRoutes({ sourceStationId: originStation.id, destinationStationId: destinationStation.id, transportModes: [] });
    const keyMap = { time: 'fastest', distance: 'shortest', fare: 'cheapest', stops: 'min_stops' };
    state.routeOptions = Object.fromEntries(Object.entries(keyMap).map(([criterion, key]) => [criterion, normalizeBackendRoute(comparisons[key])]));
    const available = Object.entries(state.routeOptions).filter(([, route]) => route);
    $('#results-title').textContent = 'Your journey';
    $('#route-count').textContent = String(available.length).padStart(2, '0');
    if (!available.length) {
      $('#route-summary').innerHTML = `<div class="summary-line"><span>${escapeHtml(originStation.name.toUpperCase())}</span><span>TO&nbsp; ${escapeHtml(destinationStation.name.toUpperCase())}</span></div><p>No connected route was found by the backend.</p>`;
      $('#route-list').innerHTML = '<div class="empty-routes"><b>No route found.</b><span>The backend graph has no available path between these stations.</span></div>';
      if (state.routeLayer && state.map) state.map.removeLayer(state.routeLayer);
      state.routeLayer = null; state.selectedRoute = null;
      return;
    }
    $('#route-summary').innerHTML = `<div class="summary-line"><span>${escapeHtml(originStation.name.toUpperCase())}</span><span>TO&nbsp; ${escapeHtml(destinationStation.name.toUpperCase())}</span></div><p>${available.length} live route ${available.length === 1 ? 'option' : 'options'} · Ranked by ${labels[state.selectedCriterion].toLowerCase()} first.</p>`;
    const ranked = available.sort(([a], [b]) => a === state.selectedCriterion ? -1 : b === state.selectedCriterion ? 1 : 0);
    $('#route-list').innerHTML = ranked.map(([criterion, route]) => renderRouteCard(criterion, route, labels[criterion])).join('');
    const selected = state.routeOptions[state.selectedCriterion] ? state.selectedCriterion : ranked[0][0];
    selectRoute(selected);
    state.searchedOrigin = `${originStation.name} → ${destinationStation.name}`;
  } catch (error) {
    console.error('Raasta route API unavailable', error);
    $('#route-count').textContent = '—';
    $('#route-list').innerHTML = `<div class="empty-routes"><b>Route service unavailable.</b><span>${escapeHtml(error.message || 'Could not retrieve routes from the backend.')}</span></div>`;
    if (state.routeLayer && state.map) state.map.removeLayer(state.routeLayer);
    state.routeLayer = null;
  }
}

function renderRouteCard(criterion, route, label) {
  const points = route.stationIds.map(id => stationById(id)).filter(Boolean);
  const timeline = points.map((station, i) => `<div class="timeline-stop"><i></i><span>${escapeHtml(station.name)}${i === 0 ? ' · START' : i === points.length - 1 ? ' · ARRIVAL' : ''}</span><span>${i < route.edges.length ? `${Math.round(route.edges[i].minutes)} min` : ''}</span></div>`).join('');
  const chips = [...new Set(route.edges.map(edge => edge.lineName))].map(name => `<span class="mode-chip">${escapeHtml(name)}</span>`).join('');
  const fare = route.fareInr >= 0 ? `₹${Math.round(route.fareInr)}` : 'Unavailable';
  const fareLabel = route.fareStatus === 'approximate' ? 'APPROX. FARE' : route.fareStatus === 'unavailable' ? 'FARE UNAVAILABLE' : 'FARE';
  return `<article class="route-card ${criterion === state.selectedCriterion ? 'selected' : ''}" data-criterion="${criterion}"><div class="route-card-head"><div><div class="route-card-name">${escapeHtml(label[0] + label.slice(1).toLowerCase())}</div><div class="route-card-tag">${criterion === state.selectedCriterion ? 'YOUR PRIORITY' : 'ALTERNATIVE'}</div></div><span class="route-card-tag">⌄</span></div><div class="route-metrics"><div class="metric"><b>${Math.round(route.minutes)}<small> min</small></b><span>TIME</span></div><div class="metric"><b>${route.distanceKm.toFixed(1)}<small> km</small></b><span>DISTANCE</span></div><div class="metric"><b>${fare}</b><span>${fareLabel}</span></div></div><div class="route-modes">${chips}<span class="transfer-chip">${route.stops} stops · ${route.transfers} transfers</span></div><div class="route-timeline">${timeline || '<div>No intermediate stops.</div>'}</div></article>`;
}

function selectRoute(criterion) {
  const route = state.routeOptions[criterion];
  const card = $(`.route-card[data-criterion="${criterion}"]`);
  if (!card || !route) return;
  state.selectedRoute = criterion;
  $$('.route-card').forEach(item => item.classList.toggle('selected', item === card));
  drawRoute(route);
}

function drawRoute(route) {
  if (!state.map || !route) return;
  if (state.routeLayer) state.map.removeLayer(state.routeLayer);
  const coords = route.stationIds.map(id => stationById(id)).filter(Boolean).map(station => [station.lat, station.lng]);
  if (coords.length < 2) return;
  state.routeLayer = L.polyline(coords, { color: '#ff7139', weight: 5, opacity: .94, dashArray: '5, 7', lineCap: 'round', lineJoin: 'round' }).addTo(state.map);
  const bounds = state.routeLayer.getBounds(); if (bounds.isValid()) state.map.fitBounds(bounds, { padding: [35, 35], maxZoom: 10, animate: true });
}

function initMap() {
  if (!window.L) { $('#map-fallback').hidden = false; return; }
  state.map = L.map('map', { zoomControl: false, preferCanvas: true, scrollWheelZoom: true }).setView([28.72, 77.35], 8);
  L.control.zoom({ position: 'topright' }).addTo(state.map);
  const osm = L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', { maxZoom: 19, attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap contributors</a>' });
  const topo = L.tileLayer('https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png', { maxZoom: 13, attribution: 'Map data: &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap contributors</a> · Map style: &copy; <a href="https://opentopomap.org">OpenTopoMap</a>' });
  state.layers.street = osm; state.layers.terrain = topo; topo.addTo(state.map);
  for (const layer of [osm, topo]) layer.on('tileerror', () => { $('#map-fallback').hidden = false; });
  $('#map-layer').addEventListener('change', event => {
    for (const layer of Object.values(state.layers)) if (state.map.hasLayer(layer)) state.map.removeLayer(layer);
    state.layers[event.target.value].addTo(state.map);
    $('#map-fallback').hidden = false;
    setTimeout(() => $('#map-fallback').hidden = true, 2400);
  });
  L.control.scale({ imperial: false, position: 'bottomleft' }).addTo(state.map);
  state.markerLayer = L.layerGroup().addTo(state.map);
  renderMapStations();
  initNetworkMap();
  $$('.map-view-button').forEach(button => button.addEventListener('click', () => {
    $$('.map-view-button').forEach(item => item.classList.toggle('active', item === button));
    const views = { india: [[22.8, 79.2], 4], regional: [[28.85, 77.7], 7], detail: [[28.63, 77.24], 11] };
    const [center, zoom] = views[button.dataset.mapView]; state.map.setView(center, zoom, { animate: true });
  }));
}

function initNetworkMap() {
  if (!window.L) return;
  state.networkMap = L.map('network-mini-map', { zoomControl: false, attributionControl: true, scrollWheelZoom: false, dragging: true }).setView([28.7, 77.35], 7);
  L.tileLayer('https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png', { maxZoom: 13, attribution: 'Map data: &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap contributors</a> · Map style: &copy; <a href="https://opentopomap.org">OpenTopoMap</a>' }).addTo(state.networkMap);
  L.control.zoom({ position: 'topright' }).addTo(state.networkMap);
}

function drawNetworkDetail(station, connections) {
  if (!state.networkMap) return;
  state.networkMapLayers.forEach(layer => state.networkMap.removeLayer(layer)); state.networkMapLayers = [];
  const visible = [station, ...connections.map(item => item.station).filter(Boolean)];
  connections.forEach(({ edge, station: next }) => {
    if (!next) return;
    const color = lineById(edge.line)?.color || '#ff7139';
    state.networkMapLayers.push(L.polyline([[station.lat, station.lng], [next.lat, next.lng]], { color, weight: 3, opacity: .8 }).addTo(state.networkMap));
  });
  visible.forEach(item => state.networkMapLayers.push(L.circleMarker([item.lat, item.lng], { radius: item.id === station.id ? 7 : 5, color: '#f2f0e9', weight: 1, fillColor: item.id === station.id ? '#ff7139' : '#77d5e8', fillOpacity: .95 }).bindTooltip(escapeHtml(item.name)).addTo(state.networkMap)));
  const bounds = L.latLngBounds(visible.map(item => [item.lat, item.lng]));
  state.networkMap.fitBounds(bounds, { padding: [25, 25], maxZoom: 11 });
  setTimeout(() => state.networkMap.invalidateSize(), 100);
}

function renderMapStations() {
  if (!state.markerLayer) return;
  state.markerLayer.clearLayers();
  state.apiStations.forEach(station => {
    const color = /rail|train/i.test(station.type) ? '#a1c78b' : '#f2c84b';
    const marker = L.circleMarker([station.lat, station.lng], { radius: 5, color: '#e7e4dc', weight: 1.1, fillColor: color, fillOpacity: .94 });
    marker.bindTooltip(escapeHtml(station.name), { direction: 'top', offset: [0, -6], className: 'raasta-tooltip' });
    marker.on('click', () => { showStationDetail(station.id); setView('network'); });
    marker.addTo(state.markerLayer);
  });
}

function populateModes() {
  const filter = $('#mode-filter');
  const selectedMode = filter.value || 'all';
  const apiTypes = [...new Set(state.apiStations.map(station => station.type).filter(Boolean))].sort();
  filter.innerHTML = `<option value="all">All modes</option>` + apiTypes.map(type => `<option value="${escapeHtml(type)}">${escapeHtml(prettyMode(type))}</option>`).join('');
  filter.value = apiTypes.includes(selectedMode) ? selectedMode : 'all';
  const adminSelect = $('#station-form select[name="mode"]');
  adminSelect.innerHTML = state.network.modes.map(mode => `<option>${escapeHtml(mode)}</option>`).join('');
  if (!state.filtersBound) {
    filter.addEventListener('change', renderNetworkList);
    $('#station-search').addEventListener('input', renderNetworkList);
    state.filtersBound = true;
  }
  renderNetworkList();
}

function renderNetworkList() {
  const query = $('#station-search').value.trim().toLowerCase(), mode = $('#mode-filter').value;
  const stations = state.apiStations;
  const filtered = stations.filter(station => (!mode || mode === 'all' || station.type === mode) && (!query || `${station.name} ${station.code} ${station.city} ${station.type}`.toLowerCase().includes(query)));
  $('#station-total').textContent = stations.length.toString().padStart(2, '0');
  $('#line-total').textContent = '—';
  $('#station-result-count').textContent = `${filtered.length} / ${stations.length}`;
  const emptyMessage = state.stationDataLoading ? 'Loading backend stations…' : 'No backend stations are available.';
  $('#network-stations').innerHTML = filtered.map((station, index) => `<div class="station-row" data-station="${station.id}"><span class="station-row-number">${String(index + 1).padStart(2, '0')}</span><div><div class="station-row-name">${escapeHtml(station.name)}</div><div class="station-row-meta">${escapeHtml(station.city || 'Unknown city')} · ${escapeHtml(station.code || station.type)}</div></div><span class="station-row-modes">${escapeHtml(prettyMode(station.type))}${station.interchange ? ' · INTERCHANGE' : ''}</span></div>`).join('') || `<div class="empty-routes">${escapeHtml(query ? 'No stations match this search.' : emptyMessage)}</div>`;
  $$('.station-row').forEach(row => row.addEventListener('click', () => showStationDetail(row.dataset.station)));
}

function showStationDetail(id) {
  const station = stationById(id); if (!station) return;
  $$('.station-row').forEach(row => row.classList.toggle('selected', String(row.dataset.station) === String(id)));
  const isBackendStation = state.apiStations.some(item => String(item.id) === String(station.id));
  const connections = isBackendStation ? [] : state.network.connections.filter(edge => edge.from === id || edge.to === id).map(edge => ({ edge, station: stationById(edge.from === id ? edge.to : edge.from) }));
  const stationType = station.type || station.modes?.[0] || 'Station';
  $('#station-detail').className = 'station-profile';
  const profileLabel = station.dataStatus ? `${station.dataStatus.toUpperCase()} / ${prettyMode(stationType)}` : `${String(station.zone || station.city || 'STATION').toUpperCase()} / NODE`;
  const lineDetails = station.lines?.length ? station.lines.map(lineId => `<span style="border-color:${escapeHtml(lineById(lineId)?.color || '#555')}">${escapeHtml(lineById(lineId)?.name || lineId)}</span>`).join('') : `<span>${escapeHtml(prettyMode(stationType))}</span>`;
  const connectionFallback = isBackendStation ? 'Connection details are not included in this station endpoint.' : 'No direct connections in this sample.';
  $('#station-detail').innerHTML = `<span class="profile-kicker">${escapeHtml(profileLabel)}</span><h2>${escapeHtml(station.name)}</h2><div class="profile-place">${escapeHtml(station.city)}${station.code ? ` · ${escapeHtml(station.code)}` : ''}</div><div class="profile-coords">${station.lat.toFixed(4)}° N&nbsp;&nbsp; ${station.lng.toFixed(4)}° E<br />${isBackendStation ? 'BACKEND STATION COORDINATES' : 'APPROXIMATE MAP POSITION'}</div><div class="profile-block"><label>LINES &amp; MODES</label><div class="profile-lines">${lineDetails}</div></div><div class="profile-block profile-connections"><label>CONNECTED NODES (${connections.length})</label>${connections.map(({edge, station: next}) => `<div class="profile-connection"><span>${escapeHtml(next?.name || 'Unknown node')}</span><span>${edge.distanceKm} km · ${edge.minutes} min</span></div>`).join('') || `<p class="station-row-meta">${escapeHtml(connectionFallback)}</p>`}</div>`;
  drawNetworkDetail(station, connections);
  if (state.map) { state.map.setView([station.lat, station.lng], Math.max(state.map.getZoom(), 10), { animate: true }); }
}

function initAdmin() {
  $('#demo-login').addEventListener('click', () => {
    if (!$('#demo-name').value.trim()) { $('#demo-name').focus(); return; }
    state.adminOpen = true; $('#admin-gate').hidden = true; $('#admin-workspace').hidden = false; renderAdmin();
  });
  $('#admin-logout').addEventListener('click', () => { state.adminOpen = false; $('#admin-gate').hidden = false; $('#admin-workspace').hidden = true; });
  $('#station-form').addEventListener('submit', event => {
    event.preventDefault(); const form = new FormData(event.currentTarget);
    const name = String(form.get('name')).trim(), city = String(form.get('city')).trim(), lat = Number(form.get('lat')), lng = Number(form.get('lng'));
    if (!name || !city || !Number.isFinite(lat) || !Number.isFinite(lng) || Math.abs(lat) > 90 || Math.abs(lng) > 180) return;
    const id = `${name.toLowerCase().replace(/[^a-z0-9]+/g, '-')}-${Date.now().toString(36)}`;
    const mode = String(form.get('mode'));
    state.network.stations.push({ id, name, city, lat, lng, modes: [mode], lines: [], zone: 'Demo record' });
    event.currentTarget.reset(); renderAdmin(); refreshStationSelectors(); populateModes(); renderMapStations();
  });
  $('#admin-table').addEventListener('click', event => {
    const edit = event.target.closest('[data-edit]');
    if (edit) {
      const station = stationById(edit.dataset.edit); if (!station) return;
      const name = window.prompt('Station name', station.name); if (name === null || !name.trim()) return;
      const city = window.prompt('City / area', station.city); if (city === null || !city.trim()) return;
      station.name = name.trim(); station.city = city.trim();
      renderAdmin(); populateModes(); renderMapStations(); return;
    }
    const button = event.target.closest('[data-delete]'); if (!button) return;
    const id = button.dataset.delete;
    state.network.stations = state.network.stations.filter(station => station.id !== id);
    state.network.connections = state.network.connections.filter(edge => edge.from !== id && edge.to !== id);
    renderAdmin(); refreshStationSelectors(); populateModes(); renderMapStations();
  });
  $('#connection-form').addEventListener('submit', event => {
    event.preventDefault(); const form = new FormData(event.currentTarget);
    const from = String(form.get('from')), to = String(form.get('to')), line = String(form.get('line'));
    if (!from || !to || from === to || !stationById(from) || !stationById(to) || !lineById(line)) return;
    const distanceKm = Number(form.get('distanceKm')), minutes = Number(form.get('minutes')), fareInr = Number(form.get('fareInr'));
    if (![distanceKm, minutes, fareInr].every(Number.isFinite) || distanceKm < 0 || minutes < 0 || fareInr < 0) return;
    state.network.connections.push({ from, to, line, distanceKm, minutes, fareInr, stops: 1 });
    event.currentTarget.reset(); renderAdmin(); findRoutes();
  });
  $('#connection-table').addEventListener('click', event => {
    const button = event.target.closest('[data-delete-connection]'); if (!button) return;
    const index = Number(button.dataset.deleteConnection);
    if (!Number.isInteger(index) || index < 0 || index >= state.network.connections.length) return;
    state.network.connections.splice(index, 1);
    renderAdmin(); findRoutes();
  });
}

function refreshStationSelectors() {
  populatePlannerSelectors();
  for (const selector of [$('#connection-form select[name="from"]'), $('#connection-form select[name="to"]')]) {
    const previous = selector.value;
    selector.innerHTML = state.network.stations.map(station => `<option value="${escapeHtml(station.id)}">${escapeHtml(station.name)} · ${escapeHtml(station.city)}</option>`).join('');
    if (state.network.stations.some(station => station.id === previous)) selector.value = previous;
  }
}

function renderAdmin() {
  $('#admin-stats').innerHTML = `<div class="admin-stat"><span>STATIONS</span><b>${state.network.stations.length}</b></div><div class="admin-stat"><span>CONNECTIONS</span><b>${state.network.connections.length}</b></div><div class="admin-stat"><span>LINES</span><b>${state.network.lines.length}</b></div><div class="admin-stat"><span>DATA SOURCE</span><b>DEMO</b></div>`;
  $('#admin-table').innerHTML = state.network.stations.map(station => `<tr><td>${escapeHtml(station.name)}<small>${escapeHtml(station.id)}</small></td><td>${escapeHtml(station.city)}</td><td>${escapeHtml(station.modes.join(', '))}</td><td>${station.lat.toFixed(4)}, ${station.lng.toFixed(4)}</td><td><button class="delete-row" data-edit="${escapeHtml(station.id)}">EDIT</button> <button class="delete-row" data-delete="${escapeHtml(station.id)}">REMOVE</button></td></tr>`).join('');
  const from = $('#connection-form select[name="from"]'), to = $('#connection-form select[name="to"]');
  const stationOptions = state.network.stations.map(station => `<option value="${escapeHtml(station.id)}">${escapeHtml(station.name)}</option>`).join('');
  for (const select of [from, to]) { const previous = select.value; select.innerHTML = stationOptions; if (state.network.stations.some(station => station.id === previous)) select.value = previous; }
  $('#connection-form select[name="line"]').innerHTML = state.network.lines.map(line => `<option value="${escapeHtml(line.id)}">${escapeHtml(line.name)}</option>`).join('');
  $('#connection-table').innerHTML = state.network.connections.map((edge, index) => `<tr><td>${escapeHtml(stationById(edge.from)?.name || edge.from)}</td><td>${escapeHtml(stationById(edge.to)?.name || edge.to)}</td><td>${escapeHtml(lineById(edge.line)?.name || edge.line)}</td><td>${edge.distanceKm} km / ${edge.minutes} min / ₹${edge.fareInr}</td><td><button class="delete-row" data-delete-connection="${index}">REMOVE</button></td></tr>`).join('');
}

function setView(name) {
  state.currentView = name;
  $$('.view').forEach(view => view.classList.toggle('active', view.id === `${name}-view`));
  $$('.nav-link').forEach(link => link.classList.toggle('active', link.dataset.view === name));
  $('.main-nav').classList.remove('open'); $('.menu-toggle').setAttribute('aria-expanded', 'false');
  if (name === 'planner' && state.map) setTimeout(() => state.map.invalidateSize(), 100);
  if (name === 'network' && state.networkMap) setTimeout(() => state.networkMap.invalidateSize(), 100);
  if (name === 'planner' && state.selectedRoute) setTimeout(() => drawRoute(state.routeOptions[state.selectedRoute]), 110);
  window.scrollTo({ top: 0, behavior: matchMedia('(prefers-reduced-motion: reduce)').matches ? 'instant' : 'smooth' });
}

function initNavigation() {
  $$('[data-view]').forEach(button => button.addEventListener('click', event => { event.preventDefault(); setView(button.dataset.view); }));
  $('.menu-toggle').addEventListener('click', () => { const nav = $('.main-nav'); nav.classList.toggle('open'); $('.menu-toggle').setAttribute('aria-expanded', nav.classList.contains('open')); });
}

function showStationDataNotice(title, message) {
  let notice = $('#station-data-status');
  if (!notice) {
    document.body.insertAdjacentHTML('afterbegin', '<div class="admin-alert" id="station-data-status" role="status" aria-live="polite"><span>!</span><div><b></b><p></p></div></div>');
    notice = $('#station-data-status');
  }
  $('b', notice).textContent = title;
  $('p', notice).textContent = message;
}

function clearStationDataNotice() {
  $('#station-data-status')?.remove();
}

async function boot() {
  try {
    const response = await fetch(DATA_URL); if (!response.ok) throw new Error('Sample data unavailable');
    state.network = await response.json();
    state.apiStations = [];
    state.stationDataLoading = true;
    initNavigation(); initMap(); initPlanner(); populateModes(); initAdmin();
    const requestedView = new URLSearchParams(window.location.search).get('view');
    if (['home', 'planner', 'network', 'admin'].includes(requestedView)) setView(requestedView);
  } catch (error) {
    console.error(error);
    document.body.insertAdjacentHTML('afterbegin', '<div class="admin-alert"><span>!</span><div><b>Sample network could not load.</b><p>Check that the app server can serve /data/network.json.</p></div></div>');
    return;
  }

  showStationDataNotice('Loading backend stations', 'Fetching station records from the configured API…');
  try {
    const api = await import('./api-service.mjs');
    state.apiStations = await api.getAllStations();
    state.stationLoadReport = api.getStationLoadReport();
    state.stationDataLoading = false;
    refreshStationSelectors();
    populateModes();
    renderMapStations();
    const report = state.stationLoadReport;
    console.info('Raasta backend station load', report);
    if (!state.apiStations.length) {
      showStationDataNotice('No backend stations received', 'The API returned an empty station list. Bundled demo stations are not substituted as live data.');
    } else if (report.invalidCount || report.duplicateCount || (report.advertisedCount !== null && report.advertisedCount !== report.receivedCount)) {
      showStationDataNotice('Some station records were skipped', `Received ${report.receivedCount}; loaded ${report.loadedCount}; skipped ${report.invalidCount} invalid and ${report.duplicateCount} duplicate records.`);
    } else {
      clearStationDataNotice();
    }
  } catch (error) {
    console.error('Raasta station API unavailable', error);
    state.apiStations = [];
    state.stationDataLoading = false;
    refreshStationSelectors();
    populateModes();
    renderMapStations();
    showStationDataNotice('Station backend unavailable', `${error.message || 'Station data could not be loaded.'} No bundled demo stations are shown as live backend data.`);
  }
}

document.addEventListener('DOMContentLoaded', boot);
