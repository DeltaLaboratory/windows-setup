$progressIdWinget = 8
$wingetTotalSteps = 8 # Installation + Upgrade + 6 packages
$wingetCurrentStep = 0

$wingetCurrentStep++; $statusMessage = "Starting Winget Configuration..."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete (($wingetCurrentStep / $wingetTotalSteps) * 100) -Id $progressIdWinget
I $statusMessage

# Ensure Winget is installed
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    $statusMessage = "Winget not found. Installing Winget..."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete (($wingetCurrentStep / $wingetTotalSteps) * 100) -Id $progressIdWinget
    I $statusMessage
    $wingetInstallerUrl = "https://aka.ms/getwinget"
    $installerPath = "$env:TEMP\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle"
    try {
        Invoke-WebRequest -Uri $wingetInstallerUrl -OutFile $installerPath -ErrorAction Stop
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
    # Optionally, exit the script or take other error handling actions
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
    # Optionally, exit the script or take other error handling actions
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
    # Optionally, exit the script or take other error handling actions
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
    # Optionally, exit the script or take other error handling actions
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
    # Optionally, exit the script or take other error handling actions
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
    # Optionally, exit the script or take other error handling actions
} else {
    I "Snipping Tool Installed Successfully!"
}

$wingetCurrentStep++; $statusMessage = "Installing PowerToys via Winget..."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete (($wingetCurrentStep / $wingetTotalSteps) * 100) -Id $progressIdWinget
I $statusMessage
I "Installing PowerToys via Winget..."
winget install Microsoft.Powertoys --accept-package-agreements --accept-source-agreements
if ($LASTEXITCODE -ne 0) {
    E "Error installing PowerToys. Exit code: $LASTEXITCODE"
    # Optionally, exit the script or take other error handling actions
} else {
    I "PowerToys Installed Successfully!"
}

I "Winget Configuration Completed Successfully!"
Write-Progress -Activity "Winget Package Management" -Completed -Id $progressIdWinget

exit