Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Load configuration and utilities
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/modules/config.ps1" | Invoke-Expression
Invoke-RestMethod -Uri $Global:UTILS_URL | Invoke-Expression

# Clear screen and show main header
Clear-Host
Write-BoxedHeader "🖥️ WINDOWS SYSTEM CONFIGURATION" "Cyan" 70

$progressIdMain = $Global:PROGRESS_IDS.Main
$mainCurrentStep = 0
$mainTotalSteps = 8

Write-StatusLine "🚀" "Starting Windows Setup Configuration..." "Green"
Write-StatusLine "📊" "Total Steps: $mainTotalSteps" "DarkGray"
Write-Host ""

$mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Starting System Registry Configuration..." -PercentComplete (($mainCurrentStep / $mainTotalSteps) * 100) -Id $progressIdMain

try {
    Write-SectionHeader "REGISTRY CONFIGURATION" "🔧"

    $mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring System Registry..." -PercentComplete (($mainCurrentStep / $mainTotalSteps) * 100) -Id $progressIdMain
    Write-ProgressStep "Executing System Registry Configuration..." "IN_PROGRESS"
    Invoke-RemoteScript -Url $Global:REGISTRY_SYSTEM_URL -Description "System Registry Configuration"
    Write-ProgressStep "System Registry Configuration completed" "SUCCESS"

    $mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring Hardening Registry Settings..." -PercentComplete (($mainCurrentStep / $mainTotalSteps) * 100) -Id $progressIdMain
    Write-ProgressStep "Executing Security Hardening Configuration..." "IN_PROGRESS"
    Invoke-RemoteScript -Url $Global:REGISTRY_HARDENING_URL -Description "Hardening Registry Configuration"
    Write-ProgressStep "Security Hardening Configuration completed" "SUCCESS"

    $mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring Browser Registry Settings..." -PercentComplete (($mainCurrentStep / $mainTotalSteps) * 100) -Id $progressIdMain
    Write-ProgressStep "Executing Browser Configuration..." "IN_PROGRESS"
    Invoke-RemoteScript -Url $Global:REGISTRY_BROWSER_URL -Description "Browser Registry Configuration"
    Write-ProgressStep "Browser Configuration completed" "SUCCESS"

    $mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring Miscellaneous Registry Settings..." -PercentComplete (($mainCurrentStep / $mainTotalSteps) * 100) -Id $progressIdMain
    Write-ProgressStep "Executing Miscellaneous Registry Configuration..." "IN_PROGRESS"
    Invoke-RemoteScript -Url $Global:REGISTRY_MISC_URL -Description "Miscellaneous Registry Configuration"
    Write-ProgressStep "Miscellaneous Registry Configuration completed" "SUCCESS"

    Write-SectionHeader "SYSTEM SETTINGS" "⚙️"

    $mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring System Settings..." -PercentComplete (($mainCurrentStep / $mainTotalSteps) * 100) -Id $progressIdMain
    Write-ProgressStep "Executing System Settings Configuration..." "IN_PROGRESS"
    Invoke-RemoteScript -Url $Global:SETTINGS_GENERAL_URL -Description "System Settings Configuration"
    Write-ProgressStep "System Settings Configuration completed" "SUCCESS"

    $mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring PowerShell Settings..." -PercentComplete (($mainCurrentStep / $mainTotalSteps) * 100) -Id $progressIdMain
    Write-ProgressStep "Executing PowerShell Profile Configuration..." "IN_PROGRESS"
    Invoke-RemoteScript -Url $Global:SETTINGS_POWERSHELL_URL -Description "PowerShell Settings Configuration"
    Write-ProgressStep "PowerShell Profile Configuration completed" "SUCCESS"

    Write-SectionHeader "PACKAGE MANAGERS" "📦"

    $mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring Winget Packages..." -PercentComplete (($mainCurrentStep / $mainTotalSteps) * 100) -Id $progressIdMain
    Write-ProgressStep "Executing Winget Package Configuration..." "IN_PROGRESS"
    Invoke-RemoteScript -Url $Global:WINGET_CONFIG_URL -Description "Winget Package Configuration"
    Write-ProgressStep "Winget Package Configuration completed" "SUCCESS"
} catch {
    Write-Host ""
    Write-BoxedHeader "❌ CONFIGURATION ERROR" "Red" 50
    E "An error occurred during script execution: $($_.Exception.Message)"
    Write-Progress -Activity "Main Setup Progress" -Status "Error during script execution" -Completed -Id $progressIdMain
    Read-Host "Press Enter to acknowledge this error and exit..."
    exit 1
}

Write-SectionHeader "SCOOP PACKAGES" "🪣"

$mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring Scoop Packages..." -PercentComplete (($mainCurrentStep / $mainTotalSteps) * 100) -Id $progressIdMain
Write-ProgressStep "Launching Scoop Package Configuration..." "IN_PROGRESS"
$STUB = "iex (iwr '$Global:SCOOP_CONFIG_URL' -UseBasicParsing).Content"
Start-Process powershell.exe -ArgumentList "-NoExit -ExecutionPolicy Bypass -Command `$STUB" -Wait
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-BoxedHeader "❌ SCOOP ERROR" "Red" 40
    E "Error executing scoop.ps1. Exit code: $LASTEXITCODE"
    Write-Progress -Activity "Main Setup Progress" -Status "Error executing scoop.ps1" -Completed -Id $progressIdMain
    Read-Host "Press Enter to acknowledge this error and exit..."
    exit 1
} else {
    Write-ProgressStep "Scoop Package Configuration completed" "SUCCESS"
}

Write-Host ""
Write-BoxedHeader "🎉 SETUP COMPLETED SUCCESSFULLY!" "Green" 60
Write-StatusLine "✅" "All configurations completed successfully." "Green"
Write-StatusLine "📝" "Registry changes logged to: ~/Documents/RegistryChanges.jsonl" "Cyan"
Write-StatusLine "🔄" "System restart recommended for all changes to take effect." "Yellow"
Write-Progress -Activity "Main Setup Progress" -Completed -Id $progressIdMain
