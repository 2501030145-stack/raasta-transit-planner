-- Raasta: Metro Dataset Ingestion Seed
-- Generated at: 2026-11-13T17:44:17.214759
USE raasta_db;


INSERT INTO data_sources (name, url, source_type, transport_type_id, operator_id, description, license, last_verified_date)
VALUES ('DMRC & UP Metro Official Portals', 'https://delhimetrorail.com', 'official_website', 1, 1, 'Verified operational metro network for Delhi NCR, Lucknow, Kanpur, Agra', 'Government Open Data', CURDATE())
ON DUPLICATE KEY UPDATE last_verified_date = CURDATE();


INSERT INTO transport_lines (name, code, color, transport_type_id, operator_id, is_active)
SELECT 'Red Line', 'DMRC_RED', '#E53935', tt.id, op.id, 1
FROM transport_types tt, operators op
WHERE tt.code = 'metro' AND op.code = 'DMRC'
ON DUPLICATE KEY UPDATE color='#E53935', name='Red Line';

INSERT INTO transport_lines (name, code, color, transport_type_id, operator_id, is_active)
SELECT 'Yellow Line', 'DMRC_YELLOW', '#FDD835', tt.id, op.id, 1
FROM transport_types tt, operators op
WHERE tt.code = 'metro' AND op.code = 'DMRC'
ON DUPLICATE KEY UPDATE color='#FDD835', name='Yellow Line';

INSERT INTO transport_lines (name, code, color, transport_type_id, operator_id, is_active)
SELECT 'Blue Line (Main)', 'DMRC_BLUE_MAIN', '#1E88E5', tt.id, op.id, 1
FROM transport_types tt, operators op
WHERE tt.code = 'metro' AND op.code = 'DMRC'
ON DUPLICATE KEY UPDATE color='#1E88E5', name='Blue Line (Main)';

INSERT INTO transport_lines (name, code, color, transport_type_id, operator_id, is_active)
SELECT 'Blue Line (Branch)', 'DMRC_BLUE_BRANCH', '#1E88E5', tt.id, op.id, 1
FROM transport_types tt, operators op
WHERE tt.code = 'metro' AND op.code = 'DMRC'
ON DUPLICATE KEY UPDATE color='#1E88E5', name='Blue Line (Branch)';

INSERT INTO transport_lines (name, code, color, transport_type_id, operator_id, is_active)
SELECT 'Violet Line', 'DMRC_VIOLET', '#8E24AA', tt.id, op.id, 1
FROM transport_types tt, operators op
WHERE tt.code = 'metro' AND op.code = 'DMRC'
ON DUPLICATE KEY UPDATE color='#8E24AA', name='Violet Line';

INSERT INTO transport_lines (name, code, color, transport_type_id, operator_id, is_active)
SELECT 'Pink Line', 'DMRC_PINK', '#F06292', tt.id, op.id, 1
FROM transport_types tt, operators op
WHERE tt.code = 'metro' AND op.code = 'DMRC'
ON DUPLICATE KEY UPDATE color='#F06292', name='Pink Line';

INSERT INTO transport_lines (name, code, color, transport_type_id, operator_id, is_active)
SELECT 'Magenta Line', 'DMRC_MAGENTA', '#D81B60', tt.id, op.id, 1
FROM transport_types tt, operators op
WHERE tt.code = 'metro' AND op.code = 'DMRC'
ON DUPLICATE KEY UPDATE color='#D81B60', name='Magenta Line';

INSERT INTO transport_lines (name, code, color, transport_type_id, operator_id, is_active)
SELECT 'Green Line', 'DMRC_GREEN', '#43A047', tt.id, op.id, 1
FROM transport_types tt, operators op
WHERE tt.code = 'metro' AND op.code = 'DMRC'
ON DUPLICATE KEY UPDATE color='#43A047', name='Green Line';

INSERT INTO transport_lines (name, code, color, transport_type_id, operator_id, is_active)
SELECT 'Airport Express Line', 'DMRC_AIRPORT', '#FB8C00', tt.id, op.id, 1
FROM transport_types tt, operators op
WHERE tt.code = 'metro' AND op.code = 'DMRC'
ON DUPLICATE KEY UPDATE color='#FB8C00', name='Airport Express Line';

INSERT INTO transport_lines (name, code, color, transport_type_id, operator_id, is_active)
SELECT 'Grey Line', 'DMRC_GREY', '#757575', tt.id, op.id, 1
FROM transport_types tt, operators op
WHERE tt.code = 'metro' AND op.code = 'DMRC'
ON DUPLICATE KEY UPDATE color='#757575', name='Grey Line';

INSERT INTO transport_lines (name, code, color, transport_type_id, operator_id, is_active)
SELECT 'Rapid Metro Gurugram', 'RM_GURUGRAM', '#3949AB', tt.id, op.id, 1
FROM transport_types tt, operators op
WHERE tt.code = 'metro' AND op.code = 'GMCBL'
ON DUPLICATE KEY UPDATE color='#3949AB', name='Rapid Metro Gurugram';

INSERT INTO transport_lines (name, code, color, transport_type_id, operator_id, is_active)
SELECT 'Aqua Line', 'NMRC_AQUA', '#00ACC1', tt.id, op.id, 1
FROM transport_types tt, operators op
WHERE tt.code = 'metro' AND op.code = 'NMRC'
ON DUPLICATE KEY UPDATE color='#00ACC1', name='Aqua Line';

INSERT INTO transport_lines (name, code, color, transport_type_id, operator_id, is_active)
SELECT 'North-South Corridor (Red Line)', 'LMRC_RED', '#E53935', tt.id, op.id, 1
FROM transport_types tt, operators op
WHERE tt.code = 'metro' AND op.code = 'UPMRC'
ON DUPLICATE KEY UPDATE color='#E53935', name='North-South Corridor (Red Line)';

INSERT INTO transport_lines (name, code, color, transport_type_id, operator_id, is_active)
SELECT 'Orange Line (IITK to Motijheel)', 'KMRC_ORANGE', '#FB8C00', tt.id, op.id, 1
FROM transport_types tt, operators op
WHERE tt.code = 'metro' AND op.code = 'UPMRC'
ON DUPLICATE KEY UPDATE color='#FB8C00', name='Orange Line (IITK to Motijheel)';

