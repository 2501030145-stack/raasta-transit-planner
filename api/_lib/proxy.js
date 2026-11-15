const DEFAULT_BACKEND_URL = "https://raasta-backend-recr.onrender.com";
const REQUEST_TIMEOUT_MS = 75_000;
const MAX_ATTEMPTS = 3;

function wait(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function backendUrl(path, query = "") {
  const base = (process.env.RAASTA_API_BASE_URL || DEFAULT_BACKEND_URL).trim().replace(/\/+$/, "");
  const url = new URL(path, `${base}/`);
  if (query) url.search = query;
  return url;
}

function getRequestBody(req) {
  if (req.body === undefined || req.body === null) return undefined;
  if (typeof req.body === "string" || Buffer.isBuffer(req.body)) return req.body;
  return JSON.stringify(req.body);
}

async function proxyRequest(req, res, { path, method }) {
  if (req.method !== method) {
    res.setHeader("Allow", method);
    return res.status(405).json({ success: false, error: "Method not allowed." });
  }

  const incomingUrl = new URL(req.url || "/", "https://vercel.invalid");
  const target = backendUrl(path, incomingUrl.search);
  const body = method === "POST" ? getRequestBody(req) : undefined;
  let lastError = null;

  for (let attempt = 1; attempt <= MAX_ATTEMPTS; attempt += 1) {
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), REQUEST_TIMEOUT_MS);

    try {
      const upstream = await fetch(target, {
        method,
        headers: {
          Accept: "application/json",
          ...(method === "POST" ? { "Content-Type": "application/json" } : {})
        },
        body,
        signal: controller.signal,
        cache: "no-store"
      });

      const responseText = await upstream.text();
      const retryable = [502, 503, 504].includes(upstream.status);

      if (retryable && attempt < MAX_ATTEMPTS) {
        lastError = new Error(`Backend returned HTTP ${upstream.status}`);
        clearTimeout(timeout);
        await wait(attempt * 1500);
        continue;
      }

      res.status(upstream.status);
      res.setHeader(
        "Content-Type",
        upstream.headers.get("content-type") || "application/json; charset=utf-8"
      );
      res.setHeader("Cache-Control", "no-store");
      return res.send(responseText);
    } catch (error) {
      lastError = error;
      if (attempt < MAX_ATTEMPTS) {
        clearTimeout(timeout);
        await wait(attempt * 1500);
        continue;
      }
    } finally {
      clearTimeout(timeout);
    }
  }

  const timedOut = lastError?.name === "AbortError";
  return res.status(timedOut ? 504 : 502).json({
    success: false,
    error: timedOut
      ? "The Raasta backend did not wake up before the request timeout. Please retry once."
      : "The Raasta backend is temporarily unreachable. Please retry in a moment.",
    backend: "raasta-backend",
    attempts: MAX_ATTEMPTS
  });
}

module.exports = { proxyRequest };
