module.exports = function healthHandler(_req, res) {
  res.setHeader("Cache-Control", "no-store");
  return res.status(200).json({
    ok: true,
    service: "raasta-vercel-frontend"
  });
};