INSERT INTO transport_lines (name, code, color, transport_type_id, operator_id, is_active)
SELECT 'Yellow Line (Priority Corridor)', 'AMRC_YELLOW', '#FDD835', tt.id, op.id, 1
FROM transport_types tt, operators op
WHERE tt.code = 'metro' AND op.code = 'UPMRC'
ON DUPLICATE KEY UPDATE color='#FDD835', name='Yellow Line (Priority Corridor)';

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Rithala', 'DEL_RTH', 28.7208000, 77.1072000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.7208000, longitude=77.1072000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Rohini Sector 5', 'alternate' FROM stations WHERE code='DEL_RTH' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Rohini West', 'DEL_RWE', 28.7148000, 77.1152000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.7148000, longitude=77.1152000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sector 6 Rohini', 'alternate' FROM stations WHERE code='DEL_RWE' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Rohini East', 'DEL_REA', 28.7131000, 77.1264000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.7131000, longitude=77.1264000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sector 8 Rohini', 'alternate' FROM stations WHERE code='DEL_REA' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Pitampura', 'DEL_PTP', 28.7032000, 77.1328000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.7032000, longitude=77.1328000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Madhuban Chowk', 'alternate' FROM stations WHERE code='DEL_PTP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Kohat Enclave', 'DEL_KTE', 28.6978000, 77.1408000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6978000, longitude=77.1408000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Kohat Enclave Pitampura', 'alternate' FROM stations WHERE code='DEL_KTE' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Netaji Subhash Place', 'DEL_NSP', 28.6954000, 77.1524000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6954000, longitude=77.1524000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'NSP Pitampura', 'alternate' FROM stations WHERE code='DEL_NSP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Keshav Puram', 'DEL_KVP', 28.6892000, 77.1616000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6892000, longitude=77.1616000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Keshavpuram', 'alternate' FROM stations WHERE code='DEL_KVP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Kanhaiya Nagar', 'DEL_KNN', 28.6828000, 77.1654000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6828000, longitude=77.1654000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Tri Nagar Kanhaiya Nagar', 'alternate' FROM stations WHERE code='DEL_KNN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Inderlok', 'DEL_IDL', 28.6734000, 77.1706000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6734000, longitude=77.1706000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Inder Lok Metro', 'alternate' FROM stations WHERE code='DEL_IDL' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Shastri Nagar', 'DEL_SHN', 28.6698000, 77.1812000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6698000, longitude=77.1812000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sarai Rohilla Shastri Nagar', 'alternate' FROM stations WHERE code='DEL_SHN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Pratap Nagar', 'DEL_PRN', 28.6668000, 77.1942000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6668000, longitude=77.1942000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Subzi Mandi Pratap Nagar', 'alternate' FROM stations WHERE code='DEL_PRN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Pul Bangash', 'DEL_PLB', 28.6662000, 77.2064000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6662000, longitude=77.2064000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Pulbangash', 'alternate' FROM stations WHERE code='DEL_PLB' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Tis Hazari', 'DEL_TZH', 28.6672000, 77.2166000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6672000, longitude=77.2166000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Tis Hazari Courts', 'alternate' FROM stations WHERE code='DEL_TZH' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Kashmere Gate', 'DEL_KG', 28.6675000, 77.2285000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6675000, longitude=77.2285000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'ISBT Kashmere Gate', 'alternate' FROM stations WHERE code='DEL_KG' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Shastri Park', 'DEL_SHP', 28.6684000, 77.2502000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6684000, longitude=77.2502000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Shastri Park Depot', 'alternate' FROM stations WHERE code='DEL_SHP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Seelampur', 'DEL_SLP', 28.6698000, 77.2652000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6698000, longitude=77.2652000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Seelampur Market', 'alternate' FROM stations WHERE code='DEL_SLP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Welcome', 'DEL_WLC', 28.6719000, 77.2776000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6719000, longitude=77.2776000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Welcome Seelampur', 'alternate' FROM stations WHERE code='DEL_WLC' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Shahdara', 'DEL_SHD', 28.6734000, 77.2894000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6734000, longitude=77.2894000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Shahdara Railway Station Metro', 'alternate' FROM stations WHERE code='DEL_SHD' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Mansarovar Park', 'DEL_MSP', 28.6756000, 77.3006000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6756000, longitude=77.3006000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Mansarover Park', 'alternate' FROM stations WHERE code='DEL_MSP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Jhilmil', 'DEL_JLM', 28.6772000, 77.3122000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6772000, longitude=77.3122000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Jhilmil Colony', 'alternate' FROM stations WHERE code='DEL_JLM' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Dilshad Garden', 'DEL_DSG', 28.6759000, 77.3214000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6759000, longitude=77.3214000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Dilshad Garden Border', 'alternate' FROM stations WHERE code='DEL_DSG' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Shaheed Nagar', 'GZB_SHN', 28.6751000, 77.3326000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6751000, longitude=77.3326000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Shaheed Nagar Ghaziabad', 'alternate' FROM stations WHERE code='GZB_SHN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Raj Bagh', 'GZB_RJB', 28.6754000, 77.3412000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6754000, longitude=77.3412000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Rajbagh Ghaziabad', 'alternate' FROM stations WHERE code='GZB_RJB' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Major Mohit Sharma Rajendra Nagar', 'GZB_MHM', 28.6766000, 77.3468000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6766000, longitude=77.3468000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Rajendra Nagar Sahibabad', 'alternate' FROM stations WHERE code='GZB_MHM' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Shyam Park', 'GZB_SYN', 28.6782000, 77.3612000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6782000, longitude=77.3612000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Shyam Park Sahibabad', 'alternate' FROM stations WHERE code='GZB_SYN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Mohan Nagar', 'GZB_MHN', 28.6798000, 77.3824000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6798000, longitude=77.3824000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Mohan Nagar Junction', 'alternate' FROM stations WHERE code='GZB_MHN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Arthala', 'GZB_ART', 28.6784000, 77.3986000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6784000, longitude=77.3986000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Arthala Mohan Nagar', 'alternate' FROM stations WHERE code='GZB_ART' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Hindon River', 'GZB_HNR', 28.6742000, 77.4142000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6742000, longitude=77.4142000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Hindon Ghaziabad', 'alternate' FROM stations WHERE code='GZB_HNR' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Shaheed Sthal (New Bus Adda)', 'GZB_SHS', 28.6708000, 77.4289000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6708000, longitude=77.4289000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Ghaziabad Bus Adda', 'alternate' FROM stations WHERE code='GZB_SHS' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Samaypur Badli', 'DEL_SMB', 28.7456000, 77.1354000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.7456000, longitude=77.1354000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Badli Terminal', 'alternate' FROM stations WHERE code='DEL_SMB' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Rohini Sector 18-19', 'DEL_R18', 28.7382000, 77.1428000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.7382000, longitude=77.1428000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Rohini 18', 'alternate' FROM stations WHERE code='DEL_R18' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Haiderpur Badli Mor', 'DEL_HBM', 28.7242000, 77.1554000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.7242000, longitude=77.1554000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Badli Mor', 'alternate' FROM stations WHERE code='DEL_HBM' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Jahangirpuri', 'DEL_JHP', 28.7186000, 77.1684000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.7186000, longitude=77.1684000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Jahangir Puri', 'alternate' FROM stations WHERE code='DEL_JHP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Adarsh Nagar', 'DEL_ADR', 28.7148000, 77.1742000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.7148000, longitude=77.1742000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Adarsh Nagar Railway Station', 'alternate' FROM stations WHERE code='DEL_ADR' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Azadpur', 'DEL_AZP', 28.7067000, 77.1812000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.7067000, longitude=77.1812000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Azadpur Mandi', 'alternate' FROM stations WHERE code='DEL_AZP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Model Town', 'DEL_MTW', 28.7012000, 77.1936000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.7012000, longitude=77.1936000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Model Town III', 'alternate' FROM stations WHERE code='DEL_MTW' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Guru Tegh Bahadur Nagar', 'DEL_GTB', 28.6978000, 77.2064000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6978000, longitude=77.2064000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'GTB Nagar Kingsway Camp', 'alternate' FROM stations WHERE code='DEL_GTB' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Vishwa Vidyalaya', 'DEL_VSP', 28.6946000, 77.2144000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6946000, longitude=77.2144000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Delhi University North Campus', 'alternate' FROM stations WHERE code='DEL_VSP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Vidhan Sabha', 'DEL_VDS', 28.6872000, 77.2208000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6872000, longitude=77.2208000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Delhi Assembly', 'alternate' FROM stations WHERE code='DEL_VDS' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Civil Lines', 'DEL_CVL', 28.6764000, 77.2248000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6764000, longitude=77.2248000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Civil Lines Delhi', 'alternate' FROM stations WHERE code='DEL_CVL' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Chandni Chowk', 'DEL_CC', 28.6578000, 77.2301000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6578000, longitude=77.2301000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Old Delhi Railway Station', 'alternate' FROM stations WHERE code='DEL_CC' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Chawri Bazar', 'DEL_CWB', 28.6496000, 77.2264000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6496000, longitude=77.2264000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Jama Masjid Chawri Bazar', 'alternate' FROM stations WHERE code='DEL_CWB' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('New Delhi Metro', 'DEL_NDLS', 28.6431000, 77.2223000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6431000, longitude=77.2223000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'NDLS Airport Express Interchange', 'alternate' FROM stations WHERE code='DEL_NDLS' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Rajiv Chowk', 'DEL_RC', 28.6328000, 77.2197000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6328000, longitude=77.2197000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Connaught Place', 'alternate' FROM stations WHERE code='DEL_RC' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Patel Chowk', 'DEL_PTC', 28.6234000, 77.2142000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6234000, longitude=77.2142000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Dak Bhawan Patel Chowk', 'alternate' FROM stations WHERE code='DEL_PTC' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Central Secretariat', 'DEL_CS', 28.6147000, 77.2120000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6147000, longitude=77.2120000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Kendriya Sachivalaya', 'alternate' FROM stations WHERE code='DEL_CS' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Udyog Bhawan', 'DEL_UBH', 28.6112000, 77.2124000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6112000, longitude=77.2124000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Nirman Bhawan', 'alternate' FROM stations WHERE code='DEL_UBH' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Lok Kalyan Marg', 'DEL_LKM', 28.5996000, 77.2118000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5996000, longitude=77.2118000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Race Course PM Residence', 'alternate' FROM stations WHERE code='DEL_LKM' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Jor Bagh', 'DEL_JRB', 28.5884000, 77.2122000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5884000, longitude=77.2122000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Safdarjung Tomb', 'alternate' FROM stations WHERE code='DEL_JRB' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Dilli Haat - INA', 'DEL_INA', 28.5744000, 77.2097000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5744000, longitude=77.2097000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'INA Colony', 'alternate' FROM stations WHERE code='DEL_INA' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('AIIMS', 'DEL_AIM', 28.5684000, 77.2078000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5684000, longitude=77.2078000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'All India Institute of Medical Sciences', 'alternate' FROM stations WHERE code='DEL_AIM' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Green Park', 'DEL_GNP', 28.5586000, 77.2064000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5586000, longitude=77.2064000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Green Park Market', 'alternate' FROM stations WHERE code='DEL_GNP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Hauz Khas', 'DEL_HK', 28.5432000, 77.2065000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5432000, longitude=77.2065000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'IIT Hauz Khas', 'alternate' FROM stations WHERE code='DEL_HK' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Malviya Nagar', 'DEL_MVN', 28.5284000, 77.2062000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5284000, longitude=77.2062000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Saket Malviya Nagar', 'alternate' FROM stations WHERE code='DEL_MVN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Saket', 'DEL_SKT', 28.5198000, 77.2036000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5198000, longitude=77.2036000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Saket District Centre', 'alternate' FROM stations WHERE code='DEL_SKT' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Qutab Minar', 'DEL_QTM', 28.5126000, 77.1856000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5126000, longitude=77.1856000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Mehrauli Qutub Minar', 'alternate' FROM stations WHERE code='DEL_QTM' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Chhattarpur', 'DEL_CHT', 28.5064000, 77.1742000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5064000, longitude=77.1742000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Chhatarpur Temple', 'alternate' FROM stations WHERE code='DEL_CHT' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Sultanpur', 'DEL_SLT', 28.4986000, 77.1614000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4986000, longitude=77.1614000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sultanpur MG Road', 'alternate' FROM stations WHERE code='DEL_SLT' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Ghitorni', 'DEL_GHT', 28.4934000, 77.1428000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4934000, longitude=77.1428000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Ghitorni Village', 'alternate' FROM stations WHERE code='DEL_GHT' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Arjan Garh', 'DEL_AJG', 28.4812000, 77.1264000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4812000, longitude=77.1264000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Aya Nagar Arjan Garh', 'alternate' FROM stations WHERE code='DEL_AJG' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Guru Dronacharya', 'GGN_GDC', 28.4818000, 77.1032000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4818000, longitude=77.1032000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Garden Estate Gurugram', 'alternate' FROM stations WHERE code='GGN_GDC' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Sikanderpur', 'GGN_SIK', 28.4816000, 77.0931000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4816000, longitude=77.0931000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sikanderpur Interchange', 'alternate' FROM stations WHERE code='GGN_SIK' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('MG Road', 'GGN_MGR', 28.4798000, 77.0804000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4798000, longitude=77.0804000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'MG Road Gurugram Malls', 'alternate' FROM stations WHERE code='GGN_MGR' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('IFFCO Chowk', 'GGN_IFC', 28.4722000, 77.0724000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4722000, longitude=77.0724000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'IFFCO Chowk Sector 29', 'alternate' FROM stations WHERE code='GGN_IFC' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Millennium City Centre Gurugram', 'GGN_MCC', 28.4593000, 77.0725000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4593000, longitude=77.0725000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'HUDA City Centre', 'alternate' FROM stations WHERE code='GGN_MCC' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Dwarka Sector 21', 'DEL_DW21', 28.5523000, 77.0583000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5523000, longitude=77.0583000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Dwarka 21 Metro', 'alternate' FROM stations WHERE code='DEL_DW21' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Dwarka Sector 8', 'DEL_DW08', 28.5642000, 77.0674000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5642000, longitude=77.0674000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Dwarka 8', 'alternate' FROM stations WHERE code='DEL_DW08' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Dwarka Sector 9', 'DEL_DW09', 28.5746000, 77.0642000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5746000, longitude=77.0642000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Dwarka 9', 'alternate' FROM stations WHERE code='DEL_DW09' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Dwarka Sector 10', 'DEL_DW10', 28.5812000, 77.0578000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5812000, longitude=77.0578000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Dwarka 10', 'alternate' FROM stations WHERE code='DEL_DW10' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Dwarka Sector 11', 'DEL_DW11', 28.5886000, 77.0564000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5886000, longitude=77.0564000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Dwarka 11', 'alternate' FROM stations WHERE code='DEL_DW11' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Dwarka Sector 12', 'DEL_DW12', 28.5924000, 77.0412000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5924000, longitude=77.0412000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Dwarka 12', 'alternate' FROM stations WHERE code='DEL_DW12' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Dwarka Sector 13', 'DEL_DW13', 28.5998000, 77.0326000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5998000, longitude=77.0326000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Dwarka 13', 'alternate' FROM stations WHERE code='DEL_DW13' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Dwarka Sector 14', 'DEL_DW14', 28.6024000, 77.0256000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6024000, longitude=77.0256000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Dwarka 14', 'alternate' FROM stations WHERE code='DEL_DW14' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Dwarka', 'DEL_DWK', 28.6142000, 77.0204000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6142000, longitude=77.0204000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Dwarka Interchange Grey Line', 'alternate' FROM stations WHERE code='DEL_DWK' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Dwarka Mor', 'DEL_DWM', 28.6194000, 77.0328000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6194000, longitude=77.0328000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Dwarka Mor Bus Terminal', 'alternate' FROM stations WHERE code='DEL_DWM' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Nawada', 'DEL_NWD', 28.6212000, 77.0436000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6212000, longitude=77.0436000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Nawada Uttam Nagar', 'alternate' FROM stations WHERE code='DEL_NWD' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Uttam Nagar West', 'DEL_UNW', 28.6234000, 77.0562000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6234000, longitude=77.0562000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Uttam Nagar W', 'alternate' FROM stations WHERE code='DEL_UNW' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Uttam Nagar East', 'DEL_UNE', 28.6258000, 77.0664000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6258000, longitude=77.0664000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Uttam Nagar E', 'alternate' FROM stations WHERE code='DEL_UNE' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Janakpuri West', 'DEL_JPW', 28.6294000, 77.0777000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6294000, longitude=77.0777000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Janak Puri West', 'alternate' FROM stations WHERE code='DEL_JPW' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Janakpuri East', 'DEL_JPE', 28.6324000, 77.0876000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6324000, longitude=77.0876000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Janak Puri East', 'alternate' FROM stations WHERE code='DEL_JPE' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Tilak Nagar', 'DEL_TLK', 28.6366000, 77.0964000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6366000, longitude=77.0964000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Tilak Nagar Market', 'alternate' FROM stations WHERE code='DEL_TLK' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Subhash Nagar', 'DEL_SBN', 28.6402000, 77.1062000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6402000, longitude=77.1062000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Subhash Nagar Pacific Mall', 'alternate' FROM stations WHERE code='DEL_SBN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Tagore Garden', 'DEL_TAG', 28.6442000, 77.1148000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6442000, longitude=77.1148000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Tagore Garden', 'alternate' FROM stations WHERE code='DEL_TAG' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Rajouri Garden', 'DEL_RJG', 28.6492000, 77.1228000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6492000, longitude=77.1228000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Rajouri Garden Main', 'alternate' FROM stations WHERE code='DEL_RJG' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Ramesh Nagar', 'DEL_RMN', 28.6528000, 77.1304000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6528000, longitude=77.1304000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Ramesh Nagar', 'alternate' FROM stations WHERE code='DEL_RMN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Moti Nagar', 'DEL_MTN', 28.6578000, 77.1424000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6578000, longitude=77.1424000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Moti Nagar Crossing', 'alternate' FROM stations WHERE code='DEL_MTN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Kirti Nagar', 'DEL_KRT', 28.6558000, 77.1504000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6558000, longitude=77.1504000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Kirti Nagar Industrial', 'alternate' FROM stations WHERE code='DEL_KRT' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Shadipur', 'DEL_SHD2', 28.6522000, 77.1586000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6522000, longitude=77.1586000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Shadipur Depot', 'alternate' FROM stations WHERE code='DEL_SHD2' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Patel Nagar', 'DEL_PTN', 28.6482000, 77.1684000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6482000, longitude=77.1684000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'West Patel Nagar', 'alternate' FROM stations WHERE code='DEL_PTN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Rajendra Place', 'DEL_RJP', 28.6442000, 77.1782000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6442000, longitude=77.1782000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Rajendra Place Business Dist', 'alternate' FROM stations WHERE code='DEL_RJP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Karol Bagh', 'DEL_KBG', 28.6446000, 77.1902000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6446000, longitude=77.1902000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Karol Bagh Market', 'alternate' FROM stations WHERE code='DEL_KBG' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Jhandewalan', 'DEL_JHW', 28.6442000, 77.1998000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6442000, longitude=77.1998000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Jhandewalan Temple', 'alternate' FROM stations WHERE code='DEL_JHW' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('RK Ashram Marg', 'DEL_RKA', 28.6394000, 77.2092000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6394000, longitude=77.2092000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Ramakrishna Ashram Marg', 'alternate' FROM stations WHERE code='DEL_RKA' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Barakhamba Road', 'DEL_BKB', 28.6308000, 77.2274000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6308000, longitude=77.2274000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Barakhamba', 'alternate' FROM stations WHERE code='DEL_BKB' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Mandi House', 'DEL_MDH', 28.6258000, 77.2343000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6258000, longitude=77.2343000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Mandi House Circle', 'alternate' FROM stations WHERE code='DEL_MDH' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Supreme Court', 'DEL_SUP', 28.6214000, 77.2436000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6214000, longitude=77.2436000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Pragati Maidan', 'alternate' FROM stations WHERE code='DEL_SUP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Indraprastha', 'DEL_INP', 28.6202000, 77.2534000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6202000, longitude=77.2534000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'IP Estate', 'alternate' FROM stations WHERE code='DEL_INP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Yamuna Bank', 'DEL_YMB', 28.6234000, 77.2687000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6234000, longitude=77.2687000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Yamuna Bank Junction', 'alternate' FROM stations WHERE code='DEL_YMB' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Akshardham', 'DEL_AKD', 28.6186000, 77.2798000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6186000, longitude=77.2798000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Akshardham Temple', 'alternate' FROM stations WHERE code='DEL_AKD' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Mayur Vihar - I', 'DEL_MYV', 28.6053000, 77.2946000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6053000, longitude=77.2946000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Mayur Vihar Phase 1', 'alternate' FROM stations WHERE code='DEL_MYV' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Mayur Vihar Extension', 'DEL_MVE', 28.5942000, 77.3042000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5942000, longitude=77.3042000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Mayur Vihar Ext', 'alternate' FROM stations WHERE code='DEL_MVE' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('New Ashok Nagar', 'DEL_NAN', 28.5898000, 77.3114000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5898000, longitude=77.3114000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'New Ashok Nagar Border', 'alternate' FROM stations WHERE code='DEL_NAN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Noida Sector 15', 'NOI_S15', 28.5842000, 77.3146000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5842000, longitude=77.3146000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Noida 15', 'alternate' FROM stations WHERE code='NOI_S15' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Noida Sector 16', 'NOI_S16', 28.5786000, 77.3178000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5786000, longitude=77.3178000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Noida 16', 'alternate' FROM stations WHERE code='NOI_S16' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Noida Sector 18', 'NOI_S18', 28.5708000, 77.3242000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5708000, longitude=77.3242000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Atta Market Sector 18', 'alternate' FROM stations WHERE code='NOI_S18' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Botanical Garden', 'NOI_BOT', 28.5641000, 77.3342000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5641000, longitude=77.3342000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Botanical Garden Noida', 'alternate' FROM stations WHERE code='NOI_BOT' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Golf Course', 'NOI_GLF', 28.5672000, 77.3458000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5672000, longitude=77.3458000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Noida Golf Course', 'alternate' FROM stations WHERE code='NOI_GLF' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Noida City Centre', 'NOI_NCC', 28.5746000, 77.3562000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5746000, longitude=77.3562000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sector 32 Noida', 'alternate' FROM stations WHERE code='NOI_NCC' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Noida Sector 34', 'NOI_S34', 28.5824000, 77.3624000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5824000, longitude=77.3624000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sector 34 Noida', 'alternate' FROM stations WHERE code='NOI_S34' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Noida Sector 52', 'NOI_S52', 28.5916000, 77.3688000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5916000, longitude=77.3688000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sector 52 Blue Line', 'alternate' FROM stations WHERE code='NOI_S52' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Noida Sector 61', 'NOI_S61', 28.6012000, 77.3698000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6012000, longitude=77.3698000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sector 61 Noida', 'alternate' FROM stations WHERE code='NOI_S61' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Noida Sector 59', 'NOI_S59', 28.6114000, 77.3712000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6114000, longitude=77.3712000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sector 59 Noida', 'alternate' FROM stations WHERE code='NOI_S59' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Noida Sector 62', 'NOI_S62', 28.6212000, 77.3742000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6212000, longitude=77.3742000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sector 62 Noida', 'alternate' FROM stations WHERE code='NOI_S62' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Noida Electronic City', 'NOI_NEC', 28.6288000, 77.3768000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6288000, longitude=77.3768000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Electronic City Sector 62', 'alternate' FROM stations WHERE code='NOI_NEC' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Laxmi Nagar', 'DEL_LMN', 28.6308000, 77.2774000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6308000, longitude=77.2774000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Laxmi Nagar Vikas Marg', 'alternate' FROM stations WHERE code='DEL_LMN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Nirman Vihar', 'DEL_NMV', 28.6366000, 77.2858000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6366000, longitude=77.2858000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Nirman Vihar V3S Mall', 'alternate' FROM stations WHERE code='DEL_NMV' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Preet Vihar', 'DEL_PRV', 28.6412000, 77.2942000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6412000, longitude=77.2942000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Preet Vihar Commercial', 'alternate' FROM stations WHERE code='DEL_PRV' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Karkarduma', 'DEL_KKD', 28.6568000, 77.3032000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6568000, longitude=77.3032000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Karkardooma Court', 'alternate' FROM stations WHERE code='DEL_KKD' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Anand Vihar ISBT', 'DEL_ANVT', 28.6469000, 77.3160000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6469000, longitude=77.3160000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Anand Vihar Terminal', 'alternate' FROM stations WHERE code='DEL_ANVT' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Kaushambi', 'GZB_KSH', 28.6454000, 77.3242000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6454000, longitude=77.3242000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Kaushambi Ghaziabad', 'alternate' FROM stations WHERE code='GZB_KSH' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Vaishali', 'GZB_VSH', 28.6499000, 77.3396000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6499000, longitude=77.3396000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Vaishali Ghaziabad', 'alternate' FROM stations WHERE code='GZB_VSH' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Lal Quila', 'DEL_LAL', 28.6562000, 77.2374000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6562000, longitude=77.2374000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Red Fort', 'alternate' FROM stations WHERE code='DEL_LAL' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Jama Masjid', 'DEL_JAM', 28.6498000, 77.2372000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6498000, longitude=77.2372000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Jama Masjid Delhi', 'alternate' FROM stations WHERE code='DEL_JAM' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Delhi Gate', 'DEL_DLG', 28.6412000, 77.2404000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6412000, longitude=77.2404000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Delhi Gate Feroz Shah Kotla', 'alternate' FROM stations WHERE code='DEL_DLG' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('ITO', 'DEL_ITO', 28.6312000, 77.2412000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6312000, longitude=77.2412000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'ITO Crossing', 'alternate' FROM stations WHERE code='DEL_ITO' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Janpath', 'DEL_JNP', 28.6212000, 77.2184000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6212000, longitude=77.2184000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Janpath Market', 'alternate' FROM stations WHERE code='DEL_JNP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Khan Market', 'DEL_KMK', 28.6012000, 77.2274000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6012000, longitude=77.2274000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Khan Market Sujan Singh Park', 'alternate' FROM stations WHERE code='DEL_KMK' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Jawaharlal Nehru Stadium', 'DEL_JLN', 28.5912000, 77.2342000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5912000, longitude=77.2342000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'JLN Stadium Lodhi Road', 'alternate' FROM stations WHERE code='DEL_JLN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Jangpura', 'DEL_JPG', 28.5834000, 77.2384000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5834000, longitude=77.2384000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Jangpura Pant Nagar', 'alternate' FROM stations WHERE code='DEL_JPG' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Lajpat Nagar', 'DEL_LAK', 28.5708000, 77.2374000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5708000, longitude=77.2374000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Lajpat Nagar Central Market', 'alternate' FROM stations WHERE code='DEL_LAK' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Moolchand', 'DEL_MLC', 28.5654000, 77.2342000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5654000, longitude=77.2342000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Moolchand Hospital', 'alternate' FROM stations WHERE code='DEL_MLC' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Kailash Colony', 'DEL_KLC', 28.5552000, 77.2424000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5552000, longitude=77.2424000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Kailash Colony Market', 'alternate' FROM stations WHERE code='DEL_KLC' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Nehru Place', 'DEL_NHP', 28.5492000, 77.2514000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5492000, longitude=77.2514000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Nehru Place Commercial Centre', 'alternate' FROM stations WHERE code='DEL_NHP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Kalkaji Mandir', 'DEL_KAL', 28.5498000, 77.2582000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5498000, longitude=77.2582000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Kalkaji Temple', 'alternate' FROM stations WHERE code='DEL_KAL' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Govind Puri', 'DEL_GVP', 28.5386000, 77.2642000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5386000, longitude=77.2642000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Govindpuri Okhla', 'alternate' FROM stations WHERE code='DEL_GVP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Harkesh Nagar Okhla', 'DEL_HNO', 28.5312000, 77.2714000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5312000, longitude=77.2714000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Okhla Phase II', 'alternate' FROM stations WHERE code='DEL_HNO' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Jasola Apollo', 'DEL_JSA', 28.5242000, 77.2834000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5242000, longitude=77.2834000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Apollo Hospital Jasola', 'alternate' FROM stations WHERE code='DEL_JSA' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Sarita Vihar', 'DEL_SRV', 28.5178000, 77.2912000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5178000, longitude=77.2912000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sarita Vihar Crossing', 'alternate' FROM stations WHERE code='DEL_SRV' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Mohan Estate', 'DEL_MHE', 28.5086000, 77.3012000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5086000, longitude=77.3012000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Mohan Co-operative Industrial', 'alternate' FROM stations WHERE code='DEL_MHE' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Tughlakabad Station', 'DEL_TKS', 28.4984000, 77.3086000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4984000, longitude=77.3086000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Tughlaqabad', 'alternate' FROM stations WHERE code='DEL_TKS' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Badarpur Border', 'DEL_BDP', 28.4892000, 77.3074000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4892000, longitude=77.3074000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Delhi Haryana Border Badarpur', 'alternate' FROM stations WHERE code='DEL_BDP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Sarai', 'FBD_SAR', 28.4746000, 77.3082000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4746000, longitude=77.3082000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sarai Faridabad', 'alternate' FROM stations WHERE code='FBD_SAR' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('NHPC Chowk', 'FBD_NHP', 28.4612000, 77.3094000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4612000, longitude=77.3094000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'NHPC Faridabad', 'alternate' FROM stations WHERE code='FBD_NHP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Mewala Maharajpur', 'FBD_MWM', 28.4486000, 77.3102000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4486000, longitude=77.3102000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Mewla Maharajpur', 'alternate' FROM stations WHERE code='FBD_MWM' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Sector 28', 'FBD_S28', 28.4324000, 77.3114000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4324000, longitude=77.3114000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Faridabad Sector 28', 'alternate' FROM stations WHERE code='FBD_S28' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Badkal Mor', 'FBD_BDM', 28.4186000, 77.3128000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4186000, longitude=77.3128000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Badkhal Mor', 'alternate' FROM stations WHERE code='FBD_BDM' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Old Faridabad', 'FBD_OFB', 28.4042000, 77.3142000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4042000, longitude=77.3142000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Old Faridabad Railway Station', 'alternate' FROM stations WHERE code='FBD_OFB' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Neelam Chowk Ajronda', 'FBD_NCA', 28.3886000, 77.3154000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.3886000, longitude=77.3154000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Ajronda Faridabad', 'alternate' FROM stations WHERE code='FBD_NCA' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Bata Chowk', 'FBD_BTM', 28.3752000, 77.3168000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.3752000, longitude=77.3168000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Faridabad Bata', 'alternate' FROM stations WHERE code='FBD_BTM' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Escorts Mujesar', 'FBD_ESM', 28.3612000, 77.3172000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.3612000, longitude=77.3172000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Mujesar Escorts', 'alternate' FROM stations WHERE code='FBD_ESM' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Sant Surdas (Sihi)', 'FBD_STS', 28.3498000, 77.3174000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.3498000, longitude=77.3174000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sihi Faridabad', 'alternate' FROM stations WHERE code='FBD_STS' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Raja Nahar Singh (Ballabhgarh)', 'FBD_RNS', 28.3391000, 77.3175000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.3391000, longitude=77.3175000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Ballabgarh Metro', 'alternate' FROM stations WHERE code='FBD_RNS' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Majlis Park', 'DEL_MJP', 28.7183000, 77.1793000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.7183000, longitude=77.1793000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Majlis Park Ring Road', 'alternate' FROM stations WHERE code='DEL_MJP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Shalimar Bagh', 'DEL_SMB2', 28.6998000, 77.1684000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6998000, longitude=77.1684000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Shalimar Bagh Ring Road', 'alternate' FROM stations WHERE code='DEL_SMB2' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Shakurpur', 'DEL_SKP', 28.6912000, 77.1412000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6912000, longitude=77.1412000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Shakurpur Ring Road', 'alternate' FROM stations WHERE code='DEL_SKP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Punjabi Bagh West', 'DEL_PBW', 28.6734000, 77.1324000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6734000, longitude=77.1324000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Punjabi Bagh W', 'alternate' FROM stations WHERE code='DEL_PBW' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('ESI Hospital Basaidarapur', 'DEL_ESI', 28.6624000, 77.1284000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6624000, longitude=77.1284000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'ESI Hospital Ring Road', 'alternate' FROM stations WHERE code='DEL_ESI' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Maya Puri', 'DEL_MYP', 28.6386000, 77.1264000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6386000, longitude=77.1264000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Mayapuri Industrial Area', 'alternate' FROM stations WHERE code='DEL_MYP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Naraina Vihar', 'DEL_NRV', 28.6274000, 77.1384000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6274000, longitude=77.1384000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Naraina Ring Road', 'alternate' FROM stations WHERE code='DEL_NRV' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Delhi Cantonment', 'DEL_DLC', 28.6012000, 77.1486000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6012000, longitude=77.1486000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Delhi Cantt Metro', 'alternate' FROM stations WHERE code='DEL_DLC' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Durgabai Deshmukh South Campus', 'DEL_DHK', 28.5886000, 77.1624000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5886000, longitude=77.1624000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Dhaula Kuan South Campus', 'alternate' FROM stations WHERE code='DEL_DHK' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Sir M. Vishweshwaraiah Moti Bagh', 'DEL_MVB', 28.5794000, 77.1742000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5794000, longitude=77.1742000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Moti Bagh Ring Road', 'alternate' FROM stations WHERE code='DEL_MVB' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Bhikaji Cama Place', 'DEL_BKC', 28.5712000, 77.1864000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5712000, longitude=77.1864000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Bhikaji Cama', 'alternate' FROM stations WHERE code='DEL_BKC' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Sarojini Nagar', 'DEL_SRJ', 28.5724000, 77.1986000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5724000, longitude=77.1986000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sarojini Nagar Market', 'alternate' FROM stations WHERE code='DEL_SRJ' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('South Extension', 'DEL_SOE', 28.5714000, 77.2212000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5714000, longitude=77.2212000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'South Ext Part 1 & 2', 'alternate' FROM stations WHERE code='DEL_SOE' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Vinobapuri', 'DEL_VNB', 28.5684000, 77.2486000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5684000, longitude=77.2486000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Vinoba Puri', 'alternate' FROM stations WHERE code='DEL_VNB' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Ashram', 'DEL_ASH', 28.5712000, 77.2584000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5712000, longitude=77.2584000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Ashram Chowk', 'alternate' FROM stations WHERE code='DEL_ASH' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Sarai Kale Khan - Nizamuddin', 'DEL_SKK_M', 28.5886000, 77.2562000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5886000, longitude=77.2562000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Hazrat Nizamuddin Railway Metro', 'alternate' FROM stations WHERE code='DEL_SKK_M' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Mayur Vihar Pocket 1', 'DEL_MVP', 28.6112000, 77.2998000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6112000, longitude=77.2998000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'MV Pocket 1', 'alternate' FROM stations WHERE code='DEL_MVP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Trilokpuri Sanjay Lake', 'DEL_TLS', 28.6186000, 77.3042000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6186000, longitude=77.3042000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Trilokpuri', 'alternate' FROM stations WHERE code='DEL_TLS' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('East Vinod Nagar - Mayur Vihar-II', 'DEL_EVN', 28.6274000, 77.3086000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6274000, longitude=77.3086000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'East Vinod Nagar', 'alternate' FROM stations WHERE code='DEL_EVN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Mandawali - West Vinod Nagar', 'DEL_MWV', 28.6342000, 77.3064000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6342000, longitude=77.3064000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Mandawali', 'alternate' FROM stations WHERE code='DEL_MWV' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('IP Extension', 'DEL_IPE', 28.6412000, 77.3078000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6412000, longitude=77.3078000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'IP Ext Patparganj', 'alternate' FROM stations WHERE code='DEL_IPE' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Karkarduma Court', 'DEL_KKC', 28.6624000, 77.2986000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6624000, longitude=77.2986000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Karkardooma Court Complex', 'alternate' FROM stations WHERE code='DEL_KKC' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Krishna Nagar', 'DEL_KRN', 28.6664000, 77.2886000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6664000, longitude=77.2886000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Krishna Nagar Market', 'alternate' FROM stations WHERE code='DEL_KRN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('East Azad Nagar', 'DEL_EAN', 28.6688000, 77.2824000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6688000, longitude=77.2824000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Azad Nagar East', 'alternate' FROM stations WHERE code='DEL_EAN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Jaffrabad', 'DEL_JFR', 28.6784000, 77.2734000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6784000, longitude=77.2734000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Jafrabad', 'alternate' FROM stations WHERE code='DEL_JFR' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Maujpur - Babarpur', 'DEL_MJB', 28.6864000, 77.2712000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6864000, longitude=77.2712000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Maujpur Chowk', 'alternate' FROM stations WHERE code='DEL_MJB' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Gokulpuri', 'DEL_GKP_M', 28.6974000, 77.2742000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6974000, longitude=77.2742000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Gokul Puri', 'alternate' FROM stations WHERE code='DEL_GKP_M' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Johri Enclave', 'DEL_JHE', 28.7042000, 77.2814000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.7042000, longitude=77.2814000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Johri Enclave Border', 'alternate' FROM stations WHERE code='DEL_JHE' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Shiv Vihar', 'DEL_SHV', 28.7118000, 77.2913000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.7118000, longitude=77.2913000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Shiv Vihar Terminal', 'alternate' FROM stations WHERE code='DEL_SHV' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Dabri Mor - Janakpuri South', 'DEL_DBM', 28.6186000, 77.0864000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6186000, longitude=77.0864000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Dabri Mor', 'alternate' FROM stations WHERE code='DEL_DBM' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Dashrath Puri', 'DEL_DSP', 28.6084000, 77.0898000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6084000, longitude=77.0898000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Dashrathpuri', 'alternate' FROM stations WHERE code='DEL_DSP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Palam', 'DEL_PLM', 28.5912000, 77.0886000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5912000, longitude=77.0886000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Palam Village Palam Colony', 'alternate' FROM stations WHERE code='DEL_PLM' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Sadar Bazar Cantonment', 'DEL_SBC', 28.5814000, 77.1084000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5814000, longitude=77.1084000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Delhi Cantt Sadar Bazar', 'alternate' FROM stations WHERE code='DEL_SBC' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Terminal 1-IGI Airport', 'DEL_T1A', 28.5612000, 77.1214000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5612000, longitude=77.1214000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Domestic Airport Terminal 1', 'alternate' FROM stations WHERE code='DEL_T1A' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Shankar Vihar', 'DEL_SKV', 28.5542000, 77.1386000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5542000, longitude=77.1386000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Shankar Vihar Military Cantt', 'alternate' FROM stations WHERE code='DEL_SKV' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Vasant Vihar', 'DEL_VSV', 28.5584000, 77.1612000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5584000, longitude=77.1612000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Vasant Vihar Market', 'alternate' FROM stations WHERE code='DEL_VSV' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Munirka', 'DEL_MNR', 28.5582000, 77.1742000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5582000, longitude=77.1742000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Munirka Crossing', 'alternate' FROM stations WHERE code='DEL_MNR' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('RK Puram', 'DEL_RKP', 28.5512000, 77.1864000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5512000, longitude=77.1864000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Rama Krishna Puram', 'alternate' FROM stations WHERE code='DEL_RKP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('IIT Delhi', 'DEL_IIT', 28.5442000, 77.1942000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5442000, longitude=77.1942000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Indian Institute of Technology Delhi', 'alternate' FROM stations WHERE code='DEL_IIT' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Panchsheel Park', 'DEL_PSP', 28.5436000, 77.2184000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5436000, longitude=77.2184000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Panchsheel Enclave', 'alternate' FROM stations WHERE code='DEL_PSP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Chirag Delhi', 'DEL_CRD', 28.5442000, 77.2298000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5442000, longitude=77.2298000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Chirag Dilli BRT', 'alternate' FROM stations WHERE code='DEL_CRD' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Greater Kailash', 'DEL_GKL', 28.5448000, 77.2412000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5448000, longitude=77.2412000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'GK 2 Enclave', 'alternate' FROM stations WHERE code='DEL_GKL' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Nehru Enclave', 'DEL_NHE', 28.5472000, 77.2514000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5472000, longitude=77.2514000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Kalkaji Nehru Enclave', 'alternate' FROM stations WHERE code='DEL_NHE' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Okhla NSIC', 'DEL_OKN', 28.5542000, 77.2664000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5542000, longitude=77.2664000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'NSIC Okhla', 'alternate' FROM stations WHERE code='DEL_OKN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Sukhdev Vihar', 'DEL_SKV2', 28.5612000, 77.2742000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5612000, longitude=77.2742000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Masih Garh Sukhdev Vihar', 'alternate' FROM stations WHERE code='DEL_SKV2' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Jamia Millia Islamia', 'DEL_JMI', 28.5624000, 77.2842000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5624000, longitude=77.2842000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Jamia University', 'alternate' FROM stations WHERE code='DEL_JMI' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Okhla Vihar', 'DEL_OKV', 28.5598000, 77.2942000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5598000, longitude=77.2942000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Okhla Village', 'alternate' FROM stations WHERE code='DEL_OKV' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Jasola Vihar Shaheen Bagh', 'DEL_JSV', 28.5478000, 77.3012000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5478000, longitude=77.3012000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Shaheen Bagh Jasola', 'alternate' FROM stations WHERE code='DEL_JSV' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Kalindi Kunj', 'DEL_KLK', 28.5442000, 77.3114000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5442000, longitude=77.3114000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Kalindi Kunj Yamuna', 'alternate' FROM stations WHERE code='DEL_KLK' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Okhla Bird Sanctuary', 'NOI_OBS', 28.5486000, 77.3242000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5486000, longitude=77.3242000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Noida Entrance Bird Sanctuary', 'alternate' FROM stations WHERE code='NOI_OBS' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Satguru Ram Singh Marg', 'DEL_SRM', 28.6624000, 77.1562000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6624000, longitude=77.1562000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Ram Singh Marg', 'alternate' FROM stations WHERE code='DEL_SRM' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Ashok Park Main', 'DEL_APM', 28.6712000, 77.1584000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6712000, longitude=77.1584000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Ashok Park', 'alternate' FROM stations WHERE code='DEL_APM' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Punjabi Bagh', 'DEL_PJB', 28.6724000, 77.1428000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6724000, longitude=77.1428000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Punjabi Bagh East', 'alternate' FROM stations WHERE code='DEL_PJB' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Shivaji Park', 'DEL_SJP', 28.6742000, 77.1214000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6742000, longitude=77.1214000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Shivaji Park Rohtak Road', 'alternate' FROM stations WHERE code='DEL_SJP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Madipur', 'DEL_MDP', 28.6752000, 77.1114000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6752000, longitude=77.1114000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Madipur Village', 'alternate' FROM stations WHERE code='DEL_MDP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Paschim Vihar East', 'DEL_PVE', 28.6764000, 77.1012000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6764000, longitude=77.1012000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Paschim Vihar E', 'alternate' FROM stations WHERE code='DEL_PVE' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Paschim Vihar West', 'DEL_PVW', 28.6782000, 77.0898000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6782000, longitude=77.0898000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Paschim Vihar W Jwala Heri', 'alternate' FROM stations WHERE code='DEL_PVW' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Peeragarhi', 'DEL_PRG', 28.6798000, 77.0784000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6798000, longitude=77.0784000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Peera Garhi Chowk Outer Ring', 'alternate' FROM stations WHERE code='DEL_PRG' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Udyog Nagar', 'DEL_UDN', 28.6812000, 77.0684000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6812000, longitude=77.0684000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Udyog Nagar Rohtak Road', 'alternate' FROM stations WHERE code='DEL_UDN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Maharaja Surajmal Stadium', 'DEL_SJM', 28.6824000, 77.0586000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6824000, longitude=77.0586000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Surajmal Stadium', 'alternate' FROM stations WHERE code='DEL_SJM' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Nangloi', 'DEL_NGL', 28.6834000, 77.0484000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6834000, longitude=77.0484000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Nangloi Chowk', 'alternate' FROM stations WHERE code='DEL_NGL' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Nangloi Railway Station', 'DEL_NGR', 28.6842000, 77.0384000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6842000, longitude=77.0384000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Nangloi Rail', 'alternate' FROM stations WHERE code='DEL_NGR' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Rajdhani Park', 'DEL_RDP', 28.6852000, 77.0264000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6852000, longitude=77.0264000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Rajdhani Park Rohtak Rd', 'alternate' FROM stations WHERE code='DEL_RDP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Mundka', 'DEL_MND', 28.6864000, 77.0124000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6864000, longitude=77.0124000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Mundka Village', 'alternate' FROM stations WHERE code='DEL_MND' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Mundka Industrial Area', 'DEL_MIA', 28.6874000, 76.9984000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6874000, longitude=76.9984000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'MIA', 'alternate' FROM stations WHERE code='DEL_MIA' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Ghevra', 'DEL_GHV', 28.6886000, 76.9784000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6886000, longitude=76.9784000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Ghevra Railway Crossing', 'alternate' FROM stations WHERE code='DEL_GHV' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Tikri Kalan', 'DEL_TKK', 28.6898000, 76.9584000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6898000, longitude=76.9584000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Tikri Kalan Village', 'alternate' FROM stations WHERE code='DEL_TKK' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Tikri Border', 'DEL_TKB', 28.6912000, 76.9384000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6912000, longitude=76.9384000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Delhi Haryana Border Tikri', 'alternate' FROM stations WHERE code='DEL_TKB' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Pandit Shree Ram Sharma', 'DEL_PSR', 28.6924000, 76.9298000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6924000, longitude=76.9298000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Modern Industrial Estate MIE', 'alternate' FROM stations WHERE code='DEL_PSR' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Brigadier Hoshiar Singh', 'DEL_BHS', 28.6942000, 76.9208000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6942000, longitude=76.9208000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Bahadurgarh City Bus Stand', 'alternate' FROM stations WHERE code='DEL_BHS' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Shivaji Stadium', 'DEL_SVS', 28.6294000, 77.2132000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6294000, longitude=77.2132000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Connaught Place Shivaji Stadium', 'alternate' FROM stations WHERE code='DEL_SVS' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Dhaula Kuan Airport Metro', 'DEL_DHK_A', 28.5914000, 77.1612000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5914000, longitude=77.1612000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Dhaula Kuan Ring Road', 'alternate' FROM stations WHERE code='DEL_DHK_A' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Delhi Aerocity', 'DEL_AER', 28.5498000, 77.1214000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5498000, longitude=77.1214000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Aerocity Hospitality District', 'alternate' FROM stations WHERE code='DEL_AER' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('IGI Airport (Terminal 3)', 'DEL_T3', 28.5562000, 77.0863000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5562000, longitude=77.0863000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Indira Gandhi International Airport', 'alternate' FROM stations WHERE code='DEL_T3' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Yashobhoomi Dwarka Sector 25', 'DEL_YAS', 28.5471000, 77.0452000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5471000, longitude=77.0452000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'IICC Convention Centre', 'alternate' FROM stations WHERE code='DEL_YAS' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Nangli', 'DEL_NGLI', 28.6146000, 77.0014000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6146000, longitude=77.0014000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Nangli Dairy', 'alternate' FROM stations WHERE code='DEL_NGLI' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Najafgarh', 'DEL_NJG', 28.6124000, 76.9854000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6124000, longitude=76.9854000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Najafgarh Terminal', 'alternate' FROM stations WHERE code='DEL_NJG' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Dhansa Bus Stand', 'DEL_DBS', 28.6084000, 76.9742000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.6084000, longitude=76.9742000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Dhansa Stand Najafgarh', 'alternate' FROM stations WHERE code='DEL_DBS' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Sector 55-56', 'GGN_S55', 28.4239000, 77.1065000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4239000, longitude=77.1065000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sector 55-56 Rapid Metro', 'alternate' FROM stations WHERE code='GGN_S55' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Sector 54 Chowk', 'GGN_S54', 28.4384000, 77.1024000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4384000, longitude=77.1024000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sector 54 Chowk', 'alternate' FROM stations WHERE code='GGN_S54' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Sector 53-54', 'GGN_S53', 28.4498000, 77.0984000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4498000, longitude=77.0984000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sector 53-54 South Point Mall', 'alternate' FROM stations WHERE code='GGN_S53' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Sector 42-43', 'GGN_S42', 28.4612000, 77.0942000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4612000, longitude=77.0942000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sector 42-43 Golf Course Road', 'alternate' FROM stations WHERE code='GGN_S42' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Phase 1', 'GGN_PH1', 28.4724000, 77.0924000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4724000, longitude=77.0924000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'DLF Phase 1 Golf Course Rd', 'alternate' FROM stations WHERE code='GGN_PH1' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Phase 2', 'GGN_PH2', 28.4902000, 77.0908000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4902000, longitude=77.0908000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'DLF Phase 2', 'alternate' FROM stations WHERE code='GGN_PH2' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Belvedere Towers', 'GGN_BLV', 28.4942000, 77.0894000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4942000, longitude=77.0894000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Belvedere Tower Cyber City', 'alternate' FROM stations WHERE code='GGN_BLV' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Cyber City', 'GGN_CYB', 28.4952000, 77.0886000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4952000, longitude=77.0886000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'DLF Cyber City Hub', 'alternate' FROM stations WHERE code='GGN_CYB' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Moulsari Avenue', 'GGN_MLS', 28.5012000, 77.0924000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5012000, longitude=77.0924000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Moulsari Avenue Ambience Mall', 'alternate' FROM stations WHERE code='GGN_MLS' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Phase 3', 'GGN_PH3', 28.4934000, 77.0974000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4934000, longitude=77.0974000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'DLF Phase 3', 'alternate' FROM stations WHERE code='GGN_PH3' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Noida Sector 51', 'NOI_S51', 28.5925000, 77.3698000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5925000, longitude=77.3698000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sector 51 Aqua Line', 'alternate' FROM stations WHERE code='NOI_S51' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Noida Sector 50', 'NOI_S50', 28.5842000, 77.3712000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5842000, longitude=77.3712000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sector 50 Noida', 'alternate' FROM stations WHERE code='NOI_S50' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Noida Sector 76', 'NOI_S76', 28.5724000, 77.3764000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5724000, longitude=77.3764000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sector 76 Noida', 'alternate' FROM stations WHERE code='NOI_S76' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Noida Sector 101', 'NOI_S101', 28.5612000, 77.3812000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5612000, longitude=77.3812000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sector 101 Noida', 'alternate' FROM stations WHERE code='NOI_S101' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Noida Sector 81', 'NOI_S81', 28.5498000, 77.3894000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5498000, longitude=77.3894000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sector 81 Phase 2', 'alternate' FROM stations WHERE code='NOI_S81' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('NSEZ', 'NOI_NSEZ', 28.5386000, 77.4012000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5386000, longitude=77.4012000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Noida Special Economic Zone', 'alternate' FROM stations WHERE code='NOI_NSEZ' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Noida Sector 83', 'NOI_S83', 28.5274000, 77.4124000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5274000, longitude=77.4124000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sector 83 Noida', 'alternate' FROM stations WHERE code='NOI_S83' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Noida Sector 137', 'NOI_S137', 28.5142000, 77.4064000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.5142000, longitude=77.4064000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sector 137 Expressway', 'alternate' FROM stations WHERE code='NOI_S137' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Noida Sector 142', 'NOI_S142', 28.4998000, 77.4142000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4998000, longitude=77.4142000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sector 142 Expressway', 'alternate' FROM stations WHERE code='NOI_S142' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Noida Sector 143', 'NOI_S143', 28.4892000, 77.4264000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4892000, longitude=77.4264000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sector 143 Noida', 'alternate' FROM stations WHERE code='NOI_S143' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Noida Sector 144', 'NOI_S144', 28.4784000, 77.4386000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4784000, longitude=77.4386000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sector 144 Noida', 'alternate' FROM stations WHERE code='NOI_S144' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Noida Sector 145', 'NOI_S145', 28.4682000, 77.4498000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4682000, longitude=77.4498000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sector 145 Noida', 'alternate' FROM stations WHERE code='NOI_S145' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Noida Sector 146', 'NOI_S146', 28.4586000, 77.4612000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4586000, longitude=77.4612000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sector 146 Noida', 'alternate' FROM stations WHERE code='NOI_S146' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Noida Sector 147', 'NOI_S147', 28.4512000, 77.4724000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4512000, longitude=77.4724000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sector 147 Noida', 'alternate' FROM stations WHERE code='NOI_S147' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Noida Sector 148', 'NOI_S148', 28.4524000, 77.4886000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4524000, longitude=77.4886000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Sector 148 Noida', 'alternate' FROM stations WHERE code='NOI_S148' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Knowledge Park II', 'NOI_KP2', 28.4586000, 77.5024000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4586000, longitude=77.5024000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'KP 2 Greater Noida', 'alternate' FROM stations WHERE code='NOI_KP2' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Pari Chowk', 'NOI_PAR', 28.4678000, 77.5133000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4678000, longitude=77.5133000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Pari Chowk Greater Noida', 'alternate' FROM stations WHERE code='NOI_PAR' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Alpha 1', 'NOI_ALP', 28.4734000, 77.5198000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4734000, longitude=77.5198000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Alpha 1 Commercial Belt', 'alternate' FROM stations WHERE code='NOI_ALP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Delta 1', 'NOI_DLT', 28.4684000, 77.5286000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4684000, longitude=77.5286000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Delta 1 Greater Noida', 'alternate' FROM stations WHERE code='NOI_DLT' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('GNIDA Office', 'NOI_GND', 28.4512000, 77.5312000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4512000, longitude=77.5312000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Greater Noida Authority Office', 'alternate' FROM stations WHERE code='NOI_GND' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Depot Station', 'NOI_DEP', 28.4357000, 77.5256000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=28.4357000, longitude=77.5256000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Depot Greater Noida Terminus', 'alternate' FROM stations WHERE code='NOI_DEP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('CCS Airport Lucknow', 'LKO_AIR', 26.7645000, 80.8841000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.7645000, longitude=80.8841000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Chaudhary Charan Singh International Airport', 'alternate' FROM stations WHERE code='LKO_AIR' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Amausi', 'LKO_AMA', 26.7784000, 80.8898000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.7784000, longitude=80.8898000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Amausi Industrial', 'alternate' FROM stations WHERE code='LKO_AMA' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Transport Nagar', 'LKO_TPN', 26.7912000, 80.8964000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.7912000, longitude=80.8964000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Transport Nagar Lucknow', 'alternate' FROM stations WHERE code='LKO_TPN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Krishna Nagar', 'LKO_KRN', 26.8024000, 80.9012000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.8024000, longitude=80.9012000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Krishna Nagar Lucknow', 'alternate' FROM stations WHERE code='LKO_KRN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Singar Nagar', 'LKO_SNG', 26.8114000, 80.9064000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.8114000, longitude=80.9064000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Singar Nagar Alambagh', 'alternate' FROM stations WHERE code='LKO_SNG' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Alambagh', 'LKO_ALB', 26.8186000, 80.9102000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.8186000, longitude=80.9102000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Alambagh Bus Stand Metro', 'alternate' FROM stations WHERE code='LKO_ALB' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Alambagh Bus Station', 'LKO_ABS', 26.8224000, 80.9134000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.8224000, longitude=80.9134000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Alambagh ISBT', 'alternate' FROM stations WHERE code='LKO_ABS' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Mawaiya', 'LKO_MVG', 26.8286000, 80.9168000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.8286000, longitude=80.9168000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Mawaiya Crossing', 'alternate' FROM stations WHERE code='LKO_MVG' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Durgapuri', 'LKO_DGR', 26.8312000, 80.9184000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.8312000, longitude=80.9184000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Durgapuri Charbagh', 'alternate' FROM stations WHERE code='LKO_DGR' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Charbagh Railway Station Metro', 'LKO_CHR', 26.8322000, 80.9205000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.8322000, longitude=80.9205000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Lucknow Junction Railway Metro', 'alternate' FROM stations WHERE code='LKO_CHR' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Hussainganj', 'LKO_HSA', 26.8398000, 77.9284000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.8398000, longitude=77.9284000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Hussainganj Crossing', 'alternate' FROM stations WHERE code='LKO_HSA' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Sachivalaya', 'LKO_SCH', 26.8442000, 80.9362000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.8442000, longitude=80.9362000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'UP Civil Secretariat', 'alternate' FROM stations WHERE code='LKO_SCH' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Hazratganj', 'LKO_HZG', 26.8492000, 80.9428000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.8492000, longitude=80.9428000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Hazratganj Shopping', 'alternate' FROM stations WHERE code='LKO_HZG' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('KD Singh Babu Stadium', 'LKO_KDM', 26.8586000, 80.9412000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.8586000, longitude=80.9412000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'KD Singh Babu Stadium', 'alternate' FROM stations WHERE code='LKO_KDM' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Vishwavidyalaya Lucknow', 'LKO_UVV', 26.8674000, 80.9386000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.8674000, longitude=80.9386000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Lucknow University', 'alternate' FROM stations WHERE code='LKO_UVV' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('IT College', 'LKO_ITJ', 26.8742000, 80.9434000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.8742000, longitude=80.9434000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Isabella Thoburn College', 'alternate' FROM stations WHERE code='LKO_ITJ' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Badshahnagar', 'LKO_BDN', 26.8764000, 80.9586000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.8764000, longitude=80.9586000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Badshahnagar Railway Station Metro', 'alternate' FROM stations WHERE code='LKO_BDN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Lekhraj Market', 'LKO_LKN', 26.8784000, 80.9698000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.8784000, longitude=80.9698000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Lekhraj Market Indira Nagar', 'alternate' FROM stations WHERE code='LKO_LKN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Bhootnath Market', 'LKO_BTN', 26.8812000, 80.9784000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.8812000, longitude=80.9784000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Bhootnath Indira Nagar', 'alternate' FROM stations WHERE code='LKO_BTN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Indira Nagar', 'LKO_IDN', 26.8834000, 80.9862000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.8834000, longitude=80.9862000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Indira Nagar Lucknow', 'alternate' FROM stations WHERE code='LKO_IDN' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Munshi Pulia', 'LKO_MSP', 26.8856000, 80.9934000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.8856000, longitude=80.9934000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Munshi Pulia Terminal', 'alternate' FROM stations WHERE code='LKO_MSP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('IIT Kanpur', 'KNP_IIT', 26.5186000, 80.2335000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.5186000, longitude=80.2335000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'IIT Kanpur Campus Gate', 'alternate' FROM stations WHERE code='KNP_IIT' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Kalyanpur', 'KNP_KLY', 26.4952000, 80.2587000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.4952000, longitude=80.2587000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Kalyanpur Railway Crossing', 'alternate' FROM stations WHERE code='KNP_KLY' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('SPM Hospital', 'KNP_SPM', 26.4912000, 80.2684000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.4912000, longitude=80.2684000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'SPM Hospital Kalyanpur', 'alternate' FROM stations WHERE code='KNP_SPM' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('CSJM University', 'KNP_CSJ', 26.4864000, 80.2786000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.4864000, longitude=80.2786000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Kanpur University', 'alternate' FROM stations WHERE code='KNP_CSJ' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Gurudev Chauraha', 'KNP_GNR', 26.4812000, 80.2894000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.4812000, longitude=80.2894000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Gurudev Crossing', 'alternate' FROM stations WHERE code='KNP_GNR' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Geeta Nagar', 'KNP_GNP', 26.4786000, 80.2986000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.4786000, longitude=80.2986000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Geeta Nagar Kanpur', 'alternate' FROM stations WHERE code='KNP_GNP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Rawatpur', 'KNP_RWP', 26.4764000, 80.3064000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.4764000, longitude=80.3064000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Rawatpur Railway Station Metro', 'alternate' FROM stations WHERE code='KNP_RWP' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('LLR Hospital', 'KNP_LLR', 26.4752000, 80.3114000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.4752000, longitude=80.3114000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Hallet Hospital', 'alternate' FROM stations WHERE code='KNP_LLR' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Motijheel', 'KNP_MJL', 26.4764000, 80.3168000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=26.4764000, longitude=80.3168000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Moti Jheel Kanpur', 'alternate' FROM stations WHERE code='KNP_MJL' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Taj East Gate', 'AGR_TEG', 27.1624000, 78.0583000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=27.1624000, longitude=78.0583000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Taj East Gate Metro', 'alternate' FROM stations WHERE code='AGR_TEG' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Captain Shubham Gupta', 'AGR_CSG', 27.1664000, 78.0498000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=27.1664000, longitude=78.0498000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Fatehabad Road', 'alternate' FROM stations WHERE code='AGR_CSG' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Fatehabad Road', 'AGR_FBR', 27.1698000, 78.0436000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=27.1698000, longitude=78.0436000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Fatehabad Road Agra', 'alternate' FROM stations WHERE code='AGR_FBR' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Taj Mahal', 'AGR_TJM', 27.1725000, 78.0375000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=27.1725000, longitude=78.0375000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Taj Mahal Western Gate Metro', 'alternate' FROM stations WHERE code='AGR_TJM' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Agra Fort', 'AGR_AGF', 27.1784000, 78.0264000, 'metro_station', 1, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=27.1784000, longitude=78.0264000, is_interchange=1, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Agra Fort Railway Metro', 'alternate' FROM stations WHERE code='AGR_AGF' LIMIT 1;

INSERT INTO stations (name, code, latitude, longitude, station_type, is_interchange, is_active, data_status)
VALUES ('Mankameshwar Mandir', 'AGR_MKM', 27.1815000, 78.0162000, 'metro_station', 0, 1, 'verified')
ON DUPLICATE KEY UPDATE latitude=27.1815000, longitude=78.0162000, is_interchange=0, data_status='verified';

INSERT IGNORE INTO station_aliases (station_id, alias_name, alias_type)
SELECT id, 'Jama Masjid Agra', 'alternate' FROM stations WHERE code='AGR_MKM' LIMIT 1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_RTH' AND ts.code = 'DEL_RWE' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_RWE' AND ts.code = 'DEL_REA' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.3, 2.8, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_REA' AND ts.code = 'DEL_PTP' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.3, estimated_travel_time_min=2.8;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_PTP' AND ts.code = 'DEL_KTE' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_KTE' AND ts.code = 'DEL_NSP' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_NSP' AND ts.code = 'DEL_KVP' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.8, 2.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_KVP' AND ts.code = 'DEL_KNN' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=0.8, estimated_travel_time_min=2.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_KNN' AND ts.code = 'DEL_IDL' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_IDL' AND ts.code = 'DEL_SHN' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.3, 2.9, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_SHN' AND ts.code = 'DEL_PRN' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.3, estimated_travel_time_min=2.9;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.7, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_PRN' AND ts.code = 'DEL_PLB' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.7;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_PLB' AND ts.code = 'DEL_TZH' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_TZH' AND ts.code = 'DEL_KG' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 2.1, 4.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_KG' AND ts.code = 'DEL_SHP' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=2.1, estimated_travel_time_min=4.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.5, 3.2, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_SHP' AND ts.code = 'DEL_SLP' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.5, estimated_travel_time_min=3.2;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.7, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_SLP' AND ts.code = 'DEL_WLC' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.7;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_WLC' AND ts.code = 'DEL_SHD' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_SHD' AND ts.code = 'DEL_MSP' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_MSP' AND ts.code = 'DEL_JLM' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.9, 2.2, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_JLM' AND ts.code = 'DEL_DSG' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=0.9, estimated_travel_time_min=2.2;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_DSG' AND ts.code = 'GZB_SHN' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.8, 2.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'GZB_SHN' AND ts.code = 'GZB_RJB' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=0.8, estimated_travel_time_min=2.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.6, 1.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'GZB_RJB' AND ts.code = 'GZB_MHM' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=0.6, estimated_travel_time_min=1.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.4, 3.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'GZB_MHM' AND ts.code = 'GZB_SYN' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.4, estimated_travel_time_min=3.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 2.1, 4.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'GZB_SYN' AND ts.code = 'GZB_MHN' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=2.1, estimated_travel_time_min=4.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.6, 3.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'GZB_MHN' AND ts.code = 'GZB_ART' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.6, estimated_travel_time_min=3.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.6, 3.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'GZB_ART' AND ts.code = 'GZB_HNR' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.6, estimated_travel_time_min=3.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.5, 3.2, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'GZB_HNR' AND ts.code = 'GZB_SHS' AND tl.code = 'DMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.5, estimated_travel_time_min=3.2;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_SMB' AND ts.code = 'DEL_R18' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 2.0, 4.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_R18' AND ts.code = 'DEL_HBM' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=2.0, estimated_travel_time_min=4.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.4, 3.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_HBM' AND ts.code = 'DEL_JHP' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.4, estimated_travel_time_min=3.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.7, 1.8, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_JHP' AND ts.code = 'DEL_ADR' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=0.7, estimated_travel_time_min=1.8;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_ADR' AND ts.code = 'DEL_AZP' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.4, 3.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_AZP' AND ts.code = 'DEL_MTW' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.4, estimated_travel_time_min=3.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.3, 2.9, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_MTW' AND ts.code = 'DEL_GTB' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.3, estimated_travel_time_min=2.9;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.9, 2.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_GTB' AND ts.code = 'DEL_VSP' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=0.9, estimated_travel_time_min=2.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_VSP' AND ts.code = 'DEL_VDS' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.3, 2.8, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_VDS' AND ts.code = 'DEL_CVL' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.3, estimated_travel_time_min=2.8;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_CVL' AND ts.code = 'DEL_KG' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_KG' AND ts.code = 'DEL_CC' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_CC' AND ts.code = 'DEL_CWB' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.8, 2.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_CWB' AND ts.code = 'DEL_NDLS' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=0.8, estimated_travel_time_min=2.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_NDLS' AND ts.code = 'DEL_RC' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_RC' AND ts.code = 'DEL_PTC' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_PTC' AND ts.code = 'DEL_CS' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.4, 1.2, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_CS' AND ts.code = 'DEL_UBH' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=0.4, estimated_travel_time_min=1.2;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.3, 2.8, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_UBH' AND ts.code = 'DEL_LKM' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.3, estimated_travel_time_min=2.8;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.8, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_LKM' AND ts.code = 'DEL_JRB' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.8;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.6, 3.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_JRB' AND ts.code = 'DEL_INA' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.6, estimated_travel_time_min=3.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.7, 1.8, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_INA' AND ts.code = 'DEL_AIM' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=0.7, estimated_travel_time_min=1.8;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_AIM' AND ts.code = 'DEL_GNP' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.7, 3.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_GNP' AND ts.code = 'DEL_HK' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.7, estimated_travel_time_min=3.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.6, 3.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_HK' AND ts.code = 'DEL_MVN' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.6, estimated_travel_time_min=3.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_MVN' AND ts.code = 'DEL_SKT' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.9, 4.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_SKT' AND ts.code = 'DEL_QTM' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.9, estimated_travel_time_min=4.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.3, 2.9, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_QTM' AND ts.code = 'DEL_CHT' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.3, estimated_travel_time_min=2.9;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.5, 3.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_CHT' AND ts.code = 'DEL_SLT' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.5, estimated_travel_time_min=3.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.9, 4.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_SLT' AND ts.code = 'DEL_GHT' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.9, estimated_travel_time_min=4.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 2.1, 4.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_GHT' AND ts.code = 'DEL_AJG' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=2.1, estimated_travel_time_min=4.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 2.3, 4.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_AJG' AND ts.code = 'GGN_GDC' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=2.3, estimated_travel_time_min=4.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'GGN_GDC' AND ts.code = 'GGN_SIK' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.3, 2.8, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'GGN_SIK' AND ts.code = 'GGN_MGR' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.3, estimated_travel_time_min=2.8;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'GGN_MGR' AND ts.code = 'GGN_IFC' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.4, 3.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'GGN_IFC' AND ts.code = 'GGN_MCC' AND tl.code = 'DMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.4, estimated_travel_time_min=3.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.6, 3.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_DW21' AND ts.code = 'DEL_DW08' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.6, estimated_travel_time_min=3.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.7, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_DW08' AND ts.code = 'DEL_DW09' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.7;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.2, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_DW09' AND ts.code = 'DEL_DW10' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.2;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.8, 2.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_DW10' AND ts.code = 'DEL_DW11' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=0.8, estimated_travel_time_min=2.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.5, 3.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_DW11' AND ts.code = 'DEL_DW12' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.5, estimated_travel_time_min=3.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_DW12' AND ts.code = 'DEL_DW13' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.7, 1.8, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_DW13' AND ts.code = 'DEL_DW14' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=0.7, estimated_travel_time_min=1.8;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.4, 3.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_DW14' AND ts.code = 'DEL_DWK' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.4, estimated_travel_time_min=3.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.3, 2.9, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_DWK' AND ts.code = 'DEL_DWM' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.3, estimated_travel_time_min=2.9;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_DWM' AND ts.code = 'DEL_NWD' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.8, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_NWD' AND ts.code = 'DEL_UNW' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.8;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_UNW' AND ts.code = 'DEL_UNE' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_UNE' AND ts.code = 'DEL_JPW' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_JPW' AND ts.code = 'DEL_JPE' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_JPE' AND ts.code = 'DEL_TLK' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_TLK' AND ts.code = 'DEL_SBN' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.9, 2.2, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_SBN' AND ts.code = 'DEL_TAG' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=0.9, estimated_travel_time_min=2.2;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.2, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_TAG' AND ts.code = 'DEL_RJG' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.2;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.8, 2.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_RJG' AND ts.code = 'DEL_RMN' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=0.8, estimated_travel_time_min=2.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.3, 2.9, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_RMN' AND ts.code = 'DEL_MTN' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.3, estimated_travel_time_min=2.9;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.8, 2.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_MTN' AND ts.code = 'DEL_KRT' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=0.8, estimated_travel_time_min=2.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.9, 2.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_KRT' AND ts.code = 'DEL_SHD2' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=0.9, estimated_travel_time_min=2.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_SHD2' AND ts.code = 'DEL_PTN' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_PTN' AND ts.code = 'DEL_RJP' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_RJP' AND ts.code = 'DEL_KBG' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.9, 2.2, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_KBG' AND ts.code = 'DEL_JHW' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=0.9, estimated_travel_time_min=2.2;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_JHW' AND ts.code = 'DEL_RKA' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.3, 2.8, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_RKA' AND ts.code = 'DEL_RC' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.3, estimated_travel_time_min=2.8;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.8, 1.9, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_RC' AND ts.code = 'DEL_BKB' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=0.8, estimated_travel_time_min=1.9;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.9, 2.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_BKB' AND ts.code = 'DEL_MDH' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=0.9, estimated_travel_time_min=2.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_MDH' AND ts.code = 'DEL_SUP' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_SUP' AND ts.code = 'DEL_INP' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.5, 3.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_INP' AND ts.code = 'DEL_YMB' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.5, estimated_travel_time_min=3.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.7, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_YMB' AND ts.code = 'DEL_AKD' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.7;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 2.1, 4.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_AKD' AND ts.code = 'DEL_MYV' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=2.1, estimated_travel_time_min=4.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.6, 3.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_MYV' AND ts.code = 'DEL_MVE' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.6, estimated_travel_time_min=3.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.9, 2.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_MVE' AND ts.code = 'DEL_NAN' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=0.9, estimated_travel_time_min=2.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.7, 1.8, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_NAN' AND ts.code = 'NOI_S15' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=0.7, estimated_travel_time_min=1.8;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.7, 1.8, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_S15' AND ts.code = 'NOI_S16' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=0.7, estimated_travel_time_min=1.8;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_S16' AND ts.code = 'NOI_S18' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.7, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_S18' AND ts.code = 'NOI_BOT' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.7;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_BOT' AND ts.code = 'NOI_GLF' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.3, 2.9, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_GLF' AND ts.code = 'NOI_NCC' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.3, estimated_travel_time_min=2.9;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_NCC' AND ts.code = 'NOI_S34' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.7, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_S34' AND ts.code = 'NOI_S52' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.7;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_S52' AND ts.code = 'NOI_S61' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_S61' AND ts.code = 'NOI_S59' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_S59' AND ts.code = 'NOI_S62' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.9, 2.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_S62' AND ts.code = 'NOI_NEC' AND tl.code = 'DMRC_BLUE_MAIN'
ON DUPLICATE KEY UPDATE distance_km=0.9, estimated_travel_time_min=2.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_YMB' AND ts.code = 'DEL_LMN' AND tl.code = 'DMRC_BLUE_BRANCH'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_LMN' AND ts.code = 'DEL_NMV' AND tl.code = 'DMRC_BLUE_BRANCH'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_NMV' AND ts.code = 'DEL_PRV' AND tl.code = 'DMRC_BLUE_BRANCH'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.9, 4.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_PRV' AND ts.code = 'DEL_KKD' AND tl.code = 'DMRC_BLUE_BRANCH'
ON DUPLICATE KEY UPDATE distance_km=1.9, estimated_travel_time_min=4.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.7, 3.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_KKD' AND ts.code = 'DEL_ANVT' AND tl.code = 'DMRC_BLUE_BRANCH'
ON DUPLICATE KEY UPDATE distance_km=1.7, estimated_travel_time_min=3.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.8, 2.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_ANVT' AND ts.code = 'GZB_KSH' AND tl.code = 'DMRC_BLUE_BRANCH'
ON DUPLICATE KEY UPDATE distance_km=0.8, estimated_travel_time_min=2.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.6, 3.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'GZB_KSH' AND ts.code = 'GZB_VSH' AND tl.code = 'DMRC_BLUE_BRANCH'
ON DUPLICATE KEY UPDATE distance_km=1.6, estimated_travel_time_min=3.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.5, 3.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_KG' AND ts.code = 'DEL_LAL' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.5, estimated_travel_time_min=3.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.7, 1.8, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_LAL' AND ts.code = 'DEL_JAM' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=0.7, estimated_travel_time_min=1.8;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_JAM' AND ts.code = 'DEL_DLG' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_DLG' AND ts.code = 'DEL_ITO' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.9, 2.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_ITO' AND ts.code = 'DEL_MDH' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=0.9, estimated_travel_time_min=2.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.6, 3.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_MDH' AND ts.code = 'DEL_JNP' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.6, estimated_travel_time_min=3.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.2, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_JNP' AND ts.code = 'DEL_CS' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.2;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 2.1, 4.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_CS' AND ts.code = 'DEL_KMK' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=2.1, estimated_travel_time_min=4.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.3, 2.9, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_KMK' AND ts.code = 'DEL_JLN' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.3, estimated_travel_time_min=2.9;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.2, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_JLN' AND ts.code = 'DEL_JPG' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.2;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.4, 3.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_JPG' AND ts.code = 'DEL_LAK' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.4, estimated_travel_time_min=3.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.7, 1.7, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_LAK' AND ts.code = 'DEL_MLC' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=0.7, estimated_travel_time_min=1.7;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.4, 3.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_MLC' AND ts.code = 'DEL_KLC' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.4, estimated_travel_time_min=3.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_KLC' AND ts.code = 'DEL_NHP' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.7, 1.7, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_NHP' AND ts.code = 'DEL_KAL' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=0.7, estimated_travel_time_min=1.7;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.4, 3.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_KAL' AND ts.code = 'DEL_GVP' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.4, estimated_travel_time_min=3.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_GVP' AND ts.code = 'DEL_HNO' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.4, 3.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_HNO' AND ts.code = 'DEL_JSA' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.4, estimated_travel_time_min=3.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_JSA' AND ts.code = 'DEL_SRV' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.4, 3.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_SRV' AND ts.code = 'DEL_MHE' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.4, estimated_travel_time_min=3.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.4, 3.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_MHE' AND ts.code = 'DEL_TKS' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.4, estimated_travel_time_min=3.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_TKS' AND ts.code = 'DEL_BDP' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.6, 3.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_BDP' AND ts.code = 'FBD_SAR' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.6, estimated_travel_time_min=3.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.5, 3.2, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'FBD_SAR' AND ts.code = 'FBD_NHP' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.5, estimated_travel_time_min=3.2;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.4, 3.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'FBD_NHP' AND ts.code = 'FBD_MWM' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.4, estimated_travel_time_min=3.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.8, 3.8, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'FBD_MWM' AND ts.code = 'FBD_S28' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.8, estimated_travel_time_min=3.8;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.5, 3.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'FBD_S28' AND ts.code = 'FBD_BDM' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.5, estimated_travel_time_min=3.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.6, 3.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'FBD_BDM' AND ts.code = 'FBD_OFB' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.6, estimated_travel_time_min=3.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.7, 3.7, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'FBD_OFB' AND ts.code = 'FBD_NCA' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.7, estimated_travel_time_min=3.7;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.5, 3.2, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'FBD_NCA' AND ts.code = 'FBD_BTM' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.5, estimated_travel_time_min=3.2;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.6, 3.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'FBD_BTM' AND ts.code = 'FBD_ESM' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.6, estimated_travel_time_min=3.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.3, 2.8, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'FBD_ESM' AND ts.code = 'FBD_STS' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.3, estimated_travel_time_min=2.8;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.7, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'FBD_STS' AND ts.code = 'FBD_RNS' AND tl.code = 'DMRC_VIOLET'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.7;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.3, 2.9, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_MJP' AND ts.code = 'DEL_AZP' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=1.3, estimated_travel_time_min=2.9;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.5, 3.2, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_AZP' AND ts.code = 'DEL_SMB2' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=1.5, estimated_travel_time_min=3.2;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.6, 3.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_SMB2' AND ts.code = 'DEL_NSP' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=1.6, estimated_travel_time_min=3.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.7, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_NSP' AND ts.code = 'DEL_SKP' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.7;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 2.2, 4.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_SKP' AND ts.code = 'DEL_PBW' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=2.2, estimated_travel_time_min=4.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.3, 2.8, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_PBW' AND ts.code = 'DEL_ESI' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=1.3, estimated_travel_time_min=2.8;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.6, 3.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_ESI' AND ts.code = 'DEL_RJG' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=1.6, estimated_travel_time_min=3.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.7, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_RJG' AND ts.code = 'DEL_MYP' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.7;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.7, 3.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_MYP' AND ts.code = 'DEL_NRV' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=1.7, estimated_travel_time_min=3.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 3.1, 6.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_NRV' AND ts.code = 'DEL_DLC' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=3.1, estimated_travel_time_min=6.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.9, 4.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_DLC' AND ts.code = 'DEL_DHK' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=1.9, estimated_travel_time_min=4.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.5, 3.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_DHK' AND ts.code = 'DEL_MVB' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=1.5, estimated_travel_time_min=3.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.5, 3.2, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_MVB' AND ts.code = 'DEL_BKC' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=1.5, estimated_travel_time_min=3.2;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.7, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_BKC' AND ts.code = 'DEL_SRJ' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.7;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_SRJ' AND ts.code = 'DEL_INA' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_INA' AND ts.code = 'DEL_SOE' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.6, 3.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_SOE' AND ts.code = 'DEL_LAK' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=1.6, estimated_travel_time_min=3.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_LAK' AND ts.code = 'DEL_VNB' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_VNB' AND ts.code = 'DEL_ASH' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.9, 4.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_ASH' AND ts.code = 'DEL_SKK_M' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=1.9, estimated_travel_time_min=4.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 4.2, 8.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_SKK_M' AND ts.code = 'DEL_MYV' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=4.2, estimated_travel_time_min=8.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.8, 2.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_MYV' AND ts.code = 'DEL_MVP' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=0.8, estimated_travel_time_min=2.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.9, 2.2, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_MVP' AND ts.code = 'DEL_TLS' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=0.9, estimated_travel_time_min=2.2;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_TLS' AND ts.code = 'DEL_EVN' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.8, 1.9, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_EVN' AND ts.code = 'DEL_MWV' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=0.8, estimated_travel_time_min=1.9;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.8, 1.9, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_MWV' AND ts.code = 'DEL_IPE' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=0.8, estimated_travel_time_min=1.9;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_IPE' AND ts.code = 'DEL_ANVT' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.7, 3.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_ANVT' AND ts.code = 'DEL_KKD' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=1.7, estimated_travel_time_min=3.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.8, 1.9, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_KKD' AND ts.code = 'DEL_KKC' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=0.8, estimated_travel_time_min=1.9;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_KKC' AND ts.code = 'DEL_KRN' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.7, 1.7, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_KRN' AND ts.code = 'DEL_EAN' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=0.7, estimated_travel_time_min=1.7;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.6, 1.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_EAN' AND ts.code = 'DEL_WLC' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=0.6, estimated_travel_time_min=1.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.8, 2.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_WLC' AND ts.code = 'DEL_JFR' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=0.8, estimated_travel_time_min=2.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.9, 2.2, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_JFR' AND ts.code = 'DEL_MJB' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=0.9, estimated_travel_time_min=2.2;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.3, 2.8, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_MJB' AND ts.code = 'DEL_GKP_M' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=1.3, estimated_travel_time_min=2.8;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_GKP_M' AND ts.code = 'DEL_JHE' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.3, 2.8, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_JHE' AND ts.code = 'DEL_SHV' AND tl.code = 'DMRC_PINK'
ON DUPLICATE KEY UPDATE distance_km=1.3, estimated_travel_time_min=2.8;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.5, 3.2, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_JPW' AND ts.code = 'DEL_DBM' AND tl.code = 'DMRC_MAGENTA'
ON DUPLICATE KEY UPDATE distance_km=1.5, estimated_travel_time_min=3.2;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_DBM' AND ts.code = 'DEL_DSP' AND tl.code = 'DMRC_MAGENTA'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.9, 4.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_DSP' AND ts.code = 'DEL_PLM' AND tl.code = 'DMRC_MAGENTA'
ON DUPLICATE KEY UPDATE distance_km=1.9, estimated_travel_time_min=4.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 2.2, 4.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_PLM' AND ts.code = 'DEL_SBC' AND tl.code = 'DMRC_MAGENTA'
ON DUPLICATE KEY UPDATE distance_km=2.2, estimated_travel_time_min=4.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 2.6, 5.2, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_SBC' AND ts.code = 'DEL_T1A' AND tl.code = 'DMRC_MAGENTA'
ON DUPLICATE KEY UPDATE distance_km=2.6, estimated_travel_time_min=5.2;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.9, 3.9, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_T1A' AND ts.code = 'DEL_SKV' AND tl.code = 'DMRC_MAGENTA'
ON DUPLICATE KEY UPDATE distance_km=1.9, estimated_travel_time_min=3.9;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 2.3, 4.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_SKV' AND ts.code = 'DEL_VSV' AND tl.code = 'DMRC_MAGENTA'
ON DUPLICATE KEY UPDATE distance_km=2.3, estimated_travel_time_min=4.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.3, 2.8, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_VSV' AND ts.code = 'DEL_MNR' AND tl.code = 'DMRC_MAGENTA'
ON DUPLICATE KEY UPDATE distance_km=1.3, estimated_travel_time_min=2.8;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.4, 3.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_MNR' AND ts.code = 'DEL_RKP' AND tl.code = 'DMRC_MAGENTA'
ON DUPLICATE KEY UPDATE distance_km=1.4, estimated_travel_time_min=3.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_RKP' AND ts.code = 'DEL_IIT' AND tl.code = 'DMRC_MAGENTA'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.7, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_IIT' AND ts.code = 'DEL_HK' AND tl.code = 'DMRC_MAGENTA'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.7;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_HK' AND ts.code = 'DEL_PSP' AND tl.code = 'DMRC_MAGENTA'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_PSP' AND ts.code = 'DEL_CRD' AND tl.code = 'DMRC_MAGENTA'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_CRD' AND ts.code = 'DEL_GKL' AND tl.code = 'DMRC_MAGENTA'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_GKL' AND ts.code = 'DEL_NHE' AND tl.code = 'DMRC_MAGENTA'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.7, 1.8, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_NHE' AND ts.code = 'DEL_KAL' AND tl.code = 'DMRC_MAGENTA'
ON DUPLICATE KEY UPDATE distance_km=0.7, estimated_travel_time_min=1.8;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.9, 2.2, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_KAL' AND ts.code = 'DEL_OKN' AND tl.code = 'DMRC_MAGENTA'
ON DUPLICATE KEY UPDATE distance_km=0.9, estimated_travel_time_min=2.2;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_OKN' AND ts.code = 'DEL_SKV2' AND tl.code = 'DMRC_MAGENTA'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_SKV2' AND ts.code = 'DEL_JMI' AND tl.code = 'DMRC_MAGENTA'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_JMI' AND ts.code = 'DEL_OKV' AND tl.code = 'DMRC_MAGENTA'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.5, 3.2, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_OKV' AND ts.code = 'DEL_JSV' AND tl.code = 'DMRC_MAGENTA'
ON DUPLICATE KEY UPDATE distance_km=1.5, estimated_travel_time_min=3.2;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_JSV' AND ts.code = 'DEL_KLK' AND tl.code = 'DMRC_MAGENTA'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.3, 2.9, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_KLK' AND ts.code = 'NOI_OBS' AND tl.code = 'DMRC_MAGENTA'
ON DUPLICATE KEY UPDATE distance_km=1.3, estimated_travel_time_min=2.9;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 2.0, 4.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_OBS' AND ts.code = 'NOI_BOT' AND tl.code = 'DMRC_MAGENTA'
ON DUPLICATE KEY UPDATE distance_km=2.0, estimated_travel_time_min=4.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 2.8, 5.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_IDL' AND ts.code = 'DEL_KRT' AND tl.code = 'DMRC_GREEN'
ON DUPLICATE KEY UPDATE distance_km=2.8, estimated_travel_time_min=5.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.9, 2.2, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_KRT' AND ts.code = 'DEL_SRM' AND tl.code = 'DMRC_GREEN'
ON DUPLICATE KEY UPDATE distance_km=0.9, estimated_travel_time_min=2.2;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_SRM' AND ts.code = 'DEL_APM' AND tl.code = 'DMRC_GREEN'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.5, 3.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_APM' AND ts.code = 'DEL_PJB' AND tl.code = 'DMRC_GREEN'
ON DUPLICATE KEY UPDATE distance_km=1.5, estimated_travel_time_min=3.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_PJB' AND ts.code = 'DEL_PBW' AND tl.code = 'DMRC_GREEN'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_PBW' AND ts.code = 'DEL_SJP' AND tl.code = 'DMRC_GREEN'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_SJP' AND ts.code = 'DEL_MDP' AND tl.code = 'DMRC_GREEN'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_MDP' AND ts.code = 'DEL_PVE' AND tl.code = 'DMRC_GREEN'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_PVE' AND ts.code = 'DEL_PVW' AND tl.code = 'DMRC_GREEN'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_PVW' AND ts.code = 'DEL_PRG' AND tl.code = 'DMRC_GREEN'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_PRG' AND ts.code = 'DEL_UDN' AND tl.code = 'DMRC_GREEN'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_UDN' AND ts.code = 'DEL_SJM' AND tl.code = 'DMRC_GREEN'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_SJM' AND ts.code = 'DEL_NGL' AND tl.code = 'DMRC_GREEN'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_NGL' AND ts.code = 'DEL_NGR' AND tl.code = 'DMRC_GREEN'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_NGR' AND ts.code = 'DEL_RDP' AND tl.code = 'DMRC_GREEN'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.4, 3.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_RDP' AND ts.code = 'DEL_MND' AND tl.code = 'DMRC_GREEN'
ON DUPLICATE KEY UPDATE distance_km=1.4, estimated_travel_time_min=3.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.4, 3.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_MND' AND ts.code = 'DEL_MIA' AND tl.code = 'DMRC_GREEN'
ON DUPLICATE KEY UPDATE distance_km=1.4, estimated_travel_time_min=3.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 2.0, 4.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_MIA' AND ts.code = 'DEL_GHV' AND tl.code = 'DMRC_GREEN'
ON DUPLICATE KEY UPDATE distance_km=2.0, estimated_travel_time_min=4.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 2.0, 4.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_GHV' AND ts.code = 'DEL_TKK' AND tl.code = 'DMRC_GREEN'
ON DUPLICATE KEY UPDATE distance_km=2.0, estimated_travel_time_min=4.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 2.0, 4.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_TKK' AND ts.code = 'DEL_TKB' AND tl.code = 'DMRC_GREEN'
ON DUPLICATE KEY UPDATE distance_km=2.0, estimated_travel_time_min=4.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.8, 2.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_TKB' AND ts.code = 'DEL_PSR' AND tl.code = 'DMRC_GREEN'
ON DUPLICATE KEY UPDATE distance_km=0.8, estimated_travel_time_min=2.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.9, 2.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_PSR' AND ts.code = 'DEL_BHS' AND tl.code = 'DMRC_GREEN'
ON DUPLICATE KEY UPDATE distance_km=0.9, estimated_travel_time_min=2.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.8, 3.7, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_NDLS' AND ts.code = 'DEL_SVS' AND tl.code = 'DMRC_AIRPORT'
ON DUPLICATE KEY UPDATE distance_km=1.8, estimated_travel_time_min=3.7;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 6.6, 12.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_SVS' AND ts.code = 'DEL_DHK_A' AND tl.code = 'DMRC_AIRPORT'
ON DUPLICATE KEY UPDATE distance_km=6.6, estimated_travel_time_min=12.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 6.0, 11.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_DHK_A' AND ts.code = 'DEL_AER' AND tl.code = 'DMRC_AIRPORT'
ON DUPLICATE KEY UPDATE distance_km=6.0, estimated_travel_time_min=11.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 3.5, 6.9, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_AER' AND ts.code = 'DEL_T3' AND tl.code = 'DMRC_AIRPORT'
ON DUPLICATE KEY UPDATE distance_km=3.5, estimated_travel_time_min=6.9;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 2.8, 5.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_T3' AND ts.code = 'DEL_DW21' AND tl.code = 'DMRC_AIRPORT'
ON DUPLICATE KEY UPDATE distance_km=2.8, estimated_travel_time_min=5.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.4, 3.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_DW21' AND ts.code = 'DEL_YAS' AND tl.code = 'DMRC_AIRPORT'
ON DUPLICATE KEY UPDATE distance_km=1.4, estimated_travel_time_min=3.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.9, 3.9, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_DWK' AND ts.code = 'DEL_NGLI' AND tl.code = 'DMRC_GREY'
ON DUPLICATE KEY UPDATE distance_km=1.9, estimated_travel_time_min=3.9;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.6, 3.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_NGLI' AND ts.code = 'DEL_NJG' AND tl.code = 'DMRC_GREY'
ON DUPLICATE KEY UPDATE distance_km=1.6, estimated_travel_time_min=3.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'DEL_NJG' AND ts.code = 'DEL_DBS' AND tl.code = 'DMRC_GREY'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.7, 3.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'GGN_S55' AND ts.code = 'GGN_S54' AND tl.code = 'RM_GURUGRAM'
ON DUPLICATE KEY UPDATE distance_km=1.7, estimated_travel_time_min=3.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.3, 2.9, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'GGN_S54' AND ts.code = 'GGN_S53' AND tl.code = 'RM_GURUGRAM'
ON DUPLICATE KEY UPDATE distance_km=1.3, estimated_travel_time_min=2.9;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.3, 2.9, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'GGN_S53' AND ts.code = 'GGN_S42' AND tl.code = 'RM_GURUGRAM'
ON DUPLICATE KEY UPDATE distance_km=1.3, estimated_travel_time_min=2.9;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.3, 2.8, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'GGN_S42' AND ts.code = 'GGN_PH1' AND tl.code = 'RM_GURUGRAM'
ON DUPLICATE KEY UPDATE distance_km=1.3, estimated_travel_time_min=2.8;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'GGN_PH1' AND ts.code = 'GGN_SIK' AND tl.code = 'RM_GURUGRAM'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'GGN_SIK' AND ts.code = 'GGN_PH2' AND tl.code = 'RM_GURUGRAM'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.5, 1.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'GGN_PH2' AND ts.code = 'GGN_BLV' AND tl.code = 'RM_GURUGRAM'
ON DUPLICATE KEY UPDATE distance_km=0.5, estimated_travel_time_min=1.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.8, 2.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'GGN_BLV' AND ts.code = 'GGN_CYB' AND tl.code = 'RM_GURUGRAM'
ON DUPLICATE KEY UPDATE distance_km=0.8, estimated_travel_time_min=2.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.8, 1.9, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'GGN_CYB' AND ts.code = 'GGN_MLS' AND tl.code = 'RM_GURUGRAM'
ON DUPLICATE KEY UPDATE distance_km=0.8, estimated_travel_time_min=1.9;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'GGN_MLS' AND ts.code = 'GGN_PH3' AND tl.code = 'RM_GURUGRAM'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.9, 2.2, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_S51' AND ts.code = 'NOI_S50' AND tl.code = 'NMRC_AQUA'
ON DUPLICATE KEY UPDATE distance_km=0.9, estimated_travel_time_min=2.2;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.4, 3.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_S50' AND ts.code = 'NOI_S76' AND tl.code = 'NMRC_AQUA'
ON DUPLICATE KEY UPDATE distance_km=1.4, estimated_travel_time_min=3.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.3, 2.9, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_S76' AND ts.code = 'NOI_S101' AND tl.code = 'NMRC_AQUA'
ON DUPLICATE KEY UPDATE distance_km=1.3, estimated_travel_time_min=2.9;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.5, 3.2, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_S101' AND ts.code = 'NOI_S81' AND tl.code = 'NMRC_AQUA'
ON DUPLICATE KEY UPDATE distance_km=1.5, estimated_travel_time_min=3.2;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.7, 3.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_S81' AND ts.code = 'NOI_NSEZ' AND tl.code = 'NMRC_AQUA'
ON DUPLICATE KEY UPDATE distance_km=1.7, estimated_travel_time_min=3.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.7, 3.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_NSEZ' AND ts.code = 'NOI_S83' AND tl.code = 'NMRC_AQUA'
ON DUPLICATE KEY UPDATE distance_km=1.7, estimated_travel_time_min=3.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.6, 3.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_S83' AND ts.code = 'NOI_S137' AND tl.code = 'NMRC_AQUA'
ON DUPLICATE KEY UPDATE distance_km=1.6, estimated_travel_time_min=3.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.8, 3.7, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_S137' AND ts.code = 'NOI_S142' AND tl.code = 'NMRC_AQUA'
ON DUPLICATE KEY UPDATE distance_km=1.8, estimated_travel_time_min=3.7;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.7, 3.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_S142' AND ts.code = 'NOI_S143' AND tl.code = 'NMRC_AQUA'
ON DUPLICATE KEY UPDATE distance_km=1.7, estimated_travel_time_min=3.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.7, 3.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_S143' AND ts.code = 'NOI_S144' AND tl.code = 'NMRC_AQUA'
ON DUPLICATE KEY UPDATE distance_km=1.7, estimated_travel_time_min=3.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.6, 3.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_S144' AND ts.code = 'NOI_S145' AND tl.code = 'NMRC_AQUA'
ON DUPLICATE KEY UPDATE distance_km=1.6, estimated_travel_time_min=3.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.5, 3.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_S145' AND ts.code = 'NOI_S146' AND tl.code = 'NMRC_AQUA'
ON DUPLICATE KEY UPDATE distance_km=1.5, estimated_travel_time_min=3.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.4, 3.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_S146' AND ts.code = 'NOI_S147' AND tl.code = 'NMRC_AQUA'
ON DUPLICATE KEY UPDATE distance_km=1.4, estimated_travel_time_min=3.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.6, 3.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_S147' AND ts.code = 'NOI_S148' AND tl.code = 'NMRC_AQUA'
ON DUPLICATE KEY UPDATE distance_km=1.6, estimated_travel_time_min=3.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.5, 3.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_S148' AND ts.code = 'NOI_KP2' AND tl.code = 'NMRC_AQUA'
ON DUPLICATE KEY UPDATE distance_km=1.5, estimated_travel_time_min=3.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.5, 3.2, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_KP2' AND ts.code = 'NOI_PAR' AND tl.code = 'NMRC_AQUA'
ON DUPLICATE KEY UPDATE distance_km=1.5, estimated_travel_time_min=3.2;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.9, 2.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_PAR' AND ts.code = 'NOI_ALP' AND tl.code = 'NMRC_AQUA'
ON DUPLICATE KEY UPDATE distance_km=0.9, estimated_travel_time_min=2.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_ALP' AND ts.code = 'NOI_DLT' AND tl.code = 'NMRC_AQUA'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.9, 4.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_DLT' AND ts.code = 'NOI_GND' AND tl.code = 'NMRC_AQUA'
ON DUPLICATE KEY UPDATE distance_km=1.9, estimated_travel_time_min=4.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.8, 3.8, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_GND' AND ts.code = 'NOI_DEP' AND tl.code = 'NMRC_AQUA'
ON DUPLICATE KEY UPDATE distance_km=1.8, estimated_travel_time_min=3.8;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.6, 3.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'LKO_AIR' AND ts.code = 'LKO_AMA' AND tl.code = 'LMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.6, estimated_travel_time_min=3.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.6, 3.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'LKO_AMA' AND ts.code = 'LKO_TPN' AND tl.code = 'LMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.6, estimated_travel_time_min=3.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.3, 2.9, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'LKO_TPN' AND ts.code = 'LKO_KRN' AND tl.code = 'LMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.3, estimated_travel_time_min=2.9;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'LKO_KRN' AND ts.code = 'LKO_SNG' AND tl.code = 'LMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.9, 2.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'LKO_SNG' AND ts.code = 'LKO_ALB' AND tl.code = 'LMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=0.9, estimated_travel_time_min=2.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.5, 1.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'LKO_ALB' AND ts.code = 'LKO_ABS' AND tl.code = 'LMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=0.5, estimated_travel_time_min=1.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.8, 1.9, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'LKO_ABS' AND ts.code = 'LKO_MVG' AND tl.code = 'LMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=0.8, estimated_travel_time_min=1.9;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.3, 1.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'LKO_MVG' AND ts.code = 'LKO_DGR' AND tl.code = 'LMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=0.3, estimated_travel_time_min=1.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.8, 2.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'LKO_DGR' AND ts.code = 'LKO_CHR' AND tl.code = 'LMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=0.8, estimated_travel_time_min=2.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 296.9, 540.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'LKO_CHR' AND ts.code = 'LKO_HSA' AND tl.code = 'LMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=296.9, estimated_travel_time_min=540.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 298.4, 543.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'LKO_HSA' AND ts.code = 'LKO_SCH' AND tl.code = 'LMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=298.4, estimated_travel_time_min=543.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.9, 2.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'LKO_SCH' AND ts.code = 'LKO_HZG' AND tl.code = 'LMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=0.9, estimated_travel_time_min=2.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'LKO_HZG' AND ts.code = 'LKO_KDM' AND tl.code = 'LMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'LKO_KDM' AND ts.code = 'LKO_UVV' AND tl.code = 'LMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.9, 2.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'LKO_UVV' AND ts.code = 'LKO_ITJ' AND tl.code = 'LMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=0.9, estimated_travel_time_min=2.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.5, 3.3, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'LKO_ITJ' AND ts.code = 'LKO_BDN' AND tl.code = 'LMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.5, estimated_travel_time_min=3.3;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'LKO_BDN' AND ts.code = 'LKO_LKN' AND tl.code = 'LMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.9, 2.2, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'LKO_LKN' AND ts.code = 'LKO_BTN' AND tl.code = 'LMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=0.9, estimated_travel_time_min=2.2;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.8, 2.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'LKO_BTN' AND ts.code = 'LKO_IDN' AND tl.code = 'LMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=0.8, estimated_travel_time_min=2.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.8, 1.9, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'LKO_IDN' AND ts.code = 'LKO_MSP' AND tl.code = 'LMRC_RED'
ON DUPLICATE KEY UPDATE distance_km=0.8, estimated_travel_time_min=1.9;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 3.6, 7.1, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'KNP_IIT' AND ts.code = 'KNP_KLY' AND tl.code = 'KMRC_ORANGE'
ON DUPLICATE KEY UPDATE distance_km=3.6, estimated_travel_time_min=7.1;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'KNP_KLY' AND ts.code = 'KNP_SPM' AND tl.code = 'KMRC_ORANGE'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.6, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'KNP_SPM' AND ts.code = 'KNP_CSJ' AND tl.code = 'KMRC_ORANGE'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.6;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.2, 2.7, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'KNP_CSJ' AND ts.code = 'KNP_GNR' AND tl.code = 'KMRC_ORANGE'
ON DUPLICATE KEY UPDATE distance_km=1.2, estimated_travel_time_min=2.7;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.0, 2.2, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'KNP_GNR' AND ts.code = 'KNP_GNP' AND tl.code = 'KMRC_ORANGE'
ON DUPLICATE KEY UPDATE distance_km=1.0, estimated_travel_time_min=2.2;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.8, 2.0, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'KNP_GNP' AND ts.code = 'KNP_RWP' AND tl.code = 'KMRC_ORANGE'
ON DUPLICATE KEY UPDATE distance_km=0.8, estimated_travel_time_min=2.0;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.5, 1.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'KNP_RWP' AND ts.code = 'KNP_LLR' AND tl.code = 'KMRC_ORANGE'
ON DUPLICATE KEY UPDATE distance_km=0.5, estimated_travel_time_min=1.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.6, 1.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'KNP_LLR' AND ts.code = 'KNP_MJL' AND tl.code = 'KMRC_ORANGE'
ON DUPLICATE KEY UPDATE distance_km=0.6, estimated_travel_time_min=1.5;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.9, 2.2, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'AGR_TEG' AND ts.code = 'AGR_CSG' AND tl.code = 'AMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=0.9, estimated_travel_time_min=2.2;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.7, 1.8, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'AGR_CSG' AND ts.code = 'AGR_FBR' AND tl.code = 'AMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=0.7, estimated_travel_time_min=1.8;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.7, 1.7, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'AGR_FBR' AND ts.code = 'AGR_TJM' AND tl.code = 'AMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=0.7, estimated_travel_time_min=1.7;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.3, 2.8, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'AGR_TJM' AND ts.code = 'AGR_AGF' AND tl.code = 'AMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.3, estimated_travel_time_min=2.8;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 1.1, 2.4, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'AGR_AGF' AND ts.code = 'AGR_MKM' AND tl.code = 'AMRC_YELLOW'
ON DUPLICATE KEY UPDATE distance_km=1.1, estimated_travel_time_min=2.4;

INSERT INTO connections (from_station_id, to_station_id, line_id, transport_type_id, distance_km, estimated_travel_time_min, is_bidirectional, is_active, data_status)
SELECT fs.id, ts.id, tl.id, 1, 0.3, 4.5, 1, 1, 'verified'
FROM stations fs, stations ts, transport_lines tl
WHERE fs.code = 'NOI_S52' AND ts.code = 'NOI_S51' AND tl.code = 'NMRC_AQUA'
ON DUPLICATE KEY UPDATE distance_km=0.3, estimated_travel_time_min=4.5;