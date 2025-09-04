#Requires -RunAsAdministrator
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Standalone script to disable Windows Defender Real-Time Protection
# WARNING: Disabling real-time protection reduces system security

# TUI Helper Functions for Enhanced Visual Experience
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

# Enhanced Registry Functions
function Set-RegistryValue {
    param(
        [string]$Path,
        [string]$Name,
        [object]$Value,
        [string]$Type,
        [switch]$ContinueOnError
    )
    try {
        # Check if the path exists, if not, create it
        if (-not (Test-Path -Path $Path)) {
            try {
                New-Item -Path $Path -ItemType Directory -Force | Out-Null
            } catch {
                if (-not $ContinueOnError) {
                    throw "Failed to create registry path: $Path. Error: $($_.Exception.Message)"
                }
                Write-ProgressStep "Failed to create registry path: $Path. Error: $($_.Exception.Message)" "ERROR"
                return $false
            }
        }

        # Set the registry property
        try {
            New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType $Type -Force | Out-Null
            Write-ProgressStep "Registry: $($Path)\$($Name) = $($Value) ($($Type))" "SUCCESS"
        } catch {
            if (-not $ContinueOnError) {
                throw "Failed to set registry value: $($Path)\$($Name). Error: $($_.Exception.Message)"
            }
            Write-ProgressStep "Failed to set registry value: $($Path)\$($Name). Error: $($_.Exception.Message)" "ERROR"
            return $false
        }
        
        return $true
    }
    catch {
        if (-not $ContinueOnError) {
            Write-ProgressStep "Failed to set registry value: $($Path)\$($Name). Error: $($_.Exception.Message)" "ERROR"
            throw "Failed to set registry value: $($Path)\$($Name). Error: $($_.Exception.Message)"
        }
        Write-ProgressStep "Failed to set registry value: $($Path)\$($Name). Error: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

function Set-RegistryDword {
    param(
        [string]$Path,
        [string]$Name,
        [int]$Value,
        [switch]$ContinueOnError
    )
    Set-RegistryValue -Path $Path -Name $Name -Value $Value -Type DWord -ContinueOnError:$ContinueOnError
}

# Check if running as administrator
function Test-IsAdministrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Main execution
try {
    Clear-Host
    
    # Main Header
    Write-BoxedHeader "🛡️ DISABLE WINDOWS DEFENDER REAL-TIME PROTECTION" "Red" 70
    
    # Security Warning
    Write-Host ""
    Write-StatusLine "⚠️" "WARNING: This script will disable Windows Defender real-time protection" "Yellow"
    Write-StatusLine "🔓" "This action reduces your system's security against malware" "Yellow"
    Write-StatusLine "💡" "Only proceed if you understand the security implications" "Yellow"
    Write-Host ""
    
    # Confirm action
    $confirmation = Read-Host "Do you want to continue? (Type 'YES' to confirm)"
    if ($confirmation -ne "YES") {
        Write-StatusLine "❌" "Operation cancelled by user" "Red"
        exit 1
    }
    
    Write-Host ""
    Write-BoxedHeader "🔧 DISABLING REAL-TIME PROTECTION" "Yellow" 50
    
    # Check administrator privileges
    Write-ProgressStep "Checking administrator privileges..." "IN_PROGRESS"
    if (-not (Test-IsAdministrator)) {
        Write-ProgressStep "Administrator privileges required" "ERROR"
        Write-StatusLine "❌" "This script must be run as Administrator" "Red"
        Write-StatusLine "💡" "Right-click and select 'Run as Administrator'" "Cyan"
        exit 1
    }
    Write-ProgressStep "Administrator privileges confirmed" "SUCCESS"
    
    $methods = @()
    $successCount = 0
    
    # Method 1: PowerShell Cmdlets (Primary method)
    Write-ProgressStep "Attempting to disable via PowerShell cmdlets..." "IN_PROGRESS"
    try {
        # Check if Windows Defender module is available
        if (Get-Module -ListAvailable -Name Defender) {
            Import-Module Defender -ErrorAction Stop
            Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction Stop
            Write-ProgressStep "PowerShell cmdlet method successful" "SUCCESS"
            $methods += "PowerShell Cmdlets"
            $successCount++
        } else {
            throw "Windows Defender PowerShell module not available"
        }
    } catch {
        Write-ProgressStep "PowerShell cmdlet method failed: $($_.Exception.Message)" "ERROR"
    }
    
    # Method 2: Registry Method (Fallback)
    Write-ProgressStep "Attempting to disable via registry..." "IN_PROGRESS"
    try {
        $registrySuccess = $true
        
        # Set registry values for Windows Defender real-time protection
        if (-not (Set-RegistryDword -Path "HKLM:\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableRealtimeMonitoring" -Value 1 -ContinueOnError)) {
            $registrySuccess = $false
        }
        
        if (-not (Set-RegistryDword -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableRealtimeMonitoring" -Value 1 -ContinueOnError)) {
            $registrySuccess = $false
        }
        
        if ($registrySuccess) {
            Write-ProgressStep "Registry method successful" "SUCCESS"
            $methods += "Registry Keys"
            $successCount++
        } else {
            Write-ProgressStep "Registry method had some failures" "WARNING"
        }
    } catch {
        Write-ProgressStep "Registry method failed: $($_.Exception.Message)" "ERROR"
    }
    
    # Display results
    Write-Host ""
    if ($successCount -gt 0) {
        Write-BoxedHeader "✅ REAL-TIME PROTECTION DISABLED" "Green" 50
        Write-StatusLine "🎯" "Windows Defender real-time protection has been disabled" "Green"
        Write-StatusLine "📊" "Methods used: $($methods -join ', ')" "Cyan"
        Write-StatusLine "🔄" "Changes take effect immediately" "Green"
    } else {
        Write-BoxedHeader "❌ OPERATION FAILED" "Red" 50
        Write-StatusLine "❌" "Failed to disable Windows Defender real-time protection" "Red"
        Write-StatusLine "💡" "Try running as Administrator or check system policies" "Yellow"
    }
    
    Write-Host ""
    Write-StatusLine "⚠️" "Security Reminder: Your system is now more vulnerable to malware" "Yellow"
    Write-StatusLine "🔧" "To re-enable protection, run 'enable-defender-realtime.ps1'" "Cyan"
    
} catch {
    Write-Host ""
    Write-BoxedHeader "❌ UNEXPECTED ERROR" "Red" 50
    Write-StatusLine "❌" "An unexpected error occurred: $($_.Exception.Message)" "Red"
    Write-StatusLine "💡" "Please check the error details and try again" "Yellow"
    exit 1
}

Write-Host ""
Write-StatusLine "✨" "Script execution completed" "Green"
Read-Host "Press Enter to continue"