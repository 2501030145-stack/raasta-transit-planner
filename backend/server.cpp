#include <httplib.h>
#include <mysql/mysql.h>
#include <nlohmann/json.hpp>

#include <algorithm>
#include <cmath>
#include <cctype>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <limits>
#include <map>
#include <queue>
#include <set>
#include <stdexcept>
#include <string>
#include <utility>
#include <vector>

using json = nlohmann::json;
struct Station { std::string id, name, city, zone; double lat = 0, lng = 0; std::vector<std::string> modes, lines; };
struct Edge { std::string from, to, line; double distance = 0, minutes = 0, fare = 0; int stops = 1; };
struct Line { std::string id, name, mode, color; };
struct Network { std::vector<Station> stations; std::vector<Edge> edges; std::vector<Line> lines; };
struct Step { std::string previous; Edge edge; bool hasEdge = false; };
struct SearchEdge { std::string to; Edge edge; bool hasEdge = false; };

static std::string env(const char* key, const std::string& fallback = "") {
  const char* value = std::getenv(key); return value ? value : fallback;
}
static std::string mysqlEscape(MYSQL* db, const std::string& value) {
  std::string out(value.size() * 2 + 1, '\0');
  const auto len = mysql_real_escape_string(db, out.data(), value.c_str(), value.size()); out.resize(len); return out;
}
static std::string column(MYSQL_ROW row, unsigned long* lengths, unsigned index) {
  return row[index] ? std::string(row[index], lengths[index]) : std::string();
}
static std::vector<std::string> split(const std::string& value, char delimiter) {
  std::vector<std::string> result; std::string part;
  for (char c : value) { if (c == delimiter) { if (!part.empty()) result.push_back(part); part.clear(); } else part.push_back(c); }
  if (!part.empty()) result.push_back(part); return result;
}

static Network loadJson(const std::string& path) {
  std::ifstream in(path); if (!in) throw std::runtime_error("Cannot open RAASTA_DATA_FILE: " + path);
  json source; in >> source; Network n;
  for (const auto& item : source.at("stations")) {
    Station s; s.id=item.at("id"); s.name=item.at("name"); s.city=item.at("city"); s.zone=item.value("zone", ""); s.lat=item.at("lat"); s.lng=item.at("lng"); s.modes=item.at("modes").get<std::vector<std::string>>(); s.lines=item.at("lines").get<std::vector<std::string>>(); n.stations.push_back(s);
  }
  for (const auto& item : source.at("lines")) n.lines.push_back({item.at("id"),item.at("name"),item.at("mode"),item.at("color")});
  for (const auto& item : source.at("connections")) n.edges.push_back({item.at("from"),item.at("to"),item.at("line"),item.at("distanceKm"),item.at("minutes"),item.at("fareInr"),item.value("stops",1)});
  return n;
}

static Network loadMysql(MYSQL* db) {
  Network n;
  auto query = [&](const char* sql) {
    if (mysql_query(db, sql) != 0) throw std::runtime_error(mysql_error(db));
    MYSQL_RES* res=mysql_store_result(db); if (!res) throw std::runtime_error(mysql_error(db));
    const auto count=mysql_num_fields(res); MYSQL_ROW row;
    while ((row=mysql_fetch_row(res))) {
      unsigned long* lengths=mysql_fetch_lengths(res);
      if (std::string(sql).find("FROM stations") != std::string::npos) {
        Station s; s.id=column(row,lengths,0); s.name=column(row,lengths,1); s.city=column(row,lengths,2); s.zone=column(row,lengths,3); s.lat=std::stod(column(row,lengths,4)); s.lng=std::stod(column(row,lengths,5));
        if (count > 6) s.modes=split(column(row,lengths,6), ','); if (count > 7) s.lines=split(column(row,lengths,7), ','); n.stations.push_back(s);
      } else if (std::string(sql).find("FROM transport_lines") != std::string::npos) {
        n.lines.push_back({column(row,lengths,0),column(row,lengths,1),column(row,lengths,2),column(row,lengths,3)});
      } else if (std::string(sql).find("FROM connections") != std::string::npos) {
        n.edges.push_back({column(row,lengths,0),column(row,lengths,1),column(row,lengths,2),std::stod(column(row,lengths,3)),std::stod(column(row,lengths,4)),std::stod(column(row,lengths,5)),std::stoi(column(row,lengths,6))});
      }
    }
    mysql_free_result(res);
  };
  query("SELECT s.id,s.name,s.city,s.zone,s.latitude,s.longitude,GROUP_CONCAT(DISTINCT tt.name),GROUP_CONCAT(DISTINCT tl.id) FROM stations s LEFT JOIN station_lines sl ON sl.station_id=s.id LEFT JOIN transport_lines tl ON tl.id=sl.line_id LEFT JOIN transport_types tt ON tt.id=tl.transport_type_id GROUP BY s.id");
  query("SELECT tl.id,tl.name,tt.name,tl.color FROM transport_lines tl JOIN transport_types tt ON tt.id=tl.transport_type_id");
  query("SELECT from_station_id,to_station_id,line_id,distance_km,travel_minutes,fare_inr,stop_count FROM connections");
  return n;
}

