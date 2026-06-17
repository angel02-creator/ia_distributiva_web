-- Esquema SQL de ejemplo para un proyecto de IA distributiva
-- Crea las tablas principales que modelan nodos, sensores, conexiones y datos.

CREATE TABLE nodes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  node_type TEXT NOT NULL,
  location TEXT,
  capacity INTEGER,
  status TEXT DEFAULT 'activo',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sensors (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  node_id INTEGER NOT NULL,
  sensor_type TEXT NOT NULL,
  description TEXT,
  installed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (node_id) REFERENCES nodes(id) ON DELETE CASCADE
);

CREATE TABLE models (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  node_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  version TEXT NOT NULL,
  accuracy REAL,
  last_updated DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (node_id) REFERENCES nodes(id) ON DELETE CASCADE
);

CREATE TABLE connections (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  source_node_id INTEGER NOT NULL,
  target_node_id INTEGER NOT NULL,
  bandwidth_mbps INTEGER,
  latency_ms INTEGER,
  secure BOOLEAN DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (source_node_id) REFERENCES nodes(id) ON DELETE CASCADE,
  FOREIGN KEY (target_node_id) REFERENCES nodes(id) ON DELETE CASCADE
);

CREATE TABLE observations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  sensor_id INTEGER NOT NULL,
  recorded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  data_type TEXT NOT NULL,
  value REAL NOT NULL,
  unit TEXT,
  FOREIGN KEY (sensor_id) REFERENCES sensors(id) ON DELETE CASCADE
);

CREATE TABLE data_flows (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  source_node_id INTEGER NOT NULL,
  target_node_id INTEGER NOT NULL,
  payload TEXT,
  transmitted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  status TEXT DEFAULT 'completado',
  FOREIGN KEY (source_node_id) REFERENCES nodes(id) ON DELETE CASCADE,
  FOREIGN KEY (target_node_id) REFERENCES nodes(id) ON DELETE CASCADE
);

-- Ejemplos de datos iniciales
INSERT INTO nodes (name, node_type, location, capacity, status) VALUES
  ('Nodo de borde A', 'borde', 'Ciudad A', 120, 'activo'),
  ('Servidor central', 'nube', 'Centro de datos', 500, 'activo'),
  ('Nodo de borda B', 'borde', 'Ciudad B', 100, 'mantenimiento');

INSERT INTO sensors (node_id, sensor_type, description) VALUES
  (1, 'temperatura', 'Sensor de temperatura ambiente'),
  (1, 'humedad', 'Sensor de humedad'),
  (2, 'carga', 'Monitoreo de CPU del servidor');

INSERT INTO models (node_id, name, version, accuracy) VALUES
  (1, 'Clasificador de anomalías', '1.0.0', 0.93),
  (2, 'Predicción de tráfico', '2.1.0', 0.89);

INSERT INTO connections (source_node_id, target_node_id, bandwidth_mbps, latency_ms) VALUES
  (1, 2, 120, 20),
  (3, 2, 110, 24);

INSERT INTO observations (sensor_id, data_type, value, unit) VALUES
  (1, 'temperatura', 22.8, '°C'),
  (2, 'humedad', 55.3, '%');

INSERT INTO data_flows (source_node_id, target_node_id, payload, status) VALUES
  (1, 2, 'json: {"evento": "sensor"}', 'completado'),
  (3, 2, 'json: {"evento": "detección"}', 'pendiente');
