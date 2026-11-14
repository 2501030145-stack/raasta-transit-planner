-- Raasta: Bus Network Ingestion Seed
-- Generated at: 2026-11-13T17:24:22.851359
USE raasta_db;


INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Sarai Kale Khan ISBT', 'DTC_SKK', 28.5880000, 77.2555000, 'bus_stop', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5880000, longitude=77.2555000, is_interchange=1, data_status='verified';

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Kashmere Gate ISBT', 'DTC_KG', 28.6690000, 77.2280000, 'bus_stop', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6690000, longitude=77.2280000, is_interchange=1, data_status='verified';

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Anand Vihar ISBT', 'DTC_ANVT', 28.6480000, 77.3165000, 'bus_stop', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6480000, longitude=77.3165000, is_interchange=1, data_status='verified';

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Shivaji Stadium Terminal', 'DTC_CP', 28.6295000, 77.2135000, 'bus_stop', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6295000, longitude=77.2135000, is_interchange=1, data_status='verified';

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('AIIMS Bus Stop', 'DTC_AIIMS', 28.5685000, 77.2105000, 'bus_stop', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5685000, longitude=77.2105000, is_interchange=1, data_status='verified';

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Dhaula Kuan Bus Stop', 'DTC_DHAULA', 28.5925000, 77.1610000, 'bus_stop', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5925000, longitude=77.1610000, is_interchange=1, data_status='verified';

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Nehru Place Terminal', 'DTC_NEHRU', 28.5490000, 77.2515000, 'bus_stop', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5490000, longitude=77.2515000, is_interchange=1, data_status='verified';

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Mehrauli Terminal', 'DTC_MEHRAULI', 28.5180000, 77.1850000, 'bus_stop', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5180000, longitude=77.1850000, is_interchange=0, data_status='verified';

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Lucknow Alambagh Bus Station', 'UPSRTC_ALB', 26.8150000, 80.9020000, 'bus_stop', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.8150000, longitude=80.9020000, is_interchange=1, data_status='verified';

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Kanpur Jhakarkati Bus Station', 'UPSRTC_JHK', 26.4510000, 80.3420000, 'bus_stop', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.4510000, longitude=80.3420000, is_interchange=1, data_status='verified';

INSERT INTO transport_lines (name, code, color, transport_type_id, operator_id, is_active)
SELECT 'Mehrauli to Old Delhi Railway Station', '502', '#388E3C', tt.id, op.id, 1
FROM transport_types tt, operators op
WHERE tt.code = 'bus' AND op.code = 'DTC'
ON DUPLICATE KEY UPDATE name='Mehrauli to Old Delhi Railway Station';

INSERT INTO transport_lines (name, code, color, transport_type_id, operator_id, is_active)
SELECT 'Shivaji Stadium to Vasant Kunj', '620', '#388E3C', tt.id, op.id, 1
FROM transport_types tt, operators op
WHERE tt.code = 'bus' AND op.code = 'DTC'
ON DUPLICATE KEY UPDATE name='Shivaji Stadium to Vasant Kunj';

INSERT INTO transport_lines (name, code, color, transport_type_id, operator_id, is_active)
SELECT 'Anand Vihar ISBT to Mehrauli', '534', '#388E3C', tt.id, op.id, 1
FROM transport_types tt, operators op
WHERE tt.code = 'bus' AND op.code = 'DTC'
ON DUPLICATE KEY UPDATE name='Anand Vihar ISBT to Mehrauli';

INSERT INTO transport_lines (name, code, color, transport_type_id, operator_id, is_active)
SELECT 'Nehru Place to Najafgarh', '764', '#388E3C', tt.id, op.id, 1
FROM transport_types tt, operators op
WHERE tt.code = 'bus' AND op.code = 'DIMTS'
ON DUPLICATE KEY UPDATE name='Nehru Place to Najafgarh';

INSERT INTO transport_lines (name, code, color, transport_type_id, operator_id, is_active)
SELECT 'Mudrika Sewa (Ring Road Ring)', 'TMS', '#388E3C', tt.id, op.id, 1
FROM transport_types tt, operators op
WHERE tt.code = 'bus' AND op.code = 'DTC'
ON DUPLICATE KEY UPDATE name='Mudrika Sewa (Ring Road Ring)';

INSERT INTO transport_lines (name, code, color, transport_type_id, operator_id, is_active)
SELECT 'Lucknow Alambagh to Kanpur Jhakarkati', 'UPSRTC_LKO_CNB', '#388E3C', tt.id, op.id, 1
FROM transport_types tt, operators op
WHERE tt.code = 'bus' AND op.code = 'UPSRTC'
ON DUPLICATE KEY UPDATE name='Lucknow Alambagh to Kanpur Jhakarkati';