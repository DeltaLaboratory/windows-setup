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

# Function to safely invoke remote script with error handling
function Invoke-RemoteScript {
    param(
        [string]$Url,
        [string]$Description = "Remote script"
    )

    try {
        I "Executing $Description from: $Url"
        Invoke-RestMethod -Uri $Url | Invoke-Expression
    } catch {
        E "Failed to execute $Description from $Url"
        E "Error: $($_.Exception.Message)"
        throw $_
    }
}

# Export functions for use in other scripts
Export-ModuleMember -Function Get-ProgressId, Invoke-RemoteScript -Variable PROGRESS_IDS, REPO_BASE_URL, UTILS_URL, REGISTRY_SYSTEM_URL, REGISTRY_HARDENING_URL, REGISTRY_BROWSER_URL, REGISTRY_MISC_URL, SETTINGS_GENERAL_URL, SETTINGS_POWERSHELL_URL, WINGET_CONFIG_URL, SCOOP_CONFIG_URL
