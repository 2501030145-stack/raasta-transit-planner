-- Raasta: Indian Railways Ingestion Seed
-- Generated at: 2026-11-13T17:24:22.791749
USE raasta_db;


INSERT INTO transport_lines (name, code, color, transport_type_id, operator_id, is_active)
SELECT 'Northern & North Central Railway Corridors', 'IR_NCR_NR', '#455A64', tt.id, op.id, 1
FROM transport_types tt, operators op
WHERE tt.code = 'railway' AND op.code = 'IR'
ON DUPLICATE KEY UPDATE name='Northern & North Central Railway Corridors';


INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('New Delhi', 'NDLS', 28.6435000, 77.2230000, 'railway_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6435000, longitude=77.2230000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'New Delhi Railway Station', 'alternate' FROM stations WHERE code='NDLS' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Old Delhi Junction', 'DLI', 28.6606000, 77.2290000, 'railway_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6606000, longitude=77.2290000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Delhi Junction', 'alternate' FROM stations WHERE code='DLI' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Hazrat Nizamuddin', 'NZM', 28.5888000, 77.2536000, 'railway_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5888000, longitude=77.2536000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Nizamuddin Station', 'alternate' FROM stations WHERE code='NZM' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Anand Vihar Terminal', 'ANVT', 28.6508000, 77.3152000, 'railway_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6508000, longitude=77.3152000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Anand Vihar Railway Station', 'alternate' FROM stations WHERE code='ANVT' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Delhi Sarai Rohilla', 'DEE', 28.6657000, 77.1866000, 'railway_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6657000, longitude=77.1866000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sarai Rohilla Station', 'alternate' FROM stations WHERE code='DEE' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Ghaziabad Junction', 'GZB', 28.6507000, 77.4320000, 'railway_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6507000, longitude=77.4320000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Ghaziabad Railway Station', 'alternate' FROM stations WHERE code='GZB' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Meerut City', 'MTC', 28.9760000, 77.6970000, 'railway_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.9760000, longitude=77.6970000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Meerut City Railway Station', 'alternate' FROM stations WHERE code='MTC' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Meerut Cantt', 'MUT', 29.0060000, 77.7120000, 'railway_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=29.0060000, longitude=77.7120000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Meerut Cantonment', 'alternate' FROM stations WHERE code='MUT' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Aligarh Junction', 'ALJN', 27.8920000, 78.0820000, 'railway_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=27.8920000, longitude=78.0820000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Aligarh Railway Station', 'alternate' FROM stations WHERE code='ALJN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Tundla Junction', 'TDL', 27.2080000, 78.2380000, 'railway_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=27.2080000, longitude=78.2380000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Tundla Station', 'alternate' FROM stations WHERE code='TDL' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Agra Cantt', 'AGC', 27.1580000, 77.9900000, 'railway_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=27.1580000, longitude=77.9900000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Agra Cantonment', 'alternate' FROM stations WHERE code='AGC' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Agra Fort', 'AF', 27.1810000, 78.0210000, 'railway_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=27.1810000, longitude=78.0210000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Agra Fort Railway Station', 'alternate' FROM stations WHERE code='AF' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Mathura Junction', 'MTJ', 27.4870000, 77.6710000, 'railway_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=27.4870000, longitude=77.6710000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Mathura Railway Station', 'alternate' FROM stations WHERE code='MTJ' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Moradabad', 'MB', 28.8290000, 78.7730000, 'railway_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.8290000, longitude=78.7730000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Moradabad Junction', 'alternate' FROM stations WHERE code='MB' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Bareilly', 'BE', 28.3370000, 79.4180000, 'railway_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.3370000, longitude=79.4180000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Bareilly Junction', 'alternate' FROM stations WHERE code='BE' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Kanpur Central', 'CNB', 26.4540000, 80.3500000, 'railway_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.4540000, longitude=80.3500000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Kanpur Central Railway Station', 'alternate' FROM stations WHERE code='CNB' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Lucknow Charbagh', 'LKO', 26.8315000, 80.9220000, 'railway_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.8315000, longitude=80.9220000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Lucknow NR', 'alternate' FROM stations WHERE code='LKO' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Lucknow Junction', 'LJN', 26.8320000, 80.9210000, 'railway_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.8320000, longitude=80.9210000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Lucknow NER', 'alternate' FROM stations WHERE code='LJN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Ayodhya Dham', 'AY', 26.7990000, 82.2030000, 'railway_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.7990000, longitude=82.2030000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Ayodhya Railway Station', 'alternate' FROM stations WHERE code='AY' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Ayodhya Cantt', 'AYC', 26.7760000, 82.1390000, 'railway_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.7760000, longitude=82.1390000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Faizabad Junction', 'alternate' FROM stations WHERE code='AYC' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Prayagraj Junction', 'PRYJ', 25.4430000, 81.8330000, 'railway_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=25.4430000, longitude=81.8330000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Allahabad Junction', 'alternate' FROM stations WHERE code='PRYJ' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Varanasi Junction', 'BSB', 25.3260000, 82.9860000, 'railway_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=25.3260000, longitude=82.9860000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Varanasi Cantt', 'alternate' FROM stations WHERE code='BSB' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Gorakhpur Junction', 'GKP', 26.7580000, 83.3820000, 'railway_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.7580000, longitude=83.3820000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Gorakhpur Station', 'alternate' FROM stations WHERE code='GKP' LIMIT 1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 3, 25.0, 35.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NDLS' AND ts.code = 'GZB' AND tl.code = 'IR_NCR_NR'
ON DUPLICATE KEY UPDATE distance_km=25.0, estimated_travel_time_min=35.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 3, 20.0, 30.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DLI' AND ts.code = 'GZB' AND tl.code = 'IR_NCR_NR'
ON DUPLICATE KEY UPDATE distance_km=20.0, estimated_travel_time_min=30.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 3, 23.0, 32.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NZM' AND ts.code = 'GZB' AND tl.code = 'IR_NCR_NR'
ON DUPLICATE KEY UPDATE distance_km=23.0, estimated_travel_time_min=32.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 3, 13.0, 20.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'ANVT' AND ts.code = 'GZB' AND tl.code = 'IR_NCR_NR'
ON DUPLICATE KEY UPDATE distance_km=13.0, estimated_travel_time_min=20.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 3, 47.0, 45.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'GZB' AND ts.code = 'MTC' AND tl.code = 'IR_NCR_NR'
ON DUPLICATE KEY UPDATE distance_km=47.0, estimated_travel_time_min=45.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 3, 5.0, 7.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'MTC' AND ts.code = 'MUT' AND tl.code = 'IR_NCR_NR'
ON DUPLICATE KEY UPDATE distance_km=5.0, estimated_travel_time_min=7.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 3, 106.0, 85.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'GZB' AND ts.code = 'ALJN' AND tl.code = 'IR_NCR_NR'
ON DUPLICATE KEY UPDATE distance_km=106.0, estimated_travel_time_min=85.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 3, 78.0, 60.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'ALJN' AND ts.code = 'TDL' AND tl.code = 'IR_NCR_NR'
ON DUPLICATE KEY UPDATE distance_km=78.0, estimated_travel_time_min=60.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 3, 231.0, 160.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'TDL' AND ts.code = 'CNB' AND tl.code = 'IR_NCR_NR'
ON DUPLICATE KEY UPDATE distance_km=231.0, estimated_travel_time_min=160.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 3, 72.0, 70.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'CNB' AND ts.code = 'LKO' AND tl.code = 'IR_NCR_NR'
ON DUPLICATE KEY UPDATE distance_km=72.0, estimated_travel_time_min=70.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 3, 128.0, 110.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'LKO' AND ts.code = 'AYC' AND tl.code = 'IR_NCR_NR'
ON DUPLICATE KEY UPDATE distance_km=128.0, estimated_travel_time_min=110.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 3, 8.0, 12.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'AYC' AND ts.code = 'AY' AND tl.code = 'IR_NCR_NR'
ON DUPLICATE KEY UPDATE distance_km=8.0, estimated_travel_time_min=12.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 3, 194.0, 130.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'CNB' AND ts.code = 'PRYJ' AND tl.code = 'IR_NCR_NR'
ON DUPLICATE KEY UPDATE distance_km=194.0, estimated_travel_time_min=130.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 3, 124.0, 120.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'PRYJ' AND ts.code = 'BSB' AND tl.code = 'IR_NCR_NR'
ON DUPLICATE KEY UPDATE distance_km=124.0, estimated_travel_time_min=120.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 3, 141.0, 120.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'GZB' AND ts.code = 'MB' AND tl.code = 'IR_NCR_NR'
ON DUPLICATE KEY UPDATE distance_km=141.0, estimated_travel_time_min=120.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 3, 90.0, 75.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'MB' AND ts.code = 'BE' AND tl.code = 'IR_NCR_NR'
ON DUPLICATE KEY UPDATE distance_km=90.0, estimated_travel_time_min=75.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 3, 235.0, 210.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'BE' AND ts.code = 'LKO' AND tl.code = 'IR_NCR_NR'
ON DUPLICATE KEY UPDATE distance_km=235.0, estimated_travel_time_min=210.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 3, 141.0, 95.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NDLS' AND ts.code = 'MTJ' AND tl.code = 'IR_NCR_NR'
ON DUPLICATE KEY UPDATE distance_km=141.0, estimated_travel_time_min=95.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 3, 54.0, 40.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'MTJ' AND ts.code = 'AGC' AND tl.code = 'IR_NCR_NR'
ON DUPLICATE KEY UPDATE distance_km=54.0, estimated_travel_time_min=40.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 3, 4.0, 10.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'AGC' AND ts.code = 'AF' AND tl.code = 'IR_NCR_NR'
ON DUPLICATE KEY UPDATE distance_km=4.0, estimated_travel_time_min=10.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 3, 270.0, 240.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'LKO' AND ts.code = 'GKP' AND tl.code = 'IR_NCR_NR'
ON DUPLICATE KEY UPDATE distance_km=270.0, estimated_travel_time_min=240.0;