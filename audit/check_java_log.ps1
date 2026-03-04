$ServerName = "192.168.1.73"  # Reemplázalo con el nombre o IP del servidor
$LogName = "Application"
$Keyword = "java"

# Ejecutar el comando en el servidor remoto
Invoke-Command -ComputerName $ServerName -ScriptBlock {
    param ($LogName, $Keyword)

    $Events = Get-WinEvent -LogName $LogName | Where-Object {
        ($_.Message -match "java" -or $_.Message -match "JVM" -or $_.Message -match "java.exe")
    }

    if ($Events) {
        "Eventos relacionados con Java encontrados en '$LogName':"
        $Events | ForEach-Object {
            "Fecha: $($_.TimeCreated)"
            "ID de Evento: $($_.Id)"
            "Origen: $($_.ProviderName)"
            "Mensaje: $($_.Message)"
            "-------------------------------------"
        }
    } else {
        "No se encontraron eventos relacionados con Java."
    }
} -ArgumentList $LogName, $Keyword
