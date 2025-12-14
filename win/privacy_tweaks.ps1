# privacy_tweaks.ps1
# Comprehensive Windows privacy tweaks extracted from privacy.sexy
# This script applies advanced privacy settings and removes telemetry

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

# Clear SRUM database
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
