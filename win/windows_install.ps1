# windows_install.ps1
# Chocolatey package installation script for Windows

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "This script requires Administrator privileges. Please run as Administrator." -ForegroundColor Red
    exit 1
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Windows Setup Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Install Chocolatey
Write-Host "Step 1: Installing Chocolatey..." -ForegroundColor Yellow

$chocoInstalled = Get-Command choco -ErrorAction SilentlyContinue

if ($chocoInstalled) {
    Write-Host "Chocolatey is already installed." -ForegroundColor Green
} else {
    Write-Host "Installing Chocolatey..." -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    try {
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        Write-Host "Chocolatey installed successfully!" -ForegroundColor Green
    } catch {
        Write-Host "Failed to install Chocolatey: $_" -ForegroundColor Red
        exit 1
    }
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

Write-Host ""

# Step 2: Detect GPU and determine graphics drivers
Write-Host "Step 2: Detecting GPU..." -ForegroundColor Yellow

$gpu = Get-WmiObject Win32_VideoController | Select-Object -First 1
$isNvidia = $gpu.Name -match "NVIDIA" -or $gpu.AdapterCompatibility -match "NVIDIA"
$isAmd = $gpu.Name -match "AMD" -or $gpu.Name -match "Radeon" -or $gpu.AdapterCompatibility -match "Advanced Micro Devices"

if ($isNvidia) {
    Write-Host "NVIDIA GPU detected: $($gpu.Name)" -ForegroundColor Cyan
    $gpuPackages = @("nvidia-app", "nvidia-physx")
} elseif ($isAmd) {
    Write-Host "AMD GPU detected: $($gpu.Name)" -ForegroundColor Cyan
    Write-Host "Note: AMD drivers should be downloaded manually from AMD website" -ForegroundColor Yellow
    $gpuPackages = @()
} else {
    Write-Host "Unknown GPU: $($gpu.Name)" -ForegroundColor Yellow
    $gpuPackages = @()
}

Write-Host ""

# Step 3: Install packages
Write-Host "Step 3: Installing Chocolatey packages..." -ForegroundColor Yellow
Write-Host ""

$packages = @(
    "1password",
    "7zip.install",
    "bat",
    "beeper-app",
    "brave",
    "calibre",
    "chatgpt",
    "chocolateygui",
    "clipchamp",
    "curl",
    "ddu",
    "discord.install",
    "dotnet-desktopruntime",
    "ea-app",
    "epicgameslauncher",
    "everything",
    "fd",
    "ffmpeg",
    "fzf",
    "gh",
    "git.install",
    "git-delta",
    "github-desktop",
    "glorious-core",
    "goggalaxy",
    "GoogleChrome",
    "googledrive",
    "hwinfo.install",
    "hwmonitor.install",
    "icloud",
    "iTunes",
    "jq",
    "less",
    "linqpad",
    "microsoft-edge",
    "microsoft-teams",
    "microsoft-windows-terminal",
    "msiafterburner",
    "neovim",
    "nodejs.install",
    "obsidian",
    "pandoc",
    "plexmediaplayer",
    "postman",
    "powertoys",
    "protondrive",
    "protonmail",
    "protonvpn",
    "python314",
    "ripgrep",
    "rivatuner",
    "sabnzbd",
    "signal",
    "slack",
    "starship.install",
    "steam",
    "steelseries-gg",
    "sysinternals",
    "telegram.install",
    "treesizefree",
    "ubisoft-connect",
    "vlc.install",
    "vscode.install",
    "webview2-runtime",
    "whatsapp",
    "winrar",
    "wireshark",
    "wiztree",
    "zoxide",
    "zoom"
)

$successCount = 0
$failCount = 0
$failedPackages = @()

# Install GPU-specific packages first
if ($gpuPackages.Count -gt 0) {
    Write-Host "Installing GPU-specific packages first..." -ForegroundColor Cyan
    Write-Host ""
    
    foreach ($package in $gpuPackages) {
        Write-Host "Installing $package..." -ForegroundColor Cyan
        try {
            choco install $package -y --ignore-checksums
            if ($LASTEXITCODE -eq 0) {
                Write-Host "- $package installed successfully" -ForegroundColor Green
                $successCount++
            } else {
                Write-Host "- Failed to install $package" -ForegroundColor Red
                $failCount++
                $failedPackages += $package
            }
        } catch {
            Write-Host "- Error installing $package`: $_" -ForegroundColor Red
            $failCount++
            $failedPackages += $package
        }
        Write-Host ""
    }
}

foreach ($package in $packages) {
    Write-Host "Installing $package..." -ForegroundColor Cyan
    try {
        choco install $package -y --ignore-checksums
        if ($LASTEXITCODE -eq 0) {
            Write-Host "- $package installed successfully" -ForegroundColor Green
            $successCount++
        } else {
            Write-Host "- Failed to install $package" -ForegroundColor Red
            $failCount++
            $failedPackages += $package
        }
    } catch {
        Write-Host "- Error installing $package`: $_" -ForegroundColor Red
        $failCount++
        $failedPackages += $package
    }
    Write-Host ""
}

# Step 4: Summary
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Installation Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Total packages: $($packages.Count + $gpuPackages.Count)" -ForegroundColor White
Write-Host "Successfully installed: $successCount" -ForegroundColor Green
Write-Host "Failed: $failCount" -ForegroundColor $(if ($failCount -gt 0) { "Red" } else { "Green" })

if ($failedPackages.Count -gt 0) {
    Write-Host ""
    Write-Host "Failed packages:" -ForegroundColor Red
    foreach ($pkg in $failedPackages) {
        Write-Host "  - $pkg" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Setup complete!" -ForegroundColor Green
Write-Host "You may need to restart your terminal or computer for all changes to take effect." -ForegroundColor Yellow

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Windows Privacy and Performance Tweaks" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Applying Windows tweaks..." -ForegroundColor Yellow
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

# Create system restore point
Write-Host "- Creating system restore point..." -ForegroundColor Cyan
try {
    Enable-ComputerRestore -Drive "$env:SystemDrive"
    Checkpoint-Computer -Description "Before PC Setup Tweaks" -RestorePointType "MODIFY_SETTINGS"
    $tweakCount++
} catch {
    Write-Host "  Could not create restore point (might need to be enabled)" -ForegroundColor Yellow
    $tweakErrors++
}

# Delete temporary files
Write-Host "- Deleting temporary files..." -ForegroundColor Cyan
try {
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    $tweakCount++
} catch {
    $tweakErrors++
}

# Disable Telemetry
Write-Host "- Disabling telemetry..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" 0) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "AllowTelemetry" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable Consumer Features
Write-Host "- Disabling consumer features..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableWindowsConsumerFeatures" 1) { $tweakCount++ } else { $tweakErrors++ }

# Disable Activity History
Write-Host "- Disabling activity history..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "EnableActivityFeed" 0) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "PublishUserActivities" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable GameDVR
Write-Host "- Disabling GameDVR..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\System\GameConfigStore" "GameDVR_Enabled" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable Hibernation
Write-Host "- Disabling hibernation..." -ForegroundColor Cyan
try {
    powercfg.exe /hibernate off | Out-Null
    $tweakCount++
} catch {
    $tweakErrors++
}

# Disable Location Tracking
Write-Host "- Disabling location tracking..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" "DisableLocation" 1) { $tweakCount++ } else { $tweakErrors++ }

