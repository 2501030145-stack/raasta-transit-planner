-- Raasta: Namo Bharat (RRTS) Ingestion Seed
-- Generated at: 2026-11-13T17:24:22.766544
USE raasta_db;


INSERT INTO transport_lines (name, code, color, transport_type_id, operator_id, is_active)
SELECT 'Delhi–Ghaziabad–Meerut RRTS Corridor', 'NCRTC_DGM', '#0D47A1', tt.id, op.id, 1
FROM transport_types tt, operators op
WHERE tt.code = 'rrts' AND op.code = 'NCRTC'
ON DUPLICATE KEY UPDATE name='Delhi–Ghaziabad–Meerut RRTS Corridor';


INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Sarai Kale Khan', 'RRTS_SKK', 28.5886000, 77.2562000, 'rrts_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5886000, longitude=77.2562000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Hazrat Nizamuddin RRTS', 'alternate' FROM stations WHERE code='RRTS_SKK' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('New Ashok Nagar', 'RRTS_NAN', 28.5947000, 77.3061000, 'rrts_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5947000, longitude=77.3061000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'New Ashok Nagar RRTS', 'alternate' FROM stations WHERE code='RRTS_NAN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Anand Vihar', 'RRTS_ANV', 28.6475000, 77.3155000, 'rrts_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6475000, longitude=77.3155000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Anand Vihar RRTS Hub', 'alternate' FROM stations WHERE code='RRTS_ANV' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Sahibabad', 'RRTS_SHB', 28.6728000, 77.3614000, 'rrts_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6728000, longitude=77.3614000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sahibabad RRTS Station', 'alternate' FROM stations WHERE code='RRTS_SHB' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Ghaziabad', 'RRTS_GZB', 28.6742000, 77.4336000, 'rrts_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6742000, longitude=77.4336000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Ghaziabad Central RRTS', 'alternate' FROM stations WHERE code='RRTS_GZB' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Guldhar', 'RRTS_GLD', 28.6947000, 77.4641000, 'rrts_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6947000, longitude=77.4641000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Guldhar RRTS', 'alternate' FROM stations WHERE code='RRTS_GLD' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Duhai', 'RRTS_DUH', 28.7364000, 77.4912000, 'rrts_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.7364000, longitude=77.4912000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Duhai RRTS Junction', 'alternate' FROM stations WHERE code='RRTS_DUH' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Muradnagar', 'RRTS_MDN', 28.7831000, 77.5083000, 'rrts_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.7831000, longitude=77.5083000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Murad Nagar RRTS', 'alternate' FROM stations WHERE code='RRTS_MDN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Modinagar South', 'RRTS_MNS', 28.8256000, 77.5517000, 'rrts_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.8256000, longitude=77.5517000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Modi Nagar South RRTS', 'alternate' FROM stations WHERE code='RRTS_MNS' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Modinagar North', 'RRTS_MNN', 28.8589000, 77.5852000, 'rrts_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.8589000, longitude=77.5852000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Modi Nagar North RRTS', 'alternate' FROM stations WHERE code='RRTS_MNN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Meerut South', 'RRTS_MRS', 28.9175000, 77.6386000, 'rrts_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.9175000, longitude=77.6386000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Bhudbaral Meerut South', 'alternate' FROM stations WHERE code='RRTS_MRS' LIMIT 1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 4, 5.2, 4.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'RRTS_SKK' AND ts.code = 'RRTS_NAN' AND tl.code = 'NCRTC_DGM'
ON DUPLICATE KEY UPDATE distance_km=5.2, estimated_travel_time_min=4.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 4, 6.1, 5.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'RRTS_NAN' AND ts.code = 'RRTS_ANV' AND tl.code = 'NCRTC_DGM'
ON DUPLICATE KEY UPDATE distance_km=6.1, estimated_travel_time_min=5.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 4, 5.4, 4.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'RRTS_ANV' AND ts.code = 'RRTS_SHB' AND tl.code = 'NCRTC_DGM'
ON DUPLICATE KEY UPDATE distance_km=5.4, estimated_travel_time_min=4.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 4, 7.1, 5.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'RRTS_SHB' AND ts.code = 'RRTS_GZB' AND tl.code = 'NCRTC_DGM'
ON DUPLICATE KEY UPDATE distance_km=7.1, estimated_travel_time_min=5.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 4, 3.9, 3.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'RRTS_GZB' AND ts.code = 'RRTS_GLD' AND tl.code = 'NCRTC_DGM'
ON DUPLICATE KEY UPDATE distance_km=3.9, estimated_travel_time_min=3.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 4, 4.6, 4.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'RRTS_GLD' AND ts.code = 'RRTS_DUH' AND tl.code = 'NCRTC_DGM'
ON DUPLICATE KEY UPDATE distance_km=4.6, estimated_travel_time_min=4.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 4, 6.2, 5.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'RRTS_DUH' AND ts.code = 'RRTS_MDN' AND tl.code = 'NCRTC_DGM'
ON DUPLICATE KEY UPDATE distance_km=6.2, estimated_travel_time_min=5.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 4, 6.8, 5.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'RRTS_MDN' AND ts.code = 'RRTS_MNS' AND tl.code = 'NCRTC_DGM'
ON DUPLICATE KEY UPDATE distance_km=6.8, estimated_travel_time_min=5.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 4, 4.1, 3.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'RRTS_MNS' AND ts.code = 'RRTS_MNN' AND tl.code = 'NCRTC_DGM'
ON DUPLICATE KEY UPDATE distance_km=4.1, estimated_travel_time_min=3.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 4, 8.3, 6.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'RRTS_MNN' AND ts.code = 'RRTS_MRS' AND tl.code = 'NCRTC_DGM'
ON DUPLICATE KEY UPDATE distance_km=8.3, estimated_travel_time_min=6.5;