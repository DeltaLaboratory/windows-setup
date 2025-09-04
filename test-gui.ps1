# Test script for GUI Progress functionality
# This script tests the GUI components without running the full setup

param(
    [switch]$UseGUI
)

# Load the GUI progress module directly
if ($UseGUI) {
    Write-Host "Testing GUI Progress Module..." -ForegroundColor Cyan
    
    # Check if GUI components are available
    try {
        Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop
        Add-Type -AssemblyName System.Drawing -ErrorAction Stop
        Write-Host "✓ Windows Forms components are available" -ForegroundColor Green
    } catch {
        Write-Host "✗ Windows Forms components are not available: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
    
    # Load and test the GUI module
    try {
        . "$PSScriptRoot/modules/gui-progress.ps1"
        Write-Host "✓ GUI Progress module loaded successfully" -ForegroundColor Green
    } catch {
        Write-Host "✗ Failed to load GUI Progress module: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
    
    # Test GUI initialization
    try {
        Enable-ProgressGUI
        Initialize-ProgressGUI -Title "Windows Setup Test"
        Write-Host "✓ GUI Progress window initialized" -ForegroundColor Green
    } catch {
        Write-Host "✗ Failed to initialize GUI Progress: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
    
    # Test progress updates
    try {
        $steps = @(
            "Initializing system...",
            "Configuring registry...",
            "Installing packages...",
            "Applying settings...",
            "Finalizing setup..."
        )
        
        for ($i = 0; $i -lt $steps.Count; $i++) {
            $percent = [Math]::Round(($i / $steps.Count) * 100)
            Update-ProgressGUI -Step $steps[$i] -Status "Step $($i + 1) of $($steps.Count)" -PercentComplete $percent
            Write-Host "✓ Updated progress: $($steps[$i]) ($percent%)" -ForegroundColor Green
            Start-Sleep -Seconds 1
        }
        
        # Complete progress
        Update-ProgressGUI -Step "Complete" -Status "Setup finished!" -PercentComplete 100
        Write-Host "✓ Progress completed" -ForegroundColor Green
        
        Start-Sleep -Seconds 2
        
        # Test completion dialog
        Show-CompletionDialog -Title "Test Complete" -Message "GUI Progress test completed successfully!" -Icon "Information"
        Write-Host "✓ Completion dialog shown" -ForegroundColor Green
        
    } catch {
        Write-Host "✗ Error during progress testing: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    # Cleanup
    try {
        Close-ProgressGUI
        Write-Host "✓ GUI Progress window closed successfully" -ForegroundColor Green
    } catch {
        Write-Host "✗ Error closing GUI Progress: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "GUI Progress test completed!" -ForegroundColor Magenta
    
} else {
    Write-Host "GUI Test mode not enabled. Use -UseGUI parameter to test GUI functionality." -ForegroundColor Yellow
    Write-Host "Example: .\test-gui.ps1 -UseGUI" -ForegroundColor Cyan
}