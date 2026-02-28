Write-Host @"
============================================
      NetScannerX v2.0 - Universal
============================================
By Irving Salinas
"@ -ForegroundColor Cyan

$networkPrefix = Read-Host "Introduce el segmento de red (Ejemplo: 192.168.1)"
$logDir = "C:\scripts_logs"
$logFile = "$logDir\netscan.txt"

if (!(Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir | Out-Null }
"Escaneo realizado el: $(Get-Date)" | Out-File -FilePath $logFile

$ips = 1..254
$activos = 0

Write-Host "`nBuscando equipos en $networkPrefix.0/24..." -ForegroundColor Yellow

foreach ($ip in $ips) {
    $fullIP = "$networkPrefix.$ip"
    Write-Progress -Activity "Escaneando..." -Status "Probando: $fullIP" -PercentComplete ([math]::Round(($ip/254)*100, 2))

    # Usamos parámetros básicos que no fallan en PS 5.1
    # -Count 1 (un solo intento)
    # -ErrorAction SilentlyContinue (si falla, no grites)
    $ping = Test-Connection -ComputerName $fullIP -Count 1 -Quiet -ErrorAction SilentlyContinue
    
    $hostName = ""
    if (!$ping) {
        try {
            $hostName = [System.Net.Dns]::GetHostEntry($fullIP).HostName
            if ($hostName) { $ping = $true } 
        } catch { $ping = $false }
    }

    if ($ping) {
        if ($hostName -ne "") {
            $msg = "✔ [ACTIVA]   $fullIP - Nombre: $hostName"
        } else {
            $msg = "✔ [ACTIVA]   $fullIP"
        }
        Write-Host $msg -ForegroundColor Green
        $msg | Out-File -Append -FilePath $logFile
        $activos++
    }
}

Write-Host "`nEscaneo finalizado. Equipos encontrados: $activos" -ForegroundColor Cyan
Write-Host "Log guardado en: $logFile"
