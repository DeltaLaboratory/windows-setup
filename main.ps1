Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Load configuration and utilities
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/modules/config.ps1" | Invoke-Expression
Invoke-RestMethod -Uri $Global:UTILS_URL | Invoke-Expression

$progressIdMain = $Global:PROGRESS_IDS.Main
$mainCurrentStep = 0
$mainTotalSteps = 8

$mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Starting System Registry Configuration..." -PercentComplete (($mainCurrentStep / $mainTotalSteps) * 100) -Id $progressIdMain
I "Starting Configuration..."

try {
    $mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring System Registry..." -PercentComplete (($mainCurrentStep / $mainTotalSteps) * 100) -Id $progressIdMain
    Invoke-RemoteScript -Url $Global:REGISTRY_SYSTEM_URL -Description "System Registry Configuration"

    $mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring Hardening Registry Settings..." -PercentComplete (($mainCurrentStep / $mainTotalSteps) * 100) -Id $progressIdMain
    Invoke-RemoteScript -Url $Global:REGISTRY_HARDENING_URL -Description "Hardening Registry Configuration"

    $mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring Browser Registry Settings..." -PercentComplete (($mainCurrentStep / $mainTotalSteps) * 100) -Id $progressIdMain
    Invoke-RemoteScript -Url $Global:REGISTRY_BROWSER_URL -Description "Browser Registry Configuration"

    $mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring Miscellaneous Registry Settings..." -PercentComplete (($mainCurrentStep / $mainTotalSteps) * 100) -Id $progressIdMain
    Invoke-RemoteScript -Url $Global:REGISTRY_MISC_URL -Description "Miscellaneous Registry Configuration"

    $mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring System Settings..." -PercentComplete (($mainCurrentStep / $mainTotalSteps) * 100) -Id $progressIdMain
    Invoke-RemoteScript -Url $Global:SETTINGS_GENERAL_URL -Description "System Settings Configuration"

    $mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring PowerShell Settings..." -PercentComplete (($mainCurrentStep / $mainTotalSteps) * 100) -Id $progressIdMain
    Invoke-RemoteScript -Url $Global:SETTINGS_POWERSHELL_URL -Description "PowerShell Settings Configuration"

    $mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring Winget Packages..." -PercentComplete (($mainCurrentStep / $mainTotalSteps) * 100) -Id $progressIdMain
    Invoke-RemoteScript -Url $Global:WINGET_CONFIG_URL -Description "Winget Package Configuration"
} catch {
    E "An error occurred during script execution: $($_.Exception.Message)"
    Write-Progress -Activity "Main Setup Progress" -Status "Error during script execution" -Completed -Id $progressIdMain
    Read-Host "Press Enter to acknowledge this error and exit..."
    exit 1
}

$mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring Scoop Packages..." -PercentComplete (($mainCurrentStep / $mainTotalSteps) * 100) -Id $progressIdMain
$STUB = "iex (iwr '$Global:SCOOP_CONFIG_URL' -UseBasicParsing).Content"
Start-Process powershell.exe -ArgumentList "-NoExit -ExecutionPolicy Bypass -Command `$STUB" -Wait
if ($LASTEXITCODE -ne 0) {
    E "Error executing scoop.ps1. Exit code: $LASTEXITCODE"
    Write-Progress -Activity "Main Setup Progress" -Status "Error executing scoop.ps1" -Completed -Id $progressIdMain # Mark as completed to remove
    Read-Host "Press Enter to acknowledge this error and exit..."
    exit 1
}

I "All configurations completed successfully."
Write-Progress -Activity "Main Setup Progress" -Completed -Id $progressIdMain
