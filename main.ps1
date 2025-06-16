Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

I "Starting Configuration..."
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/modules/utils.ps1" | Invoke-Expression
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/modules/configure/registry/system.ps1" | Invoke-Expression
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/modules/configure/registry/hardening.ps1" | Invoke-Expression
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/modules/configure/registry/browser.ps1" | Invoke-Expression
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/modules/configure/registry/misc.ps1" | Invoke-Expression

Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/modules/configure/settings/settings.ps1" | Invoke-Expression
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/modules/configure/settings/powershell.ps1" | Invoke-Expression

Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/modules/configure/winget.ps1" | Invoke-Expression

$STUB = "iex (iwr 'https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/modules/configure/scoop.ps1' -UseBasicParsing).Content"
Start-Process powershell.exe -ArgumentList "-NoExit -ExecutionPolicy Bypass -Command $STUB" -Wait