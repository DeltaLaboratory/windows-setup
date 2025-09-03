# Load dependencies - this script should only be called from main.ps1 or other scripts that have already loaded config and utils

$progressIdBrowser = $Global:PROGRESS_IDS.Browser
$browserTotalSteps = 5 # Number of main configuration blocks
$browserCurrentStep = 0

$browserCurrentStep++; $statusMessage = "Setting Registry: Edge Config..."; Write-Progress -Activity "Browser Registry Configuration" -Status $statusMessage -PercentComplete (($browserCurrentStep / $browserTotalSteps) * 100) -Id $progressIdBrowser
I $statusMessage
Set-RegistryString -Path "HKCU:\\Software\\Microsoft\\Edge\\Defaults" -Name "is_startup_page_recommended" -Value "0"
Set-RegistryString -Path "HKCU:\\Software\\Microsoft\\Edge\\Defaults" -Name "is_dse_recommended" -Value "0"

$browserCurrentStep++; $statusMessage = "Setting Registry: Edge Security..."; Write-Progress -Activity "Browser Registry Configuration" -Status $statusMessage -PercentComplete (($browserCurrentStep / $browserTotalSteps) * 100) -Id $progressIdBrowser
I $statusMessage
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge" -Name "InternetExplorerIntegrationReloadInIEModeAllowed" -Value 0
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge" -Name "SSLErrorOverrideAllowed" -Value 1
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge" -Name "InternetExplorerIntegrationZoneIdentifierMhtFileAllowed" -Value 0
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge" -Name "BrowserLegacyExtensionPointsBlockingEnabled" -Value 1
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge" -Name "SitePerProcess" -Value 1
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge" -Name "InternetExplorerModeToolbarButtonEnabled" -Value 0
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge" -Name "SharedArrayBufferUnrestrictedAccessAllowed" -Value 0
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge" -Name "BasicAuthOverHttpEnabled" -Value 0
Set-RegistryString -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge" -Name "AuthSchemes" -Value "ntlm,negotiate"
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge" -Name "NativeMessagingUserLevelHosts" -Value 0
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge" -Name "InsecurePrivateNetworkRequestsAllowed" -Value 1
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge" -Name "TyposquattingCheckerEnabled" -Value 1
Set-RegistryString -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge" -Name "DnsOverHttpsMode" -Value "secure"
Set-RegistryString -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge" -Name "DnsOverHttpsTemplates" -Value "https://cloudflare-dns.com/dns-query"

Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge" -Name "AutomaticHttpsDefault" -Value 2
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge" -Name "AutoImportAtFirstRun" -Value 4
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge" -Name "DiagnosticData" -Value 0
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge" -Name "Edge3PSerpTelemetryEnabled" -Value 0
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge" -Name "SyncDisabled" -Value 1
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge" -Name "PasswordGeneratorEnabled" -Value 0
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge" -Name "PasswordManagerEnabled" -Value 0
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge" -Name "PasswordMonitorAllowed" -Value 0
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge" -Name "PasswordProtectionWarningTrigger" -Value 0
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge" -Name "BingAdsSuppression" -Value 1
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge" -Name "EdgeShoppingAssistantEnabled" -Value 0

$browserCurrentStep++; $statusMessage = "Setting Registry: Edge Fake MDM..."; Write-Progress -Activity "Browser Registry Configuration" -Status $statusMessage -PercentComplete (($browserCurrentStep / $browserTotalSteps) * 100) -Id $progressIdBrowser
I $statusMessage
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Microsoft\\Enrollments\\FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF" -Name "EnrollmentState" -Value 1
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Microsoft\\Enrollments\\FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF" -Name "EnrollmentType" -Value 0
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Microsoft\\Enrollments\\FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF" -Name "IsFederated" -Value 0
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Microsoft\\Provisioning\\OMADM\\Accounts\\FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF" -Name "Flags" -Value 0x00d6fb7f
Set-RegistryString -Path "HKLM:\\SOFTWARE\\Microsoft\\Provisioning\\OMADM\\Accounts\\FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF" -Name "AcctUId" -Value "0x000000000000000000000000000000000000000000000000000000000000000000000000"
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Microsoft\\Provisioning\\OMADM\\Accounts\\FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF" -Name "RoamingCount" -Value 0
Set-RegistryString -Path "HKLM:\\SOFTWARE\\Microsoft\\Provisioning\\OMADM\\Accounts\\FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF" -Name "SslClientCertReference" -Value "MY;User;0000000000000000000000000000000000000000"
Set-RegistryString -Path "HKLM:\\SOFTWARE\\Microsoft\\Provisioning\\OMADM\\Accounts\\FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF" -Name "ProtoVer" -Value "1.2"

$browserCurrentStep++; $statusMessage = "Setting Registry: Edge Search Engine..."; Write-Progress -Activity "Browser Registry Configuration" -Status $statusMessage -PercentComplete (($browserCurrentStep / $browserTotalSteps) * 100) -Id $progressIdBrowser
I $statusMessage
Set-RegistryString -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge\\Recommended" -Name "DefaultSearchProviderName" -Value "Google"
Set-RegistryString -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge\\Recommended" -Name "DefaultSearchProviderSearchURL" -Value "{google:baseURL}search?q={searchTerms}&{google:RLZ}{google:originalQueryForSuggestion}{google:assistedQueryStats}{google:searchFieldtrialParameter}{google:searchClient}{google:sourceId}ie={inputEncoding}"
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge\\Recommended" -Name "DefaultSearchProviderEnabled" -Value 1
Set-RegistryString -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge\\Recommended" -Name "DefaultSearchProviderSuggestURL" -Value "{google:baseURL}complete/search?output=chrome&q={searchTerms}"
Set-RegistryString -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge\\Recommended" -Name "DefaultSearchProviderImageURL" -Value "{google:baseURL}searchbyimage/upload"
Set-RegistryString -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge\\Recommended" -Name "DefaultSearchProviderImageURLPostParams" -Value "encoded_image={google:imageThumbnail},image_url={google:imageURL},sbisrc={google:imageSearchSource},original_width={google:imageOriginalWidth},original_height={google:imageOriginalHeight}"
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge\\Recommended" -Name "ImportPaymentInfo" -Value 0
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge\\Recommended" -Name "ImportHistory" -Value 0
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge\\Recommended" -Name "ImportSavedPasswords" -Value 0
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge\\Recommended" -Name "ImportOpenTabs" -Value 0
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge\\Recommended" -Name "ImportAutofillFormData" -Value 0
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge\\Recommended" -Name "ImportBrowserSettings" -Value 0
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge\\Recommended" -Name "ImportCookies" -Value 0
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge\\Recommended" -Name "ImportExtensions" -Value 0
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge\\Recommended" -Name "ImportFavorites" -Value 0
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge\\Recommended" -Name "ImportSearchEngine" -Value 0
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge\\Recommended" -Name "ImportShortcuts" -Value 0
# Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge\\Recommended" -Name "RestoreOnStartup" -Value 4
Set-RegistryDword -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge\\Recommended" -Name "ShowHomeButton" -Value 1

$browserCurrentStep++; $statusMessage = "Browser configuration complete."; Write-Progress -Activity "Browser Registry Configuration" -Status $statusMessage -PercentComplete (($browserCurrentStep / $browserTotalSteps) * 100) -Id $progressIdBrowser

Write-Progress -Activity "Browser Registry Configuration" -Completed -Id $progressIdBrowser
