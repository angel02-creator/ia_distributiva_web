@echo off
REM Inicia el servidor local de conexión para la página IA Distributiva
SET SCRIPT_DIR=%~dp0
SET SITE_DIR=%SCRIPT_DIR%..\site

IF NOT EXIST "%SITE_DIR%\index.html" (
  echo No se encontro site\index.html.
  echo Asegurate de que la carpeta site existe y contiene tu proyecto.
  pause
  exit /b 1
)

python "%SCRIPT_DIR%app.py"
IF %ERRORLEVEL% NEQ 0 (
  echo.
  echo No se pudo ejecutar Python. Asegurate de tener Python instalado.
  pause
)
