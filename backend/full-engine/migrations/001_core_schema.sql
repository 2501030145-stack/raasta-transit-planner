-- Raasta Backend: Core Schema Migration
-- Version: 001
-- Description: Core tables for transport network

CREATE DATABASE IF NOT EXISTS raasta_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE raasta_db;

-- ── Geographic Reference ─────────────────────────────

CREATE TABLE IF NOT EXISTS states (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    code VARCHAR(10) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS cities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    state_id INT NOT NULL,
    district VARCHAR(100),
    latitude DECIMAL(10, 7),
    longitude DECIMAL(10, 7),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (state_id) REFERENCES states(id),
    UNIQUE KEY uk_city_state (name, state_id)
) ENGINE=InnoDB;

-- ── Transport Types & Operators ─────────────────────

CREATE TABLE IF NOT EXISTS transport_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    code VARCHAR(20) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS operators (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(20) NOT NULL UNIQUE,
    transport_type_id INT NOT NULL,
    website VARCHAR(255),
    region VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (transport_type_id) REFERENCES transport_types(id)
) ENGINE=InnoDB;

-- ── Transport Lines ─────────────────────────────────

CREATE TABLE IF NOT EXISTS transport_lines (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(30) NOT NULL,
    color VARCHAR(20),
    transport_type_id INT NOT NULL,
    operator_id INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (transport_type_id) REFERENCES transport_types(id),
    FOREIGN KEY (operator_id) REFERENCES operators(id),
    UNIQUE KEY uk_line_code_operator (code, operator_id)
) ENGINE=InnoDB;

-- ── Stations ────────────────────────────────────────

CREATE TABLE IF NOT EXISTS stations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    code VARCHAR(30),
    latitude DECIMAL(10, 7) NOT NULL,
    longitude DECIMAL(10, 7) NOT NULL,
    city_id INT,
    state_id INT,
    station_type VARCHAR(30) NOT NULL COMMENT 'metro_station, bus_stop, railway_station, rrts_station',
    address TEXT,
    is_interchange BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    source_id INT,
    data_status ENUM('verified', 'estimated', 'unavailable') DEFAULT 'estimated',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (city_id) REFERENCES cities(id),
    FOREIGN KEY (state_id) REFERENCES states(id),
    INDEX idx_station_name (name),
    INDEX idx_station_code (code),
    INDEX idx_station_type (station_type),
    INDEX idx_station_coords (latitude, longitude),
    INDEX idx_station_city (city_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS station_aliases (
    id INT AUTO_INCREMENT PRIMARY KEY,
    station_id INT NOT NULL,
    alias_name VARCHAR(150) NOT NULL,
    alias_type VARCHAR(30) DEFAULT 'alternate' COMMENT 'alternate, hindi, abbreviation, legacy',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (station_id) REFERENCES stations(id) ON DELETE CASCADE,
    INDEX idx_alias_name (alias_name)
) ENGINE=InnoDB;

-- Junction table: which lines serve which station (with sequence)
CREATE TABLE IF NOT EXISTS station_lines (
    id INT AUTO_INCREMENT PRIMARY KEY,
    station_id INT NOT NULL,
    line_id INT NOT NULL,
    sequence_order INT NOT NULL DEFAULT 0,
    platform VARCHAR(30),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (station_id) REFERENCES stations(id) ON DELETE CASCADE,
    FOREIGN KEY (line_id) REFERENCES transport_lines(id) ON DELETE CASCADE,
    UNIQUE KEY uk_station_line (station_id, line_id)
) ENGINE=InnoDB;

-- ── Connections ─────────────────────────────────────

CREATE TABLE IF NOT EXISTS connections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    from_station_id INT NOT NULL,
    to_station_id INT NOT NULL,
    line_id INT,
    transport_type_id INT NOT NULL,
    distance_km DECIMAL(8, 2),
    estimated_travel_time_min DECIMAL(8, 2),
    is_bidirectional BOOLEAN DEFAULT TRUE,
    is_active BOOLEAN DEFAULT TRUE,
    source_id INT,
    data_status ENUM('verified', 'estimated', 'unavailable') DEFAULT 'estimated',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (from_station_id) REFERENCES stations(id),
    FOREIGN KEY (to_station_id) REFERENCES stations(id),
    FOREIGN KEY (line_id) REFERENCES transport_lines(id),
    FOREIGN KEY (transport_type_id) REFERENCES transport_types(id),
    INDEX idx_conn_from (from_station_id),
    INDEX idx_conn_to (to_station_id),
    INDEX idx_conn_type (transport_type_id),
    INDEX idx_conn_line (line_id)
) ENGINE=InnoDB;

