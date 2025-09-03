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

# Configuration
$REPO_BASE_URL = "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/$Version"
$MAIN_SCRIPT_URL = "$REPO_BASE_URL/main.ps1"
$CONFIG_SCRIPT_URL = "$REPO_BASE_URL/modules/config.ps1"
$UTILS_SCRIPT_URL = "$REPO_BASE_URL/modules/utils.ps1"

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
            Write-Host "Using cached version: $FileName" -ForegroundColor Yellow
            return Get-Content $CachedPath -Raw
        } else {
            throw "Offline mode requested but no cached version of $FileName found"
        }
    }

    if ($ShouldDownload) {
        try {
            Write-Host "Downloading: $FileName" -ForegroundColor Green
            $Content = Invoke-RestMethod -Uri $Url -ErrorAction Stop
            $Content | Out-File -FilePath $CachedPath -Encoding UTF8 -Force
            return $Content
        } catch {
            if (Test-Path $CachedPath) {
                Write-Host "Download failed, using cached version: $FileName" -ForegroundColor Yellow
                return Get-Content $CachedPath -Raw
            } else {
                throw "Failed to download $FileName and no cached version available: $($_.Exception.Message)"
            }
        }
    } else {
        Write-Host "Using cached version: $FileName" -ForegroundColor Cyan
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
    Write-Host "Windows Setup Loader v2.0" -ForegroundColor Magenta
    Write-Host "================================" -ForegroundColor Magenta

    # Load configuration first
    $ConfigContent = Get-CachedScript -Url $CONFIG_SCRIPT_URL -FileName "config.ps1"
    if (-not (Test-ScriptIntegrity $ConfigContent)) {
        throw "Configuration script integrity check failed"
    }

    # Load utilities
    $UtilsContent = Get-CachedScript -Url $UTILS_SCRIPT_URL -FileName "utils.ps1"
    if (-not (Test-ScriptIntegrity $UtilsContent)) {
        throw "Utils script integrity check failed"
    }

    # Load main script
    $MainContent = Get-CachedScript -Url $MAIN_SCRIPT_URL -FileName "main.ps1"
    if (-not (Test-ScriptIntegrity $MainContent)) {
        throw "Main script integrity check failed"
    }

    Write-Host "All scripts loaded successfully. Starting execution..." -ForegroundColor Green
    Write-Host "Cache directory: $CacheDir" -ForegroundColor DarkGray
    Write-Host ""

    # Execute the scripts in order
    Invoke-Expression $ConfigContent
    Invoke-Expression $UtilsContent
    Invoke-Expression $MainContent

} catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "You can try:" -ForegroundColor Yellow
    Write-Host "  - Run with -ForceDownload to refresh cache" -ForegroundColor Yellow
    Write-Host "  - Run with -OfflineMode to use only cached files" -ForegroundColor Yellow
    Write-Host "  - Check your internet connection" -ForegroundColor Yellow

    Read-Host "Press Enter to exit"
    exit 1
}
