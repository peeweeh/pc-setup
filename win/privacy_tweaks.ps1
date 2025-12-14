################################################################################
# privacy_tweaks.ps1
# Comprehensive Windows privacy tweaks extracted from privacy.sexy
# This script applies advanced privacy settings and removes telemetry
#
# Author: @mrfixit027
# GitHub: https://github.com/peeweeh/pc-setup
################################################################################

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "This script requires Administrator privileges. Please run as Administrator." -ForegroundColor Red
    exit 1
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Windows Privacy Tweaks (privacy.sexy)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$tweakCount = 0
$tweakErrors = 0

function Set-RegistryValue {
    param($Path, $Name, $Value, $Type = "DWord")
    try {
        if (!(Test-Path $Path)) {
            New-Item -Path $Path -Force | Out-Null
        }
        Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -Force
        return $true
    } catch {
        return $false
    }
}

Write-Host "Applying privacy tweaks..." -ForegroundColor Yellow
Write-Host ""

# Remove controversial default0 user
Write-Host "- Removing controversial defaultuser0..." -ForegroundColor Cyan
try {
    net user defaultuser0 /delete 2>$null
    $tweakCount++
} catch {
    $tweakErrors++
}

# Minimize DISM Reset Base update data
Write-Host "- Minimizing DISM Reset Base update data..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\Software\Microsoft\Windows\CurrentVersion\SideBySide\Configuration" "DisableResetbase" 1) { $tweakCount++ } else { $tweakErrors++ }

# Disable cloud-based speech recognition
Write-Host "- Disabling cloud-based speech recognition..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" "HasAccepted" 0) { $tweakCount++ } else { $tweakErrors++ }

# Opt out of Windows privacy consent
Write-Host "- Opting out of Windows privacy consent..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" "AcceptedPrivacyPolicy" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable Windows feedback collection
Write-Host "- Disabling Windows feedback collection..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" "NumberOfSIUFInPeriod" 0) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "DoNotShowFeedbackNotifications" 1) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "DoNotShowFeedbackNotifications" 1) { $tweakCount++ } else { $tweakErrors++ }

# Disable text and handwriting data collection
Write-Host "- Disabling text and handwriting data collection..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\InputPersonalization" "RestrictImplicitInkCollection" 1) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\InputPersonalization" "RestrictImplicitTextCollection" 1) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" "PreventHandwritingErrorReports" 1) { $tweakCount++ } else { $tweakErrors++ }

# Disable Cortana
Write-Host "- Disabling Cortana..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable app diagnostics
Write-Host "- Disabling app diagnostics..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowSuperHidden" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable diagnostic data
Write-Host "- Disabling diagnostic data..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "AllowDiagnosticData" 0) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowDiagnosticData" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable app suggestions
Write-Host "- Disabling app suggestions..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "ContentDeliveryAllowed" 0) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "OemPreInstalledAppsEnabled" 0) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "PreInstalledAppsEnabled" 0) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SilentInstalledAppsEnabled" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable Start menu suggestions
Write-Host "- Disabling Start menu suggestions..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPanelFirstRunCompleted" 1) { $tweakCount++ } else { $tweakErrors++ }

# Disable tailored experiences
Write-Host "- Disabling tailored experiences..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" "TailoredExperiencesEnabled" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable activity history
Write-Host "- Disabling activity history..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" "ClearActivityHistoryOnExit" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable inking and typing personalization
Write-Host "- Disabling inking and typing personalization..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\InputPersonalization" "RestrictImplicitInkCollection" 1) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\InputPersonalization" "RestrictImplicitTextCollection" 1) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\InputPersonalization\Patterns" "RestrictImplicitInkCollection" 1) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\InputPersonalization\Patterns" "RestrictImplicitTextCollection" 1) { $tweakCount++ } else { $tweakErrors++ }

# Disable ad targeting
Write-Host "- Disabling ad targeting..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Enabled" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable tracking for Start menu suggestions
Write-Host "- Disabling Start menu tracking..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" "DisableSearchBoxSuggestions" 1) { $tweakCount++ } else { $tweakErrors++ }

# Disable Microsoft consumer experiences
Write-Host "- Disabling Microsoft consumer experiences..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-353694Enabled" 0) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-353696Enabled" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable app launch tracking
Write-Host "- Disabling app launch tracking..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start_TrackProgs" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable connected experiences
Write-Host "- Disabling connected experiences..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Office\Common\Privacy" "DisconnectedState" 2) { $tweakCount++ } else { $tweakErrors++ }

