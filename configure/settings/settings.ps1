# Load dependencies - this script should only be called from main.ps1 or other scripts that have already loaded config and utils

Write-BoxedHeader "[CONFIG] SYSTEM SETTINGS CONFIGURATION" "Green" 60

$progressIdSettings = $Global:PROGRESS_IDS.Settings
$settingsTotalSteps = 3
$settingsCurrentStep = 0

Write-StatusLine "[FIX]" "Configuring system-level settings..." "Yellow"
Write-StatusLine "[STATS]" "Total Configuration Groups: $settingsTotalSteps" "DarkGray"
Write-Host ""

$settingsCurrentStep++; $statusMessage = "Setting Host Information..."; Write-Progress -Activity "System Settings Configuration" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($settingsCurrentStep / $settingsTotalSteps) * 100))) -Id $progressIdSettings
Write-SectionHeader "HOSTS FILE CONFIGURATION" "[NET]"
I "Setting Host Information..."
Write-StatusLine "[BLOCKED]" "Adding ad-blocking entries to hosts file..." "Cyan"
try {
    Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value @"
0.0.0.0 ad.kakao.com
0.0.0.0 ad.daum.net
0.0.0.0 analytics.ad.daum.net
0.0.0.0 display.ad.daum.net

0.0.0.0 pipe.aria.microsoft.com
0.0.0.0 assets.msn.com
0.0.0.0 web.vortex.data.microsoft.com
0.0.0.0 browser.events.data.msn.com
0.0.0.0 www.msn.com
0.0.0.0 sb.scorecardresearch.com
"@ -Force -Encoding utf8 -ErrorAction Stop
    Write-Success "Host file configured successfully!"
} catch {
    E "Error configuring host file: $($_.Exception.Message)"
    throw $_
}

$settingsCurrentStep++; $statusMessage = "Configuring Sudo..."; Write-Progress -Activity "System Settings Configuration" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($settingsCurrentStep / $settingsTotalSteps) * 100))) -Id $progressIdSettings
Write-SectionHeader "SUDO CONFIGURATION" "[SECURE]"
I "Configuring Sudo..."
Write-StatusLine "[POWER]" "Enabling sudo for normal users..." "Cyan"
sudo config --enable normal
if ($LASTEXITCODE -ne 0) {
    E "Error configuring sudo. Exit code: $LASTEXITCODE"
    throw "Error configuring sudo. Exit code: $LASTEXITCODE"
} else {
    Write-Success "Sudo configured successfully!"
}

$settingsCurrentStep++; $statusMessage = "Configuring Network for Winget..."; Write-Progress -Activity "System Settings Configuration" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($settingsCurrentStep / $settingsTotalSteps) * 100))) -Id $progressIdSettings
Write-SectionHeader "NETWORK OPTIMIZATION" "[NET]"
I "Configuring Network for Winget..."
Write-StatusLine "[SIGNAL]" "Optimizing TCP auto-tuning for better performance..." "Cyan"
netsh int tcp set global autotuninglevel=normal
if ($LASTEXITCODE -ne 0) {
    E "Error configuring network for Winget. Exit code: $LASTEXITCODE"
    throw "Error configuring network for Winget. Exit code: $LASTEXITCODE"
} else {
    Write-Success "Network configuration completed successfully!"
}

Write-Progress -Activity "System Settings Configuration" -Completed -Id $progressIdSettings
Write-Host ""
Write-BoxedHeader "[OK] SYSTEM SETTINGS COMPLETED" "Green" 50
