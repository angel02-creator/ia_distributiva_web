# Conexión Web para IA Distributiva

Este servidor local permite conectar tu sitio web de IA distributiva y visualizarlo dentro de una interfaz segura.

## Archivos

- `app.py` — servidor local en Python que sirve `site/index.html` dentro de un iframe y muestra información del proyecto.
- `start_webapp.bat` — lanzador para Windows.

## Uso

1. Asegúrate de que la carpeta `site` contiene `index.html` y los activos del proyecto.
2. Ejecuta `webapp\start_webapp.bat`.
3. Abre `http://127.0.0.1:9000/program` en el navegador.

No se necesitan descargas externas ni paquetes adicionales porque usa solo librerías estándar de Python.
