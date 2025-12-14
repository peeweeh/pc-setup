# choco-setup.ps1
# Script to install Chocolatey and all currently installed packages

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "This script requires Administrator privileges. Please run as Administrator." -ForegroundColor Red
    exit 1
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Chocolatey Setup Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Install Chocolatey
Write-Host "Step 1: Installing Chocolatey..." -ForegroundColor Yellow

# Check if Chocolatey is already installed
$chocoInstalled = Get-Command choco -ErrorAction SilentlyContinue

if ($chocoInstalled) {
    Write-Host "Chocolatey is already installed." -ForegroundColor Green
} else {
    Write-Host "Installing Chocolatey..." -ForegroundColor Yellow
    
    # Set execution policy for this process
    Set-ExecutionPolicy Bypass -Scope Process -Force
    
    # Download and install Chocolatey
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    try {
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        Write-Host "Chocolatey installed successfully!" -ForegroundColor Green
    } catch {
        Write-Host "Failed to install Chocolatey: $_" -ForegroundColor Red
        exit 1
    }
    
    # Refresh environment variables
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

# List of packages to install (excluding chocolatey itself and dependency packages)
$packages = @(
    "1password",
    "7zip.install",
    "amd-ryzen-chipset",
    "amd-ryzen-master",
    "arc-browser",
    "bat",
    "beeper-app",
    "boxstarter",
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
    "oh-my-posh",
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
                Write-Host "✓ $package installed successfully" -ForegroundColor Green
                $successCount++
            } else {
                Write-Host "✗ Failed to install $package" -ForegroundColor Red
                $failCount++
                $failedPackages += $package
            }
        } catch {
            Write-Host "✗ Error installing $package`: $_" -ForegroundColor Red
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
            Write-Host "✓ $package installed successfully" -ForegroundColor Green
            $successCount++
        } else {
            Write-Host "✗ Failed to install $package" -ForegroundColor Red
            $failCount++
            $failedPackages += $package
        }
    } catch {
        Write-Host "✗ Error installing $package`: $_" -ForegroundColor Red
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
Write-Host "Windows Privacy & Performance Tweaks" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 4: Apply Essential Windows Tweaks
Write-Host "Applying essential Windows tweaks..." -ForegroundColor Yellow
Write-Host ""

$tweakCount = 0
$tweakErrors = 0

# Helper function to create registry keys
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

# 0. Create Restore Point
Write-Host "→ Creating system restore point..." -ForegroundColor Cyan
try {
    Enable-ComputerRestore -Drive "$env:SystemDrive"
    Checkpoint-Computer -Description "Before WinUtil Tweaks" -RestorePointType "MODIFY_SETTINGS"
    $tweakCount++
} catch {
    Write-Host "  Could not create restore point (might need to be enabled in System Properties)" -ForegroundColor Yellow
    $tweakErrors++
}

# 1. Delete Temporary Files
Write-Host "→ Deleting temporary files..." -ForegroundColor Cyan
try {
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    $tweakCount++
} catch {
    $tweakErrors++
}

# 2. Disable Telemetry
Write-Host "→ Disabling telemetry..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" 0) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "AllowTelemetry" 0) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "AllowTelemetry" 0) { $tweakCount++ } else { $tweakErrors++ }

# 3. Disable Consumer Features
Write-Host "→ Disabling consumer features..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableWindowsConsumerFeatures" 1) { $tweakCount++ } else { $tweakErrors++ }

# 4. Disable Activity History
Write-Host "→ Disabling activity history..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "EnableActivityFeed" 0) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "PublishUserActivities" 0) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "UploadUserActivities" 0) { $tweakCount++ } else { $tweakErrors++ }

# 5. Disable Explorer Automatic Folder Discovery
Write-Host "→ Disabling Explorer automatic folder discovery..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" "FolderType" "NotSpecified" "String") { $tweakCount++ } else { $tweakErrors++ }

# 6. Disable GameDVR
Write-Host "→ Disabling GameDVR..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\System\GameConfigStore" "GameDVR_Enabled" 0) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" "AllowGameDVR" 0) { $tweakCount++ } else { $tweakErrors++ }

# 7. Disable Hibernation
Write-Host "→ Disabling hibernation..." -ForegroundColor Cyan
try {
    powercfg.exe /hibernate off | Out-Null
    $tweakCount++
} catch {
    $tweakErrors++
}

# 8. Disable Location Tracking
Write-Host "→ Disabling location tracking..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" "DisableLocation" 1) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" "Value" "Deny" "String") { $tweakCount++ } else { $tweakErrors++ }

# 9. Disable Storage Sense
Write-Host "→ Disabling storage sense..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" "01" 0) { $tweakCount++ } else { $tweakErrors++ }

# 10. Disable Wi-Fi Sense
Write-Host "→ Disabling Wi-Fi sense..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" "Value" 0) { $tweakCount++ } else { $tweakErrors++ }
if (Set-RegistryValue "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" "Value" 0) { $tweakCount++ } else { $tweakErrors++ }

