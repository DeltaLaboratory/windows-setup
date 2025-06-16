Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

I "Starting Configuration..."
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/modules/utils.ps1" | Invoke-Expression
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/modules/configure/registry/system.ps1" | Invoke-Expression
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/modules/configure/registry/hardening.ps1" | Invoke-Expression
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/modules/configure/registry/browser.ps1" | Invoke-Expression
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/modules/configure/registry/misc.ps1" | Invoke-Expression

Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/modules/configure/settings/settings.ps1" | Invoke-Expression
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/modules/configure/settings/powershell.ps1" | Invoke-Expression

Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/modules/configure/winget.ps1" | Invoke-Expression

$scriptUrl_A = "https://raw.githubusercontent.com/DeltaLaboratory/modules/configure/scoop.ps1"
$commandToExecute_A = "iex (iwr '$scriptUrl_A' -UseBasicParsing).Content"

Start-Process powershell.exe -ArgumentList "-NoExit -ExecutionPolicy Bypass -Command $commandToExecute_A"