static json stationJson(const Station& s) { return {{"id",s.id},{"name",s.name},{"city",s.city},{"zone",s.zone},{"lat",s.lat},{"lng",s.lng},{"modes",s.modes},{"lines",s.lines}}; }
static const Line* findLine(const Network& n, const std::string& id) { for (const auto& l:n.lines) if (l.id==id) return &l; return nullptr; }
static const Station* findStation(const Network& n, const std::string& id) { for (const auto& s:n.stations) if (s.id==id) return &s; return nullptr; }

static json route(const Network& n, const std::string& start, const std::string& goal, const std::string& criterion) {
  if (!findStation(n,start) || !findStation(n,goal)) throw std::invalid_argument("Unknown origin or destination station id");
  if (start == goal) return {{"stationIds",json::array({start})},{"edges",json::array()},{"distanceKm",0},{"minutes",0},{"fareInr",0},{"stops",0},{"hops",0},{"transfers",0}};
  std::map<std::string,std::vector<Edge>> graph; for (const auto& s:n.stations) graph[s.id];
  for (const auto& e:n.edges) { graph[e.from].push_back(e); Edge reverse=e; std::swap(reverse.from,reverse.to); graph[e.to].push_back(reverse); }
  std::map<std::string,Step> previous; std::set<std::string> visited;
  if (criterion == "stops") {
    std::map<std::string,std::vector<SearchEdge>> expanded;
    for (const auto& station:n.stations) expanded[station.id];
    std::size_t edgeSequence=0;
    for (const auto& [from,links]:graph) for (const auto& e:links) {
      const int segments=std::max(1,e.stops); std::string previousNode=from;
      for (int segment=1;segment<=segments;++segment) {
        const bool carriesEdge=segment==segments;
        const std::string next=carriesEdge?e.to:"__sample_stop_"+std::to_string(edgeSequence)+"_"+std::to_string(segment);
        expanded[next]; expanded[previousNode].push_back({next,carriesEdge?e:Edge{},carriesEdge}); previousNode=next;
      }
      ++edgeSequence;
    }
    std::queue<std::string> q; q.push(start); visited.insert(start);
    while (!q.empty() && !visited.count(goal)) { auto current=q.front(); q.pop(); for (const auto& e:expanded[current]) if (visited.insert(e.to).second) { previous[e.to]={current,e.edge,e.hasEdge}; q.push(e.to); } }
  } else {
    const std::string key = criterion=="distance" ? "distance" : criterion=="fare" ? "fare" : "time";
    std::map<std::string,double> costs; costs[start]=0;
    while (true) {
      std::string current; double best=std::numeric_limits<double>::infinity();
      for (const auto& [id,cost]:costs) if (!visited.count(id) && cost<best) { current=id; best=cost; }
      if (current.empty() || current==goal) break; visited.insert(current);
      for (const auto& e:graph[current]) {
        const double weight=key=="distance"?e.distance:key=="fare"?e.fare:e.minutes; const double next=best+weight;
        if (!visited.count(e.to) && (!costs.count(e.to) || next<costs[e.to])) { costs[e.to]=next; previous[e.to]={current,e,true}; }
      }
    }
  }
  if (!previous.count(goal)) throw std::runtime_error("No route in the configured network");
  std::vector<std::string> ids{goal}; std::vector<Edge> edges; std::string cursor=goal;
  while (cursor!=start) { auto it=previous.find(cursor); if (it==previous.end()) throw std::runtime_error("Could not reconstruct route"); if (it->second.hasEdge) edges.insert(edges.begin(),it->second.edge); cursor=it->second.previous; if (findStation(n,cursor)) ids.insert(ids.begin(),cursor); }
  double distance=0, minutes=0, fare=0; int stops=0, transfers=0; std::string lastLine;
  json edgeList=json::array();
  for (const auto& e:edges) { distance+=e.distance; minutes+=e.minutes; fare+=e.fare; stops+=std::max(1,e.stops); if (!lastLine.empty() && lastLine!=e.line) ++transfers; lastLine=e.line; edgeList.push_back({{"from",e.from},{"to",e.to},{"line",e.line},{"distanceKm",e.distance},{"minutes",e.minutes},{"fareInr",e.fare},{"stops",e.stops}}); }
  return {{"stationIds",ids},{"edges",edgeList},{"distanceKm",distance},{"minutes",minutes},{"fareInr",fare},{"stops",stops},{"hops",edges.size()},{"transfers",transfers},{"criterion",criterion}};
}


