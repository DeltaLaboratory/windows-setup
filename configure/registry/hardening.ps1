# Load dependencies - this script should only be called from main.ps1 or other scripts that have already loaded config and utils

Write-BoxedHeader "[SHIELD] SECURITY HARDENING CONFIGURATION" "Red" 60

$progressIdHardening = $Global:PROGRESS_IDS.Hardening
$hardeningTotalSteps = 3
$hardeningCurrentStep = 0

Write-StatusLine "[LOCKED]" "Applying security hardening configurations..." "Yellow"
Write-StatusLine "[STATS]" "Total Security Groups: $hardeningTotalSteps" "DarkGray"
Write-Host ""

$hardeningCurrentStep++; $statusMessage = "Setting Registry: BitLocker Config..."; Write-Progress -Activity "Hardening Registry Configuration" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($hardeningCurrentStep / $hardeningTotalSteps) * 100))) -Id $progressIdHardening
Write-SectionHeader "BITLOCKER ENCRYPTION SETTINGS" "[SECURE]"
I $statusMessage
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\FVE" -Name "EncryptionMethodWithXtsOs" -Value 6
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\FVE" -Name "DisableExternalDMAUnderLock" -Value 1
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\FVE" -Name "OSAllowSecureBootForIntegrity" -Value 1
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\FVE" -Name "UseAdvancedStartup" -Value 1
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\FVE" -Name "EnableBDEWithNoTPM" -Value 0
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\FVE" -Name "UseTPM" -Value 0
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\FVE" -Name "UseTPMPIN" -Value 1
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\FVE" -Name "UseTPMKey" -Value 0
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\FVE" -Name "UseTPMKeyPIN" -Value 0
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\FVE" -Name "UseEnhancedPin" -Value 1
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\FVE" -Name "OSHardwareEncryption" -Value 0
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\FVE" -Name "MinimumPIN" -Value 8
Write-Success "BitLocker encryption settings configured"

$hardeningCurrentStep++; $statusMessage = "Setting Registry: Exploit Prevention Config..."; Write-Progress -Activity "Hardening Registry Configuration" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($hardeningCurrentStep / $hardeningTotalSteps) * 100))) -Id $progressIdHardening
Write-SectionHeader "WINDOWS DEFENDER & EXPLOIT PROTECTION" "[SHIELD]"
I $statusMessage

# Windows Defender Core Settings
Write-StatusLine "[SEARCH]" "Configuring Windows Defender settings..." "Cyan"
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 0
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\Windows Defender" -Name "PUAProtection" -Value 1
Set-RegistryString -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Exclusions" -Name "Exclusions_Extensions" -Value ""
Set-RegistryString -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Policy Manager" -Name "ExcludedExtensions" -Value ""
Set-RegistryString -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Exclusions" -Name "Exclusions_Paths" -Value ""
Set-RegistryString -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Policy Manager" -Name "ExcludedPaths" -Value ""
Set-RegistryString -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Exclusions" -Name "Exclusions_Processes" -Value ""
Set-RegistryString -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Policy Manager" -Name "ExcludedProcesses" -Value ""

# Cloud Protection & Real-time Monitoring
Write-StatusLine "[CLOUD]" "Configuring cloud protection and real-time monitoring..." "Cyan"
Set-RegistryDword -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SpynetReporting" -Value 2
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Spynet" -Name "DisableBlockAtFirstSeen" -Value 0
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Spynet" -Name "SubmitSamplesConsent" -Value 0
Set-RegistryDword -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine" -Name "EnableFileHashComputation" -Value 1
Set-RegistryDword -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine" -Name "MpCloudBlockLevel" -Value 2
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableIOAVProtection" -Value 0
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableRealtimeMonitoring" -Value 0
Set-RegistryDword -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableBehaviorMonitoring" -Value 0
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableScriptScanning" -Value 0
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Scan" -Name "DisableRemovableDriveScanning" -Value 0
Set-RegistryDword -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name "MP_FORCE_USE_SANDBOX" -Value 1

