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

function Write-SectionHeader {
    param(
        [string]$Title,
        [string]$Icon = "📋"
    )
    Write-Host ""
    Write-Host " $Icon $Title " -ForegroundColor "Cyan" -BackgroundColor "DarkBlue"
    Write-Host (" " + "─" * ($Title.Length + 4)) -ForegroundColor "Cyan"
}

# Enhanced Logging Functions
function I {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Output
    )
    Write-StatusLine "ℹ️" $Output "White"
}

function D {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Output
    )
    Write-StatusLine "🔍" $Output "DarkGray"
}

function E {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Output
    )
    Write-StatusLine "❌" $Output "Red"
}

function Write-Success {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Output
    )
    Write-StatusLine "✅" $Output "Green"
}

function Write-Warning {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Output
    )
    Write-StatusLine "⚠️" $Output "Yellow"
}

# Enhanced Registry Functions
function Set-RegistryValue {
    param(
        [string]$Path,
        [string]$Name,
        [object]$Value,
        [string]$Type
    )
    try {
        # Get original value if exists
        $originalValue = $null
        if (Test-Path -Path $Path) {
            try {
                $originalValue = Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue
            } catch {}
        }

        # Check if the path exists, if not, create it
        if (-not (Test-Path -Path $Path)) {
            New-Item -Path $Path -ItemType Directory -Force | Out-Null
        }

        # Set the registry property
        New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType $Type -Force | Out-Null
        D "Registry: $($Path)\$($Name) = $($Value) ($($Type))"

        # Create change record
        $changeRecord = @{
            Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Path = $Path
            Name = $Name
            NewValue = $Value
            NewType = $Type
            OriginalValue = if ($originalValue) { $originalValue.$Name } else { $null }
            OriginalType = if ($originalValue) { $originalValue.GetType().Name } else { $null }
        }

        # Save change record to file
        $recordPath = Join-Path $env:USERPROFILE "Documents\RegistryChanges.jsonl"
        $changeRecord | ConvertTo-Json | Add-Content $recordPath
    }
    catch {
        E "Failed to set registry value: $($Path)\$($Name). Error: $($_.Exception.Message)"
        throw "Failed to set registry value: $($Path)\$($Name). Error: $($_.Exception.Message)"
    }
}

function Set-RegistryDword {
    param(
        [string]$Path,
        [string]$Name,
        [int]$Value
    )
    Set-RegistryValue -Path $Path -Name $Name -Value $Value -Type DWord
}

function Set-RegistryString {
    param(
        [string]$Path,
        [string]$Name,
        [string]$Value
    )
    Set-RegistryValue -Path $Path -Name $Name -Value $Value -Type String
}

# Set console colors for better TUI experience
$Host.UI.RawUI.BackgroundColor = 'Black'
$Host.UI.RawUI.ForegroundColor = 'White'
