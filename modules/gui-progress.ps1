# GUI Progress Module for Windows Setup
# Provides an optional GUI progress window using Windows Forms

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Global GUI variables
$Global:ProgressForm = $null
$Global:ProgressBar = $null
$Global:StatusLabel = $null
$Global:StepLabel = $null
$Global:UseGUI = $false

function Initialize-ProgressGUI {
    <#
    .SYNOPSIS
    Initialize the GUI progress window
    #>
    param(
        [string]$Title = "Windows Setup Progress",
        [int]$Width = 500,
        [int]$Height = 200
    )
    
    if ($Global:UseGUI -eq $false) {
        return
    }
    
    try {
        # Create main form
        $Global:ProgressForm = New-Object System.Windows.Forms.Form
        $Global:ProgressForm.Text = $Title
        $Global:ProgressForm.Size = New-Object System.Drawing.Size($Width, $Height)
        $Global:ProgressForm.StartPosition = "CenterScreen"
        $Global:ProgressForm.FormBorderStyle = "FixedSingle"
        $Global:ProgressForm.MaximizeBox = $false
        $Global:ProgressForm.MinimizeBox = $true
        $Global:ProgressForm.TopMost = $false
        $Global:ProgressForm.BackColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
        
        # Create title label
        $titleLabel = New-Object System.Windows.Forms.Label
        $titleLabel.Text = "🖥️ Windows Setup Configuration"
        $titleLabel.Size = New-Object System.Drawing.Size(460, 25)
        $titleLabel.Location = New-Object System.Drawing.Point(20, 20)
        $titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
        $titleLabel.TextAlign = "MiddleCenter"
        $titleLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
        $Global:ProgressForm.Controls.Add($titleLabel)
        
        # Create current step label
        $Global:StepLabel = New-Object System.Windows.Forms.Label
        $Global:StepLabel.Text = "Initializing..."
        $Global:StepLabel.Size = New-Object System.Drawing.Size(460, 20)
        $Global:StepLabel.Location = New-Object System.Drawing.Point(20, 55)
        $Global:StepLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
        $Global:StepLabel.ForegroundColor = [System.Drawing.Color]::FromArgb(68, 68, 68)
        $Global:ProgressForm.Controls.Add($Global:StepLabel)
        
        # Create progress bar
        $Global:ProgressBar = New-Object System.Windows.Forms.ProgressBar
        $Global:ProgressBar.Size = New-Object System.Drawing.Size(460, 20)
        $Global:ProgressBar.Location = New-Object System.Drawing.Point(20, 85)
        $Global:ProgressBar.Style = "Continuous"
        $Global:ProgressBar.Minimum = 0
        $Global:ProgressBar.Maximum = 100
        $Global:ProgressBar.Value = 0
        $Global:ProgressForm.Controls.Add($Global:ProgressBar)
        
        # Create status label
        $Global:StatusLabel = New-Object System.Windows.Forms.Label
        $Global:StatusLabel.Text = "Ready to begin setup..."
        $Global:StatusLabel.Size = New-Object System.Drawing.Size(460, 40)
        $Global:StatusLabel.Location = New-Object System.Drawing.Point(20, 115)
        $Global:StatusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8)
        $Global:StatusLabel.ForegroundColor = [System.Drawing.Color]::FromArgb(102, 102, 102)
        $Global:ProgressForm.Controls.Add($Global:StatusLabel)
        
        # Show form non-blocking
        $Global:ProgressForm.Show()
        $Global:ProgressForm.Refresh()
        [System.Windows.Forms.Application]::DoEvents()
        
        Write-Host "GUI Progress window initialized successfully" -ForegroundColor Green
    } catch {
        Write-Warning "Failed to initialize GUI progress window: $($_.Exception.Message)"
        Write-Warning "Falling back to console progress display"
        $Global:UseGUI = $false
    }
}

