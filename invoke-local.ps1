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
    Write-Host ("+" + "-" * ($Width - 2) + "+") -ForegroundColor $Color
    Write-Host ("|" + $leftPad + $Title + $rightPad + "|") -ForegroundColor $Color
    Write-Host ("+" + "-" * ($Width - 2) + "+") -ForegroundColor $Color
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
Write-BoxedHeader "[HOME] LOCAL DEVELOPMENT LOADER" "Green" 60
Write-StatusLine "[DIR]" "Workspace: $WorkspacePath" "DarkGray"

if ($Verbose) {
    Write-StatusLine "[SEARCH]" "Verbose mode enabled" "Yellow"
}

Write-Host ""
Write-StatusLine "[SEARCH]" "Validating workspace structure..." "Cyan"

# Check if all required files exist
$MissingFiles = @()
$FoundFiles = @()

foreach ($File in $RequiredFiles) {
    $FullPath = Join-Path $WorkspacePath $File
    if (-not (Test-Path $FullPath)) {
        $MissingFiles += $File
        Write-StatusLine "[ERROR]" "Missing: $File" "Red"
    } else {
        $FoundFiles += $File
        Write-StatusLine "[OK]" "Found: $File" "Green"
    }
}

if ($MissingFiles.Count -gt 0) {
    Write-Host ""
    Write-BoxedHeader "[ERROR] WORKSPACE VALIDATION FAILED" "Red" 50
    Write-StatusLine "[LIST]" "Required files summary:" "Yellow"
    Write-StatusLine "  [OK]" "Found: $($FoundFiles.Count) files" "Green"
    Write-StatusLine "  [ERROR]" "Missing: $($MissingFiles.Count) files" "Red"
    Write-Host ""
    Write-StatusLine "[HINT]" "Please ensure all required files are present before running the local loader." "Yellow"
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-StatusLine "[OK]" "Workspace validation completed successfully!" "Green"
Write-StatusLine "[STATS]" "All $($RequiredFiles.Count) required files found" "DarkGray"

# Function to load local script with error handling
function Import-LocalScript {
    param(
        [string]$RelativePath,
        [string]$Description
    )

    $FullPath = Join-Path $WorkspacePath $RelativePath

    if ($Verbose) {
        Write-StatusLine "[INBOX]" "Loading: $Description ($RelativePath)" "Cyan"
    } else {
        Write-StatusLine "[INBOX]" "Loading: $Description" "Cyan"
    }

    try {
        . $FullPath
        Write-StatusLine "[OK]" "$Description loaded successfully" "Green"
    } catch {
        Write-StatusLine "[ERROR]" "ERROR loading $Description`: $($_.Exception.Message)" "Red"
        throw $_
    }
}

try {
    Write-Host ""
    Write-BoxedHeader "[LIST] LOADING LOCAL SCRIPTS" "Blue" 50

    # Load scripts in dependency order
    Import-LocalScript -RelativePath "modules\config.ps1" -Description "Configuration Module"
    Import-LocalScript -RelativePath "modules\utils.ps1" -Description "Utilities Module"
    Import-LocalScript -RelativePath "main.ps1" -Description "Main Script"

    Write-Host ""
    Write-BoxedHeader "[SUCCESS] LOCAL SETUP COMPLETED!" "Green" 50
    Write-StatusLine "[OK]" "All local scripts loaded successfully!" "Green"
    Write-StatusLine "[FIX]" "Development environment ready" "Cyan"

} catch {
    Write-Host ""
    Write-BoxedHeader "[ERROR] LOADING FAILED" "Red" 40
    Write-StatusLine "[ALERT]" "Failed to load local scripts: $($_.Exception.Message)" "Red"
    Write-Host ""
    Write-StatusLine "[HINT]" "Troubleshooting tips:" "Yellow"
    Write-StatusLine "  [SEARCH]" "Check file permissions" "Cyan"
    Write-StatusLine "  [NOTE]" "Verify script syntax" "Cyan"
    Write-StatusLine "  [REFRESH]" "Ensure PowerShell execution policy allows local scripts" "Cyan"
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}
