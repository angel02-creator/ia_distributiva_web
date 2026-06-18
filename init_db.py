import sqlite3
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
DB_DIR = BASE_DIR / 'db'
DB_DIR.mkdir(parents=True, exist_ok=True)
DB_PATH = DB_DIR / 'ia_distributiva.db'

schema = '''
PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS nodes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  node_type TEXT NOT NULL,
  location TEXT,
  capacity INTEGER,
  status TEXT DEFAULT 'activo',
  created_at DATETIME DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS sensors (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  node_id INTEGER NOT NULL,
  sensor_type TEXT NOT NULL,
  description TEXT,
  installed_at DATETIME DEFAULT (datetime('now')),
  FOREIGN KEY (node_id) REFERENCES nodes(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS models (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  node_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  version TEXT NOT NULL,
  accuracy REAL,
  last_updated DATETIME DEFAULT (datetime('now')),
  FOREIGN KEY (node_id) REFERENCES nodes(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS connections (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  source_node_id INTEGER NOT NULL,
  target_node_id INTEGER NOT NULL,
  bandwidth_mbps INTEGER,
  latency_ms INTEGER,
  secure INTEGER DEFAULT 1,
  created_at DATETIME DEFAULT (datetime('now')),
  FOREIGN KEY (source_node_id) REFERENCES nodes(id) ON DELETE CASCADE,
  FOREIGN KEY (target_node_id) REFERENCES nodes(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS observations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  sensor_id INTEGER NOT NULL,
  recorded_at DATETIME DEFAULT (datetime('now')),
  data_type TEXT NOT NULL,
  value REAL NOT NULL,
  unit TEXT,
  FOREIGN KEY (sensor_id) REFERENCES sensors(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS data_flows (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  source_node_id INTEGER NOT NULL,
  target_node_id INTEGER NOT NULL,
  payload TEXT,
  transmitted_at DATETIME DEFAULT (datetime('now')),
  status TEXT DEFAULT 'completado',
  FOREIGN KEY (source_node_id) REFERENCES nodes(id) ON DELETE CASCADE,
  FOREIGN KEY (target_node_id) REFERENCES nodes(id) ON DELETE CASCADE
);
'''

initial_inserts = '''
INSERT INTO nodes (name, node_type, location, capacity, status) VALUES
  ('Nodo de borde A', 'borde', 'Ciudad A', 120, 'activo'),
  ('Servidor central', 'nube', 'Centro de datos', 500, 'activo'),
  ('Nodo de borde B', 'borde', 'Ciudad B', 100, 'mantenimiento');

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
  (1, 2, '{"evento": "sensor"}', 'completado'),
  (3, 2, '{"evento": "detección"}', 'pendiente');
'''

if __name__ == '__main__':
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    cur.executescript(schema)
    conn.commit()
    try:
        cur.executescript(initial_inserts)
        conn.commit()
        print('Base de datos inicializada en', DB_PATH)
    except sqlite3.IntegrityError:
        print('Los datos iniciales ya existen o hubo un conflicto. La base de datos fue creada sin duplicados.')
    finally:
        conn.close()
