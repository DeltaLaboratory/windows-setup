Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

$progressIdMain = 1

Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/modules/utils.ps1" | Invoke-Expression
if ($LASTEXITCODE -ne 0 -or !$?) {
    Write-Error "Failed to load utils.ps1"
    Write-Progress -Activity "Main Setup Progress" -Status "Failed to load utils.ps1" -Completed -Id $progressIdMain # Mark as completed to remove
    Read-Host "Press Enter to acknowledge this error and exit..."
    exit 1
}

$mainCurrentStep = 0
$mainTotalSteps = 8

$mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Starting System Registry Configuration..." -PercentComplete (($mainCurrentStep / $mainTotalSteps) * 100) -Id $progressIdMain
I "Starting Configuration..."

try {
    $mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring System Registry..." -PercentComplete (($mainCurrentStep / $mainTotalSteps) * 100) -Id $progressIdMain
    Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/configure/registry/system.ps1" | Invoke-Expression

    $mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring Hardening Registry Settings..." -PercentComplete (($mainCurrentStep / $mainTotalSteps) * 100) -Id $progressIdMain
    Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/configure/registry/hardening.ps1" | Invoke-Expression

    $mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring Browser Registry Settings..." -PercentComplete (($mainCurrentStep / $mainTotalSteps) * 100) -Id $progressIdMain
    Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/configure/registry/browser.ps1" | Invoke-Expression

    $mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring Miscellaneous Registry Settings..." -PercentComplete (($mainCurrentStep / $mainTotalSteps) * 100) -Id $progressIdMain
    Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/configure/registry/misc.ps1" | Invoke-Expression

    $mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring System Settings..." -PercentComplete (($mainCurrentStep / $mainTotalSteps) * 100) -Id $progressIdMain
    Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/configure/settings/settings.ps1" | Invoke-Expression

    $mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring PowerShell Settings..." -PercentComplete (($mainCurrentStep / $mainTotalSteps) * 100) -Id $progressIdMain
    Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/configure/settings/powershell.ps1" | Invoke-Expression

    $mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring Winget Packages..." -PercentComplete (($mainCurrentStep / $mainTotalSteps) * 100) -Id $progressIdMain
    Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/configure/winget.ps1" | Invoke-Expression
} catch {
    E "An error occurred during script execution: $($_.Exception.Message)"
    Write-Progress -Activity "Main Setup Progress" -Status "Error during script execution" -Completed -Id $progressIdMain # Mark as completed to remove
    Read-Host "Press Enter to acknowledge this error and exit..."
    exit 1
}

$mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring Scoop Packages..." -PercentComplete (($mainCurrentStep / $mainTotalSteps) * 100) -Id $progressIdMain
$STUB = "iex (iwr 'https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/configure/scoop.ps1' -UseBasicParsing).Content"
Start-Process powershell.exe -ArgumentList "-NoExit -ExecutionPolicy Bypass -Command `$STUB" -Wait
if ($LASTEXITCODE -ne 0) {
    E "Error executing scoop.ps1. Exit code: $LASTEXITCODE"
    Write-Progress -Activity "Main Setup Progress" -Status "Error executing scoop.ps1" -Completed -Id $progressIdMain # Mark as completed to remove
    Read-Host "Press Enter to acknowledge this error and exit..."
    exit 1
}

I "All configurations completed successfully."
Write-Progress -Activity "Main Setup Progress" -Completed -Id $progressIdMain
