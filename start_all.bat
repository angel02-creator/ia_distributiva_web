@echo off
REM Inicia ambos servidores en ventanas separadas (Windows)
SET SCRIPT_DIR=%~dp0

IF NOT EXIST "%SCRIPT_DIR%site\index.html" (
  echo No se encontro site\index.html.
  echo Asegurate de que el proyecto este en la carpeta site.
  pause
  exit /b 1
)

echo Abriendo servidor estatico (puerto 8000)...
start "Static Server" cmd /k "python "%SCRIPT_DIR%run_site.py""

echo Abriendo interfaz conexion (puerto 9000)...
start "WebApp Server" cmd /k "python "%SCRIPT_DIR%webapp\app.py""

echo Ambos servidores iniciados en nuevas ventanas de consola.
pause
