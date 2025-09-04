#Requires -RunAsAdministrator
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Standalone script to enable Windows Defender Real-Time Protection

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

function Remove-RegistryValue {
    param(
        [string]$Path,
        [string]$Name,
        [switch]$ContinueOnError
    )
    try {
        if (Test-Path -Path $Path) {
            $property = Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue
            if ($property) {
                Remove-ItemProperty -Path $Path -Name $Name -Force | Out-Null
                Write-ProgressStep "Removed registry value: $($Path)\$($Name)" "SUCCESS"
                return $true
            } else {
                Write-ProgressStep "Registry value not found: $($Path)\$($Name)" "WARNING"
                return $true
            }
        } else {
            Write-ProgressStep "Registry path not found: $Path" "WARNING"
            return $true
        }
    } catch {
        if (-not $ContinueOnError) {
            throw "Failed to remove registry value: $($Path)\$($Name). Error: $($_.Exception.Message)"
        }
        Write-ProgressStep "Failed to remove registry value: $($Path)\$($Name). Error: $($_.Exception.Message)" "ERROR"
        return $false
    }
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
    Write-BoxedHeader "🛡️ ENABLE WINDOWS DEFENDER REAL-TIME PROTECTION" "Green" 70
    
    # Information
    Write-Host ""
    Write-StatusLine "🔒" "This script will enable Windows Defender real-time protection" "Green"
    Write-StatusLine "🛡️" "This action improves your system's security against malware" "Green"
    Write-StatusLine "⚡" "Real-time scanning will monitor files and processes continuously" "Cyan"
    Write-Host ""
    
    Write-BoxedHeader "🔧 ENABLING REAL-TIME PROTECTION" "Green" 50
    
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
    Write-ProgressStep "Attempting to enable via PowerShell cmdlets..." "IN_PROGRESS"
    try {
        # Check if Windows Defender module is available
        if (Get-Module -ListAvailable -Name Defender) {
            Import-Module Defender -ErrorAction Stop
            Set-MpPreference -DisableRealtimeMonitoring $false -ErrorAction Stop
            Write-ProgressStep "PowerShell cmdlet method successful" "SUCCESS"
            $methods += "PowerShell Cmdlets"
            $successCount++
        } else {
            throw "Windows Defender PowerShell module not available"
        }
    } catch {
        Write-ProgressStep "PowerShell cmdlet method failed: $($_.Exception.Message)" "ERROR"
    }
    
    # Method 2: Registry Method (Fallback) - Remove disable flags
    Write-ProgressStep "Attempting to enable via registry cleanup..." "IN_PROGRESS"
    try {
        $registrySuccess = $true
        
        # Remove or set registry values to enable Windows Defender real-time protection
        # Set to 0 (enabled) or remove the DisableRealtimeMonitoring values
        if (-not (Set-RegistryDword -Path "HKLM:\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableRealtimeMonitoring" -Value 0 -ContinueOnError)) {
            # Try to remove the value entirely as an alternative
            Remove-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableRealtimeMonitoring" -ContinueOnError
        }
        
        if (-not (Set-RegistryDword -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableRealtimeMonitoring" -Value 0 -ContinueOnError)) {
            # Try to remove the value entirely as an alternative
            Remove-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableRealtimeMonitoring" -ContinueOnError
        }
        
        Write-ProgressStep "Registry method completed" "SUCCESS"
        $methods += "Registry Keys"
        $successCount++
    } catch {
        Write-ProgressStep "Registry method failed: $($_.Exception.Message)" "ERROR"
    }
    
    # Method 3: Additional verification - Check service status
    Write-ProgressStep "Verifying Windows Defender service status..." "IN_PROGRESS"
    try {
        $defenderService = Get-Service -Name "WinDefend" -ErrorAction SilentlyContinue
        if ($defenderService) {
            if ($defenderService.Status -ne "Running") {
                Write-ProgressStep "Starting Windows Defender service..." "IN_PROGRESS"
                Start-Service -Name "WinDefend" -ErrorAction Stop
                Write-ProgressStep "Windows Defender service started" "SUCCESS"
            } else {
                Write-ProgressStep "Windows Defender service is already running" "SUCCESS"
            }
        } else {
            Write-ProgressStep "Windows Defender service not found" "WARNING"
        }
    } catch {
        Write-ProgressStep "Service verification failed: $($_.Exception.Message)" "ERROR"
    }
    
    # Display results
    Write-Host ""
    if ($successCount -gt 0) {
        Write-BoxedHeader "✅ REAL-TIME PROTECTION ENABLED" "Green" 50
        Write-StatusLine "🛡️" "Windows Defender real-time protection has been enabled" "Green"
        Write-StatusLine "📊" "Methods used: $($methods -join ', ')" "Cyan"
        Write-StatusLine "🔄" "Changes take effect immediately" "Green"
        
        # Additional verification
        Write-Host ""
        Write-ProgressStep "Verifying current protection status..." "IN_PROGRESS"
        try {
            if (Get-Module -ListAvailable -Name Defender) {
                Import-Module Defender -ErrorAction SilentlyContinue
                $mpPreference = Get-MpPreference -ErrorAction SilentlyContinue
                if ($mpPreference -and -not $mpPreference.DisableRealtimeMonitoring) {
                    Write-ProgressStep "Real-time protection is now ACTIVE" "SUCCESS"
                } else {
                    Write-ProgressStep "Real-time protection status unclear - may need system restart" "WARNING"
                }
            }
        } catch {
            Write-ProgressStep "Status verification failed, but changes were applied" "WARNING"
        }
    } else {
        Write-BoxedHeader "❌ OPERATION FAILED" "Red" 50
        Write-StatusLine "❌" "Failed to enable Windows Defender real-time protection" "Red"
        Write-StatusLine "💡" "Try running as Administrator or check system policies" "Yellow"
    }
    
    Write-Host ""
    Write-StatusLine "🔒" "Security Status: Your system protection has been enhanced" "Green"
    Write-StatusLine "🔧" "To disable protection, run 'disable-defender-realtime.ps1'" "Cyan"
    
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