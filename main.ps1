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

$mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Starting System Registry Configuration..." -PercentComplete ([Math]::Min(100, (($mainCurrentStep / $mainTotalSteps) * 100))) -Id $progressIdMain

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

Write-SectionHeader "REGISTRY CONFIGURATION" "🔧"

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

Write-SectionHeader "SYSTEM SETTINGS" "⚙️"

$mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring System Settings..." -PercentComplete ([Math]::Min(100, (($mainCurrentStep / $mainTotalSteps) * 100))) -Id $progressIdMain
Invoke-SafeStep -StepName "System Settings Configuration" -Description "System Settings Configuration" -Action {
    Invoke-RemoteScript -Url $Global:SETTINGS_GENERAL_URL -Description "System Settings Configuration"
}

$mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring PowerShell Settings..." -PercentComplete ([Math]::Min(100, (($mainCurrentStep / $mainTotalSteps) * 100))) -Id $progressIdMain
Invoke-SafeStep -StepName "PowerShell Profile Configuration" -Description "PowerShell Settings Configuration" -Action {
    Invoke-RemoteScript -Url $Global:SETTINGS_POWERSHELL_URL -Description "PowerShell Settings Configuration"
}

Write-SectionHeader "PACKAGE MANAGERS" "📦"

$mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring Winget Packages..." -PercentComplete ([Math]::Min(100, (($mainCurrentStep / $mainTotalSteps) * 100))) -Id $progressIdMain
Invoke-SafeStep -StepName "Winget Package Configuration" -Description "Winget Package Configuration" -Action {
    Invoke-RemoteScript -Url $Global:WINGET_CONFIG_URL -Description "Winget Package Configuration"
}

Write-SectionHeader "SCOOP PACKAGES" "🪣"

$mainCurrentStep++; Write-Progress -Activity "Main Setup Progress" -Status "Configuring Scoop Packages..." -PercentComplete ([Math]::Min(100, (($mainCurrentStep / $mainTotalSteps) * 100))) -Id $progressIdMain
$scoopSuccess = Invoke-SafeStep -StepName "Scoop Package Configuration" -Description "Scoop Package Configuration" -Action {
    $STUB = "iex (iwr '$Global:SCOOP_CONFIG_URL' -UseBasicParsing).Content"
    Start-Process powershell.exe -ArgumentList "-NoExit -ExecutionPolicy Bypass -Command `$STUB" -Wait
    if ($LASTEXITCODE -ne 0) {
        throw "Error executing scoop.ps1. Exit code: $LASTEXITCODE"
    }
}

# Display comprehensive completion summary
Write-Host ""
$totalSteps = $script:SuccessfulSteps.Count + $script:FailedSteps.Count
$successRate = if ($totalSteps -gt 0) { [Math]::Round(($script:SuccessfulSteps.Count / $totalSteps) * 100, 1) } else { 0 }

if ($script:FailedSteps.Count -eq 0) {
    Write-BoxedHeader "🎉 SETUP COMPLETED SUCCESSFULLY!" "Green" 60
    Write-StatusLine "✅" "All configurations completed successfully." "Green"
} else {
    Write-BoxedHeader "⚠️ SETUP COMPLETED WITH WARNINGS" "Yellow" 60
    Write-StatusLine "📊" "Success Rate: $successRate% ($($script:SuccessfulSteps.Count)/$totalSteps steps)" "Yellow"
}

Write-StatusLine "📝" "Registry changes logged to: ~/Documents/RegistryChanges.jsonl" "Cyan"
Write-StatusLine "🔄" "System restart recommended for all changes to take effect." "Yellow"

# Display successful steps
if ($script:SuccessfulSteps.Count -gt 0) {
    Write-Host ""
    Write-StatusLine "✅" "Successful Steps:" "Green"
    foreach ($step in $script:SuccessfulSteps) {
        Write-StatusLine "  ▫️" $step "Green"
    }
}

# Display failed steps and errors
if ($script:FailedSteps.Count -gt 0) {
    Write-Host ""
    Write-StatusLine "❌" "Failed Steps:" "Red"
    foreach ($step in $script:FailedSteps) {
        Write-StatusLine "  ▫️" $step "Red"
    }
    
    Write-Host ""
    Write-StatusLine "🔍" "Error Details:" "Yellow"
    foreach ($error in $script:ErrorSummary) {
        Write-StatusLine "  📍" "$($error.Step): $($error.Error)" "Red"
    }
    
    Write-Host ""
    Write-StatusLine "💡" "Some steps failed, but setup continued. Review the errors above." "Yellow"
    Write-StatusLine "🔧" "You can manually run failed steps or re-run the entire setup." "Cyan"
}

Write-Progress -Activity "Main Setup Progress" -Completed -Id $progressIdMain
