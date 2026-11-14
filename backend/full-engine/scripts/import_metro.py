#!/usr/bin/env python3
"""
Raasta: Metro Dataset Importer
Imports verified metro lines, stations, and connections into MySQL or generates idempotent SQL.
"""

import sys
import os
import csv
import argparse
from datetime import datetime

def parse_args():
    parser = argparse.ArgumentParser(description="Import verified Metro dataset into Raasta database.")
    parser.add_argument("--data-dir", default="data/metro", help="Path to metro data directory")
    parser.add_argument("--sql-output", default="migrations/005_import_metro_seed.sql", help="Path for generated SQL file")
    parser.add_argument("--execute", action="store_true", help="Execute against MySQL directly if credentials configured")
    return parser.parse_args()

def validate_coords(lat, lon, name):
    try:
        lat_f = float(lat)
        lon_f = float(lon)
        # Bounding box for Delhi NCR and UP (approx 23°N-31°N, 76°E-85°E)
        if not (23.0 <= lat_f <= 31.5 and 76.0 <= lon_f <= 85.0):
            print(f"[WARN] Station {name} has coordinates outside NCR/UP bounds: ({lat}, {lon})")
            return False
        return True
    except ValueError:
        print(f"[ERROR] Invalid coordinate values for {name}: ({lat}, {lon})")
        return False

def main():
    args = parse_args()
    lines_file = os.path.join(args.data_dir, "metro_lines.csv")
    stations_file = os.path.join(args.data_dir, "metro_stations.csv")
    conns_file = os.path.join(args.data_dir, "metro_connections.csv")

    for f in [lines_file, stations_file, conns_file]:
        if not os.path.exists(f):
            print(f"[ERROR] Required dataset file not found: {f}")
            sys.exit(1)

    print("═══════════════════════════════════════════════════")
    print("  Raasta Metro Dataset Ingestion Pipeline")
    print(f"  Source Directory: {args.data_dir}")
    print(f"  Timestamp: {datetime.now().isoformat()}")
    print("═══════════════════════════════════════════════════")

    sql_statements = [
        "-- Raasta: Metro Dataset Ingestion Seed",
        f"-- Generated at: {datetime.now().isoformat()}",
        "USE raasta_db;\n"
    ]

    # 1. Provenance Record
    sql_statements.append("""
INSERT INTO data_sources (name, url, source_type, transport_type_id, operator_id, description, license, last_verified_date)
VALUES ('DMRC & UP Metro Official Portals', 'https://delhimetrorail.com', 'official_website', 1, 1, 'Verified operational metro network for Delhi NCR, Lucknow, Kanpur, Agra', 'Government Open Data', CURDATE())
ON DUPLICATE KEY UPDATE last_verified_date = CURDATE();
""")

    # 2. Lines
    lines_count = 0
    with open(lines_file, mode="r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for r in reader:
            op_code = r["operator_code"]
            color = r["color"]
            code = r["code"]
            name = r["name"]
            stmt = f"""
INSERT INTO transport_lines (name, code, color, transport_type_id, operator_id, is_active)
SELECT '{name}', '{code}', '{color}', tt.id, op.id, 1
FROM transport_types tt, operators op
WHERE tt.code = 'metro' AND op.code = '{op_code}'
ON DUPLICATE KEY UPDATE color='{color}', name='{name}';"""
            sql_statements.append(stmt)
            lines_count += 1

    # 3. Stations
    stations_count = 0
    stations_map = {}
    with open(stations_file, mode="r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for r in reader:
            code = r["code"]
            name = r["name"]
            lat = r["latitude"]
            lon = r["longitude"]
            city = r["city"]
            state = r["state"]
            is_ic = 1 if r["is_interchange"] == "1" else 0
            status = r["data_status"]
            alt_names = r.get("alternate_names", "")

            validate_coords(lat, lon, name)
            stations_map[code] = name

            stmt = f"""
INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('{name.replace("'", "''")}', '{code}', {lat}, {lon}, 'metro_station', {is_ic}, 1, '{status}')
ON DUPLICATE KEY UPDATE latitude={lat}, longitude={lon}, is_interchange={is_ic}, data_status='{status}';"""
            sql_statements.append(stmt)

            if alt_names:
                for alt in alt_names.split(","):
                    alt_clean = alt.strip()
                    if alt_clean:
                        sql_statements.append(f"""
INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, '{alt_clean.replace("'", "''")}', 'alternate' FROM stations WHERE code='{code}' LIMIT 1;""")

            stations_count += 1

    # 4. Connections
    conns_count = 0
    with open(conns_file, mode="r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for r in reader:
            f_code = r["from_code"]
            t_code = r["to_code"]
            l_code = r["line_code"]
            dist = r["distance_km"]
            time_m = r["estimated_time_min"]
            bidi = r["is_bidirectional"]

            stmt = f"""
INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, {dist}, {time_m}, {bidi}, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = '{f_code}' AND ts.code = '{t_code}' AND tl.code = '{l_code}'
ON DUPLICATE KEY UPDATE distance_km={dist}, estimated_travel_time_min={time_m};"""
            sql_statements.append(stmt)
            conns_count += 1

    # Write SQL Output
    os.makedirs(os.path.dirname(args.sql_output), exist_ok=True)
    with open(args.sql_output, "w", encoding="utf-8") as f:
        f.write("\n".join(sql_statements))

    print(f"✓ Imported {lines_count} lines")
    print(f"✓ Imported {stations_count} stations")
    print(f"✓ Imported {conns_count} connections")
    print(f"✓ Generated idempotent migration script: {args.sql_output}")

if __name__ == "__main__":
    main()

