-- Raasta Backend: Fare Schema Migration
-- Version: 002

USE raasta_db;

-- ── Fare Rules ──────────────────────────────────────

CREATE TABLE IF NOT EXISTS fare_rules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    transport_type_id INT NOT NULL,
    operator_id INT,
    line_id INT,
    rule_name VARCHAR(100) NOT NULL,
    fare_type ENUM('distance_slab', 'flat', 'zone', 'stage') DEFAULT 'distance_slab',
    fare_class VARCHAR(30) DEFAULT 'general' COMMENT 'general, ac, non_ac, premium, first_class, second_class, sleeper',
    min_distance_km DECIMAL(8, 2) DEFAULT 0.00,
    max_distance_km DECIMAL(8, 2) DEFAULT 9999.99,
    base_fare DECIMAL(8, 2) NOT NULL DEFAULT 0.00,
    per_km_fare DECIMAL(8, 4) DEFAULT 0.00,
    fare_amount DECIMAL(8, 2) NOT NULL DEFAULT 0.00,
    currency VARCHAR(3) DEFAULT 'INR',
    applies_on ENUM('all_days', 'weekday', 'weekend', 'sunday', 'holiday') DEFAULT 'all_days',
    is_smart_card BOOLEAN DEFAULT FALSE,
    discount_pct DECIMAL(5, 2) DEFAULT 0.00,
    source VARCHAR(255),
    data_status ENUM('verified', 'estimated', 'unavailable') DEFAULT 'estimated',
    is_active BOOLEAN DEFAULT TRUE,
    effective_from DATE,
    effective_to DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (transport_type_id) REFERENCES transport_types(id),
    FOREIGN KEY (operator_id) REFERENCES operators(id),
    FOREIGN KEY (line_id) REFERENCES transport_lines(id),
    INDEX idx_fare_type_operator (transport_type_id, operator_id),
    INDEX idx_fare_distance (min_distance_km, max_distance_km)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS fare_products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    operator_id INT,
    product_type VARCHAR(50) COMMENT 'single_journey, return, day_pass, weekly_pass, monthly_pass, smart_card',
    base_price DECIMAL(8, 2),
    discount_pct DECIMAL(5, 2) DEFAULT 0.00,
    validity_days INT,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (operator_id) REFERENCES operators(id)
) ENGINE=InnoDB;

-- ── Transfer Rules ──────────────────────────────────

CREATE TABLE IF NOT EXISTS transfer_rules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    from_transport_type_id INT NOT NULL,
    to_transport_type_id INT NOT NULL,
    from_operator_id INT,
    to_operator_id INT,
    transfer_time_penalty_min DECIMAL(5, 2) DEFAULT 5.0,
    transfer_fare DECIMAL(8, 2) DEFAULT 0.00,
    is_integrated_ticket BOOLEAN DEFAULT FALSE,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (from_transport_type_id) REFERENCES transport_types(id),
    FOREIGN KEY (to_transport_type_id) REFERENCES transport_types(id),
    FOREIGN KEY (from_operator_id) REFERENCES operators(id),
    FOREIGN KEY (to_operator_id) REFERENCES operators(id)
) ENGINE=InnoDB;
