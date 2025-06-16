$progressIdWinget = 8
$wingetTotalSteps = 8 # Installation + Upgrade + 6 packages
$wingetCurrentStep = 0

$wingetCurrentStep++; $statusMessage = "Starting Winget Configuration..."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete (($wingetCurrentStep / $wingetTotalSteps) * 100) -Id $progressIdWinget
I $statusMessage

# Ensure Winget is installed
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    $statusMessage = "Winget not found. Installing prerequisites and Winget..."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete (($wingetCurrentStep / $wingetTotalSteps) * 100) -Id $progressIdWinget
    I "Winget not found. Installing prerequisites and Winget..."

    # Install VCLibs as a prerequisite
    I "Installing Microsoft VCLibs Desktop Framework Package (prerequisite for Winget)..."
    $vcLibsUrl = "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx"
    $vcLibsInstallerPath = "$env:TEMP\Microsoft.VCLibs.x64.14.00.Desktop.appx"
    try {
        (New-Object Net.WebClient).DownloadFile($vcLibsUrl, $vcLibsInstallerPath)
        Add-AppxPackage -Path $vcLibsInstallerPath -ErrorAction Stop
        I "Microsoft VCLibs Desktop Framework Package Installed Successfully!"
    } catch {
        E "Error installing Microsoft VCLibs Desktop Framework Package: $($_.Exception.Message)"
        Write-Progress -Activity "Winget Package Management" -Status "Error installing VCLibs prerequisite" -Completed -Id $progressIdWinget
        throw $_ # Re-throw to be caught by main.ps1
    }

    # Install Winget
    I "Installing Winget..."
    $wingetInstallerUrl = "https://aka.ms/getwinget"
    $installerPath = "$env:TEMP\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle"
    try {
        (New-Object Net.WebClient).DownloadFile($wingetInstallerUrl, $installerPath)
        Add-AppxPackage -Path $installerPath -ErrorAction Stop
        I "Winget Installed Successfully!"
    } catch {
        E "Error installing Winget: $($_.Exception.Message)"
        Write-Progress -Activity "Winget Package Management" -Status "Error installing Winget" -Completed -Id $progressIdWinget
        # Optionally, exit the script or take other error handling actions
        throw $_ # Re-throw to be caught by main.ps1
    }
} else {
    $statusMessage = "Winget is already installed."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete (($wingetCurrentStep / $wingetTotalSteps) * 100) -Id $progressIdWinget
    I $statusMessage
}

$wingetCurrentStep++; $statusMessage = "Upgrading Windows Package Manager (Winget)..."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete (($wingetCurrentStep / $wingetTotalSteps) * 100) -Id $progressIdWinget
I $statusMessage
I "Upgrading Windows Package Manager (Winget)..."
winget upgrade --all --include-unknown --accept-package-agreements --accept-source-agreements
if ($LASTEXITCODE -ne 0) {
    E "Error upgrading Winget packages. Exit code: $LASTEXITCODE"
    throw "Winget upgrade failed. Exit code: $LASTEXITCODE"
} else {
    I "Windows Package Manager (Winget) Upgraded Successfully!"
}

$wingetCurrentStep++; $statusMessage = "Installing Bandizip via Winget..."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete (($wingetCurrentStep / $wingetTotalSteps) * 100) -Id $progressIdWinget
I $statusMessage
# Install Bandizip via Winget
I "Installing Bandizip via Winget..."
winget install Bandisoft.Bandizip --accept-package-agreements --accept-source-agreements
if ($LASTEXITCODE -ne 0) {
    E "Error installing Bandizip. Exit code: $LASTEXITCODE"
    throw "Bandizip installation failed. Exit code: $LASTEXITCODE"
} else {
    I "Bandizip Installed Successfully!"
}

$wingetCurrentStep++; $statusMessage = "Installing Bandiview via Winget..."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete (($wingetCurrentStep / $wingetTotalSteps) * 100) -Id $progressIdWinget
I $statusMessage
# Install Bandiview via Winget
I "Installing Bandiview via Winget..."
winget install Bandisoft.Bandiview --accept-package-agreements --accept-source-agreements
if ($LASTEXITCODE -ne 0) {
    E "Error installing Bandiview. Exit code: $LASTEXITCODE"
    throw "Bandiview installation failed. Exit code: $LASTEXITCODE"
} else {
    I "Bandiview Installed Successfully!"
}

$wingetCurrentStep++; $statusMessage = "Installing JetBrains Toolbox via Winget..."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete (($wingetCurrentStep / $wingetTotalSteps) * 100) -Id $progressIdWinget
I $statusMessage
# Install JetBrains Toolbox via Winget
I "Installing JetBrains Toolbox via Winget..."
winget install JetBrains.Toolbox --accept-package-agreements --accept-source-agreements
if ($LASTEXITCODE -ne 0) {
    E "Error installing JetBrains Toolbox. Exit code: $LASTEXITCODE"
    throw "JetBrains Toolbox installation failed. Exit code: $LASTEXITCODE"
} else {
    I "JetBrains Toolbox Installed Successfully!"
}

$wingetCurrentStep++; $statusMessage = "Installing Powershell 7 via Winget..."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete (($wingetCurrentStep / $wingetTotalSteps) * 100) -Id $progressIdWinget
I $statusMessage
# Install Powershell 7 via Winget
I "Installing Powershell 7 via Winget..."
winget install Microsoft.PowerShell --accept-package-agreements --accept-source-agreements
if ($LASTEXITCODE -ne 0) {
    E "Error installing Powershell 7. Exit code: $LASTEXITCODE"
    throw "Powershell 7 installation failed. Exit code: $LASTEXITCODE"
} else {
    I "Powershell 7 Installed Successfully!"
}

$wingetCurrentStep++; $statusMessage = "Installing Snipping Tool via Winget..."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete (($wingetCurrentStep / $wingetTotalSteps) * 100) -Id $progressIdWinget
I $statusMessage
# Install Snipping Tool via Winget
I "Installing Snipping Tool via Winget..."
winget install 9MZ95KL8MR0L --accept-package-agreements --accept-source-agreements
if ($LASTEXITCODE -ne 0) {
    E "Error installing Snipping Tool. Exit code: $LASTEXITCODE"
    throw "Snipping Tool installation failed. Exit code: $LASTEXITCODE"
} else {
    I "Snipping Tool Installed Successfully!"
}

$wingetCurrentStep++; $statusMessage = "Installing PowerToys via Winget..."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete (($wingetCurrentStep / $wingetTotalSteps) * 100) -Id $progressIdWinget
I $statusMessage
I "Installing PowerToys via Winget..."
winget install Microsoft.Powertoys --accept-package-agreements --accept-source-agreements
if ($LASTEXITCODE -ne 0) {
    E "Error installing PowerToys. Exit code: $LASTEXITCODE"
    throw "PowerToys installation failed. Exit code: $LASTEXITCODE"
} else {
    I "PowerToys Installed Successfully!"
}

I "Winget Configuration Completed Successfully!"
Write-Progress -Activity "Winget Package Management" -Completed -Id $progressIdWinget

exit