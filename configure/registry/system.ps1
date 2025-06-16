$systemTotalSteps = 11
$systemCurrentStep = 0
$progressIdSystem = 2 # Using a specific ID for this script's progress bar

$systemCurrentStep++; $statusMessage = "Setting Global Codepage..."; Write-Progress -Activity "System Registry Configuration" -Status $statusMessage -PercentComplete (($systemCurrentStep / $systemTotalSteps) * 100) -Id $progressIdSystem
I $statusMessage
Set-RegistryString -Path "HKLM:\\SYSTEM\\CurrentControlSet\\Control\\Nls\\CodePage" -Name "ACP" -Value "65001"
Set-RegistryString -Path "HKLM:\\SYSTEM\\CurrentControlSet\\Control\\Nls\\CodePage" -Name "OEMCP" -Value "65001"
Set-RegistryString -Path "HKLM:\\SYSTEM\\CurrentControlSet\\Control\\Nls\\CodePage" -Name "MACCP" -Value "65001"

$systemCurrentStep++; $statusMessage = "Setting Registry: Console Startup..."; Write-Progress -Activity "System Registry Configuration" -Status $statusMessage -PercentComplete (($systemCurrentStep / $systemTotalSteps) * 100) -Id $progressIdSystem
I $statusMessage
Set-RegistryString -Path "HKCU:\\Console\\%%Startup" -Name "DelegationTerminal" -Value "{E12CFF52-A866-4C77-9A90-F570A7AA2C6B}"
Set-RegistryString -Path "HKCU:\\Console\\%%Startup" -Name "DelegationConsole" -Value "{2EACA947-7F5F-4CFA-BA87-8F7FBEEFBE69}"

$systemCurrentStep++; $statusMessage = "Setting Registry: PowerShell Execution Policy..."; Write-Progress -Activity "System Registry Configuration" -Status $statusMessage -PercentComplete (($systemCurrentStep / $systemTotalSteps) * 100) -Id $progressIdSystem
I $statusMessage
Set-RegistryString -Path "HKCU:\\Software\\Microsoft\\PowerShell\\1\\ShellIds\\Microsoft.PowerShell" -Name "ExecutionPolicy" -Value "RemoteSigned"

$systemCurrentStep++; $statusMessage = "Setting Registry: Explorer Advanced Settings..."; Write-Progress -Activity "System Registry Configuration" -Status $statusMessage -PercentComplete (($systemCurrentStep / $systemTotalSteps) * 100) -Id $progressIdSystem
I $statusMessage
Set-RegistryDword -Path "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced" -Name "HideDrivesWithNoMedia" -Value 0
Set-RegistryDword -Path "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced" -Name "Hidden" -Value 1
Set-RegistryDword -Path "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced" -Name "ShowSuperHidden" -Value 1
Set-RegistryDword -Path "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced" -Name "HideFileExt" -Value 0
Set-RegistryDword -Path "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced\\TaskbarDeveloperSettings" -Name "TaskbarEndTask" -Value 1

$systemCurrentStep++; $statusMessage = "Setting Registry: Taskbar Developer Settings..."; Write-Progress -Activity "System Registry Configuration" -Status $statusMessage -PercentComplete (($systemCurrentStep / $systemTotalSteps) * 100) -Id $progressIdSystem
I $statusMessage
Set-RegistryDword -Path "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced\\TaskbarDeveloperSettings" -Name "TaskbarEndTask" -Value 1

$systemCurrentStep++; $statusMessage = "Setting Registry: Explorer Policies..."; Write-Progress -Activity "System Registry Configuration" -Status $statusMessage -PercentComplete (($systemCurrentStep / $systemTotalSteps) * 100) -Id $progressIdSystem
I $statusMessage
Set-RegistryDword -Path "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer" -Name "NoDriveTypeAutoRun" -Value 0x91

$systemCurrentStep++; $statusMessage = "Setting Registry: Search Settings..."; Write-Progress -Activity "System Registry Configuration" -Status $statusMessage -PercentComplete (($systemCurrentStep / $systemTotalSteps) * 100) -Id $progressIdSystem
I $statusMessage
Set-RegistryDword -Path "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\SearchSettings" -Name "IsAADCloudSearchEnabled" -Value 0
Set-RegistryDword -Path "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\SearchSettings" -Name "IsDeviceSearchHistoryEnabled" -Value 0
Set-RegistryDword -Path "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\SearchSettings" -Name "IsMSACloudSearchEnabled" -Value 0
Set-RegistryDword -Path "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\SearchSettings" -Name "SafeSearchMode" -Value 0

$systemCurrentStep++; $statusMessage = "Setting Registry: Explorer Policies..."; Write-Progress -Activity "System Registry Configuration" -Status $statusMessage -PercentComplete (($systemCurrentStep / $systemTotalSteps) * 100) -Id $progressIdSystem
I $statusMessage # This is the second "Explorer Policies" block
Set-RegistryDword -Path "HKCU:\\Software\\Policies\\Microsoft\\Windows\\Explorer" -Name "DisableSearchBoxSuggestions" -Value 1
Set-RegistryDword -Path "HKCU:\\Software\\Policies\\Microsoft\\Windows\\Explorer" -Name "ShowRunAsDifferentUserInStart" -Value 1

$systemCurrentStep++; $statusMessage = "Setting Registry: AppModelUnlock..."; Write-Progress -Activity "System Registry Configuration" -Status $statusMessage -PercentComplete (($systemCurrentStep / $systemTotalSteps) * 100) -Id $progressIdSystem
I $statusMessage
Set-RegistryDword -Path "HKLM:\\Software\\Microsoft\\Windows\\CurrentVersion\\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -Value 1

$systemCurrentStep++; $statusMessage = "Setting Registry: LogonUI Background..."; Write-Progress -Activity "System Registry Configuration" -Status $statusMessage -PercentComplete (($systemCurrentStep / $systemTotalSteps) * 100) -Id $progressIdSystem
I $statusMessage
Set-RegistryDword -Path "HKLM:\\Software\\Microsoft\\Windows\\CurrentVersion\\Authentication\\LogonUI\\Background" -Name "OEMBackground" -Value 0

$systemCurrentStep++; $statusMessage = "Setting Registry: Sudo Config..."; Write-Progress -Activity "System Registry Configuration" -Status $statusMessage -PercentComplete (($systemCurrentStep / $systemTotalSteps) * 100) -Id $progressIdSystem
I $statusMessage
Set-RegistryDword -Path "HKLM:\\Software\\Microsoft\\Windows\\CurrentVersion\\Sudo" -Name "Enabled" -Value 1

Write-Progress -Activity "System Registry Configuration" -Completed -Id $progressIdSystem
