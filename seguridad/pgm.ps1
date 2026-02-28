# --- Inicio del Banner ---
$banner = @"
=====================================================================
   ad8888888888ba
  dP'         `"8b,
  8  ,aaa,       "Y888a     ,aaaa,     ,aaa,  ,aa,
  8  8' `8           "8baaaad""""baaaad""""baad""8b
  8  8   8              """"      """"      ""    8b
  8  8, ,8         ,aaaaaaaaaaaaaaaaaaaaaaaaddddd88P
  8  `"""'       ,d8""     PassGenMaster
  Yb,         ,ad8"   Creado por: Irving Salinas
   "Y8888888888P"                 
=====================================================================
"@


# --- Fin del Banner -

function Generate-Password {
    param (
        [int]$Length,
        [bool]$IncludeUppercase,
        [bool]$IncludeNumbers,
        [bool]$IncludeSpecialChars
    )

    $LowerChars = "abcdefghijklmnopqrstuvwxyz"
    $UpperChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    $Numbers = "0123456789"
    $SpecialChars = "!@#$%^&*()-_=+[]{}|;:,.<>?/"

    $CharacterPool = $LowerChars

    if ($IncludeUppercase) { $CharacterPool += $UpperChars }
    if ($IncludeNumbers) { $CharacterPool += $Numbers }
    if ($IncludeSpecialChars) { $CharacterPool += $SpecialChars }

    $Password = -join (1..$Length | ForEach-Object { $CharacterPool[(Get-Random -Maximum $CharacterPool.Length)] })
    return $Password
}

function Show-Menu {
    Clear-Host
    #Write-Host $banner -ForegroundColor Yellow
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "                  PassGenMaster" -ForegroundColor Green
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "`nSeleccione la longitud del password:" -ForegroundColor Yellow
    Write-Host "1) 8 caracteres"
    Write-Host "2) 16 caracteres"
    Write-Host "3) 24 caracteres"
    
    $lengthChoice = Read-Host "Ingrese una opcion (1-3)"
    
    switch ($lengthChoice) {
        "1" { $PasswordLength = 8 }
        "2" { $PasswordLength = 16 }
        "3" { $PasswordLength = 24 }
        default { Write-Host "Opción invalida, seleccione nuevamente."; Start-Sleep 2; Show-Menu }
    }

    Write-Host "`nSeleccione el tipo de caracteres:" -ForegroundColor Yellow
    $IncludeUppercase = (Read-Host "Incluir mayusculas? (s/n)").ToLower() -eq "s"
    $IncludeNumbers = (Read-Host "Incluir numeros? (s/n)").ToLower() -eq "s"
    $IncludeSpecialChars = (Read-Host "Incluir caracteres especiales? (s/n)").ToLower() -eq "s"

    $GeneratedPassword = Generate-Password -Length $PasswordLength -IncludeUppercase $IncludeUppercase -IncludeNumbers $IncludeNumbers -IncludeSpecialChars $IncludeSpecialChars

    Write-Host "`nSu clave generada es:" -ForegroundColor Green
    Write-Host $GeneratedPassword -ForegroundColor Magenta
    Write-Host "`n==================================================" -ForegroundColor Cyan
    Write-Host "By Irving Salinas" -ForegroundColor Yellow
    Write-Host "==================================================" -ForegroundColor Cyan
}

Show-Menu
