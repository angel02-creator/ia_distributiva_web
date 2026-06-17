@echo off
REM Ejecuta la demo de IA distributiva desde la carpeta site
SET SCRIPT_DIR=%~dp0
SET SITE_DIR=%SCRIPT_DIR%site

IF NOT EXIST "%SITE_DIR%\index.html" (
  echo No se encontro site\index.html.
  echo Asegurate de que el proyecto este en la carpeta site.
  pause
  exit /b 1
)

python "%SCRIPT_DIR%run_site.py"
IF %ERRORLEVEL% NEQ 0 (
  echo.
  echo No se pudo ejecutar Python. Abriendo index.html directamente...
  start "" "%SITE_DIR%\index.html"
)
