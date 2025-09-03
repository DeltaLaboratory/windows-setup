# Load dependencies - this script should only be called from main.ps1 or other scripts that have already loaded config and utils

Write-BoxedHeader "📦 WINGET PACKAGE MANAGER" "DarkCyan" 60

$progressIdWinget = $Global:PROGRESS_IDS.Winget
$wingetTotalSteps = 8
$wingetCurrentStep = 0

Write-StatusLine "📋" "Installing and configuring essential applications..." "Yellow"
Write-StatusLine "📊" "Total Package Groups: $wingetTotalSteps" "DarkGray"
Write-Host ""

$wingetCurrentStep++; $statusMessage = "Starting Winget Configuration..."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($wingetCurrentStep / $wingetTotalSteps) * 100))) -Id $progressIdWinget
Write-SectionHeader "WINGET INSTALLATION & SETUP" "🔧"
I $statusMessage

# Ensure Winget is installed
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    $statusMessage = "Winget not found. Installing prerequisites and Winget..."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($wingetCurrentStep / $wingetTotalSteps) * 100))) -Id $progressIdWinget
    Write-StatusLine "❌" "Winget not found. Installing prerequisites..." "Yellow"

    Write-StatusLine "📦" "Installing Microsoft VCLibs Desktop Framework Package..." "Cyan"
    $vcLibsUrl = "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx"
    $vcLibsInstallerPath = "$env:TEMP\Microsoft.VCLibs.x64.14.00.Desktop.appx"
    try {
        (New-Object Net.WebClient).DownloadFile($vcLibsUrl, $vcLibsInstallerPath)
        Add-AppxPackage -Path $vcLibsInstallerPath -ErrorAction Stop
        Write-Success "Microsoft VCLibs Desktop Framework Package installed!"
    } catch {
        E "Error installing Microsoft VCLibs Desktop Framework Package: $($_.Exception.Message)"
        Write-Progress -Activity "Winget Package Management" -Status "Error installing VCLibs prerequisite" -Completed -Id $progressIdWinget
        throw $_
    }

    Write-StatusLine "🔄" "Installing Winget..." "Cyan"
    $wingetInstallerUrl = "https://aka.ms/getwinget"
    $installerPath = "$env:TEMP\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle"
    try {
        (New-Object Net.WebClient).DownloadFile($wingetInstallerUrl, $installerPath)
        Add-AppxPackage -Path $installerPath -ErrorAction Stop
        Write-Success "Winget installed successfully!"
    } catch {
        E "Error installing Winget: $($_.Exception.Message)"
        Write-Progress -Activity "Winget Package Management" -Status "Error installing Winget" -Completed -Id $progressIdWinget
        throw $_
    }
} else {
    $statusMessage = "Winget is already installed."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($wingetCurrentStep / $wingetTotalSteps) * 100))) -Id $progressIdWinget
    Write-StatusLine "✅" "Winget is already installed" "Green"
}

$wingetCurrentStep++; $statusMessage = "Upgrading Windows Package Manager (Winget)..."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($wingetCurrentStep / $wingetTotalSteps) * 100))) -Id $progressIdWinget
Write-SectionHeader "SYSTEM UPDATES" "🔄"
I $statusMessage
Write-StatusLine "⬆️" "Upgrading all installed packages..." "Cyan"
winget upgrade --all --include-unknown --accept-package-agreements --accept-source-agreements
if ($LASTEXITCODE -ne 0) {
    E "Error upgrading Winget packages. Exit code: $LASTEXITCODE"
    throw "Winget upgrade failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "Windows Package Manager upgraded successfully!"
}

# Package Installation Section
Write-SectionHeader "APPLICATION INSTALLATIONS" "📱"

$wingetCurrentStep++; $statusMessage = "Installing Bandizip via Winget..."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($wingetCurrentStep / $wingetTotalSteps) * 100))) -Id $progressIdWinget
Write-StatusLine "🗜️" "Installing Bandizip archive manager..." "Cyan"
winget install Bandisoft.Bandizip --accept-package-agreements --accept-source-agreements
if ($LASTEXITCODE -ne 0) {
    E "Error installing Bandizip. Exit code: $LASTEXITCODE"
    throw "Bandizip installation failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "Bandizip installed successfully!"
}

$wingetCurrentStep++; $statusMessage = "Installing Bandiview via Winget..."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($wingetCurrentStep / $wingetTotalSteps) * 100))) -Id $progressIdWinget
Write-StatusLine "🖼️" "Installing Bandiview image viewer..." "Cyan"
winget install Bandisoft.Bandiview --accept-package-agreements --accept-source-agreements
if ($LASTEXITCODE -ne 0) {
    E "Error installing Bandiview. Exit code: $LASTEXITCODE"
    throw "Bandiview installation failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "Bandiview installed successfully!"
}

$wingetCurrentStep++; $statusMessage = "Installing JetBrains Toolbox via Winget..."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($wingetCurrentStep / $wingetTotalSteps) * 100))) -Id $progressIdWinget
Write-StatusLine "🧰" "Installing JetBrains Toolbox..." "Cyan"
winget install JetBrains.Toolbox --accept-package-agreements --accept-source-agreements
if ($LASTEXITCODE -ne 0) {
    E "Error installing JetBrains Toolbox. Exit code: $LASTEXITCODE"
    throw "JetBrains Toolbox installation failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "JetBrains Toolbox installed successfully!"
}

$wingetCurrentStep++; $statusMessage = "Installing Powershell 7 via Winget..."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($wingetCurrentStep / $wingetTotalSteps) * 100))) -Id $progressIdWinget
Write-StatusLine "⚡" "Installing PowerShell 7..." "Cyan"
winget install Microsoft.PowerShell --accept-package-agreements --accept-source-agreements
if ($LASTEXITCODE -ne 0) {
    E "Error installing PowerShell 7. Exit code: $LASTEXITCODE"
    throw "PowerShell 7 installation failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "PowerShell 7 installed successfully!"
}

$wingetCurrentStep++; $statusMessage = "Installing Snipping Tool via Winget..."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($wingetCurrentStep / $wingetTotalSteps) * 100))) -Id $progressIdWinget
Write-StatusLine "✂️" "Installing Snipping Tool..." "Cyan"
winget install 9MZ95KL8MR0L --accept-package-agreements --accept-source-agreements
if ($LASTEXITCODE -ne 0) {
    E "Error installing Snipping Tool. Exit code: $LASTEXITCODE"
    throw "Snipping Tool installation failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "Snipping Tool installed successfully!"
}

$wingetCurrentStep++; $statusMessage = "Installing PowerToys via Winget..."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($wingetCurrentStep / $wingetTotalSteps) * 100))) -Id $progressIdWinget
Write-StatusLine "🔧" "Installing Microsoft PowerToys..." "Cyan"
winget install Microsoft.Powertoys --accept-package-agreements --accept-source-agreements
if ($LASTEXITCODE -ne 0) {
    E "Error installing PowerToys. Exit code: $LASTEXITCODE"
    throw "PowerToys installation failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "PowerToys installed successfully!"
}

Write-StatusLine "🎉" "Winget configuration completed successfully!" "Green"
Write-Progress -Activity "Winget Package Management" -Completed -Id $progressIdWinget
Write-Host ""
Write-BoxedHeader "✅ WINGET PACKAGES COMPLETED" "Green" 50

exit
