-- Esquema SQL de ejemplo para un proyecto de IA distributiva
-- Compatible con MySQL / MariaDB en AlwaysData

DROP TABLE IF EXISTS data_flows;
DROP TABLE IF EXISTS observations;
DROP TABLE IF EXISTS connections;
DROP TABLE IF EXISTS models;
DROP TABLE IF EXISTS sensors;
DROP TABLE IF EXISTS nodes;

CREATE TABLE nodes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(150) NOT NULL,
  node_type VARCHAR(80) NOT NULL,
  location VARCHAR(120),
  capacity INT,
  status VARCHAR(30) NOT NULL DEFAULT 'activo',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE sensors (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  node_id INT UNSIGNED NOT NULL,
  sensor_type VARCHAR(80) NOT NULL,
  description TEXT,
  installed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (node_id) REFERENCES nodes(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE models (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  node_id INT UNSIGNED NOT NULL,
  name VARCHAR(120) NOT NULL,
  version VARCHAR(50) NOT NULL,
  accuracy DECIMAL(5,4),
  last_updated DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (node_id) REFERENCES nodes(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE connections (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  source_node_id INT UNSIGNED NOT NULL,
  target_node_id INT UNSIGNED NOT NULL,
  bandwidth_mbps INT,
  latency_ms INT,
  secure TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (source_node_id) REFERENCES nodes(id) ON DELETE CASCADE,
  FOREIGN KEY (target_node_id) REFERENCES nodes(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE observations (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  sensor_id INT UNSIGNED NOT NULL,
  recorded_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  data_type VARCHAR(80) NOT NULL,
  value DOUBLE NOT NULL,
  unit VARCHAR(30),
  PRIMARY KEY (id),
  FOREIGN KEY (sensor_id) REFERENCES sensors(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE data_flows (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  source_node_id INT UNSIGNED NOT NULL,
  target_node_id INT UNSIGNED NOT NULL,
  payload TEXT,
  transmitted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(50) NOT NULL DEFAULT 'completado',
  PRIMARY KEY (id),
  FOREIGN KEY (source_node_id) REFERENCES nodes(id) ON DELETE CASCADE,
  FOREIGN KEY (target_node_id) REFERENCES nodes(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Ejemplos de datos iniciales
INSERT INTO nodes (name, node_type, location, capacity, status) VALUES
  ('Nodo de borde A', 'borde', 'Ciudad A', 120, 'activo'),
  ('Servidor central', 'nube', 'Centro de datos', 500, 'activo'),
  ('Nodo de borde B', 'borde', 'Ciudad B', 100, 'mantenimiento');

INSERT INTO sensors (node_id, sensor_type, description) VALUES
  (1, 'temperatura', 'Sensor de temperatura ambiente'),
  (1, 'humedad', 'Sensor de humedad'),
  (2, 'carga', 'Monitoreo de CPU del servidor');

INSERT INTO models (node_id, name, version, accuracy) VALUES
  (1, 'Clasificador de anomalías', '1.0.0', 0.9300),
  (2, 'Predicción de tráfico', '2.1.0', 0.8900);

INSERT INTO connections (source_node_id, target_node_id, bandwidth_mbps, latency_ms) VALUES
  (1, 2, 120, 20),
  (3, 2, 110, 24);

INSERT INTO observations (sensor_id, data_type, value, unit) VALUES
  (1, 'temperatura', 22.8, '°C'),
  (2, 'humedad', 55.3, '%');

INSERT INTO data_flows (source_node_id, target_node_id, payload, status) VALUES
  (1, 2, '{"evento": "sensor"}', 'completado'),
  (3, 2, '{"evento": "detección"}', 'pendiente');
