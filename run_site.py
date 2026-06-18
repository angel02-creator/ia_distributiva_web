import http.server
import os
import socketserver
import webbrowser
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
SITE_DIR = BASE_DIR / 'site'
PORT = 8000

if not SITE_DIR.exists():
    SITE_DIR.mkdir(parents=True, exist_ok=True)
    (SITE_DIR / 'assets' / 'images').mkdir(parents=True, exist_ok=True)
    print('Se creó la carpeta site/ con subcarpetas necesarias.')

index_file = SITE_DIR / 'index.html'
if not index_file.exists():
    print('No se encontró site/index.html. Coloca tu proyecto en la carpeta site y vuelve a ejecutar este script.')
    raise SystemExit(1)

os.chdir(SITE_DIR)

handler = http.server.SimpleHTTPRequestHandler
with socketserver.TCPServer(('127.0.0.1', PORT), handler) as httpd:
    url = f'http://127.0.0.1:{PORT}/'
    print('Sirviendo el sitio en:', url)
    print('Abriendo el navegador por defecto...')
    webbrowser.open(url)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print('\nServidor detenido.')
