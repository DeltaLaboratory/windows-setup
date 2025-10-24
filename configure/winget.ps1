# Load dependencies - this script should only be called from main.ps1 or other scripts that have already loaded config and utils

Write-BoxedHeader "[PACKAGE] WINGET PACKAGE MANAGER" "DarkCyan" 60

$progressIdWinget = $Global:PROGRESS_IDS.Winget
$wingetTotalSteps = 4
$wingetCurrentStep = 0

Write-StatusLine "[LIST]" "Installing and configuring essential applications..." "Yellow"
Write-StatusLine "[STATS]" "Total Package Groups: $wingetTotalSteps" "DarkGray"
Write-Host ""

$wingetCurrentStep++; $statusMessage = "Starting Winget Configuration..."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($wingetCurrentStep / $wingetTotalSteps) * 100))) -Id $progressIdWinget
Write-SectionHeader "WINGET INSTALLATION & SETUP" "[FIX]"
I $statusMessage

# Ensure Winget is installed
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    $statusMessage = "Winget not found. Installing prerequisites and Winget..."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($wingetCurrentStep / $wingetTotalSteps) * 100))) -Id $progressIdWinget
    Write-StatusLine "[ERROR]" "Winget not found. Installing prerequisites..." "Yellow"

    Write-StatusLine "[PACKAGE]" "Installing Microsoft VCLibs Desktop Framework Package..." "Cyan"
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

    Write-StatusLine "[REFRESH]" "Installing Winget..." "Cyan"
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
    Write-StatusLine "[OK]" "Winget is already installed" "Green"
}

$wingetCurrentStep++; $statusMessage = "Upgrading Windows Package Manager (Winget)..."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($wingetCurrentStep / $wingetTotalSteps) * 100))) -Id $progressIdWinget
Write-SectionHeader "SYSTEM UPDATES" "[REFRESH]"
I $statusMessage
Write-StatusLine "[UP]" "Upgrading all installed packages..." "Cyan"
winget upgrade --all --include-unknown --accept-package-agreements --accept-source-agreements
if ($LASTEXITCODE -ne 0) {
    E "Error upgrading Winget packages. Exit code: $LASTEXITCODE"
    throw "Winget upgrade failed. Exit code: $LASTEXITCODE"
} else {
    Write-Success "Windows Package Manager upgraded successfully!"
}

# Package Installation Section
Write-SectionHeader "APPLICATION INSTALLATIONS" "[MOBILE]"

$wingetCurrentStep++; $statusMessage = "Installing Powershell 7 via Winget..."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($wingetCurrentStep / $wingetTotalSteps) * 100))) -Id $progressIdWinget
Write-StatusLine "[POWER]" "Checking/Installing PowerShell 7..." "Cyan"
if (-not (Install-WingetPackageIfNeeded -PackageId "Microsoft.PowerShell" -PackageName "PowerShell 7")) {
    E "Error installing PowerShell 7"
    throw "PowerShell 7 installation failed"
}

$wingetCurrentStep++; $statusMessage = "Installing Snipping Tool via Winget..."; Write-Progress -Activity "Winget Package Management" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($wingetCurrentStep / $wingetTotalSteps) * 100))) -Id $progressIdWinget
Write-StatusLine "[CUT]" "Checking/Installing Snipping Tool..." "Cyan"
if (-not (Install-WingetPackageIfNeeded -PackageId "9MZ95KL8MR0L" -PackageName "Snipping Tool")) {
    E "Error installing Snipping Tool"
    throw "Snipping Tool installation failed"
}

Write-StatusLine "[SUCCESS]" "Winget configuration completed successfully!" "Green"
Write-Progress -Activity "Winget Package Management" -Completed -Id $progressIdWinget
Write-Host ""
Write-BoxedHeader "[OK] WINGET PACKAGES COMPLETED" "Green" 50
