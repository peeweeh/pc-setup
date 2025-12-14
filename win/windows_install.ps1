################################################################################
# windows_install.ps1
# Chocolatey package installation script for Windows
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
$skippedPackages = @()

function Install-PackageGroup {
    param($GroupName, $Packages, $SkipPrompt = $false)
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Installing $GroupName" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    
    if (-not $SkipPrompt) {
        Write-Host "Packages to install: $($Packages.Count)" -ForegroundColor Yellow
        Write-Host "Press Enter to continue, or type 'skip' to skip this group..." -ForegroundColor Yellow
        $response = Read-Host
        if ($response -eq "skip") {
            Write-Host "Skipping $GroupName..." -ForegroundColor Yellow
            $script:skippedPackages += $Packages
            return
        }
    }
    
    Write-Host ""
    
    foreach ($package in $Packages) {
        Write-Host "Installing $package..." -ForegroundColor Cyan
        try {
            choco install $package -y --ignore-checksums
            if ($LASTEXITCODE -eq 0) {
                Write-Host "- $package installed successfully" -ForegroundColor Green
                $script:successCount++
            } else {
                Write-Host "- Failed to install $package" -ForegroundColor Red
                $script:failCount++
                $script:failedPackages += $package
            }
        } catch {
            Write-Host "- Error installing $package`: $_" -ForegroundColor Red
            $script:failCount++
            $script:failedPackages += $package
        }
        Write-Host ""
    }
}

# Essential packages (important)
$essentialPackages = @(
    "1password",
    "beeper-app",
    "brave",
    "protonmail",
    "protonvpn",
    "protondrive",
    "vlc.install",
    "winrar",
    "7zip.install",
    "git.install",
    "vscode.install",
    "discord.install",

    "dotnet-desktopruntime",
    "webview2-runtime",
    "googledrive"
)

# Optional packages (nice to have)
$optionalPackages = @(
    "telegram.install",
    "signal",
    "whatsapp",
    "bat",
    "calibre",
    "chatgpt",
    "chocolateygui",
    "clipchamp",
    "curl",
    "ddu",
    "ea-app",
    "epicgameslauncher",
    "everything",
    "fd",
    "ffmpeg",
    "fzf",
    "gh",
    "git-delta",
    "github-desktop",
    "glorious-core",
    "goggalaxy",
    "GoogleChrome",
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
    "python314",
    "ripgrep",
    "rivatuner",
    "sabnzbd",
    "slack",
    "starship.install",
    "steam",
    "steelseries-gg",
    "sysinternals",
    "treesizefree",
    "ubisoft-connect",
    "wireshark",
    "wiztree",
    "zoxide",
    "zoom"
)

# Install GPU drivers if detected (automatic, no prompt)
if ($gpuPackages.Count -gt 0) {
    Install-PackageGroup -GroupName "GPU Drivers" -Packages $gpuPackages -SkipPrompt $true
}

# Install essential packages
Install-PackageGroup -GroupName "Essential Packages" -Packages $essentialPackages

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

# Disable Hibernation (performance)
Write-Host "- Disabling hibernation..." -ForegroundColor Cyan
try {
    powercfg.exe /hibernate off | Out-Null
    $tweakCount++
} catch {
    $tweakErrors++
}

# Enable End Task with Right Click (convenience)
Write-Host "- Enabling end task with right click..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings" "TaskbarEndTask" 1) { $tweakCount++ } else { $tweakErrors++ }

# Disable Autoplay (performance)
Write-Host "- Disabling autoplay..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" "DisableAutoplay" 1) { $tweakCount++ } else { $tweakErrors++ }

# Set Delivery Optimization to manual (can use data)
Write-Host "- Setting Delivery Optimization to manual..." -ForegroundColor Cyan
try {
    Set-Service -Name "DoSvc" -StartupType Manual -ErrorAction SilentlyContinue
    $tweakCount++
} catch {
    $tweakErrors++
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

# Install optional packages
Install-PackageGroup -GroupName "Optional Packages" -Packages $optionalPackages

# Step 5: Final Summary
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Installation Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Total packages: $($essentialPackages.Count + $optionalPackages.Count + $gpuPackages.Count)" -ForegroundColor White
Write-Host "Successfully installed: $successCount" -ForegroundColor Green
Write-Host "Failed: $failCount" -ForegroundColor $(if ($failCount -gt 0) { "Red" } else { "Green" })

if ($skippedPackages.Count -gt 0) {
    Write-Host "Skipped: $($skippedPackages.Count)" -ForegroundColor Yellow
}

if ($failedPackages.Count -gt 0) {
    Write-Host ""
    Write-Host "Failed packages:" -ForegroundColor Red
    foreach ($pkg in $failedPackages) {
        Write-Host "  - $pkg" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Please restart your computer for all changes to take effect." -ForegroundColor Yellow
Write-Host ""

################################################################################
# End of windows_install.ps1
# Author: @mrfixit027
# GitHub: https://github.com/peeweeh/pc-setup
################################################################################