# Disable synchronization of settings
Write-Host "- Disabling settings synchronization..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" "SyncFlags" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable clipboard history
Write-Host "- Disabling clipboard history..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Clipboard" "EnableClipboardHistory" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable Windows Error Reporting
Write-Host "- Disabling Windows Error Reporting..." -ForegroundColor Cyan
try {
    Set-Service -Name "WerSvc" -StartupType Disabled -ErrorAction SilentlyContinue
    $tweakCount++
} catch {
    $tweakErrors++
}

# Disable Device Metadata Retrieval
Write-Host "- Disabling Device Metadata Retrieval..." -ForegroundColor Cyan
try {
    Set-Service -Name "dmwappushservice" -StartupType Disabled -ErrorAction SilentlyContinue
    $tweakCount++
} catch {
    $tweakErrors++
}

# Disable Connected User Experiences and Telemetry
Write-Host "- Disabling telemetry services..." -ForegroundColor Cyan
try {
    Stop-Service -Name "DiagTrack" -ErrorAction SilentlyContinue
    Set-Service -Name "DiagTrack" -StartupType Disabled -ErrorAction SilentlyContinue
    $tweakCount++
} catch {
    $tweakErrors++
}

try {
    Stop-Service -Name "dmwappushservice" -ErrorAction SilentlyContinue
    Set-Service -Name "dmwappushservice" -StartupType Disabled -ErrorAction SilentlyContinue
    $tweakCount++
} catch {
    $tweakErrors++
}

# Remove default apps associations
Write-Host "- Removing default app associations..." -ForegroundColor Cyan
try {
    dism /online /Remove-DefaultAppAssociations 2>$null | Out-Null
    $tweakCount++
} catch {
    $tweakErrors++
}

# Disable device sensors
Write-Host "- Disabling device sensors..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" "DisableSensors" 1) { $tweakCount++ } else { $tweakErrors++ }

# Disable website access of language list
Write-Host "- Disabling website access of language list..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\Control Panel\International\User Profile" "HttpAcceptLanguageOptOut" 1) { $tweakCount++ } else { $tweakErrors++ }

# Disable automatic map downloads
Write-Host "- Disabling automatic map downloads..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Maps" "AllowUntriggeredNetworkTrafficOnSettingsPage" 0) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Maps" "AutoDownloadAndUpdateMapData" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable GameDVR policy
Write-Host "- Disabling GameDVR policy..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" "AllowGameDVR" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable Windows DRM internet access
Write-Host "- Disabling Windows DRM internet access..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\WMDRM" "DisableOnline" 1) { $tweakCount++ } else { $tweakErrors++ }

# Disable typing feedback
Write-Host "- Disabling typing feedback..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Microsoft\Input\TIPC" "Enabled" 0) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Input\TIPC" "Enabled" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable Activity Feed policy
Write-Host "- Disabling Activity Feed policy..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "EnableActivityFeed" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable .NET Core CLI telemetry
Write-Host "- Disabling .NET Core CLI telemetry..." -ForegroundColor Cyan
try {
    [Environment]::SetEnvironmentVariable("DOTNET_CLI_TELEMETRY_OPTOUT", "1", "User")
    $tweakCount++
} catch {
    $tweakErrors++
}

# Disable PowerShell telemetry
Write-Host "- Disabling PowerShell telemetry..." -ForegroundColor Cyan
try {
    [Environment]::SetEnvironmentVariable("POWERSHELL_TELEMETRY_OPTOUT", "1", "User")
    $tweakCount++
} catch {
    $tweakErrors++
}

# Disable AutoPlay and AutoRun
Write-Host "- Disabling AutoPlay and AutoRun..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoDriveTypeAutoRun" 255) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoAutorun" 1) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" "NoAutoplayfornonVolume" 1) { $tweakCount++ } else { $tweakErrors++ }

# Disable lock screen camera access
Write-Host "- Disabling lock screen camera access..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" "NoLockScreenCamera" 1) { $tweakCount++ } else { $tweakErrors++ }

# Disable storage of LAN Manager password hashes
Write-Host "- Disabling LAN Manager password hash storage..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" "NoLMHash" 1) { $tweakCount++ } else { $tweakErrors++ }

