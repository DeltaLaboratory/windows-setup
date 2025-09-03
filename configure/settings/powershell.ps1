# Load dependencies - this script should only be called from main.ps1 or other scripts that have already loaded config and utils

Write-BoxedHeader "⚡ POWERSHELL PROFILE CONFIGURATION" "Blue" 60

$progressIdPowershell = $Global:PROGRESS_IDS.PowerShell
$psTotalSteps = 1
$psCurrentStep = 0

Write-StatusLine "🔧" "Setting up PowerShell 7 profile and environment..." "Yellow"
Write-StatusLine "📊" "Total Configuration Steps: $psTotalSteps" "DarkGray"
Write-Host ""

$psCurrentStep++; $statusMessage = "Setting up Powershell 7 Profile..."; Write-Progress -Activity "PowerShell Profile Configuration" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($psCurrentStep / $psTotalSteps) * 100))) -Id $progressIdPowershell
Write-SectionHeader "POWERSHELL 7 PROFILE SETUP" "📝"
I "Setting up PowerShell 7..."
I "Setting up PowerShell 7 Profile..."

try {
    Write-StatusLine "📁" "Creating PowerShell directories..." "Cyan"
    New-Item -Path $env:USERPROFILE\Documents\PowerShell -ItemType Directory -Force -ErrorAction Stop | Out-Null
    New-Item -Path $env:USERPROFILE\Documents\PowerShell\Transcripts -ItemType Directory -Force -ErrorAction Stop | Out-Null
    New-Item -Path $env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 -ItemType File -Force -ErrorAction Stop | Out-Null

    Write-StatusLine "📝" "Writing custom PowerShell profile..." "Cyan"
    Write-Output @"
# PowerShell 7 Path Ignore Fix
`$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# MSYS2 Path
`$env:Path += ";C:\Users\$env:USERNAME\scoop\apps\msys2\current\ucrt64\bin"

function prompt {
    #region Variable Definition
    `$CmdPromptUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    `$ShortPath = `$pwd.Path.Replace(`$HOME, "~")
    `$IsAdmin = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

    # Calculate execution time
    `$LastCommand = Get-History -Count 1
    if (`$lastCommand) {
        `$RunTime = (`$lastCommand.EndExecutionTime - `$lastCommand.StartExecutionTime).TotalSeconds
        `$ElapsedTime = if (`$RunTime -ge 60) {
            `$ts = [timespan]::fromseconds(`$RunTime)
            `$min, `$sec = (`$ts.ToString("mm\:ss")).Split(":")
            "`${min}m`${sec}s"
        } else {
            "`$([math]::Round((`$RunTime), 2))s"
        }
    }

    # Check for Git repository
    `$GitStatus = `$null
    if (Get-Command git -ErrorAction SilentlyContinue) {
        `$GitDir = git rev-parse --git-dir 2>`$null
        if (`$?) {
            `$Branch = git symbolic-ref --short HEAD 2>`$null
            if (`$?) {
                `$GitStatus = `$Branch
            }
        }
    }
    #endregion

    #region Prompt Display
    Write-Host ""
    Write-Host "[" -ForegroundColor DarkGray -NoNewline
    Write-Host "`$(`$CmdPromptUser.Name.split("\")[1])" -ForegroundColor Yellow -NoNewline
    if (`$IsAdmin) { Write-Host "⚡" -ForegroundColor Red -NoNewline }
    Write-Host "|" -ForegroundColor DarkGray -NoNewline
    Write-Host `$ShortPath -ForegroundColor Blue -NoNewline

    # Display Git status if available
    if (`$GitStatus) {
        Write-Host "|" -ForegroundColor DarkGray -NoNewline
        Write-Host `$GitStatus -ForegroundColor Magenta -NoNewline
    }

    # Display elapsed time only if it exists
    if (`$ElapsedTime) {
        Write-Host "|" -ForegroundColor DarkGray -NoNewline
        Write-Host "`$ElapsedTime" -ForegroundColor Green -NoNewline
    }

    Write-Host "] " -ForegroundColor DarkGray -NoNewline
    return "`$('>' * (`$nestedPromptLevel + 1)) "
    #endregion
}
"@ | Out-File -FilePath $env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 -Encoding utf8 -ErrorAction Stop

    Write-StatusLine "✨" "Profile features configured:" "Green"
    Write-StatusLine "  🎨" "Custom prompt with user, path, and admin indicator" "DarkGray"
    Write-StatusLine "  ⏱️" "Command execution time tracking" "DarkGray"
    Write-StatusLine "  🌿" "Git branch status in prompt" "DarkGray"
    Write-StatusLine "  🛤️" "Proper PATH environment management" "DarkGray"
    Write-StatusLine "  🔧" "MSYS2 integration" "DarkGray"

    Write-Success "PowerShell 7 Profile setup completed successfully!"
} catch {
    E "Error setting up PowerShell 7 profile: $($_.Exception.Message)"
    Write-Progress -Activity "PowerShell Profile Configuration" -Status "Error setting up profile" -Completed -Id $progressIdPowershell
    throw $_
}

Write-Progress -Activity "PowerShell Profile Configuration" -Completed -Id $progressIdPowershell
Write-Host ""
Write-BoxedHeader "✅ POWERSHELL PROFILE COMPLETED" "Green" 50
