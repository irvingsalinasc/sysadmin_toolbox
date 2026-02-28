Write-Host @"
==============================================
        NetScannerX v1.0 - Escaner de Red
==============================================
By Irving Salinas
"@ -ForegroundColor Cyan

$networkPrefix = Read-Host "Introduce el segmento de red (Ejemplo: 192.168.1)"

$ips = 1..254
$totalIPs = $ips.Count

Write-Host "`nIniciando escaneo optimizado en $networkPrefix.0/24..." -ForegroundColor Yellow

$count = 0

foreach ($ip in $ips) {
    $count++
    $progress = [math]::Round(($count / $totalIPs) * 100, 2)
    Write-Progress -Activity "Escaneando red..." -Status "Progreso: $progress% - Probando: $networkPrefix.$ip" -PercentComplete $progress

    $fullIP = "$networkPrefix.$ip"
    
    # AJUSTE: Timeout de 2 segundos y paquete pequeño de 32 bytes para más éxito
    $ping = Test-Connection -ComputerName $fullIP -Count 1 -Quiet -TimeoutSeconds 2 -BufferSize 32 -ErrorAction SilentlyContinue

    if ($ping) {
        Write-Host "✔ [ACTIVA]   $fullIP" -ForegroundColor Green
    } else {
        # Si prefieres una pantalla más limpia, puedes comentar la línea de abajo con un #
        Write-Host "✘ [INACTIVA] $fullIP" -ForegroundColor Red
    }
}

Write-Host "`nEscaneo completado." -ForegroundColor
