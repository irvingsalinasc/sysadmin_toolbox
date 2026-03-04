# ==============================================================================
# Script: Diagnóstico de Eventos Local (Event Viewer)
# Autor: Irving Adair Salinas Cervantes
# Perfil: IT Infrastructure Engineer
# ==============================================================================

# 1. Parámetros de búsqueda (Personalizables)
$LogName   = "System"              # Opciones: "System", "Application", "Security"
$Keywords  = "java", "error", "failed", "critical", "disk" # Palabras clave
$HoursBack = 24                    # Tiempo a revisar hacia atrás

# 2. Configuración de Archivo de Salida
$LogPath    = "C:\scripts_logs"
$OutputFile = "$LogPath\EventCheck_Local_$(Get-Date -Format 'yyyyMMdd_HHmm').txt"

# Crear carpeta si no existe
if (!(Test-Path $LogPath)) { New-Item -ItemType Directory -Path $LogPath | Out-Null }

Write-Host "--- Iniciando escaneo local en el log: $LogName ---" -ForegroundColor Cyan
Write-Host "Buscando términos: $($Keywords -join ', ')" -ForegroundColor Gray

# 3. Obtención y filtrado de eventos (Optimizado para velocidad)
$StartTime = (Get-Date).AddHours(-$HoursBack)

try {
    # Obtenemos los eventos y filtramos por fecha y palabras clave en el mensaje
    $Events = Get-WinEvent -LogName $LogName -ErrorAction SilentlyContinue | Where-Object {
        $_.TimeCreated -ge $StartTime -and 
        ($_.Message -match ($Keywords -join "|"))
    }

    # 4. Procesamiento y Visualización
    if ($Events) {
        $Header = "REPORTE DE EVENTOS: Se encontraron $($Events.Count) incidencias."
        Write-Host $Header -ForegroundColor Yellow
        $Header | Out-File -FilePath $OutputFile

        foreach ($Event in $Events) {
            $Entry = @"
------------------------------------------------------------
Fecha: $($Event.TimeCreated)
ID de Evento: $($Event.Id)
Nivel: $($Event.LevelDisplayName)
Origen: $($Event.ProviderName)
Mensaje: $($Event.Message)
------------------------------------------------------------
"@
            Write-Host $Entry
            $Entry | Out-File -FilePath $OutputFile -Append
        }
        Write-Host "`nDiagnóstico completado. Reporte guardado en: $OutputFile" -ForegroundColor Green
    } else {
        Write-Host "No se encontraron eventos que coincidan con los criterios en las últimas $HoursBack horas." -ForegroundColor White
    }
} catch {
    Write-Host "Error: No se pudo acceder al log '$LogName'. ¿Tienes permisos de Administrador?" -ForegroundColor Red
}
