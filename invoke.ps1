Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Enhanced Windows Setup Loader
# Provides caching, offline capability, and better error handling

param(
    [switch]$ForceDownload,
    [switch]$OfflineMode,
    [string]$CacheDir,
    [string]$Version = "main"
)

if ([string]::IsNullOrEmpty($CacheDir)) {
    $CacheDir = Join-Path $env:TEMP "windows-setup-cache"
}

if ([string]::IsNullOrEmpty($Version)) {
    $Version = "main"
}

# Configuration
$REPO_BASE_URL = "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/$Version"
$MAIN_SCRIPT_URL = "$REPO_BASE_URL/main.ps1"
$CONFIG_SCRIPT_URL = "$REPO_BASE_URL/modules/config.ps1"
$UTILS_SCRIPT_URL = "$REPO_BASE_URL/modules/utils.ps1"

# TUI Helper Functions
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

function Write-ProgressStep {
    param(
        [string]$Step,
        [string]$Status = "IN_PROGRESS"
    )

    $icon = switch ($Status) {
        "IN_PROGRESS" { "⚡" }
        "SUCCESS" { "✅" }
        "ERROR" { "❌" }
        "WARNING" { "⚠️" }
        default { "•" }
    }

    $color = switch ($Status) {
        "IN_PROGRESS" { "Yellow" }
        "SUCCESS" { "Green" }
        "ERROR" { "Red" }
        "WARNING" { "Magenta" }
        default { "Gray" }
    }

    Write-StatusLine -Icon $icon -Message $Step -Color $color
}

# Create cache directory if it doesn't exist
if (-not (Test-Path $CacheDir)) {
    New-Item -Path $CacheDir -ItemType Directory -Force | Out-Null
}

# Function to download and cache a script
function Get-CachedScript {
    param(
        [string]$Url,
        [string]$FileName
    )

    $CachedPath = Join-Path $CacheDir $FileName
    $ShouldDownload = $ForceDownload -or (-not (Test-Path $CachedPath))

    if ($OfflineMode) {
        if (Test-Path $CachedPath) {
            Write-ProgressStep "Using cached version: $FileName" "SUCCESS"
            return Get-Content $CachedPath -Raw
        } else {
            throw "Offline mode requested but no cached version of $FileName found"
        }
    }

    if ($ShouldDownload) {
        try {
            Write-ProgressStep "Downloading: $FileName" "IN_PROGRESS"
            $Content = Invoke-RestMethod -Uri $Url -ErrorAction Stop
            $Content | Out-File -FilePath $CachedPath -Encoding UTF8 -Force
            Write-ProgressStep "Downloaded: $FileName" "SUCCESS"
            return $Content
        } catch {
            if (Test-Path $CachedPath) {
                Write-ProgressStep "Download failed, using cached version: $FileName" "WARNING"
                return Get-Content $CachedPath -Raw
            } else {
                throw "Failed to download $FileName and no cached version available: $($_.Exception.Message)"
            }
        }
    } else {
        Write-ProgressStep "Using cached version: $FileName" "SUCCESS"
        return Get-Content $CachedPath -Raw
    }
}

# Function to validate script integrity
function Test-ScriptIntegrity {
    param([string]$Content)

    # Basic validation - check if it's valid PowerShell
    try {
        [System.Management.Automation.PSParser]::Tokenize($Content, [ref]$null) | Out-Null
        return $true
    } catch {
        return $false
    }
}

# Main execution
try {
    Clear-Host

    # Main Header
    Write-BoxedHeader "🚀 WINDOWS SETUP LOADER v2.0" "Cyan" 60

    Write-StatusLine "📁" "Cache Directory: $CacheDir" "DarkGray"
    Write-StatusLine "🌐" "Repository: $REPO_BASE_URL" "DarkGray"
    Write-StatusLine "📦" "Version: $Version" "DarkGray"

    if ($ForceDownload) {
        Write-StatusLine "🔄" "Force Download Mode: ON" "Yellow"
    }
    if ($OfflineMode) {
        Write-StatusLine "📴" "Offline Mode: ON" "Magenta"
    }

    Write-Host ""
    Write-BoxedHeader "📋 LOADING SCRIPTS" "Green" 50

    # Load configuration first
    Write-ProgressStep "Loading configuration module..." "IN_PROGRESS"
    $ConfigContent = Get-CachedScript -Url $CONFIG_SCRIPT_URL -FileName "config.ps1"
    if (-not (Test-ScriptIntegrity $ConfigContent)) {
        throw "Configuration script integrity check failed"
    }
    Write-ProgressStep "Configuration module validated" "SUCCESS"

    # Load utilities
    Write-ProgressStep "Loading utilities module..." "IN_PROGRESS"
    $UtilsContent = Get-CachedScript -Url $UTILS_SCRIPT_URL -FileName "utils.ps1"
    if (-not (Test-ScriptIntegrity $UtilsContent)) {
        throw "Utils script integrity check failed"
    }
    Write-ProgressStep "Utilities module validated" "SUCCESS"

    # Load main script
    Write-ProgressStep "Loading main script..." "IN_PROGRESS"
    $MainContent = Get-CachedScript -Url $MAIN_SCRIPT_URL -FileName "main.ps1"
    if (-not (Test-ScriptIntegrity $MainContent)) {
        throw "Main script integrity check failed"
    }
    Write-ProgressStep "Main script validated" "SUCCESS"

    Write-Host ""
    Write-BoxedHeader "🎯 EXECUTING SETUP" "Magenta" 50

    # Execute the scripts in order
    Write-ProgressStep "Executing configuration..." "IN_PROGRESS"
    Invoke-Expression $ConfigContent
    Write-ProgressStep "Configuration executed" "SUCCESS"

    Write-ProgressStep "Executing utilities..." "IN_PROGRESS"
    Invoke-Expression $UtilsContent
    Write-ProgressStep "Utilities executed" "SUCCESS"

    Write-ProgressStep "Executing main setup..." "IN_PROGRESS"
    Invoke-Expression $MainContent

} catch {
    Write-Host ""
    Write-BoxedHeader "❌ ERROR OCCURRED" "Red" 50
    Write-StatusLine "💥" "ERROR: $($_.Exception.Message)" "Red"
    Write-Host ""
    Write-StatusLine "💡" "Troubleshooting Options:" "Yellow"
    Write-StatusLine "  🔄" "Run with -ForceDownload to refresh cache" "Cyan"
    Write-StatusLine "  📴" "Run with -OfflineMode to use only cached files" "Cyan"
    Write-StatusLine "  🌐" "Check your internet connection" "Cyan"
    Write-StatusLine "  📁" "Verify cache directory permissions" "Cyan"
    Write-Host ""

    Read-Host "Press Enter to exit"
    exit 1
}
