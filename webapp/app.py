import http.server
import os
import socketserver
from pathlib import Path
import urllib.parse

BASE_DIR = Path(__file__).resolve().parent
SITE_DIR = BASE_DIR.parent / 'site'
PORT = 9000

PROGRAM_HTML = '''<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Conexión IA Distributiva</title>
  <style>
    body { margin: 0; font-family: Arial, sans-serif; background: #07111f; color: #f4fbff; }
    header { padding: 1.5rem; background: #0f2f57; display: flex; gap: 1rem; align-items: center; }
    header h1 { margin: 0; font-size: 1.4rem; }
    .content { display: grid; grid-template-columns: 1fr; gap: 1.25rem; padding: 1.5rem; }
    .box { background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); border-radius: 18px; padding: 1.2rem; }
    .box pre { white-space: pre-wrap; word-break: break-word; font-size: 0.95rem; line-height: 1.5; color: #dbefff; }
    .iframe-wrapper { min-height: 520px; border-radius: 18px; overflow: hidden; border: 1px solid rgba(255,255,255,0.12); }
    iframe { width: 100%; height: 100%; min-height: 640px; border: none; }
    .footer { padding: 1.5rem; text-align: center; color: #9cc5ff; font-size: 0.95rem; }
    @media (max-width: 900px) { .content { padding: 1rem; } header { flex-direction: column; align-items: flex-start; } }
  </style>
</head>
<body>
  <header>
    <h1>Conexión IA Distributiva</h1>
  </header>
  <div class="content">
    <div class="box">
      <h2>Vista del programa</h2>
      <p>Esta interfaz conecta el servidor local con tu sitio web. Aquí puedes ver el contenido de la página principal y la estructura del proyecto.</p>
      <pre>Ruta de sitio: {site_path}
Servidor: http://127.0.0.1:{port}/
Página principal: http://127.0.0.1:{port}/program
Sitio web embebido: http://127.0.0.1:{port}/site/index.html</pre>
    </div>
    <div class="box iframe-wrapper">
      <iframe src="/site/index.html" title="Vista del sitio IA Distributiva"></iframe>
    </div>
  </div>
  <div class="footer">
    Sirviendo tu proyecto de IA distributiva de forma segura desde la carpeta local.
  </div>
</body>
</html>
'''.format(site_path=SITE_DIR, port=PORT)

class WebAppHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        parsed = urllib.parse.urlparse(self.path)
        if parsed.path in ('/', '/program'):
            self.send_response(200)
            self.send_header('Content-Type', 'text/html; charset=utf-8')
            self.end_headers()
            self.wfile.write(PROGRAM_HTML.encode('utf-8'))
            return
        if parsed.path.startswith('/site/'):
            return super().do_GET()
        if parsed.path == '/api/files':
            self.send_response(200)
            self.send_header('Content-Type', 'application/json; charset=utf-8')
            self.end_headers()
            files = [p.as_posix() for p in SITE_DIR.rglob('*') if p.is_file()]
            self.wfile.write(('{' + '"files": ' + str(files).replace("'", '"') + '}').encode('utf-8'))
            return
        return super().do_GET()

    def translate_path(self, path):
        if path.startswith('/site/'):
            relative_path = path[len('/site/'):]
            full_path = SITE_DIR / relative_path.lstrip('/')
            return str(full_path)
        return super().translate_path(path)

if __name__ == '__main__':
    if not SITE_DIR.exists():
        SITE_DIR.mkdir(parents=True, exist_ok=True)
        (SITE_DIR / 'assets' / 'images').mkdir(parents=True, exist_ok=True)
        print('Se crearon las carpetas site/ y site/assets/images/.')

    if not (SITE_DIR / 'index.html').exists():
        print('No se encontró site/index.html. Coloca el proyecto en la carpeta site y vuelve a ejecutar el servidor.')
        raise SystemExit(1)

    os.chdir(BASE_DIR)
    with socketserver.TCPServer(('127.0.0.1', PORT), WebAppHandler) as server:
        print(f'Servidor en http://127.0.0.1:{PORT}/')
        print('Abre /program para ver la conexión y el sitio embebido.')
        try:
            server.serve_forever()
        except KeyboardInterrupt:
            print('\nServidor detenido.')
