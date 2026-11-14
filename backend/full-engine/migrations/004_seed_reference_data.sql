USE raasta_db;

-- Transport Types
INSERT IGNORE INTO transport_types (name, code, description) VALUES
('Metro', 'metro', 'Urban metro rail systems'),
('Bus', 'bus', 'City and intercity bus services'),
('Indian Railways', 'railway', 'Indian Railways train services'),
('Namo Bharat (RRTS)', 'rrts', 'Regional Rapid Transit System');

-- States
INSERT IGNORE INTO states (name, code) VALUES
('Delhi', 'DL'),
('Uttar Pradesh', 'UP'),
('Haryana', 'HR'),
('Rajasthan', 'RJ');

-- Operators (real operators only)
INSERT IGNORE INTO operators (name, code, transport_type_id, website, region) VALUES
('Delhi Metro Rail Corporation', 'DMRC', 1, 'https://delhimetrorail.com', 'Delhi NCR'),
('Noida Metro Rail Corporation', 'NMRC', 1, 'https://www.nmrcnoida.com', 'Noida'),
('Gurugram Metropolitan City Bus Limited', 'GMCBL', 1, 'https://www.rapidmetrogurgaon.com', 'Gurugram'),
('UP Metro Rail Corporation', 'UPMRC', 1, 'https://www.lfrometro.com', 'Uttar Pradesh'),
('Delhi Transport Corporation', 'DTC', 2, 'https://dtc.delhi.gov.in', 'Delhi'),
('Delhi Integrated Multi-Modal Transit System', 'DIMTS', 2, 'https://www.dimts.in', 'Delhi'),
('UP State Road Transport Corporation', 'UPSRTC', 2, 'https://www.upsrtc.com', 'Uttar Pradesh'),
('Indian Railways', 'IR', 3, 'https://www.indianrailways.gov.in', 'National'),
('National Capital Region Transport Corporation', 'NCRTC', 4, 'https://ncrtc.in', 'Delhi NCR');
