Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Local Development Loader for Windows Setup
# Use this script when working with local files during development

param(
    [string]$WorkspacePath = $PSScriptRoot,
    [switch]$Verbose
)

# TUI Helper Functions (simplified versions for local use)
function Write-BoxedHeader {
    param(
        [string]$Title,
        [string]$Color = "Cyan",
        [int]$Width = 60
    )

    $padding = [Math]::Max(0, ($Width - $Title.Length - 2) / 2)
    $leftPad = " " * [Math]::Floor($padding)
    $rightPad = " " * [Math]::Ceiling($padding)

    Write-Host ""
    Write-Host ("┌" + "─" * ($Width - 2) + "┐") -ForegroundColor $Color
    Write-Host ("│" + $leftPad + $Title + $rightPad + "│") -ForegroundColor $Color
    Write-Host ("└" + "─" * ($Width - 2) + "┘") -ForegroundColor $Color
    Write-Host ""
}

function Write-StatusLine {
    param(
        [string]$Icon,
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host " $Icon " -ForegroundColor $Color -NoNewline
    Write-Host $Message -ForegroundColor $Color
}

# Validate workspace structure
$RequiredFiles = @(
    "main.ps1",
    "modules\config.ps1",
    "modules\utils.ps1"
)

Clear-Host
Write-BoxedHeader "🏠 LOCAL DEVELOPMENT LOADER" "Green" 60
Write-StatusLine "📁" "Workspace: $WorkspacePath" "DarkGray"

if ($Verbose) {
    Write-StatusLine "🔍" "Verbose mode enabled" "Yellow"
}

Write-Host ""
Write-StatusLine "🔍" "Validating workspace structure..." "Cyan"

# Check if all required files exist
$MissingFiles = @()
$FoundFiles = @()

foreach ($File in $RequiredFiles) {
    $FullPath = Join-Path $WorkspacePath $File
    if (-not (Test-Path $FullPath)) {
        $MissingFiles += $File
        Write-StatusLine "❌" "Missing: $File" "Red"
    } else {
        $FoundFiles += $File
        Write-StatusLine "✅" "Found: $File" "Green"
    }
}

if ($MissingFiles.Count -gt 0) {
    Write-Host ""
    Write-BoxedHeader "❌ WORKSPACE VALIDATION FAILED" "Red" 50
    Write-StatusLine "📋" "Required files summary:" "Yellow"
    Write-StatusLine "  ✅" "Found: $($FoundFiles.Count) files" "Green"
    Write-StatusLine "  ❌" "Missing: $($MissingFiles.Count) files" "Red"
    Write-Host ""
    Write-StatusLine "💡" "Please ensure all required files are present before running the local loader." "Yellow"
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-StatusLine "✅" "Workspace validation completed successfully!" "Green"
Write-StatusLine "📊" "All $($RequiredFiles.Count) required files found" "DarkGray"

# Function to load local script with error handling
function Import-LocalScript {
    param(
        [string]$RelativePath,
        [string]$Description
    )

    $FullPath = Join-Path $WorkspacePath $RelativePath

    if ($Verbose) {
        Write-StatusLine "📥" "Loading: $Description ($RelativePath)" "Cyan"
    } else {
        Write-StatusLine "📥" "Loading: $Description" "Cyan"
    }

    try {
        . $FullPath
        Write-StatusLine "✅" "$Description loaded successfully" "Green"
    } catch {
        Write-StatusLine "❌" "ERROR loading $Description`: $($_.Exception.Message)" "Red"
        throw $_
    }
}

try {
    Write-Host ""
    Write-BoxedHeader "📋 LOADING LOCAL SCRIPTS" "Blue" 50

    # Load scripts in dependency order
    Import-LocalScript -RelativePath "modules\config.ps1" -Description "Configuration Module"
    Import-LocalScript -RelativePath "modules\utils.ps1" -Description "Utilities Module"
    Import-LocalScript -RelativePath "main.ps1" -Description "Main Script"

    Write-Host ""
    Write-BoxedHeader "🎉 LOCAL SETUP COMPLETED!" "Green" 50
    Write-StatusLine "✅" "All local scripts loaded successfully!" "Green"
    Write-StatusLine "🔧" "Development environment ready" "Cyan"

} catch {
    Write-Host ""
    Write-BoxedHeader "❌ LOADING FAILED" "Red" 40
    Write-StatusLine "💥" "Failed to load local scripts: $($_.Exception.Message)" "Red"
    Write-Host ""
    Write-StatusLine "💡" "Troubleshooting tips:" "Yellow"
    Write-StatusLine "  🔍" "Check file permissions" "Cyan"
    Write-StatusLine "  📝" "Verify script syntax" "Cyan"
    Write-StatusLine "  🔄" "Ensure PowerShell execution policy allows local scripts" "Cyan"
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}
