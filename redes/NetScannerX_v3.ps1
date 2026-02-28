Write-Host @"
============================================
      NetScannerX v3.0 - TURBO MODE
============================================
By Irving Salinas
"@ -ForegroundColor Cyan

$networkPrefix = Read-Host "Introduce el segmento (Ej: 192.168.1)"
$logDir = "C:\scripts_logs"
$logFile = "$logDir\netscan.txt"

if (!(Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir | Out-Null }
"Escaneo Turbo realizado el: $(Get-Date)" | Out-File -FilePath $logFile

# Creamos la lista de todas las IPs primero
$allIPs = 1..254 | ForEach-Object { "$networkPrefix.$_" }

Write-Host "`nLanzando escaneo paralelo en $networkPrefix.0/24..." -ForegroundColor Yellow
Write-Host "Esto será MUCHO más rápido. Espera un momento...`n" -ForegroundColor Gray

# El truco: Test-Connection puede recibir un ARRAY de IPs y procesarlas más rápido
$resultados = Test-Connection -ComputerName $allIPs -Count 1 -AsJob | Wait-Job | Receive-Job

$activos = 0

foreach ($res in $resultados) {
    if ($res.ResponseTime -ne $null) {
        $ipActiva = $res.Address
        $msg = "✔ [ACTIVA]   $ipActiva"
        Write-Host $msg -ForegroundColor Green
        $msg | Out-File -Append -FilePath $logFile
        $activos++
    }
}

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "ESCANEO COMPLETADO" -ForegroundColor Cyan
Write-Host "Equipos encontrados: $activos" -ForegroundColor Green
Write-Host "Log guardado en: $logFile"
Write-Host "============================================" -ForegroundColor Cyan
