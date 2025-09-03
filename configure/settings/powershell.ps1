# Load dependencies - this script should only be called from main.ps1 or other scripts that have already loaded config and utils

$progressIdPowershell = $Global:PROGRESS_IDS.PowerShell
$psTotalSteps = 1 # Only one main operation: setting up the profile
$psCurrentStep = 0

$psCurrentStep++; $statusMessage = "Setting up Powershell 7 Profile..."; Write-Progress -Activity "PowerShell Profile Configuration" -Status $statusMessage -PercentComplete (($psCurrentStep / $psTotalSteps) * 100) -Id $progressIdPowershell
I "Setting up Powershell 7..."
I "Setting up Powershell 7 Profile..."

try {
    New-Item -Path $env:USERPROFILE\Documents\PowerShell -ItemType Directory -Force -ErrorAction Stop | Out-Null
    New-Item -Path $env:USERPROFILE\Documents\PowerShell\Transcripts -ItemType Directory -Force -ErrorAction Stop | Out-Null # For Transcripts
    New-Item -Path $env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 -ItemType File -Force -ErrorAction Stop | Out-Null

    Write-Output @"
# PowerShell 7 Path Ingnore Fix
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
    I "Setting up Powershell 7 Profile Completed Successfully!"
} catch {
    E "Error setting up Powershell 7 profile: $($_.Exception.Message)"
    Write-Progress -Activity "PowerShell Profile Configuration" -Status "Error setting up profile" -Completed -Id $progressIdPowershell # Mark as completed to remove
    # Optionally, exit the script or take other error handling actions
    throw $_ # Re-throw the exception to be caught by main.ps1
}
Write-Progress -Activity "PowerShell Profile Configuration" -Completed -Id $progressIdPowershell
