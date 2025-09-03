Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Local Development Loader for Windows Setup
# Use this script when working with local files during development

param(
    [string]$WorkspacePath = $PSScriptRoot,
    [switch]$Verbose
)

# Validate workspace structure
$RequiredFiles = @(
    "main.ps1",
    "modules\config.ps1",
    "modules\utils.ps1"
)

Write-Host "Windows Setup Local Loader" -ForegroundColor Magenta
Write-Host "=============================" -ForegroundColor Magenta
Write-Host "Workspace: $WorkspacePath" -ForegroundColor Cyan

# Check if all required files exist
$MissingFiles = @()
foreach ($File in $RequiredFiles) {
    $FullPath = Join-Path $WorkspacePath $File
    if (-not (Test-Path $FullPath)) {
        $MissingFiles += $File
    }
}

if ($MissingFiles.Count -gt 0) {
    Write-Host "ERROR: Missing required files:" -ForegroundColor Red
    foreach ($File in $MissingFiles) {
        Write-Host "  - $File" -ForegroundColor Red
    }
    Read-Host "Press Enter to exit"
    exit 1
}

# Function to load local script with error handling
function Import-LocalScript {
    param(
        [string]$RelativePath,
        [string]$Description
    )

    $FullPath = Join-Path $WorkspacePath $RelativePath

    if ($Verbose) {
        Write-Host "Loading: $Description ($RelativePath)" -ForegroundColor Green
    }

    try {
        . $FullPath
    } catch {
        Write-Host "ERROR loading $Description`: $($_.Exception.Message)" -ForegroundColor Red
        throw $_
    }
}

try {
    # Load scripts in dependency order
    Import-LocalScript -RelativePath "modules\config.ps1" -Description "Configuration Module"
    Import-LocalScript -RelativePath "modules\utils.ps1" -Description "Utilities Module"
    Import-LocalScript -RelativePath "main.ps1" -Description "Main Script"

    Write-Host "All local scripts loaded successfully!" -ForegroundColor Green

} catch {
    Write-Host "Failed to load local scripts: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}
