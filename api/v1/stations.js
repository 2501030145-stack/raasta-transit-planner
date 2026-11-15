const { proxyRequest } = require("../_lib/proxy");

module.exports = async function stationsHandler(req, res) {
  return proxyRequest(req, res, {
    path: "/api/v1/stations",
    method: "GET"
  });
};
