const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const path = require('node:path');

const app = fs.readFileSync(path.join(__dirname, '..', 'app.js'), 'utf8');
const context = vm.createContext({ console, document: { addEventListener() {} }, matchMedia: () => ({ matches: true }), setTimeout });
vm.runInContext(app, context, { filename: 'app.js' });
const evaluate = source => vm.runInContext(source, context);
const sample = JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'data', 'network.json'), 'utf8'));
evaluate(`state.network = ${JSON.stringify(sample)}`);

const results = evaluate(`({
  fastest: shortestPath('rajiv-chowk','meerut-south','time'),
  shortest: shortestPath('rajiv-chowk','meerut-south','distance'),
  cheapest: shortestPath('rajiv-chowk','meerut-south','fare'),
  fewest: shortestPath('rajiv-chowk','meerut-south','stops'),
  same: shortestPath('rajiv-chowk','rajiv-chowk','time'),
  all: allRoutes('rajiv-chowk','meerut-south')
})`);
for (const route of [results.fastest, results.shortest, results.cheapest, results.fewest]) {
  assert.ok(route, 'every criterion should return a route for connected sample endpoints');
  assert.equal(route.stationIds[0], 'rajiv-chowk');
  assert.equal(route.stationIds.at(-1), 'meerut-south');
  assert.equal(route.stationIds.length, route.edges.length + 1);
  assert.ok(route.distanceKm >= 0 && route.minutes >= 0 && route.fareInr >= 0);
  assert.equal(route.stops, route.edges.reduce((sum, edge) => sum + edge.stops, 0));
}
assert.equal(results.all.length, 4);
assert.deepEqual(Array.from(results.same.stationIds), ['rajiv-chowk']);
assert.equal(results.same.distanceKm, 0);
assert.equal(results.same.stops, 0);

evaluate(`state.network = ${JSON.stringify({
  lines: [{id:'x',name:'X',mode:'Metro',color:'#fff'}],
  stations: ['a','b','c','d'].map(id => ({id,name:id,city:'test',lat:0,lng:0,modes:['Metro'],lines:['x']})),
  connections: [
    {from:'a',to:'d',line:'x',distanceKm:10,minutes:10,fareInr:20,stops:3},
    {from:'a',to:'b',line:'x',distanceKm:2,minutes:8,fareInr:1,stops:1},
    {from:'b',to:'d',line:'x',distanceKm:2,minutes:8,fareInr:1,stops:1},
    {from:'a',to:'c',line:'x',distanceKm:3,minutes:1,fareInr:8,stops:1},
    {from:'c',to:'d',line:'x',distanceKm:3,minutes:1,fareInr:8,stops:1}
  ]
})}`);
const expected = evaluate(`({time:shortestPath('a','d','time').stationIds,distance:shortestPath('a','d','distance').stationIds,fare:shortestPath('a','d','fare').stationIds,stops:shortestPath('a','d','stops')})`);
assert.deepEqual(Array.from(expected.time), ['a','c','d']);
assert.deepEqual(Array.from(expected.distance), ['a','b','d']);
assert.deepEqual(Array.from(expected.fare), ['a','b','d']);
assert.deepEqual(Array.from(expected.stops.stationIds), ['a','b','d']);
assert.equal(expected.stops.stops, 2);
assert.equal(expected.stops.hops, 2);
console.log('Routing tests passed: Dijkstra distance/time/fare, expanded BFS for minimum sample stops, totals, endpoints and identical-station case.');
