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

function Write-ProgressStep {
    param(
        [string]$Step,
        [string]$Status = "IN_PROGRESS"
    )

    $icon = switch ($Status) {
        "IN_PROGRESS" { "[POWER]" }
        "SUCCESS" { "[OK]" }
        "ERROR" { "[ERROR]" }
        "WARNING" { "[WARN]" }
        default { "-" }
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
$script:LoaderErrors = @()
$script:LoaderWarnings = @()

function Add-LoaderError {
    param([string]$Message)
    $script:LoaderErrors += $Message
    Write-StatusLine "[ERROR]" "ERROR: $Message" "Red"
}

function Add-LoaderWarning {
    param([string]$Message)
    $script:LoaderWarnings += $Message
    Write-StatusLine "[WARN]" "WARNING: $Message" "Yellow"
}

try {
    Clear-Host

    # Main Header
    Write-BoxedHeader "[START] WINDOWS SETUP LOADER v2.0" "Cyan" 60

    Write-StatusLine "[DIR]" "Cache Directory: $CacheDir" "DarkGray"
    Write-StatusLine "[NET]" "Repository: $REPO_BASE_URL" "DarkGray"
    Write-StatusLine "[PACKAGE]" "Version: $Version" "DarkGray"
    
    if ($ForceDownload) {
        Write-StatusLine "[REFRESH]" "Force Download Mode: ON" "Yellow"
    }
    if ($OfflineMode) {
        Write-StatusLine "[OFFLINE]" "Offline Mode: ON" "Magenta"
    }

    Write-Host ""
    Write-BoxedHeader "[LIST] LOADING SCRIPTS" "Green" 50

    # Load configuration first
    $configSuccess = $true
    Write-ProgressStep "Loading configuration module..." "IN_PROGRESS"
    try {
        $ConfigContent = Get-CachedScript -Url $CONFIG_SCRIPT_URL -FileName "config.ps1"
        if (-not (Test-ScriptIntegrity $ConfigContent)) {
            throw "Configuration script integrity check failed"
        }
        Write-ProgressStep "Configuration module validated" "SUCCESS"
    } catch {
        $configSuccess = $false
        Add-LoaderError "Configuration loading failed: $($_.Exception.Message)"
        Write-ProgressStep "Configuration module failed" "ERROR"
    }

    # Load utilities
    $utilsSuccess = $true
    Write-ProgressStep "Loading utilities module..." "IN_PROGRESS"
    try {
        $UtilsContent = Get-CachedScript -Url $UTILS_SCRIPT_URL -FileName "utils.ps1"
        if (-not (Test-ScriptIntegrity $UtilsContent)) {
            throw "Utils script integrity check failed"
        }
        Write-ProgressStep "Utilities module validated" "SUCCESS"
    } catch {
        $utilsSuccess = $false
        Add-LoaderError "Utilities loading failed: $($_.Exception.Message)"
        Write-ProgressStep "Utilities module failed" "ERROR"
    }

    # Load main script
    $mainSuccess = $true
    Write-ProgressStep "Loading main script..." "IN_PROGRESS"
    try {
        $MainContent = Get-CachedScript -Url $MAIN_SCRIPT_URL -FileName "main.ps1"
        if (-not (Test-ScriptIntegrity $MainContent)) {
            throw "Main script integrity check failed"
        }
        Write-ProgressStep "Main script validated" "SUCCESS"
    } catch {
        $mainSuccess = $false
        Add-LoaderError "Main script loading failed: $($_.Exception.Message)"
        Write-ProgressStep "Main script failed" "ERROR"
    }

    Write-Host ""
    
    # Check if we can proceed with execution
    if (-not $configSuccess -or -not $utilsSuccess -or -not $mainSuccess) {
        Write-BoxedHeader "[WARN] PARTIAL LOADING COMPLETED" "Yellow" 50
        Write-StatusLine "[BLOCKED]" "Some scripts failed to load. Setup cannot continue." "Red"
        
        Write-Host ""
        Write-StatusLine "[HINT]" "Troubleshooting Options:" "Yellow"
        Write-StatusLine "  [REFRESH]" "Run with -ForceDownload to refresh cache" "Cyan"
        Write-StatusLine "  [OFFLINE]" "Check your internet connection" "Cyan"
        Write-StatusLine "  [DIR]" "Verify cache directory permissions" "Cyan"
    } else {
        Write-BoxedHeader "[TARGET] EXECUTING SETUP" "Magenta" 50

        # Execute the scripts in order
        try {
            Write-ProgressStep "Executing configuration..." "IN_PROGRESS"
            Invoke-Expression $ConfigContent
            Write-ProgressStep "Configuration executed" "SUCCESS"
        } catch {
            Add-LoaderWarning "Configuration execution had issues: $($_.Exception.Message)"
            Write-ProgressStep "Configuration had warnings" "WARNING"
        }

        try {
            Write-ProgressStep "Executing utilities..." "IN_PROGRESS"
            Invoke-Expression $UtilsContent
            Write-ProgressStep "Utilities executed" "SUCCESS"
        } catch {
            Add-LoaderWarning "Utilities execution had issues: $($_.Exception.Message)"
            Write-ProgressStep "Utilities had warnings" "WARNING"
        }

        try {
            Write-ProgressStep "Executing main setup..." "IN_PROGRESS"
            Invoke-Expression $MainContent
            Write-ProgressStep "Main setup completed" "SUCCESS"
        } catch {
            Add-LoaderError "Main setup execution failed: $($_.Exception.Message)"
            Write-ProgressStep "Main setup failed" "ERROR"
        }
    }

} catch {
    Add-LoaderError "Unexpected error in loader: $($_.Exception.Message)"
}

# Display final summary
Write-Host ""
if ($script:LoaderErrors.Count -eq 0 -and $script:LoaderWarnings.Count -eq 0) {
    Write-BoxedHeader "[SUCCESS] LOADER COMPLETED SUCCESSFULLY!" "Green" 60
} elseif ($script:LoaderErrors.Count -eq 0) {
    Write-BoxedHeader "[WARN] LOADER COMPLETED WITH WARNINGS" "Yellow" 60
    Write-StatusLine "[WARN]" "$($script:LoaderWarnings.Count) warnings occurred during loading" "Yellow"
} else {
    Write-BoxedHeader "[ERROR] LOADER COMPLETED WITH ERRORS" "Red" 60
    Write-StatusLine "[ERROR]" "$($script:LoaderErrors.Count) errors and $($script:LoaderWarnings.Count) warnings occurred" "Red"
}

# Show errors and warnings if any
if ($script:LoaderWarnings.Count -gt 0) {
    Write-Host ""
    Write-StatusLine "[WARN]" "Warnings:" "Yellow"
    foreach ($warning in $script:LoaderWarnings) {
        Write-StatusLine "  -" $warning "Yellow"
    }
}

if ($script:LoaderErrors.Count -gt 0) {
    Write-Host ""
    Write-StatusLine "[ERROR]" "Errors:" "Red"
    foreach ($errorItem in $script:LoaderErrors) {
        Write-StatusLine "  -" $errorItem "Red"
    }
    Write-Host ""
    Write-StatusLine "[HINT]" "Troubleshooting Options:" "Yellow"
    Write-StatusLine "  [REFRESH]" "Run with -ForceDownload to refresh cache" "Cyan"
    Write-StatusLine "  [OFFLINE]" "Run with -OfflineMode to use only cached files" "Cyan"
    Write-StatusLine "  [NET]" "Check your internet connection" "Cyan"
    Write-StatusLine "  [DIR]" "Verify cache directory permissions" "Cyan"
}

Write-Host ""
Read-Host "Press Enter to continue"
