#!/usr/bin/env python3
"""
Raasta: Namo Bharat (RRTS) Dataset Importer
Imports verified NCRTC RRTS stations and connections into Raasta database.
"""

import sys
import os
import csv
import argparse
from datetime import datetime

def parse_args():
    parser = argparse.ArgumentParser(description="Import Namo Bharat (RRTS) dataset.")
    parser.add_argument("--data-dir", default="data/namo_bharat", help="Path to RRTS data directory")
    parser.add_argument("--sql-output", default="migrations/006_import_rrts_seed.sql", help="Path for generated SQL file")
    return parser.parse_args()

def main():
    args = parse_args()
    stations_file = os.path.join(args.data_dir, "rrts_stations.csv")
    conns_file = os.path.join(args.data_dir, "rrts_connections.csv")

    for f in [stations_file, conns_file]:
        if not os.path.exists(f):
            print(f"[ERROR] Required dataset file not found: {f}")
            sys.exit(1)

    print("═══════════════════════════════════════════════════")
    print("  Raasta Namo Bharat (RRTS) Ingestion Pipeline")
    print(f"  Source Directory: {args.data_dir}")
    print("═══════════════════════════════════════════════════")

    sql = [
        "-- Raasta: Namo Bharat (RRTS) Ingestion Seed",
        f"-- Generated at: {datetime.now().isoformat()}",
        "USE raasta_db;\n",
        # Operator and line
        """
INSERT INTO transport_lines (name, code, color, transport_type_id, operator_id, is_active)
SELECT 'Delhi–Ghaziabad–Meerut RRTS Corridor', 'NCRTC_DGM', '#0D47A1', tt.id, op.id, 1
FROM transport_types tt, operators op
WHERE tt.code = 'rrts' AND op.code = 'NCRTC'
ON DUPLICATE KEY UPDATE name='Delhi–Ghaziabad–Meerut RRTS Corridor';
"""
    ]

    stations_count = 0
    with open(stations_file, mode="r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for r in reader:
            code = r["code"]
            name = r["name"]
            lat = r["latitude"]
            lon = r["longitude"]
            is_ic = 1 if r["is_interchange"] == "1" else 0
            status = r["data_status"]
            alt = r.get("alternate_names", "")

            stmt = f"""
INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('{name}', '{code}', {lat}, {lon}, 'rrts_station', {is_ic}, 1, '{status}')
ON DUPLICATE KEY UPDATE latitude={lat}, longitude={lon}, is_interchange={is_ic}, data_status='{status}';"""
            sql.append(stmt)

            if alt:
                sql.append(f"""
INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, '{alt}', 'alternate' FROM stations WHERE code='{code}' LIMIT 1;""")
            stations_count += 1

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
SELECT fs.id, ts.id, tl.id, 4, {dist}, {time_m}, {bidi}, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = '{f_code}' AND ts.code = '{t_code}' AND tl.code = '{l_code}'
ON DUPLICATE KEY UPDATE distance_km={dist}, estimated_travel_time_min={time_m};"""
            sql.append(stmt)
            conns_count += 1

    os.makedirs(os.path.dirname(args.sql_output), exist_ok=True)
    with open(args.sql_output, "w", encoding="utf-8") as f:
        f.write("\n".join(sql))

    print(f"✓ Imported {stations_count} RRTS stations")
    print(f"✓ Imported {conns_count} RRTS corridor connections")
    print(f"✓ Saved SQL: {args.sql_output}")

if __name__ == "__main__":
    main()

