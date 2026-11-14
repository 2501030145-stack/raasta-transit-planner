#!/usr/bin/env python3
"""Generate the repeatable SQL sample seed from data/network.json."""
import json
from pathlib import Path

root = Path(__file__).resolve().parents[1]
data = json.loads((root / "data/network.json").read_text())
out = ["USE raasta;", "SET FOREIGN_KEY_CHECKS=0;", "DELETE FROM connections;", "DELETE FROM station_lines;", "DELETE FROM stations;", "DELETE FROM transport_lines;", "DELETE FROM transport_types;", "SET FOREIGN_KEY_CHECKS=1;", ""]

def q(value):
    return "'" + str(value).replace("\\", "\\\\").replace("'", "''") + "'"

for mode in data["modes"]:
    mode_id = "metro" if mode == "Metro" else "regional-rail"
    out.append(f"INSERT INTO transport_types (id,name) VALUES ({q(mode_id)},{q(mode)});")
out.append("")
for line in data["lines"]:
    mode_id = "metro" if line["mode"] == "Metro" else "regional-rail"
    out.append("INSERT INTO transport_lines (id,name,transport_type_id,color,operator_name) VALUES "
               f"({q(line['id'])},{q(line['name'])},{q(mode_id)},{q(line['color'])},{q(line['operator'])});")
out.append("")
for s in data["stations"]:
    out.append("INSERT INTO stations (id,name,city,zone,latitude,longitude) VALUES "
               f"({q(s['id'])},{q(s['name'])},{q(s['city'])},{q(s['zone'])},{s['lat']},{s['lng']});")
out.append("")
for s in data["stations"]:
    for line in s["lines"]:
        out.append(f"INSERT INTO station_lines (station_id,line_id) VALUES ({q(s['id'])},{q(line)});")
out.append("")
for e in data["connections"]:
    out.append("INSERT INTO connections (from_station_id,to_station_id,line_id,distance_km,travel_minutes,fare_inr,stop_count) VALUES "
               f"({q(e['from'])},{q(e['to'])},{q(e['line'])},{e['distanceKm']},{e['minutes']},{e['fareInr']},{int(e.get('stops',1))});")
out.append("")
(root / "sql/seed.sql").write_text("\n".join(out))
print(f"Wrote sql/seed.sql with {len(data['stations'])} stations, {len(data['lines'])} lines, and {len(data['connections'])} connections.")
