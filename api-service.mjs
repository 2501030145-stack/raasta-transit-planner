const DEFAULT_PROXY_BASE_URL = '/api-proxy';
let apiBaseUrl = DEFAULT_PROXY_BASE_URL;
let stationsCache = null;
let inFlight = null;
let loadReport = null;

function cloneStations(stations) {
  return stations.map(station => ({ ...station, modes: [...station.modes], lines: [...station.lines] }));
}

export function configureApiBaseUrl(baseUrl = DEFAULT_PROXY_BASE_URL) {
  const value = String(baseUrl || '').trim().replace(/\/+$/, '');
  if (!value) throw new TypeError('API base URL cannot be empty.');
  apiBaseUrl = value;
}

export function getStationLoadReport() {
  return loadReport ? { ...loadReport } : null;
}

export function clearStationCache() {
  stationsCache = null;
  inFlight = null;
  loadReport = null;
}

export async function getAllStations({ force = false } = {}) {
  if (stationsCache && !force) return cloneStations(stationsCache);
  if (inFlight && !force) return cloneStations(await inFlight);

  inFlight = (async () => {
    let response;
    try {
      response = await fetch(`${apiBaseUrl}/api/v1/stations`, {
        method: 'GET',
        headers: { Accept: 'application/json' },
        cache: 'no-store',
        credentials: 'omit'
      });
    } catch (error) {
      throw new Error(`Could not reach the station API: ${error?.message || 'network error'}`);
    }

    let payload;
    try {
      payload = await response.json();
    } catch {
      if (!response.ok) throw new Error(`The station API returned HTTP ${response.status}.`);
      throw new Error('The station API returned invalid JSON.');
    }

    if (!response.ok) {
      throw new Error(payload?.message || `The station API returned HTTP ${response.status}.`);
    }
    if (payload?.success !== true) {
      throw new Error(payload?.message || 'The station API reported an unsuccessful response.');
    }
    if (!Array.isArray(payload.stations)) {
      throw new Error('The station API response is missing its stations array.');
    }

    const seenIds = new Set();
    const stations = [];
    let invalidCount = 0;
    let duplicateCount = 0;

    for (const record of payload.stations) {
      if (!record || typeof record !== 'object') {
        invalidCount++;
        continue;
      }
      const id = Number(record.id);
      const name = String(record.name ?? '').trim();
      const latitude = Number(record.latitude);
      const longitude = Number(record.longitude);
      const type = String(record.station_type ?? '').trim();
      if (record.id === null || record.id === undefined || record.id === '' || !Number.isSafeInteger(id) || !name ||
          record.latitude === null || record.latitude === undefined || record.latitude === '' ||
          record.longitude === null || record.longitude === undefined || record.longitude === '' ||
          !Number.isFinite(latitude) || !Number.isFinite(longitude) || Math.abs(latitude) > 90 || Math.abs(longitude) > 180 || !type) {
        invalidCount++;
        continue;
      }
      if (seenIds.has(id)) {
        duplicateCount++;
        continue;
      }
      seenIds.add(id);

      const code = String(record.code ?? '').trim();
      const city = String(record.city_name ?? '').trim();
      stations.push({
        id,
        name,
        code,
        lat: latitude,
        lng: longitude,
        city,
        type,
        interchange: record.is_interchange === true || record.is_interchange === 1 || record.is_interchange === '1' || record.is_interchange === 'true',
        active: record.is_active === true || record.is_active === 1 || record.is_active === '1' || record.is_active === 'true',
        dataStatus: String(record.data_status ?? ''),
        zone: code || city,
        modes: [type],
        lines: []
      });
    }

    const advertisedCount = Number.isSafeInteger(Number(payload.count)) ? Number(payload.count) : null;
    loadReport = {
      advertisedCount,
      receivedCount: payload.stations.length,
      loadedCount: stations.length,
      invalidCount,
      duplicateCount,
      uniqueIds: seenIds.size
    };
    stationsCache = stations;
    return stations;
  })();

  try {
    return cloneStations(await inFlight);
  } finally {
    inFlight = null;
  }
}

export async function searchStations(query, limit = 20) {
  const stations = await getAllStations();
  const needle = String(query ?? '').trim().toLocaleLowerCase();
  const matches = needle
    ? stations.filter(station => `${station.name} ${station.code} ${station.city} ${station.type}`.toLocaleLowerCase().includes(needle))
    : stations;
  const requestedLimit = Number(limit);
  const safeLimit = Number.isFinite(requestedLimit) ? Math.max(0, Math.floor(requestedLimit)) : 20;
  return matches.slice(0, safeLimit);
}
