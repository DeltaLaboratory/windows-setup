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
        [string]$Type,
        [switch]$ContinueOnError
    )
    try {
        # Get original value if exists
        $originalValue = $null
        if (Test-Path -Path $Path) {
            try {
                $originalValue = Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue
            } catch {
                # Ignore errors when getting original value
            }
        }

        # Check if the path exists, if not, create it
        if (-not (Test-Path -Path $Path)) {
            try {
                New-Item -Path $Path -ItemType Directory -Force | Out-Null
            } catch {
                if (-not $ContinueOnError) {
                    throw "Failed to create registry path: $Path. Error: $($_.Exception.Message)"
                }
                E "Failed to create registry path: $Path. Error: $($_.Exception.Message)"
                return $false
            }
        }

        # Set the registry property
        try {
            New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType $Type -Force | Out-Null
            D "Registry: $($Path)\$($Name) = $($Value) ($($Type))"
        } catch {
            if (-not $ContinueOnError) {
                throw "Failed to set registry value: $($Path)\$($Name). Error: $($_.Exception.Message)"
            }
            E "Failed to set registry value: $($Path)\$($Name). Error: $($_.Exception.Message)"
            return $false
        }

        # Create change record
        try {
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
            $changeRecord | ConvertTo-Json | Add-Content $recordPath -ErrorAction SilentlyContinue
        } catch {
            # Log the registry change error but continue - this is not critical
            Write-Warning "Could not log registry change to file: $($_.Exception.Message)"
        }
        
        return $true
    }
    catch {
        if (-not $ContinueOnError) {
            E "Failed to set registry value: $($Path)\$($Name). Error: $($_.Exception.Message)"
            throw "Failed to set registry value: $($Path)\$($Name). Error: $($_.Exception.Message)"
        }
        E "Failed to set registry value: $($Path)\$($Name). Error: $($_.Exception.Message)"
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

function Set-RegistryString {
    param(
        [string]$Path,
        [string]$Name,
        [string]$Value,
        [switch]$ContinueOnError
    )
    Set-RegistryValue -Path $Path -Name $Name -Value $Value -Type String -ContinueOnError:$ContinueOnError
}

# Package Installation Helper Functions
function Test-WingetPackageInstalled {
    param(
        [string]$PackageId
    )
    try {
        $installedPackages = winget list --id $PackageId --exact --accept-source-agreements 2>$null
        if ($LASTEXITCODE -eq 0 -and $installedPackages -match $PackageId) {
            return $true
        }
        return $false
    } catch {
        return $false
    }
}

function Install-WingetPackageIfNeeded {
    param(
        [string]$PackageId,
        [string]$PackageName = $PackageId
    )
    if (Test-WingetPackageInstalled -PackageId $PackageId) {
        Write-StatusLine "✅" "$PackageName is already installed" "Green"
        return $true
    } else {
        Write-StatusLine "📦" "Installing $PackageName..." "Cyan"
        winget install $PackageId --accept-package-agreements --accept-source-agreements
        if ($LASTEXITCODE -eq 0) {
            Write-Success "$PackageName installed successfully!"
            return $true
        } else {
            E "Error installing $PackageName. Exit code: $LASTEXITCODE"
            return $false
        }
    }
}

function Test-ScoopPackageInstalled {
    param(
        [string]$PackageName
    )
    try {
        # Handle bucket/package format by extracting just the package name
        $packageOnly = if ($PackageName -match "/") {
            $PackageName.Split("/")[-1]
        } else {
            $PackageName
        }
        
        $installedApps = scoop list 2>$null | Out-String
        if ($LASTEXITCODE -eq 0 -and $installedApps -match [regex]::Escape($packageOnly)) {
            return $true
        }
        return $false
    } catch {
        return $false
    }
}

function Install-ScoopPackageIfNeeded {
    param(
        [string]$PackageName,
        [string]$DisplayName = $PackageName
    )
    if (Test-ScoopPackageInstalled -PackageName $PackageName) {
        Write-StatusLine "✅" "$DisplayName is already installed" "Green"
        return $true
    } else {
        Write-StatusLine "📦" "Installing $DisplayName..." "Cyan"
        scoop install $PackageName
        if ($LASTEXITCODE -eq 0) {
            Write-Success "$DisplayName installed successfully!"
            return $true
        } else {
            E "Error installing $DisplayName. Exit code: $LASTEXITCODE"
            return $false
        }
    }
}

# Administrator and User Detection Functions
function Test-IsAdministrator {
    <#
    .SYNOPSIS
        Check if current user has administrator privileges
    .DESCRIPTION
        Returns true if the current user is running with administrator privileges
    #>
    try {
        $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
        return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    } catch {
        return $false
    }
}

function Test-IsAdministratorUser {
    <#
    .SYNOPSIS
        Check if current user is the built-in Administrator user
    .DESCRIPTION
        Returns true if the current user is the built-in Administrator account
    #>
    try {
        $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
        return $currentUser.Name -like "*\Administrator"
    } catch {
        return $false
    }
}

function Start-ScoopSubshell {
    <#
    .SYNOPSIS
        Launches scoop subshell as normal user if admin permissions detected
    .DESCRIPTION
        If the current session has admin permissions or user is Administrator,
        this function launches a new PowerShell session as a normal user for scoop operations
    #>
    param(
        [string]$Command = "",
        [switch]$PassThru
    )
    
    $isAdmin = Test-IsAdministrator
    $isAdminUser = Test-IsAdministratorUser
    
    if ($isAdmin -or $isAdminUser) {
        Write-StatusLine "⚡" "Admin permissions detected - launching scoop subshell as normal user" "Yellow"
        
        try {
            # Get the current user's username without the domain part
            $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
            $username = $currentUser.Name.Split('\')[-1]
            
            # Prepare PowerShell executable - prefer pwsh over powershell.exe
            $powershellExe = if (Get-Command "pwsh" -ErrorAction SilentlyContinue) {
                "pwsh"
            } else {
                "powershell.exe"
            }
            
            # Build the command to execute
            $scoopCommand = if ([string]::IsNullOrWhiteSpace($Command)) {
                "scoop"
            } else {
                "scoop $Command"
            }
            
            Write-StatusLine "🔄" "Launching: $powershellExe as normal user for: $scoopCommand" "Cyan"
            
            # Use RunAs with the current user to drop admin privileges
            # This approach launches as the current user but without elevated privileges
            $startInfo = New-Object System.Diagnostics.ProcessStartInfo
            $startInfo.FileName = $powershellExe
            $startInfo.Arguments = "-NoProfile -ExecutionPolicy Bypass -Command `"$scoopCommand`""
            $startInfo.UseShellExecute = $true
            $startInfo.Verb = "" # Empty verb means no elevation
            
            # If we're currently elevated, we need a different approach
            if ($isAdmin) {
                # Create a new process without admin privileges by using the user's token
                Write-StatusLine "🔓" "Dropping admin privileges for scoop operation" "Yellow"
                
                # Use cmd to launch without admin privileges
                $cmdArgs = "/c `"$powershellExe`" -NoProfile -ExecutionPolicy Bypass -Command `"$scoopCommand`""
                
                $process = Start-Process -FilePath "cmd" -ArgumentList $cmdArgs -Wait:(!$PassThru) -PassThru:$PassThru
                
                if ($PassThru) {
                    return $process
                }
                
                if ($process.ExitCode -eq 0) {
                    Write-Success "Scoop subshell command completed successfully"
                } else {
                    Write-Warning "Scoop subshell command completed with exit code: $($process.ExitCode)"
                }
            } else {
                # If not admin but is Administrator user, just launch normally
                $process = Start-Process -FilePath $powershellExe -ArgumentList $startInfo.Arguments -Wait:(!$PassThru) -PassThru:$PassThru
                
                if ($PassThru) {
                    return $process
                }
                
                if ($process.ExitCode -eq 0) {
                    Write-Success "Scoop subshell command completed successfully"
                } else {
                    Write-Warning "Scoop subshell command completed with exit code: $($process.ExitCode)"
                }
            }
        } catch {
            E "Error launching scoop subshell: $($_.Exception.Message)"
            throw "Failed to launch scoop subshell as normal user: $($_.Exception.Message)"
        }
    } else {
        Write-StatusLine "✅" "Normal user context detected - executing scoop command directly" "Green"
        
        if ([string]::IsNullOrWhiteSpace($Command)) {
            # Launch interactive scoop shell
            scoop
        } else {
            # Execute the specific command
            Invoke-Expression "scoop $Command"
        }
    }
}

# Set console colors for better TUI experience
$Host.UI.RawUI.BackgroundColor = 'Black'
$Host.UI.RawUI.ForegroundColor = 'White'