# 11. Enable End Task with Right Click
Write-Host "→ Enabling end task with right click..." -ForegroundColor Cyan
if (Set-RegistryValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings" "TaskbarEndTask" 1) { $tweakCount++ } else { $tweakErrors++ }

# 12. Run Disk Cleanup
Write-Host "→ Running disk cleanup..." -ForegroundColor Cyan
try {
    Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -WindowStyle Hidden -Wait -ErrorAction SilentlyContinue
    $tweakCount++
} catch {
    $tweakErrors++
}

# 13. Disable PowerShell 7 Telemetry
Write-Host "→ Disabling PowerShell 7 telemetry..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\PowerShellCore" "EnableApplicationInsights" 0) { $tweakCount++ } else { $tweakErrors++ }

# 14. Set Services to Manual
Write-Host "→ Setting services to manual..." -ForegroundColor Cyan
if (Set-RegistryValue "HKLM:\SYSTEM\CurrentControlSet\Services" "Start" 3) { $tweakCount++ } else { $tweakErrors++ }



# Summary
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
Write-Host "All Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Please restart your computer for all changes to take effect." -ForegroundColor Yellow
Write-Host ""

# Step 5: Configure Oh My Posh
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Configuring Oh My Posh" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

try {
    # Check if Oh My Posh is installed by looking for the executable
    $ohMyPoshPath = "C:\Program Files (x86)\oh-my-posh\bin\oh-my-posh.exe"
    $ohMyPoshInstalled = Test-Path $ohMyPoshPath
    
    if ($ohMyPoshInstalled) {
        Write-Host "Configuring Oh My Posh for PowerShell..." -ForegroundColor Yellow
        
        # Create PowerShell profile if it doesn't exist
        $profilePath = $PROFILE.CurrentUserAllHosts
        $profileDir = Split-Path -Parent $profilePath
        
        if (!(Test-Path $profileDir)) {
            New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
        }
        
        # Backup existing profile if it exists
        if (Test-Path $profilePath) {
            Copy-Item $profilePath "$profilePath.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
            Write-Host "✓ Backed up existing PowerShell profile" -ForegroundColor Green
        }
        
        # Find the themes directory
        $themesPath = "C:\Program Files (x86)\oh-my-posh\themes"
        
        # Add Oh My Posh initialization to profile
        $ohMyPoshConfig = @"

# Oh My Posh Configuration
& "$ohMyPoshPath" init pwsh --config "$themesPath\atomic.omp.json" | Invoke-Expression

"@
        
        # Check if Oh My Posh is already configured
        $existingContent = if (Test-Path $profilePath) { Get-Content $profilePath -Raw } else { "" }
        
        if ($existingContent -notmatch "oh-my-posh init") {
            Add-Content -Path $profilePath -Value $ohMyPoshConfig
            Write-Host "✓ Added Oh My Posh to PowerShell profile" -ForegroundColor Green
            Write-Host "  Profile location: $profilePath" -ForegroundColor Cyan
            Write-Host "  Using theme: atomic" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "To change themes, edit your profile and replace 'atomic.omp.json' with another theme." -ForegroundColor Yellow
            Write-Host "View available themes: Get-PoshThemes" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "✓ Oh My Posh configured successfully!" -ForegroundColor Green
            Write-Host "  Restart your terminal or run: . `$PROFILE" -ForegroundColor Cyan
        } else {
            Write-Host "✓ Oh My Posh is already configured in your profile" -ForegroundColor Green
        }
    } else {
        Write-Host "Oh My Posh is not installed. Skipping configuration." -ForegroundColor Yellow
        Write-Host "Install it with: choco install oh-my-posh -y" -ForegroundColor Cyan
    }
    oh-my-posh font install FiraMono Nerd 
    oh-my-posh font install FiraCOde Nerd Font
} catch {
    Write-Host "✗ Failed to configure Oh My Posh: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Optional: To run the full Chris Titus Tech Windows Utility GUI, execute:" -ForegroundColor Cyan
Write-Host "  irm 'https://christitus.com/win' | iex" -ForegroundColor White

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Installing PowerShell Modules" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Install PSReadLine
Write-Host "→ Installing PSReadLine module..." -ForegroundColor Cyan
try {
    Install-Module -Name PSReadLine -Scope CurrentUser -Force -AllowClobber -ErrorAction Stop
    Write-Host "✓ PSReadLine installed successfully" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed to install PSReadLine: $_" -ForegroundColor Red
}

# Install Terminal-Icons
Write-Host "→ Installing Terminal-Icons module..." -ForegroundColor Cyan
try {
    Install-Module -Name Terminal-Icons -Scope CurrentUser -Force -ErrorAction Stop
    Write-Host "✓ Terminal-Icons installed successfully" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed to install Terminal-Icons: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "PowerShell Modules Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Installing O&O ShutUp10++" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "→ Downloading and launching O&O ShutUp10++..." -ForegroundColor Yellow
try {
    Invoke-WebRequest -UseBasicParsing "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe" -OutFile "$env:TEMP\OOSU10.exe"
    Write-Host "✓ Downloaded successfully" -ForegroundColor Green
    Write-Host "→ Launching O&O ShutUp10++ (running in background)..." -ForegroundColor Cyan
    Start-Process "$env:TEMP\OOSU10.exe" -NoNewWindow
    Write-Host "✓ O&O ShutUp10++ launched - you can configure privacy settings when ready" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed to download or launch O&O ShutUp10++: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "All Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Please restart your computer for all changes to take effect." -ForegroundColor Yellow