# Disable Wi-Fi Sense
Write-Host "- Disabling Wi-Fi sense..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" "Value" 0) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" "Value" 0) { $tweakCount++ } else { $tweakErrors++ }

# Enable End Task with Right Click
Write-Host "- Enabling end task with right click..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings" "TaskbarEndTask" 1) { $tweakCount++ } else { $tweakErrors++ }

# Disable Notifications
Write-Host "- Disabling notifications..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" "NOC_GLOBAL_SETTING_ALLOW_NOTIFICATION_SOUND" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable App Suggestions
Write-Host "- Disabling app suggestions..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "ContentDeliveryAllowed" 0) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "OemPreInstalledAppsEnabled" 0) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "PreInstalledAppsEnabled" 0) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SilentInstalledAppsEnabled" 0) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPanelFirstRunCompleted" 1) { $tweakCount++ } else { $tweakErrors++ }

# Disable Background Apps
Write-Host "- Disabling background apps..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "GlobalUserDisabled" 1) { $tweakCount++ } else { $tweakErrors++ }

# Disable Telemetry Services
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

# Disable Cortana
Write-Host "- Disabling Cortana..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" "AcceptedPrivacyPolicy" 0) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable Bing Search in Start Menu
Write-Host "- Disabling Bing search in Start menu..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" "BingSearchEnabled" 0) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" "CortanaConsent" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable Ad ID
Write-Host "- Disabling advertising ID..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Enabled" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable Connected User Experiences
Write-Host "- Disabling connected user experiences..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "EnableCdp" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable App Launch Tracking
Write-Host "- Disabling app launch tracking..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start_TrackProgs" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable Tips and Suggestions
Write-Host "- Disabling tips and suggestions..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*" "IsContentDirty" 0) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoInstrumentation" 1) { $tweakCount++ } else { $tweakErrors++ }

# Disable Delivery Optimization
Write-Host "- Disabling delivery optimization..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" "DODownloadMode" 0) { $tweakCount++ } else { $tweakErrors++ }

# Disable Error Reporting
Write-Host "- Disabling error reporting..." -ForegroundColor Cyan
try {
    Stop-Service -Name "WerSvc" -ErrorAction SilentlyContinue
    Set-Service -Name "WerSvc" -StartupType Disabled -ErrorAction SilentlyContinue
    $tweakCount++
} catch {
    $tweakErrors++
}

# Disable Connect to Suggested Open With
Write-Host "- Disabling connect to suggested open with..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" "NoUseStoreOpenWith" 1) { $tweakCount++ } else { $tweakErrors++ }

# Disable Autoplay
Write-Host "- Disabling autoplay..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" "DisableAutoplay" 1) { $tweakCount++ } else { $tweakErrors++ }

# Set Services to Manual
Write-Host "- Setting services to manual startup..." -ForegroundColor Cyan
$servicesToDisable = @(
    "WSearch",           # Windows Search
    "DiagTrack",         # Diagnostic Tracking Service
    "dmwappushservice",  # Device Management Wireless Application Protocol
    "MapsBroker",        # Maps
    "lfsvc",             # Location Service
    "RemoteRegistry",    # Remote Registry
    "SharedAccess"       # Internet Connection Sharing
)

foreach ($service in $servicesToDisable) {
    try {
        Set-Service -Name $service -StartupType Manual -ErrorAction SilentlyContinue
        $tweakCount++
    } catch {
        $tweakErrors++
    }
}
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Tweaks Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Successfully applied: $tweakCount tweaks" -ForegroundColor Green
if ($tweakErrors -gt 0) {
    Write-Host "Failed: $tweakErrors tweaks" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Please restart your computer for all changes to take effect." -ForegroundColor Yellow

