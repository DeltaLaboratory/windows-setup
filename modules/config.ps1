# Central Configuration File for Windows Setup
# This file contains all configurable parameters and URLs used throughout the setup process

# Repository Configuration
$Global:REPO_BASE_URL = "https://raw.githubusercontent.com/DeltaLaboratory/windows-setup/refs/heads/main"
$Global:REPO_BRANCH = "main"
$Global:REPO_OWNER = "DeltaLaboratory"
$Global:REPO_NAME = "windows-setup"

# Module URLs
$Global:UTILS_URL = "$Global:REPO_BASE_URL/modules/utils.ps1"

# Configuration Script URLs
$Global:REGISTRY_SYSTEM_URL = "$Global:REPO_BASE_URL/configure/registry/system.ps1"
$Global:REGISTRY_HARDENING_URL = "$Global:REPO_BASE_URL/configure/registry/hardening.ps1"
$Global:REGISTRY_BROWSER_URL = "$Global:REPO_BASE_URL/configure/registry/browser.ps1"
$Global:REGISTRY_MISC_URL = "$Global:REPO_BASE_URL/configure/registry/misc.ps1"
$Global:SETTINGS_GENERAL_URL = "$Global:REPO_BASE_URL/configure/settings/settings.ps1"
$Global:SETTINGS_POWERSHELL_URL = "$Global:REPO_BASE_URL/configure/settings/powershell.ps1"
$Global:WINGET_CONFIG_URL = "$Global:REPO_BASE_URL/configure/winget.ps1"
$Global:SCOOP_CONFIG_URL = "$Global:REPO_BASE_URL/configure/scoop.ps1"

# Progress Bar ID Assignments (to prevent conflicts)
$Global:PROGRESS_IDS = @{
    Main = 1
    System = 2
    Browser = 3
    Hardening = 4
    Misc = 5
    Settings = 6
    PowerShell = 7
    Winget = 8
    Scoop = 9
}

# Function to get progress ID by name
function Get-ProgressId {
    param([string]$Name)
    return $Global:PROGRESS_IDS[$Name]
}

# Function to safely invoke remote script with error handling and retry logic
function Invoke-RemoteScript {
    param(
        [string]$Url,
        [string]$Description = "Remote script",
        [int]$MaxRetries = 3,
        [int]$RetryDelaySeconds = 2
    )

    for ($attempt = 1; $attempt -le $MaxRetries; $attempt++) {
        try {
            if ($attempt -gt 1) {
                Write-Warning "Retry attempt $attempt/$MaxRetries for $Description"
                Start-Sleep -Seconds ($RetryDelaySeconds * $attempt)
            }
            
            I "Executing $Description from: $Url (Attempt $attempt/$MaxRetries)"
            $scriptContent = Invoke-RestMethod -Uri $Url -TimeoutSec 30
            Invoke-Expression $scriptContent
            return # Success - exit the retry loop
        } catch {
            $errorMessage = $_.Exception.Message
            if ($attempt -eq $MaxRetries) {
                # Last attempt failed
                E "Failed to execute $Description from $Url after $MaxRetries attempts"
                E "Final error: $errorMessage"
                throw "Failed to execute $Description after $MaxRetries attempts. Last error: $errorMessage"
            } else {
                # Not the last attempt, continue retrying
                Write-Warning "Attempt $attempt failed for $Description`: $errorMessage"
            }
        }
    }
}

# Functions and global variables are automatically available when this script is dot-sourced or executed with Invoke-Expression
