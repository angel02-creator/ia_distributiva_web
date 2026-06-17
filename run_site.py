import http.server
import os
import socketserver
import webbrowser

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
SITE_DIR = os.path.join(BASE_DIR, 'site')
PORT = 8000

if not os.path.exists(SITE_DIR):
    os.makedirs(os.path.join(SITE_DIR, 'assets', 'images'), exist_ok=True)
    print('Se creó la carpeta site/ con subcarpetas necesarias.')

index_file = os.path.join(SITE_DIR, 'index.html')
if not os.path.exists(index_file):
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