function Update-ProgressGUI {
    <#
    .SYNOPSIS
    Update the GUI progress display
    #>
    param(
        [string]$Step = "",
        [string]$Status = "",
        [int]$PercentComplete = -1
    )
    
    if ($Global:UseGUI -eq $false -or $Global:ProgressForm -eq $null) {
        return
    }
    
    try {
        if ($Global:ProgressForm.IsDisposed) {
            $Global:UseGUI = $false
            return
        }
        
        if ($Step -ne "" -and $Global:StepLabel -ne $null) {
            $Global:StepLabel.Text = $Step
        }
        
        if ($Status -ne "" -and $Global:StatusLabel -ne $null) {
            $Global:StatusLabel.Text = $Status
        }
        
        if ($PercentComplete -ge 0 -and $PercentComplete -le 100 -and $Global:ProgressBar -ne $null) {
            $Global:ProgressBar.Value = $PercentComplete
        }
        
        $Global:ProgressForm.Refresh()
        [System.Windows.Forms.Application]::DoEvents()
        
        # Small delay to prevent GUI freezing
        Start-Sleep -Milliseconds 50
    } catch {
        Write-Warning "Error updating GUI progress: $($_.Exception.Message)"
        # Don't disable GUI on update errors, just continue
    }
}

function Close-ProgressGUI {
    <#
    .SYNOPSIS
    Close and cleanup the GUI progress window
    #>
    if ($Global:UseGUI -eq $false -or $Global:ProgressForm -eq $null) {
        return
    }
    
    try {
        if (-not $Global:ProgressForm.IsDisposed) {
            $Global:ProgressForm.Close()
            $Global:ProgressForm.Dispose()
        }
        $Global:ProgressForm = $null
        $Global:ProgressBar = $null
        $Global:StatusLabel = $null
        $Global:StepLabel = $null
        Write-Host "GUI Progress window closed" -ForegroundColor Green
    } catch {
        Write-Warning "Error closing GUI progress window: $($_.Exception.Message)"
    }
}

function Show-CompletionDialog {
    <#
    .SYNOPSIS
    Show a completion dialog with summary
    #>
    param(
        [string]$Title = "Setup Complete",
        [string]$Message = "Windows setup completed successfully!",
        [string]$Icon = "Information"
    )
    
    if ($Global:UseGUI -eq $false) {
        return
    }
    
    try {
        $iconType = switch ($Icon) {
            "Error" { [System.Windows.Forms.MessageBoxIcon]::Error }
            "Warning" { [System.Windows.Forms.MessageBoxIcon]::Warning }
            "Question" { [System.Windows.Forms.MessageBoxIcon]::Question }
            default { [System.Windows.Forms.MessageBoxIcon]::Information }
        }
        
        [System.Windows.Forms.MessageBox]::Show($Message, $Title, "OK", $iconType)
    } catch {
        Write-Warning "Error showing completion dialog: $($_.Exception.Message)"
    }
}

function Enable-ProgressGUI {
    <#
    .SYNOPSIS
    Enable GUI progress mode
    #>
    $Global:UseGUI = $true
    Write-Host "GUI Progress mode enabled" -ForegroundColor Cyan
}

function Disable-ProgressGUI {
    <#
    .SYNOPSIS
    Disable GUI progress mode and use console only
    #>
    $Global:UseGUI = $false
    Close-ProgressGUI
    Write-Host "GUI Progress mode disabled - using console output" -ForegroundColor Yellow
}

function Test-GUIAvailable {
    <#
    .SYNOPSIS
    Test if GUI components are available on this system
    #>
    try {
        Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop
        Add-Type -AssemblyName System.Drawing -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}

# Enhanced progress functions that support both GUI and console
function Write-ProgressGUI {
    <#
    .SYNOPSIS
    Enhanced Write-Progress that supports both GUI and console
    #>
    param(
        [string]$Activity,
        [string]$Status,
        [int]$PercentComplete = -1,
        [int]$Id = 1
    )
    
    # Always show console progress for compatibility
    if ($PercentComplete -ge 0) {
        Write-Progress -Activity $Activity -Status $Status -PercentComplete $PercentComplete -Id $Id
    } else {
        Write-Progress -Activity $Activity -Status $Status -Id $Id
    }
    
    # Also update GUI if enabled
    if ($Global:UseGUI) {
        Update-ProgressGUI -Step $Activity -Status $Status -PercentComplete $PercentComplete
    }
}

function Complete-ProgressGUI {
    <#
    .SYNOPSIS
    Complete progress in both GUI and console
    #>
    param(
        [int]$Id = 1
    )
    
    Write-Progress -Activity "Complete" -Completed -Id $Id
    
    if ($Global:UseGUI) {
        Update-ProgressGUI -Step "Complete" -Status "Setup finished!" -PercentComplete 100
    }
}