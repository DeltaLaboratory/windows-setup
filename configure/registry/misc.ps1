$progressIdMisc = 5
$miscTotalSteps = 3
$miscCurrentStep = 0

$miscCurrentStep++; $statusMessage = "Setting Registry: Xbox Related Config..."; Write-Progress -Activity "Miscellaneous Registry Configuration" -Status $statusMessage -PercentComplete (($miscCurrentStep / $miscTotalSteps) * 100) -Id $progressIdMisc
I $statusMessage
Set-RegistryDword -Path "HKLM:\SYSTEM\CurrentControlSet\Services\XboxGipSvc" -Name "Start" -Value 4
Set-RegistryDword -Path "HKLM:\SYSTEM\CurrentControlSet\Services\XblAuthManager" -Name "Start" -Value 4
Set-RegistryDword -Path "HKLM:\SYSTEM\CurrentControlSet\Services\XblGameSave" -Name "Start" -Value 4
Set-RegistryDword -Path "HKLM:\\SYSTEM\\CurrentControlSet\\Services\\XboxNetApiSvc" -Name "Start" -Value 4

$miscCurrentStep++; $statusMessage = "Setting Registry: Annoying Things..."; Write-Progress -Activity "Miscellaneous Registry Configuration" -Status $statusMessage -PercentComplete (($miscCurrentStep / $miscTotalSteps) * 100) -Id $progressIdMisc
I $statusMessage
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\PowerShellCore\ModuleLogging" -Name "EnableModuleLogging" -Value 1
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\PowerShellCore\ModuleLogging" -Name "UseWindowsPowerShellPolicySetting" -Value 1
Set-RegistryString -Path "HKCU:\Software\Policies\Microsoft\PowerShellCore\ModuleLogging\ModuleNames" -Name "*" -Value "*"
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\PowerShellCore\ScriptBlockLogging" -Name "EnableScriptBlockLogging" -Value 1
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\PowerShellCore\ScriptBlockLogging" -Name "EnableScriptBlockInvocationLogging" -Value 1
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\PowerShellCore\ScriptBlockLogging" -Name "UseWindowsPowerShellPolicySetting" -Value 1
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\PowerShellCore\Transcription" -Name "EnableTranscripting" -Value 1
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\PowerShellCore\Transcription" -Name "EnableInvocationHeader" -Value 1
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\PowerShellCore\Transcription" -Name "UseWindowsPowerShellPolicySetting" -Value 1
Set-RegistryDword -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "NoToastApplicationNotificationOnLockScreen" -Value 1
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\Assistance\Client\1.0" -Name "NoImplicitFeedback" -Value 1
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\Windows\CloudContent" -Name "DisableTailoredExperiencesWithDiagnosticData" -Value 1
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\Windows\CloudContent" -Name "DisableThirdPartySuggestions" -Value 1
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\Windows\Installer" -Name "AlwaysInstallElevated" -Value 0
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\Windows\PowerShell\ModuleLogging" -Name "EnableModuleLogging" -Value 1
Set-RegistryString -Path "HKCU:\Software\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames" -Name "*" -Value "*"
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" -Name "EnableScriptBlockLogging" -Value 1
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" -Name "EnableScriptBlockInvocationLogging" -Value 1
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\Windows\PowerShell\Transcription" -Name "EnableTranscripting" -Value 1
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\Windows\PowerShell\Transcription" -Name "EnableInvocationHeader" -Value 1
Set-RegistryDword -Path "HKCU:\software\policies\microsoft\office\16.0\common\security" -Name "macroruntimescanscope" -Value 2
Set-RegistryDword -Path "HKCU:\software\policies\microsoft\office\16.0\excel\security\external content" -Name "enableblockunsecurequeryfiles" -Value 1
Set-RegistryDword -Path "HKCU:\software\policies\microsoft\office\16.0\excel\security\external content" -Name "disableddeserverlaunch" -Value 1
Set-RegistryDword -Path "HKCU:\software\policies\microsoft\office\16.0\excel\security\external content" -Name "disableddeserverlookup" -Value 1
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\Office\16.0\Excel\Security" -Name "blockcontentexecutionfrominternet" -Value 1
Set-RegistryDword -Path "HKCU:\Software\Microsoft\Office\16.0\Excel\Security" -Name "vbawarnings" -Value 4
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\Office\16.0\Excel\Security" -Name "vbawarnings" -Value 4
Set-RegistryDword -Path "HKCU:\Software\Microsoft\Office\16.0\Excel\Options" -Name "DontUpdateLinks" -Value 1
Set-RegistryDword -Path "HKCU:\Software\Microsoft\Office\16.0\Excel\Options" -Name "DDEAllowed" -Value 1
Set-RegistryDword -Path "HKCU:\Software\Microsoft\Office\16.0\Excel\Options" -Name "DDECleaned" -Value 1
Set-RegistryDword -Path "HKCU:\software\policies\microsoft\office\16.0\excel\security" -Name "PythonFunctionWarnings" -Value 2
Set-RegistryDword -Path "HKCU:\Software\Microsoft\Office\16.0\OneNote\Options" -Name "DisableEmbeddedFiles" -Value 1
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\Office\16.0\PowerPoint\Security" -Name "blockcontentexecutionfrominternet" -Value 1
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\Office\16.0\PowerPoint\Security" -Name "vbawarnings" -Value 4
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\Office\16.0\Word\Security" -Name "blockcontentexecutionfrominternet" -Value 1
Set-RegistryDword -Path "HKCU:\Software\Microsoft\Office\16.0\Word\Security" -Name "vbawarnings" -Value 4
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\Office\16.0\Word\Security" -Name "vbawarnings" -Value 4
Set-RegistryDword -Path "HKCU:\Software\Microsoft\Office\16.0\Word\Options" -Name "DontUpdateLinks" -Value 1
Set-RegistryDword -Path "HKCU:\Software\Microsoft\Office\16.0\Word\Options\WordMail" -Name "DontUpdateLinks" -Value 1
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\office\common\clienttelemetry" -Name "DisableTelemetry" -Value 1
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\office\16.0\common\privacy" -Name "disconnectedstate" -Value 2
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\office\16.0\common\privacy" -Name "usercontentdisabled" -Value 2
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\office\16.0\common\privacy" -Name "downloadcontentdisabled" -Value 2
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\office\16.0\common\privacy" -Name "controllerconnectedservicesenabled" -Value 2
Set-RegistryDword -Path "HKCU:\Software\Policies\Microsoft\office\common\clienttelemetry" -Name "sendtelemetry" -Value 3
Set-RegistryDword -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-310093Enabled" -Value 0
Set-RegistryDword -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Value 0
Set-RegistryDword -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CDP" -Name "RomeSdkChannelUserAuthzPolicy" -Value 0
Set-RegistryDword -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CDP" -Name "CdpSessionUserAuthzPolicy" -Value 0
Set-RegistryDword -Path "HKCU:\Software\Microsoft\TabletTip\1.7" -Name "EnableAutocorrection" -Value 0
Set-RegistryDword -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Value 0

$miscCurrentStep++; $statusMessage = "Setting Registry: PowerShell Transcript Output Directory..."; Write-Progress -Activity "Miscellaneous Registry Configuration" -Status $statusMessage -PercentComplete (($miscCurrentStep / $miscTotalSteps) * 100) -Id $progressIdMisc
I $statusMessage
Set-RegistryString -Path "HKCU:\\Software\\Policies\\Microsoft\\Windows\\PowerShell\\Transcription" -Name "OutputDirectory" -Value "C:\\Users\\$env:USERNAME\\Documents\\PowerShell\\Transcripts"

Write-Progress -Activity "Miscellaneous Registry Configuration" -Completed -Id $progressIdMisc
