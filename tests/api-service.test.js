const assert = require('node:assert/strict');
const { pathToFileURL } = require('node:url');
const { resolve } = require('node:path');

async function loadFreshService(fetchImpl) {
  global.fetch = fetchImpl;
  const url = pathToFileURL(resolve(__dirname, '../api-service.mjs'));
  url.searchParams.set('testRun', String(Date.now() + Math.random()));
  return import(url.href);
}

function response(payload, { ok = true, status = 200, invalidJson = false } = {}) {
  return {
    ok,
    status,
    json: async () => {
      if (invalidJson) throw new SyntaxError('bad json');
      return payload;
    }
  };
}

(async () => {
  const fixture = {
    success: true,
    count: 3,
    stations: [
      { id: '44', name: 'Rajiv Chowk', code: 'DEL_RC', latitude: '28.6328', longitude: '77.2197', city_name: 'Delhi', station_type: 'metro_station', is_interchange: true, is_active: true, data_status: 'verified' },
      { id: 45, name: 'New Delhi', code: 'DEL_ND', latitude: 28.643, longitude: 77.219, city_name: 'Delhi', station_type: 'railway_station', is_interchange: false, is_active: true },
      { id: 44, name: 'Duplicate ID', code: 'DUP', latitude: 28.6, longitude: 77.2, city_name: 'Delhi', station_type: 'metro_station' },
      { id: 46, name: 'Bad coordinates', code: 'BAD', latitude: 99, longitude: 77, city_name: 'Delhi', station_type: 'metro_station' }
    ]
  };
  let requestedUrl = '';
  const service = await loadFreshService(async url => {
    requestedUrl = String(url);
    return response(fixture);
  });

  const stations = await service.getAllStations();
  assert.equal(requestedUrl, '/api-proxy/api/v1/stations');
  assert.equal(stations.length, 2);
  assert.equal(stations[0].id, 44);
  assert.equal(typeof stations[0].id, 'number');
  assert.equal(stations[0].code, 'DEL_RC');
  assert.equal(stations[0].lat, 28.6328);
  assert.equal(stations[0].lng, 77.2197);
  assert.equal(stations[0].city, 'Delhi');
  assert.equal(stations[0].type, 'metro_station');
  assert.equal(stations[0].interchange, true);
  assert.deepEqual(service.getStationLoadReport(), {
    advertisedCount: 3,
    receivedCount: 4,
    loadedCount: 2,
    invalidCount: 1,
    duplicateCount: 1,
    uniqueIds: 2
  });
  assert.deepEqual((await service.searchStations('rajiv', 1)).map(station => station.code), ['DEL_RC']);
  assert.deepEqual(await service.searchStations('missing', 5), []);
  let customRequest = '';
  const configured = await loadFreshService(async url => { customRequest = String(url); return response({ success: true, count: 0, stations: [] }); });
  configured.configureApiBaseUrl('/custom-api');
  await configured.getAllStations();
  assert.equal(customRequest, '/custom-api/api/v1/stations');

  const httpError = await loadFreshService(async () => response({ success: false, message: 'offline' }, { ok: false, status: 503 }));
  await assert.rejects(httpError.getAllStations(), /offline/);

  const invalidJson = await loadFreshService(async () => response(null, { invalidJson: true }));
  await assert.rejects(invalidJson.getAllStations(), /invalid JSON/);

  const unsuccessful = await loadFreshService(async () => response({ success: false, message: 'not ready' }));
  await assert.rejects(unsuccessful.getAllStations(), /not ready/);

  const networkError = await loadFreshService(async () => { throw new Error('connection refused'); });
  await assert.rejects(networkError.getAllStations(), /connection refused/);

  console.log('Station API service tests passed: response validation, field mapping, numeric/unique IDs, coordinates, search, HTTP/JSON/network failures.');
})().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
