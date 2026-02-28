$IP = "8.8.8.8" # Cambia por la IP a monitorear
$LogDir = "C:\ping_monitor"
$LogFile = "$LogDir\ping_monitor.txt" # Ruta del archivo de log

# --- NUEVA LÓGICA DE VALIDACIÓN ---
# Revisa si la carpeta existe, y si no, la crea
if (!(Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir | Out-Null
    Write-Host "Carpeta $LogDir creada exitosamente." -ForegroundColor Cyan
}
# ----------------------------------

while ($true) {
    $PingResult = Test-Connection -ComputerName $IP -Count 1 -ErrorAction SilentlyContinue
    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    if ($PingResult) {
        $TTL = $PingResult[0].ResponseTimeToLive
        $Time = $PingResult[0].Latency.TotalMilliseconds
        $Msg = "$TimeStamp - Respuesta OK de $IP - TTL: $TTL - Tiempo: ${Time}ms"
        
        Write-Host $Msg -ForegroundColor Green
        $Msg | Out-File -Append -FilePath $LogFile
    } else {
        $Msg = "$TimeStamp - PING FALLIDO a $IP"
        
        Write-Host $Msg -ForegroundColor Red
        $Msg | Out-File -Append -FilePath $LogFile
    }
    Start-Sleep -Seconds 1 # Ajusta el intervalo de monitoreo en segundos
}