# Attack Surface Reduction Rules
Write-StatusLine "[DEFENSE]" "Configuring Attack Surface Reduction rules..." "Cyan"
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR" -Name "ExploitGuard_ASR_Rules" -Value 1
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Policy Manager" -Name "ASRRules" -Value 1
# Individual ASR Rules
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\rules" -Name "be9ba2d9-53ea-4cdc-84e5-9b1eeee46550" -Value 1
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\rules" -Name "d4f940ab-401b-4efc-aadc-ad5f3c50688a" -Value 1
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\rules" -Name "3b576869-a4ec-4529-8536-b80a7769e899" -Value 1
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\rules" -Name "75668c1f-73b5-4cf0-bb93-3ecf5cb7cc84" -Value 1
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\rules" -Name "d3e037e1-3eb8-44c8-a917-57927947596d" -Value 1
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\rules" -Name "5beb7efe-fd9a-4556-801d-275e5ffc04cc" -Value 1
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\rules" -Name "92e97fa1-2edf-4476-bdd6-9dd0b4dddc7b" -Value 1
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\rules" -Name "01443614-cd74-433a-b99e-2ecdc07bfc25" -Value 0 # Disabled - causes compatibility issues
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\rules" -Name "c1db55ab-c21a-4637-bb3f-a12568109d35" -Value 1
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\rules" -Name "9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2" -Value 1
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\rules" -Name "d1e49aac-8f56-4280-b9ba-993a6d77406c" -Value 1
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\rules" -Name "b2b3f03d-6a65-4f7b-a9c7-1c7ef74a9ba4" -Value 1
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\rules" -Name "26190899-1602-49e8-8b27-eb1d0a1ce869" -Value 1
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\rules" -Name "7674ba52-37eb-4a4f-a9a1-f0f9a1619a2c" -Value 1
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\rules" -Name "e6db77e5-3df2-4cf1-b95a-636979351e5b" -Value 1
Set-RegistryDword -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\rules" -Name "56a863a9-875e-4185-98a7-b882c64b5ce5" -Value 1
Set-RegistryString -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR" -Name "ExploitGuard_ASR_ASROnlyExclusions" -Value ""
Set-RegistryString -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Policy Manager" -Name "ASROnlyExclusions" -Value ""

# Network Protection & Application Guard
Write-StatusLine "[NET]" "Configuring network protection and application guard..." "Cyan"
Set-RegistryDword -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Network Protection" -Name "EnableNetworkProtection" -Value 1
Set-RegistryDword -Path "HKLM:\SOFTWARE\Policies\Microsoft\AppHVSI" -Name "AllowAppHVSI_ProviderSet" -Value 3
Set-RegistryDword -Path "HKLM:\SOFTWARE\Policies\Microsoft\AppHVSI" -Name "AuditApplicationGuard" -Value 1

Write-Success "Windows Defender & Exploit Protection configured"

$hardeningCurrentStep++; $statusMessage = "Setting Registry: Logon Screen Options..."; Write-Progress -Activity "Hardening Registry Configuration" -Status $statusMessage -PercentComplete ([Math]::Min(100, (($hardeningCurrentStep / $hardeningTotalSteps) * 100))) -Id $progressIdHardening
Write-SectionHeader "LOGON EXPERIENCE HARDENING" "[LIST]"
I $statusMessage

Write-StatusLine "[FIX]" "Enabling shutdown option on secure logon screen..." "Cyan"
Set-RegistryDword -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ShutdownWithoutLogon" -Value 1
Write-Success "Shutdown option enabled for logon screen"

Write-Progress -Activity "Hardening Registry Configuration" -Completed -Id $progressIdHardening
Write-Host ""
Write-BoxedHeader "[OK] SECURITY HARDENING COMPLETED" "Green" 50
