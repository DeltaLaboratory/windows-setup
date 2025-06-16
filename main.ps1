Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

I "Starting Configuration..."
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/modules/utils.ps1" | Invoke-Expression
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/configure/registry/system.ps1" | Invoke-Expression
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/configure/registry/hardening.ps1" | Invoke-Expression
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/configure/registry/browser.ps1" | Invoke-Expression
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/configure/registry/misc.ps1" | Invoke-Expression

Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/configure/settings/settings.ps1" | Invoke-Expression
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/configure/settings/powershell.ps1" | Invoke-Expression

Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/configure/winget.ps1" | Invoke-Expression

$STUB = "iex (iwr 'https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/configure/scoop.ps1' -UseBasicParsing).Content"
Start-Process powershell.exe -ArgumentList "-NoExit -ExecutionPolicy Bypass -Command $STUB" -Wait