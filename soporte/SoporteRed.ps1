<#
.SYNOPSIS
    Kit de Soporte Técnico IASC - Versión Empresarial Completa
    Incluye: Datos de Usuario/Host, Ping Google, Speedtest y Apertura de Log.
#>

$ErrorActionPreference = "SilentlyContinue"
$logPath = "C:\scripts_logs"
$logFile = "$logPath\soportered.txt"

# --- 1. PREPARACIÓN DE INFRAESTRUCTURA DE LOGS ---
if (-not (Test-Path $logPath)) {
    New-Item -Path $logPath -ItemType Directory -Force | Out-Null
}

function Write-Log {
    param([string]$Message, [string]$Color = "White")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] $Message"
    Write-Host $Message -ForegroundColor $Color
    $logEntry | Out-File -FilePath $logFile -Append -Encoding utf8
}

Clear-Host
"--- INICIO DE SESIÓN DE SOPORTE ---" | Out-File -FilePath $logFile -Append -Encoding utf8

# --- 2. BANNER DE BIENVENIDA (User & Host) ---
Write-Host "===================================================" -ForegroundColor Cyan
Write-Log "      IASC - KIT DE SOPORTE TÉCNICO PROFESIONAL    " "White"
Write-Host "===================================================" -ForegroundColor Cyan
Write-Log "Usuario: $env:USERNAME | Equipo: $env:COMPUTERNAME" "Yellow"

# --- 3. INFORMACIÓN DE RED ---
Write-Log "`n[*] Obteniendo configuración de red..." "Cyan"
$IPInfo = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notmatch 'Loopback|vEthernet' } | Select-Object -First 1

if ($null -ne $IPInfo) {
    Write-Log "  > Dirección IP: $($IPInfo.IPv4Address)" "White"
    Write-Log "  > Interfaz:     $($IPInfo.InterfaceAlias)" "White"
}

# --- 4. SOLUCIONADOR MSDT ---
Write-Log "`n[*] Ejecutando Solucionador de Red de Windows (MSDT)..." "Cyan"
Start-Process "msdt.exe" -ArgumentList "/id NetworkDiagnosticsNetworkAdapter" -Wait
Write-Log "[✓] El proceso de diagnóstico MSDT ha finalizado." "Green"

# --- 5. PRUEBA DE INTERNET Y SPEEDTEST ---
Write-Log "`n[*] Verificando conexión a Internet..." "Cyan"
if (Test-Connection -ComputerName 8.8.8.8 -Count 2 -Quiet) {
    Write-Log " [✓] Conexión a Internet: EXITOSA (Ping a Google OK)" "Green"
} else {
    Write-Log " [X] Conexión a Internet: FALLIDA" "Red"
}

$SpeedtestPath = Join-Path -Path $PSScriptRoot -ChildPath "Speedtest.exe"
if (Test-Path $SpeedtestPath) {
    Write-Log "[*] Lanzando aplicación Speedtest..." "Yellow"
    Start-Process -FilePath $SpeedtestPath -Wait
    Write-Log "[✓] Prueba de velocidad cerrada." "Green"
}

# --- 6. AUDITORÍA DE SERVICIOS EMPRESARIALES ---
$Servicios = @(
    @{Nombre="Gateway Principal"; IP="172.20.20.1"},
    @{Nombre="Controlador de Dominio"; IP="172.20.20.10"},
    @{Nombre="Gateway Sucursal NLD"; IP="172.20.21.253"}
)

Write-Log "`n[*] Comprobando enlace con Servicios Empresariales..." "Cyan"
foreach ($Server in $Servicios) {
    $ping = Test-Connection -ComputerName $Server.IP -Count 2 -Quiet
    if ($ping) {
        Write-Log " [OK] $($Server.Nombre) ($($Server.IP)) responde correctamente." "Green"
    } else {
        Write-Log " [ERROR] Sin comunicación con $($Server.Nombre) ($($Server.IP))." "Red"
    }
}

# --- 7. CIERRE Y APERTURA DE LOG ---
Write-Log "`n===================================================" "Cyan"
Write-Log "      DIAGNÓSTICO FINALIZADO CON ÉXITO           " "White"
Write-Log "  Abriendo reporte: $logFile" "Yellow"
Write-Host "===================================================" -ForegroundColor Cyan

# Esta es la parte que querías añadir:
Start-Sleep -Seconds 1
if (Test-Path $logFile) {
    Start-Process "notepad.exe" -ArgumentList $logFile
}

Write-Host "`nPresiona cualquier tecla para cerrar esta ventana..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
