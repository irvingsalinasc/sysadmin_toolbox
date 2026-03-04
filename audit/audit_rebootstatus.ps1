# --- 1. VERIFICACIÓN DE BANDERAS DE REINICIO EN EL REGISTRO ---
Write-Host "Verificando estado de reinicio en el registro..." -ForegroundColor Cyan
$flags = [ordered]@{
 'WU RebootRequired'       = Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired'
 'CBS RebootPending'       = Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending'
 'CBS PackagesPending'     = Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\PackagesPending'
 'UpdateOrchestrator'      = Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\UpdateOrchestrator\RebootPending'
}
$flags | Out-String | Write-Host -ForegroundColor White

# --- 2. AUDITORÍA DE EVENTOS DE ENERGÍA Y REINICIOS (Últimas 24h) ---
Write-Host "`nBuscando eventos de apagado/reinicio (últimas 24h)..." -ForegroundColor Cyan
try {
    $systemEvents = Get-WinEvent -FilterHashtable @{
        LogName='System';
        ID=41,1074,1076;
        StartTime=(Get-Date).AddDays(-1)
    } -ErrorAction Stop

    $systemEvents | Format-List TimeCreated, Id, ProviderName, @{Name='Message';Expression={$_.Message -replace "`r`n",' '}}
} catch {
    Write-Host "[✓] No se encontraron eventos de reinicio o apagado inesperado recientemente." -ForegroundColor Green
}

# --- 3. RASTREO DE INSTALACIONES Y PARCHES (Últimas 48h) ---
$from = (Get-Date).AddDays(-2)
Write-Host "`nBuscando rastro de instalaciones WUSA/Servicing (desde $from)..." -ForegroundColor Cyan

try {
    $setupEvents = Get-WinEvent -FilterHashtable @{ LogName='Setup'; StartTime=$from } -ErrorAction Stop |
    Where-Object {
      $_.ProviderName -match 'wusa' -or
      $_.Message -match 'WUSA|Windows Update Standalone Installer|KB5063878|Microsoft-Windows-Servicing\d+'
    }

    if ($null -eq $setupEvents) { throw "No events found after filtering" }
    
    $setupEvents | Format-List TimeCreated, Id, ProviderName, Message
} catch {
    Write-Host "[✓] No hay registros de instalaciones recientes de parches o WUSA." -ForegroundColor Green
}
