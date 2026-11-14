import assert from 'node:assert/strict';
import { compareRoutes, configureRouteApiBaseUrl } from '../route-service.mjs';

let captured;
globalThis.fetch = async (url, options) => {
  captured = { url, options, body: JSON.parse(options.body) };
  return { ok: true, status: 200, json: async () => ({ success: true, comparisons: { fastest: { found: false } } }) };
};
configureRouteApiBaseUrl('/api-proxy');
const result = await compareRoutes({ sourceStationId: 44, destinationStationId: 267, transportModes: [] });
assert.equal(captured.url, '/api-proxy/api/v1/routes/compare');
assert.equal(captured.options.method, 'POST');
assert.deepEqual(captured.body, { source_station_id: 44, destination_station_id: 267, transport_modes: [] });
assert.equal(result.fastest.found, false);
await assert.rejects(() => compareRoutes({ sourceStationId: 'Rajiv Chowk', destinationStationId: 267 }), /numeric backend station IDs/);
await assert.rejects(() => compareRoutes({ sourceStationId: 44, destinationStationId: 44 }), /different stations/);
console.log('Route service tests passed: POST proxy URL, numeric IDs, request payload and validation.');
