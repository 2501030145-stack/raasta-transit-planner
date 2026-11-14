const DEFAULT_PROXY_BASE_URL = '/api-proxy';
let apiBaseUrl = DEFAULT_PROXY_BASE_URL;

export function configureRouteApiBaseUrl(baseUrl = DEFAULT_PROXY_BASE_URL) {
  const value = String(baseUrl || '').trim().replace(/\/+$/, '');
  if (!value) throw new TypeError('API base URL cannot be empty.');
  apiBaseUrl = value;
}

export async function compareRoutes({ sourceStationId, destinationStationId, transportModes = [] }) {
  const source = Number(sourceStationId);
  const destination = Number(destinationStationId);
  if (!Number.isSafeInteger(source) || !Number.isSafeInteger(destination)) {
    throw new TypeError('Route endpoints must be valid numeric backend station IDs.');
  }
  if (source === destination) throw new TypeError('Choose two different stations.');

  let response;
  try {
    response = await fetch(`${apiBaseUrl}/api/v1/routes/compare`, {
      method: 'POST',
      headers: { Accept: 'application/json', 'Content-Type': 'application/json' },
      cache: 'no-store',
      credentials: 'omit',
      body: JSON.stringify({
        source_station_id: source,
        destination_station_id: destination,
        transport_modes: Array.isArray(transportModes) ? transportModes : []
      })
    });
  } catch (error) {
    throw new Error(`Could not reach the route API: ${error?.message || 'network error'}`);
  }

  let payload;
  try { payload = await response.json(); }
  catch { throw new Error(`The route API returned invalid JSON (HTTP ${response.status}).`); }
  if (!response.ok || payload?.success !== true) {
    throw new Error(payload?.error || payload?.message || `The route API returned HTTP ${response.status}.`);
  }
  if (!payload.comparisons || typeof payload.comparisons !== 'object') {
    throw new Error('The route API response is missing its comparisons object.');
  }
  return payload.comparisons;
}
