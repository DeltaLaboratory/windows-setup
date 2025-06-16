Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/main.ps1" | Invoke-Expression
