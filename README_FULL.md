IA Distributiva - Guía completa para ejecutar localmente

Este repositorio contiene una demo web estática y dos servidores locales en Python para visualizarla.

Estructura principal

- `site/` — sitio web estático (index.html, assets, imágenes)
- `webapp/` — interfaz que embebe el sitio en `/program` (puerto 9000)
- `run_site.py` — servidor HTTP simple para `site/` (puerto 8000)
- `start_all.bat` — lanza ambos servidores en ventanas separadas (Windows)
- `init_db.py` — crea `db/ia_distributiva.db` con esquema SQLite y datos muestra
- `db/` — carpeta donde se almacena la base de datos SQLite
- `requirements.txt` — actualmente vacío (solo librería estándar de Python)

Requisitos

- Python 3.8+ instalado

Pasos rápidos

1) Crear un entorno virtual (opcional, recomendado)

```powershell
cd "c:\Users\Miguel Angel Soto\OneDrive\Documentos\ia_distributiva_web"
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```

2) Instalar dependencias (ninguna por ahora)

```powershell
pip install -r requirements.txt
```

3) Inicializar la base de datos local (opcional)

```powershell
python init_db.py
```

4) Iniciar los servidores

- Para servir solo el sitio en http://127.0.0.1:8000:

```powershell
python run_site.py
```

- Para abrir la interfaz con el sitio embebido en http://127.0.0.1:9000/program:

```powershell
python webapp\app.py
```

- Para iniciar ambos servidores en ventanas separadas (Windows):

```powershell
start_all.bat
```

Notas de seguridad

- Todo el código usa librerías estándar de Python y archivos locales. No se descargó nada externo automáticamente.
- Si decides instalar paquetes adicionales, revisa `requirements.txt` y usa entornos virtuales.

¿Quieres que inicie uno de los servidores ahora y verifique que la página se muestra?"