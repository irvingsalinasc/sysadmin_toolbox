@echo off
:: Comprobar si tenemos permisos de Administrador
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Ejecutando como Administrador...
    goto :run
) else (
    echo Solicitando permisos de Administrador...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:run
:: Cambiar a la carpeta donde esta el script
cd /d "%~dp0"
:: Ejecutar el script de PowerShell (ajusta el nombre si es necesario)
powershell -ExecutionPolicy Bypass -File "SoporteRed.ps1"
pause