static int numericStationId(const Network& n, const std::string& id) {
  for (std::size_t i=0;i<n.stations.size();++i)
    if (n.stations[i].id==id) return static_cast<int>(i+1);
  return 0;
}

static const Station* stationByNumericId(const Network& n, int id) {
  if (id<1 || static_cast<std::size_t>(id)>n.stations.size()) return nullptr;
  return &n.stations[static_cast<std::size_t>(id-1)];
}

static json apiStation(const Station& s, int id) {
  std::string type=s.modes.empty()?"transit":s.modes.front();
  std::transform(type.begin(),type.end(),type.begin(),
    [](unsigned char ch){return static_cast<char>(std::tolower(ch));});
  std::replace(type.begin(),type.end(),' ','_');

  return {
    {"id",id},{"name",s.name},{"code","RA-"+std::to_string(id)},
    {"latitude",s.lat},{"longitude",s.lng},{"city_name",s.city},
    {"station_type",type+"_station"},
    {"is_interchange",s.lines.size()>1},
    {"is_active",true},{"data_status","sample"}
  };
}

static json apiRoute(const Network& n, const std::string& origin,
                     const std::string& destination,
                     const std::string& criterion) {
  try {
    const json result=route(n,origin,destination,criterion);
    json stations=json::array(), segments=json::array();

    for (const auto& id:result.at("stationIds")) {
      const int numeric=numericStationId(n,id.get<std::string>());
      const Station* station=stationByNumericId(n,numeric);
      if (station)
        stations.push_back({{"id",numeric},{"name",station->name}});
    }

    std::string lastLine;
    for (const auto& edge:result.at("edges")) {
      const std::string lineId=edge.at("line");
      const Line* line=findLine(n,lineId);
      const bool transfer=!lastLine.empty() && lastLine!=lineId;

      segments.push_back({
        {"from_station_id",numericStationId(n,edge.at("from").get<std::string>())},
        {"to_station_id",numericStationId(n,edge.at("to").get<std::string>())},
        {"line_name",line?line->name:lineId},
        {"transport_type_name",line?line->mode:"Transit"},
        {"estimated_time_min",edge.at("minutes")},
        {"distance_km",edge.at("distanceKm")},
        {"fare_amount",edge.at("fareInr")},
        {"is_transfer",transfer}
      });
      lastLine=lineId;
    }

    return {
      {"found",true},{"stations",stations},{"segments",segments},
      {"estimated_time_min",result.value("minutes",0.0)},
      {"total_distance_km",result.value("distanceKm",0.0)},
      {"total_fare",result.value("fareInr",0.0)},
      {"number_of_stops",result.value("stops",0)},
      {"number_of_transfers",result.value("transfers",0)},
      {"fare_status","sample_estimate"}
    };
  } catch (const std::exception&) {
    return {{"found",false}};
  }
}


