<#
.SYNOPSIS
    Network Connections Auditor (Fintech Grade).

.DESCRIPTION
    Script de grado empresarial utilizado para auditorías de red en entornos críticos. 
    Automatiza la correlación de sockets TCP/UDP con servicios de Windows y procesos activos, 
    facilitando la detección de puertos no autorizados en entornos de alta seguridad.

.NOTES
    Autor: Irving Salinas
    Versión: 1.0
    Requisitos: Ejecutar como Administrador para obtener detalles de procesos del sistema.

 Funcionalidades Clave
- **Correlación de Procesos:** Vincula cada puerto abierto con el servicio de Windows específico y su PID.
- **Auditoría de Seguridad:** Identifica procesos activos que están escuchando en interfaces de red.
- **Diseñado para Fintech:** Ideal para revisiones de seguridad rápidas en servidores bajo normativas estrictas.
- **Exportación de Datos:** Genera reportes estructurados para análisis posterior.
#>

# Combine TCP and UDP connections
$connections = @()

# TCP Connections - Include ALL states for complete picture
$connections += Get-NetTCPConnection | Where-Object {
    $_.LocalAddress -notlike "*:*" -and
    ($_.State -eq "Listen" -or $_.State -eq "Established" -or $_.State -eq "TimeWait" -or $_.State -eq "CloseWait")
} | Select-Object @{
    Name="Protocol"
    Expression={"TCP"}
}, @{
    Name="LocalAddress"
    Expression={$_.LocalAddress}
}, @{
    Name="LocalPort"
    Expression={$_.LocalPort}
}, @{
    Name="RemoteAddress"
    Expression={if($_.RemoteAddress -eq "0.0.0.0"){"*"}else{$_.RemoteAddress}}
}, @{
    Name="RemotePort"
    Expression={if($_.RemotePort -eq 0){"*"}else{$_.RemotePort}}
}, State, @{
    Name="ProcessID"
    Expression={$_.OwningProcess}
}, @{
    Name="ProcessName"
    Expression={(Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).ProcessName}
}, @{
    Name="ServiceName"
    Expression={
        $proc = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue
        if($proc) {
            $service = Get-WmiObject Win32_Service | Where-Object {$_.ProcessId -eq $proc.Id}
            if($service) {$service.Name} else {"N/A"}
        }
    }
}

# UDP Endpoints
$connections += Get-NetUDPEndpoint | Where-Object {
    $_.LocalAddress -notlike "*:*"
} | Select-Object @{
    Name="Protocol"
    Expression={"UDP"}
}, @{
    Name="LocalAddress"
    Expression={$_.LocalAddress}
}, @{
    Name="LocalPort"
    Expression={$_.LocalPort}
}, @{
    Name="RemoteAddress"
    Expression={"*"}
}, @{
    Name="RemotePort"
    Expression={"*"}
}, @{
    Name="State"
    Expression={"LISTENING"}
}, @{
    Name="ProcessID"
    Expression={$_.OwningProcess}
}, @{
    Name="ProcessName"
    Expression={(Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).ProcessName}
}, @{
    Name="ServiceName"
    Expression={
        $proc = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue
        if($proc) {
            $service = Get-WmiObject Win32_Service | Where-Object {$_.ProcessId -eq $proc.Id}
            if($service) {$service.Name} else {"N/A"}
        }
    }
}

# Add timestamp and hostname for audit trail
$auditInfo = @{
    Hostname = $env:COMPUTERNAME
    Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    TotalConnections = $connections.Count
}

# Display results
Write-Host "Network Connections Report for $($auditInfo.Hostname) at $($auditInfo.Timestamp)" -ForegroundColor Green
Write-Host "Total Connections: $($auditInfo.TotalConnections)" -ForegroundColor Yellow
Write-Host ""

# Display combined results
$connections | Sort-Object Protocol, LocalPort | Format-Table -AutoSize