-- ── Interchange / Transfer Connections ──────────────

CREATE TABLE IF NOT EXISTS interchange_connections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    from_station_id INT NOT NULL,
    to_station_id INT NOT NULL,
    from_line_id INT,
    to_line_id INT,
    transfer_time_min DECIMAL(5, 2) DEFAULT 5.0,
    walking_distance_m INT DEFAULT 0,
    is_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (from_station_id) REFERENCES stations(id),
    FOREIGN KEY (to_station_id) REFERENCES stations(id),
    FOREIGN KEY (from_line_id) REFERENCES transport_lines(id),
    FOREIGN KEY (to_line_id) REFERENCES transport_lines(id),
    INDEX idx_interchange_from (from_station_id),
    INDEX idx_interchange_to (to_station_id)
) ENGINE=InnoDB;

-- ── Connection Schedules ────────────────────────────

CREATE TABLE IF NOT EXISTS connection_schedules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    connection_id INT NOT NULL,
    day_type ENUM('weekday', 'saturday', 'sunday', 'holiday') DEFAULT 'weekday',
    first_service TIME,
    last_service TIME,
    frequency_min INT COMMENT 'Average frequency in minutes',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (connection_id) REFERENCES connections(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ── Trips (for GTFS-style data) ─────────────────────

CREATE TABLE IF NOT EXISTS trips (
    id INT AUTO_INCREMENT PRIMARY KEY,
    trip_identifier VARCHAR(100) NOT NULL,
    line_id INT NOT NULL,
    service_id VARCHAR(50),
    direction TINYINT DEFAULT 0,
    headsign VARCHAR(150),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (line_id) REFERENCES transport_lines(id),
    INDEX idx_trip_identifier (trip_identifier),
    INDEX idx_trip_line (line_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS trip_stops (
    id INT AUTO_INCREMENT PRIMARY KEY,
    trip_id INT NOT NULL,
    station_id INT NOT NULL,
    stop_sequence INT NOT NULL,
    arrival_time TIME,
    departure_time TIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trip_id) REFERENCES trips(id) ON DELETE CASCADE,
    FOREIGN KEY (station_id) REFERENCES stations(id),
    INDEX idx_trip_stop_trip (trip_id),
    INDEX idx_trip_stop_station (station_id)
) ENGINE=InnoDB;

-- ── Data Provenance ─────────────────────────────────

CREATE TABLE IF NOT EXISTS data_sources (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    url VARCHAR(500),
    source_type VARCHAR(50) COMMENT 'gtfs, csv, api, manual, official_website',
    transport_type_id INT,
    operator_id INT,
    description TEXT,
    license VARCHAR(100),
    last_verified_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (transport_type_id) REFERENCES transport_types(id),
    FOREIGN KEY (operator_id) REFERENCES operators(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS import_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data_source_id INT NOT NULL,
    import_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dataset_version VARCHAR(50),
    status ENUM('started', 'completed', 'failed', 'partial') DEFAULT 'started',
    stations_imported INT DEFAULT 0,
    connections_imported INT DEFAULT 0,
    routes_imported INT DEFAULT 0,
    errors_count INT DEFAULT 0,
    warnings_count INT DEFAULT 0,
    report TEXT,
    duration_seconds INT,
    FOREIGN KEY (data_source_id) REFERENCES data_sources(id)
) ENGINE=InnoDB;