int main() {
  try {
    Network network; MYSQL* db=nullptr;
    const bool demo=env("RAASTA_DEMO_DATA","false")=="true";
    if (demo) network=loadJson(env("RAASTA_DATA_FILE","../data/network.json"));
    else {
      const std::string host=env("MYSQL_HOST","127.0.0.1"), user=env("MYSQL_USER"), password=env("MYSQL_PASSWORD"), database=env("MYSQL_DATABASE","raasta");
      if (user.empty()) throw std::runtime_error("Set MYSQL_USER and MYSQL_PASSWORD, or explicitly set RAASTA_DEMO_DATA=true");
      db=mysql_init(nullptr); if (!db || !mysql_real_connect(db,host.c_str(),user.c_str(),password.c_str(),database.c_str(),static_cast<unsigned>(std::stoi(env("MYSQL_PORT","3306"))),nullptr,0)) throw std::runtime_error(db?mysql_error(db):"mysql_init failed");
      network=loadMysql(db);
    }
    httplib::Server server;
    server.Get("/api/health",[&](const httplib::Request&,httplib::Response& res){
      res.set_content(json({
        {"ok",true},{"dataSource",demo?"demo-file":"mysql"},
        {"stations",network.stations.size()},{"connections",network.edges.size()}
      }).dump(),"application/json");
    });

    server.Get("/api/v1/stations",[&](const httplib::Request&,httplib::Response& res){
      json items=json::array();
      for(std::size_t i=0;i<network.stations.size();++i)
        items.push_back(apiStation(network.stations[i],static_cast<int>(i+1)));
      res.set_content(json({
        {"success",true},{"count",items.size()},{"stations",items}
      }).dump(),"application/json");
    });

    server.Post("/api/v1/routes/compare",[&](const httplib::Request& req,httplib::Response& res){
      try {
        const auto input=json::parse(req.body);
        const int source=input.at("source_station_id").get<int>();
        const int destination=input.at("destination_station_id").get<int>();

        const Station* from=stationByNumericId(network,source);
        const Station* to=stationByNumericId(network,destination);

        if(!from || !to)
          throw std::invalid_argument("Unknown station ID.");
        if(source==destination)
          throw std::invalid_argument("Choose two different stations.");

        json comparisons={
          {"fastest",apiRoute(network,from->id,to->id,"time")},
          {"shortest",apiRoute(network,from->id,to->id,"distance")},
          {"cheapest",apiRoute(network,from->id,to->id,"fare")},
          {"min_stops",apiRoute(network,from->id,to->id,"stops")}
        };

        res.set_content(json({
          {"success",true},{"comparisons",comparisons},
          {"data_source",demo?"sample_network":"mysql"}
        }).dump(),"application/json");

      } catch(const std::exception& e) {
        res.status=400;
        res.set_content(json({
          {"success",false},{"error",e.what()}
        }).dump(),"application/json");
      }
    });

    server.set_error_handler([](const httplib::Request&,httplib::Response& res){ if(res.status==404) res.set_content(R"({"error":"Not found"})","application/json"); });
    const int port=std::stoi(env("PORT",env("API_PORT","8080"))); std::cout<<"Raasta API listening on 0.0.0.0:"<<port<<" ("<<(demo?"explicit demo data":"MySQL")<<")\n";
    if (db) mysql_close(db);
    if (!server.listen("0.0.0.0",port)) throw std::runtime_error("Could not bind API port");
  } catch(const std::exception& e) { std::cerr<<"Raasta API startup error: "<<e.what()<<"\n"; return 1; }
  return 0;
}
