const http = require('node:http');
const https = require('node:https');
const fs = require('node:fs');
const path = require('node:path');

const root = __dirname;
const port = Number(process.env.PORT || 3000);
const stationApiBaseUrl = process.env.RAASTA_API_BASE_URL || 'http://127.0.0.1:8088';
const types = { '.html': 'text/html; charset=utf-8', '.css': 'text/css; charset=utf-8', '.js': 'text/javascript; charset=utf-8', '.mjs': 'text/javascript; charset=utf-8', '.json': 'application/json; charset=utf-8', '.png': 'image/png', '.webp': 'image/webp', '.svg': 'image/svg+xml' };

function sendJson(response, status, payload) {
  response.writeHead(status, { 'Content-Type': 'application/json; charset=utf-8', 'Cache-Control': 'no-store' });
  response.end(JSON.stringify(payload));
}

function proxyBackend(request, response, endpoint, allowedMethod) {
  let target;
  try {
    target = new URL(endpoint, stationApiBaseUrl);
    if (!['http:', 'https:'].includes(target.protocol)) throw new Error('Unsupported API protocol');
  } catch {
    sendJson(response, 500, { success: false, error: 'RAASTA_API_BASE_URL must be an HTTP or HTTPS API origin.' });
    return;
  }
  const transport = target.protocol === 'https:' ? https : http;
  const headers = { Accept: 'application/json' };
  if (allowedMethod === 'POST') headers['Content-Type'] = request.headers['content-type'] || 'application/json';
  const upstream = transport.request(target, { method: allowedMethod, headers }, upstreamResponse => {
    response.writeHead(upstreamResponse.statusCode || 502, {
      'Content-Type': upstreamResponse.headers['content-type'] || 'application/json; charset=utf-8',
      'Cache-Control': 'no-store'
    });
    upstreamResponse.pipe(response);
  });
  upstream.setTimeout(15000, () => upstream.destroy(new Error('Backend request timed out.')));
  upstream.on('error', error => {
    if (response.headersSent) { response.destroy(); return; }
    const timedOut = error.message === 'Backend request timed out.';
    sendJson(response, timedOut ? 504 : 502, {
      success: false,
      error: timedOut ? 'Backend request timed out.' : 'Route backend unavailable. Start it or check RAASTA_API_BASE_URL.'
    });
  });
  if (allowedMethod === 'POST') request.pipe(upstream);
  else upstream.end();
}

const server = http.createServer((request, response) => {
  const urlPath = decodeURIComponent(new URL(request.url, 'http://localhost').pathname);
  if (urlPath === '/api-proxy/api/v1/stations') {
    if (request.method !== 'GET') { sendJson(response, 405, { success: false, error: 'Method not allowed.' }); return; }
    proxyBackend(request, response, '/api/v1/stations', 'GET');
    return;
  }
  if (urlPath === '/api-proxy/api/v1/routes/compare') {
    if (request.method !== 'POST') { sendJson(response, 405, { success: false, error: 'Method not allowed.' }); return; }
    proxyBackend(request, response, '/api/v1/routes/compare', 'POST');
    return;
  }
  if (urlPath === '/_app/health') {
    response.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8', 'Cache-Control': 'no-store' });
    response.end(JSON.stringify({ ok: true, service: 'raasta-demo' }));
    return;
  }
  const relative = urlPath === '/' ? 'index.html' : urlPath === '/manus-routes.json' ? 'public/manus-routes.json' : urlPath.replace(/^\/+/, '');
  const resolved = path.resolve(root, relative);
  if (!resolved.startsWith(root + path.sep) && resolved !== path.join(root, 'index.html')) {
    response.writeHead(403); response.end('Forbidden'); return;
  }
  fs.stat(resolved, (statError, stat) => {
    if (statError || !stat.isFile()) { response.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' }); response.end('Not found'); return; }
    const ext = path.extname(resolved).toLowerCase();
    const mutable = ['.html', '.js', '.mjs', '.css', '.json'].includes(ext);
    response.writeHead(200, { 'Content-Type': types[ext] || 'application/octet-stream', 'Cache-Control': mutable ? 'no-cache' : 'public, max-age=300' });
    fs.createReadStream(resolved).pipe(response);
  });
});

server.listen(port, '0.0.0.0', () => console.log(`Raasta demo listening on 0.0.0.0:${port}`));
