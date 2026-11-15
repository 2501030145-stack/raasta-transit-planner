const { proxyRequest } = require("../../_lib/proxy");

module.exports = async function compareRoutesHandler(req, res) {
  return proxyRequest(req, res, {
    path: "/api/v1/routes/compare",
    method: "POST"
  });
};