# Disable Always Install with Elevated Privileges
Write-Host "- Disabling Always Install with Elevated Privileges..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer" "AlwaysInstallElevated" 0) { $tweakCount++ } else { $tweakErrors++ }

# Enable SEHOP (Structured Exception Handling Overwrite Protection)
Write-Host "- Enabling SEHOP..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" "DisableExceptionChainValidation" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable PowerShell 2.0
Write-Host "- Disabling PowerShell 2.0..." -ForegroundColor Cyan
try {
    Disable-WindowsOptionalFeature -FeatureName "MicrosoftWindowsPowerShellV2" -Online -NoRestart -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
    Disable-WindowsOptionalFeature -FeatureName "MicrosoftWindowsPowerShellV2Root" -Online -NoRestart -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
    $tweakCount++
} catch {
    $tweakErrors++
}

# Disable Windows Connect Now wizard
Write-Host "- Disabling Windows Connect Now wizard..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\Software\Policies\Microsoft\Windows\WCN\UI" "DisableWcnUi" 1) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WCN\Registrars" "EnableRegistrars" 0) { $tweakCount++ } else { $tweakErrors++ }

# Block telemetry and crash report hosts
Write-Host "- Blocking telemetry hosts in hosts file..." -ForegroundColor Cyan
$hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
$domainsToBlock = @(
    "oca.telemetry.microsoft.com",
    "oca.microsoft.com",
    "kmwatsonc.events.data.microsoft.com",
    "watson.telemetry.microsoft.com",
    "umwatsonc.events.data.microsoft.com",
    "ceuswatcab01.blob.core.windows.net",
    "ceuswatcab02.blob.core.windows.net",
    "eaus2watcab01.blob.core.windows.net",
    "eaus2watcab02.blob.core.windows.net",
    "weus2watcab01.blob.core.windows.net",
    "weus2watcab02.blob.core.windows.net",
    "co4.telecommand.telemetry.microsoft.com",
    "cs11.wpc.v0cdn.net",
    "cs1137.wpc.gammacdn.net",
    "modern.watson.data.microsoft.com",
    "functional.events.data.microsoft.com",
    "browser.events.data.msn.com",
    "self.events.data.microsoft.com",
    "v10.events.data.microsoft.com",
    "v10c.events.data.microsoft.com",
    "us-v10c.events.data.microsoft.com",
    "eu-v10c.events.data.microsoft.com",
    "v10.vortex-win.data.microsoft.com",
    "vortex-win.data.microsoft.com",
    "telecommand.telemetry.microsoft.com",
    "www.telecommandsvc.microsoft.com",
    "umwatson.events.data.microsoft.com",
    "watsonc.events.data.microsoft.com",
    "eu-watsonc.events.data.microsoft.com",
    "config.edge.skype.com"
)

try {
    $hostsContent = if (Test-Path $hostsPath) { Get-Content $hostsPath -Raw } else { "" }
    foreach ($domain in $domainsToBlock) {
        $entry = "0.0.0.0`t$domain"
        if ($hostsContent -notlike "*$domain*") {
            Add-Content -Path $hostsPath -Value $entry -Encoding UTF8
            $tweakCount++
        }
    }
} catch {
    $tweakErrors++
}

# Disable lock screen app notifications
Write-Host "- Disabling lock screen app notifications..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "DisableLockScreenAppNotifications" 1) { $tweakCount++ } else { $tweakErrors++ }

# Disable handwriting data sharing
Write-Host "- Disabling handwriting data sharing..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\TabletPC" "PreventHandwritingDataSharing" 1) { $tweakCount++ } else { $tweakErrors++ }

# Disable input personalization
Write-Host "- Disabling input personalization..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\InputPersonalization" "AllowInputPersonalization" 0) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" "HarvestContacts" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable Windows Spotlight
Write-Host "- Disabling Windows Spotlight..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "RotatingLockScreenEnabled" 0) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "RotatingLockScreenOverlayEnabled" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable app notifications
Write-Host "- Disabling app notifications..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" "ToastEnabled" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable app access to account information
Write-Host "- Disabling app access to account information..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" "Value" "Deny") { $tweakCount++ } else { $tweakErrors++ }

