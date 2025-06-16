function I {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Output
    )
    Write-Host $Output -ForegroundColor White
}

function D {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Output
    )
    Write-Host $Output -ForegroundColor DarkGray
}

function E {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Output
    )
    Write-Host $Output -ForegroundColor Red
}

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
        D "Set registry value: $($Path)\$($Name) = $($Value) ($($Type))"

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

$Host.UI.RawUI.BackgroundColor = 'Black'
$Host.UI.RawUI.ForegroundColor = 'White'
Clear-Host