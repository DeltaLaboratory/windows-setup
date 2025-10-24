Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Load configuration and utilities
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main/modules/config.ps1" | Invoke-Expression
Invoke-RestMethod -Uri $Global:UTILS_URL | Invoke-Expression

# Clear screen and show main header
Clear-Host
Write-BoxedHeader "[PC] WINDOWS SYSTEM CONFIGURATION" "Cyan" 70

$progressIdMain = $Global:PROGRESS_IDS.Main
$mainCurrentStep = 0
$mainTotalSteps = 7

Write-StatusLine "[START]" "Starting Windows Setup Configuration..." "Green"
Write-StatusLine "[STATS]" "Total Steps: $mainTotalSteps" "DarkGray"
Write-Host ""

Write-Progress -Activity "Main Setup Progress" -Status "Starting System Registry Configuration..." -PercentComplete 0 -Id $progressIdMain

# Initialize error tracking
$script:ErrorSummary = @()
$script:SuccessfulSteps = @()
$script:FailedSteps = @()

# Helper function to execute steps with error handling
function Invoke-SafeStep {
    param(
        [string]$StepName,
        [string]$Description,
        [scriptblock]$Action
    )
    
    try {
        Write-ProgressStep "Executing $StepName..." "IN_PROGRESS"
        & $Action
        Write-ProgressStep "$StepName completed" "SUCCESS"
        $script:SuccessfulSteps += $StepName
        return $true
    } catch {
        Write-ProgressStep "$StepName failed" "ERROR"
        E "Error in ${StepName}: $($_.Exception.Message)"
        $script:ErrorSummary += @{
            Step = $StepName
            Description = $Description
            Error = $_.Exception.Message
            Timestamp = Get-Date
        }
        $script:FailedSteps += $StepName
        return $false
    }
}

Write-SectionHeader "REGISTRY CONFIGURATION" "[FIX]"

$mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring System Registry..." -PercentComplete ([Math]::Min(100, (($mainCurrentStep / $mainTotalSteps) * 100))) -Id $progressIdMain
Invoke-SafeStep -StepName "System Registry Configuration" -Description "System Registry Configuration" -Action {
    Invoke-RemoteScript -Url $Global:REGISTRY_SYSTEM_URL -Description "System Registry Configuration"
}

$mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring Hardening Registry Settings..." -PercentComplete ([Math]::Min(100, (($mainCurrentStep / $mainTotalSteps) * 100))) -Id $progressIdMain
Invoke-SafeStep -StepName "Security Hardening Configuration" -Description "Hardening Registry Configuration" -Action {
    Invoke-RemoteScript -Url $Global:REGISTRY_HARDENING_URL -Description "Hardening Registry Configuration"
}

$mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring Browser Registry Settings..." -PercentComplete ([Math]::Min(100, (($mainCurrentStep / $mainTotalSteps) * 100))) -Id $progressIdMain
Invoke-SafeStep -StepName "Browser Configuration" -Description "Browser Registry Configuration" -Action {
    Invoke-RemoteScript -Url $Global:REGISTRY_BROWSER_URL -Description "Browser Registry Configuration"
}

$mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring Miscellaneous Registry Settings..." -PercentComplete ([Math]::Min(100, (($mainCurrentStep / $mainTotalSteps) * 100))) -Id $progressIdMain
Invoke-SafeStep -StepName "Miscellaneous Registry Configuration" -Description "Miscellaneous Registry Configuration" -Action {
    Invoke-RemoteScript -Url $Global:REGISTRY_MISC_URL -Description "Miscellaneous Registry Configuration"
}

Write-SectionHeader "SYSTEM SETTINGS" "[CONFIG]"

$mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring System Settings..." -PercentComplete ([Math]::Min(100, (($mainCurrentStep / $mainTotalSteps) * 100))) -Id $progressIdMain
Invoke-SafeStep -StepName "System Settings Configuration" -Description "System Settings Configuration" -Action {
    Invoke-RemoteScript -Url $Global:SETTINGS_GENERAL_URL -Description "System Settings Configuration"
}

$mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring PowerShell Settings..." -PercentComplete ([Math]::Min(100, (($mainCurrentStep / $mainTotalSteps) * 100))) -Id $progressIdMain
Invoke-SafeStep -StepName "PowerShell Profile Configuration" -Description "PowerShell Settings Configuration" -Action {
    Invoke-RemoteScript -Url $Global:SETTINGS_POWERSHELL_URL -Description "PowerShell Settings Configuration"
}

Write-SectionHeader "PACKAGE MANAGERS" "[PACKAGE]"

$mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring Winget Packages..." -PercentComplete ([Math]::Min(100, (($mainCurrentStep / $mainTotalSteps) * 100))) -Id $progressIdMain
Invoke-SafeStep -StepName "Winget Package Configuration" -Description "Winget Package Configuration" -Action {
    Invoke-RemoteScript -Url $Global:WINGET_CONFIG_URL -Description "Winget Package Configuration"
}

# Display comprehensive completion summary
Write-Host ""
$totalSteps = $script:SuccessfulSteps.Count + $script:FailedSteps.Count
$successRate = if ($totalSteps -gt 0) { [Math]::Round(($script:SuccessfulSteps.Count / $totalSteps) * 100, 1) } else { 0 }

if ($script:FailedSteps.Count -eq 0) {
    Write-BoxedHeader "[SUCCESS] SETUP COMPLETED SUCCESSFULLY!" "Green" 60
    Write-StatusLine "[OK]" "All configurations completed successfully." "Green"
} else {
    Write-BoxedHeader "[WARN] SETUP COMPLETED WITH WARNINGS" "Yellow" 60
    Write-StatusLine "[STATS]" "Success Rate: $successRate% ($($script:SuccessfulSteps.Count)/$totalSteps steps)" "Yellow"
}

Write-StatusLine "[NOTE]" "Registry changes logged to: ~/Documents/RegistryChanges.jsonl" "Cyan"
Write-StatusLine "[REFRESH]" "System restart recommended for all changes to take effect." "Yellow"

# Display successful steps
if ($script:SuccessfulSteps.Count -gt 0) {
    Write-Host ""
    Write-StatusLine "[OK]" "Successful Steps:" "Green"
    foreach ($step in $script:SuccessfulSteps) {
        Write-StatusLine "  -" $step "Green"
    }
}

# Display failed steps and errors
if ($script:FailedSteps.Count -gt 0) {
    Write-Host ""
    Write-StatusLine "[ERROR]" "Failed Steps:" "Red"
    foreach ($step in $script:FailedSteps) {
        Write-StatusLine "  -" $step "Red"
    }
    
    Write-Host ""
    Write-StatusLine "[SEARCH]" "Error Details:" "Yellow"
    foreach ($error in $script:ErrorSummary) {
        Write-StatusLine "  [LOC]" "$($error.Step): $($error.Error)" "Red"
    }
    
    Write-Host ""
    Write-StatusLine "[HINT]" "Some steps failed, but setup continued. Review the errors above." "Yellow"
    Write-StatusLine "[FIX]" "You can manually run failed steps or re-run the entire setup." "Cyan"
}

Write-Progress -Activity "Complete" -Completed -Id $progressIdMain
