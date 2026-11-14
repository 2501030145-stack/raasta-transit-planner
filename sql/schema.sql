CREATE DATABASE IF NOT EXISTS raasta CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE raasta;

CREATE TABLE IF NOT EXISTS transport_types (
  id VARCHAR(32) PRIMARY KEY,
  name VARCHAR(80) NOT NULL UNIQUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS transport_lines (
  id VARCHAR(48) PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  transport_type_id VARCHAR(32) NOT NULL,
  color CHAR(7) NOT NULL,
  operator_name VARCHAR(160) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_line_type FOREIGN KEY (transport_type_id) REFERENCES transport_types(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS stations (
  id VARCHAR(64) PRIMARY KEY,
  name VARCHAR(160) NOT NULL,
  city VARCHAR(120) NOT NULL,
  zone VARCHAR(120) NOT NULL,
  latitude DECIMAL(10,7) NOT NULL,
  longitude DECIMAL(10,7) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT chk_station_lat CHECK (latitude BETWEEN -90 AND 90),
  CONSTRAINT chk_station_lng CHECK (longitude BETWEEN -180 AND 180),
  INDEX idx_station_name (name),
  INDEX idx_station_city (city)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS station_lines (
  station_id VARCHAR(64) NOT NULL,
  line_id VARCHAR(48) NOT NULL,
  PRIMARY KEY (station_id,line_id),
  CONSTRAINT fk_station_lines_station FOREIGN KEY (station_id) REFERENCES stations(id) ON DELETE CASCADE,
  CONSTRAINT fk_station_lines_line FOREIGN KEY (line_id) REFERENCES transport_lines(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS connections (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  from_station_id VARCHAR(64) NOT NULL,
  to_station_id VARCHAR(64) NOT NULL,
  line_id VARCHAR(48) NOT NULL,
  distance_km DECIMAL(8,3) NOT NULL,
  travel_minutes DECIMAL(8,2) NOT NULL,
  fare_inr DECIMAL(8,2) NOT NULL,
  stop_count INT UNSIGNED NOT NULL DEFAULT 1,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_connection_from FOREIGN KEY (from_station_id) REFERENCES stations(id) ON DELETE CASCADE,
  CONSTRAINT fk_connection_to FOREIGN KEY (to_station_id) REFERENCES stations(id) ON DELETE CASCADE,
  CONSTRAINT fk_connection_line FOREIGN KEY (line_id) REFERENCES transport_lines(id),
  CONSTRAINT chk_connection_distance CHECK (distance_km >= 0),
  CONSTRAINT chk_connection_time CHECK (travel_minutes >= 0),
  CONSTRAINT chk_connection_fare CHECK (fare_inr >= 0),
  CONSTRAINT chk_connection_stops CHECK (stop_count >= 1),
  UNIQUE KEY uq_connection_direction (from_station_id,to_station_id,line_id),
  INDEX idx_connection_to (to_station_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS admin_users (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(120) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('admin','editor') NOT NULL DEFAULT 'editor',
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Never seed a default administrator password. Provision a real admin through a protected,
-- audited application setup and store only a strong adaptive hash (e.g. Argon2id/bcrypt).
