# Load dependencies - this script should only be called from main.ps1 or other scripts that have already loaded config and utils

$progressIdSettings = $Global:PROGRESS_IDS.Settings

$settingsTotalSteps = 3
$settingsCurrentStep = 0

$settingsCurrentStep++; $statusMessage = "Setting Host Information..."; Write-Progress -Activity "System Settings Configuration" -Status $statusMessage -PercentComplete (($settingsCurrentStep / $settingsTotalSteps) * 100) -Id $progressIdSettings
I "Setting Host Information..."
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
    I "Host Configured Successfully!"
} catch {
    E "Error configuring host file: $($_.Exception.Message)"
    throw $_ # Re-throw the exception to be caught by main.ps1
}

$settingsCurrentStep++; $statusMessage = "Configuring Sudo..."; Write-Progress -Activity "System Settings Configuration" -Status $statusMessage -PercentComplete (($settingsCurrentStep / $settingsTotalSteps) * 100) -Id $progressIdSettings
I "Configuring Sudo..."
sudo config --enable normal
if ($LASTEXITCODE -ne 0) {
    E "Error configuring sudo. Exit code: $LASTEXITCODE"
    # Optionally, exit the script or take other error handling actions
    throw "Error configuring sudo. Exit code: $LASTEXITCODE" # Re-throw to be caught by main.ps1
} else {
    I "Sudo Configured Successfully!"
}

$settingsCurrentStep++; $statusMessage = "Configuring Network for Winget..."; Write-Progress -Activity "System Settings Configuration" -Status $statusMessage -PercentComplete (($settingsCurrentStep / $settingsTotalSteps) * 100) -Id $progressIdSettings
I "Configuring Network for Winget..."
netsh int tcp set global autotuninglevel=normal
if ($LASTEXITCODE -ne 0) {
    E "Error configuring network for Winget. Exit code: $LASTEXITCODE"
    # Optionally, exit the script or take other error handling actions
    throw "Error configuring network for Winget. Exit code: $LASTEXITCODE" # Re-throw to be caught by main.ps1
} else {
    I "Network Configured."
}

Write-Progress -Activity "System Settings Configuration" -Completed -Id $progressIdSettings
