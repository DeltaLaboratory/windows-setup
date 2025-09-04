# GUI Progress Feature

The Windows Setup tool now includes an optional GUI progress window that provides a visual interface for monitoring the setup progress.

## Features

- **Optional GUI Mode**: Enable with `-UseGUI` parameter
- **Progress Window**: Simple Windows Forms-based progress window
- **Real-time Updates**: Shows current step and overall progress percentage
- **Completion Dialog**: Shows final status with success/warning information
- **Fallback Support**: Automatically falls back to console mode if GUI is unavailable

## Usage

### Using the Enhanced Loader (invoke.ps1)
```powershell
.\invoke.ps1 -UseGUI
```

### Using the Main Script Directly (main.ps1)
```powershell
.\main.ps1 -UseGUI
```

### Using the Batch File
```batch
invoke-gui.bat
```

## GUI Window Components

- **Title Bar**: Shows "Windows Setup Progress"
- **Current Step**: Displays the current operation being performed
- **Progress Bar**: Visual progress indicator (0-100%)
- **Status Text**: Detailed status information about the current step
- **Completion Dialog**: Summary dialog when setup completes

## Requirements

- Windows PowerShell 5.1 or PowerShell Core 6.0+
- Windows Forms support (included with Windows)
- System.Drawing assembly support

## Fallback Behavior

If GUI mode is requested but not available:
1. The system will automatically detect if Windows Forms is available
2. If not available, it will fall back to console-only mode
3. A warning will be displayed about the fallback
4. All functionality continues to work in console mode

## Testing

Use the included test script to verify GUI functionality:
```powershell
.\test-gui.ps1 -UseGUI
```

## Compatibility

- **Console Mode**: Default behavior, works on all PowerShell installations
- **GUI Mode**: Requires Windows Forms, automatically detects availability
- **Backward Compatibility**: All existing functionality preserved
- **Remote Execution**: GUI mode disabled when running remotely

## Technical Details

The GUI implementation uses:
- `System.Windows.Forms` for the main window and controls
- `System.Drawing` for colors and fonts
- Non-blocking window updates with `DoEvents()`
- Automatic cleanup on completion or error