# Disable app access to contact info
Write-Host "- Disabling app access to contacts..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" "Value" "Deny") { $tweakCount++ } else { $tweakErrors++ }

# Disable app access to calendar
Write-Host "- Disabling app access to calendar..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" "Value" "Deny") { $tweakCount++ } else { $tweakErrors++ }

# Disable app access to call history
Write-Host "- Disabling app access to call history..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" "Value" "Deny") { $tweakCount++ } else { $tweakErrors++ }

# Disable app access to email
Write-Host "- Disabling app access to email..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" "Value" "Deny") { $tweakCount++ } else { $tweakErrors++ }

# Disable app access to messaging
Write-Host "- Disabling app access to messaging..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" "Value" "Deny") { $tweakCount++ } else { $tweakErrors++ }

# Disable app access to documents
Write-Host "- Disabling app access to documents..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" "Value" "Deny") { $tweakCount++ } else { $tweakErrors++ }

# Disable app access to pictures
Write-Host "- Disabling app access to pictures..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" "Value" "Deny") { $tweakCount++ } else { $tweakErrors++ }

# Disable app access to videos
Write-Host "- Disabling app access to videos..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" "Value" "Deny") { $tweakCount++ } else { $tweakErrors++ }

# Disable app access to file system
Write-Host "- Disabling app access to file system..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" "Value" "Deny") { $tweakCount++ } else { $tweakErrors++ }

# Disable app access to documents (system-wide)
Write-Host "- Disabling app access to documents (system)..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" "Value" "Deny") { $tweakCount++ } else { $tweakErrors++ }

# Disable app access to pictures (system-wide)
Write-Host "- Disabling app access to pictures (system)..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" "Value" "Deny") { $tweakCount++ } else { $tweakErrors++ }

# Disable app access to videos (system-wide)
Write-Host "- Disabling app access to videos (system)..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" "Value" "Deny") { $tweakCount++ } else { $tweakErrors++ }

# Disable background app permissions
Write-Host "- Disabling background app permissions..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "GlobalUserDisabled" 1) { $tweakCount++ } else { $tweakErrors++ }

# Disable app diagnostics
Write-Host "- Disabling app diagnostics..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" "Value" "Deny") { $tweakCount++ } else { $tweakErrors++ }

# Disable app access to documents library
Write-Host "- Blocking automatic app installs from Store..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SilentInstalledAppsEnabled" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable Windows Update Delivery Optimization P2P
Write-Host "- Disabling Delivery Optimization P2P..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" "DODownloadMode" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable Wi-Fi Sense
Write-Host "- Disabling Wi-Fi Sense..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" "value" 0) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" "Enabled" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable Consumer Features
Write-Host "- Disabling consumer features and suggested apps..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableWindowsConsumerFeatures" 1) { $tweakCount++ } else { $tweakErrors++ }

# Disable password reveal
Write-Host "- Disabling password reveal button..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredUI" "DisablePasswordReveal" 1) { $tweakCount++ } else { $tweakErrors++ }

# Disable Step Recorder
Write-Host "- Disabling Windows Step Recorder..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" "DisableUAR" 1) { $tweakCount++ } else { $tweakErrors++ }
Write-Host "- Clearing System Resource Usage Monitor data..." -ForegroundColor Cyan
try {
    $srumPath = "$env:SystemRoot\System32\sru\SRUDB.dat"
    if (Test-Path $srumPath) {
        takeown /f $srumPath /a 2>$null
        icacls $srumPath /grant "Administrators:F" 2>$null
        Remove-Item -Path $srumPath -Force -ErrorAction SilentlyContinue
        $tweakCount++
    }
} catch {
    $tweakErrors++
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Privacy Tweaks Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Successfully applied: $tweakCount tweaks" -ForegroundColor Green
if ($tweakErrors -gt 0) {
    Write-Host "Failed: $tweakErrors tweaks" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Privacy Configuration Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Please restart your computer for all changes to take effect." -ForegroundColor Yellow
Write-Host ""
Write-Host "Note: This script applies privacy tweaks from privacy.sexy" -ForegroundColor Gray
Write-Host "Source: https://privacy.sexy" -ForegroundColor Gray
Write-Host ""

################################################################################
# End of privacy_tweaks.ps1
# Author: @mrfixit027
# GitHub: https://github.com/peeweeh/pc-setup
################################################################################
