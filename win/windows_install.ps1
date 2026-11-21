param([ValidateSet('light', 'heavy')][string]$Tier = 'light')

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
Write-Host "By @mrfixit027" -ForegroundColor Cyan
Write-Host "GitHub: https://github.com/peeweeh/pc-setup" -ForegroundColor Cyan
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
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey is unavailable after installation; stopping." -ForegroundColor Red
    exit 1
}

Write-Host ""

# Step 2: Detect GPU and determine graphics drivers
Write-Host "Step 2: Detecting GPU..." -ForegroundColor Yellow

$gpuPackages = @()
try {
    $gpus = @(Get-CimInstance Win32_VideoController -ErrorAction Stop)
    $nvidia = @($gpus | Where-Object { $_.Name -match 'NVIDIA' -or $_.AdapterCompatibility -match 'NVIDIA' })
    $amd = @($gpus | Where-Object { $_.Name -match 'AMD|Radeon' -or $_.AdapterCompatibility -match 'Advanced Micro Devices' })
    if ($nvidia.Count -gt 0) {
        Write-Host "NVIDIA GPU detected: $($nvidia.Name -join ', ')" -ForegroundColor Cyan
        $gpuPackages = @("nvidia-app", "nvidia-physx")
    }
    if ($amd.Count -gt 0) {
        Write-Host "AMD GPU detected; download drivers manually from AMD." -ForegroundColor Yellow
    }
    if ($nvidia.Count -eq 0 -and $amd.Count -eq 0) {
        Write-Host "No supported NVIDIA or AMD GPU detected." -ForegroundColor Yellow
    }
} catch {
    Write-Host "Could not detect GPUs; GPU packages will be skipped: $_" -ForegroundColor Yellow
}

Write-Host ""

# Step 3: Install packages
Write-Host "Step 3: Installing Chocolatey packages..." -ForegroundColor Yellow
Write-Host ""

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
            choco install $package -y
            if ($LASTEXITCODE -eq 0 -or $LASTEXITCODE -eq 3010) {
                Write-Host "- $package installed successfully" -ForegroundColor Green
                if ($LASTEXITCODE -eq 3010) { Write-Host "  Restart required for $package." -ForegroundColor Yellow }
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

function Get-PackageSelection {
    param([string]$Tier, [string[]]$Essential, [string[]]$Optional)
    $heavy = @(
        "protonmail", "protonvpn", "protondrive", "googledrive", "onedrive",
        "microsoft-teams", "windows-app", "amazon-workspaces", "docker-desktop", "figma", "ollama", "steam",
        "ea-app", "epicgameslauncher", "goggalaxy", "ubisoft-connect",
        "icloud", "iTunes", "plexmediaplayer"
    )
    $additional = @(
        "1password-cli", "helium", "comet-browser", "claude", "sourcetree", "warp-terminal",
        "devtoys", "awscli", "uv", "nerd-fonts-firacode", "nerd-fonts-hack",
        "actionlint", "eza", "golang", "github-copilot-cli", "pipx", "python315",
        "ruff", "tailscale", "onedrive", "windows-app", "amazon-workspaces",
        "docker-desktop", "figma", "ollama"
    )
    $selected = @($Essential + $Optional + $additional | Select-Object -Unique)
    if ($Tier -eq 'light') {
        $selected = @($selected | Where-Object { $_ -notin $heavy })
    }
    return $selected
}
$packagesToInstall = @(Get-PackageSelection -Tier $Tier -Essential $essentialPackages -Optional $optionalPackages)
if ($Tier -eq 'heavy' -and $gpuPackages.Count -gt 0) {
    Install-PackageGroup -GroupName "GPU Packages" -Packages $gpuPackages -SkipPrompt $true
}
Install-PackageGroup -GroupName "$Tier packages" -Packages $packagesToInstall -SkipPrompt $true

Write-Host "Checking Hermes Agent..." -ForegroundColor Cyan
$hermesHome = if ($env:HERMES_HOME) { $env:HERMES_HOME } else { Join-Path $env:LOCALAPPDATA 'hermes' }
if ((Get-Command hermes -ErrorAction SilentlyContinue) -or (Test-Path -LiteralPath (Join-Path $hermesHome 'hermes-agent'))) {
    Write-Host "Hermes already exists; leaving it unchanged." -ForegroundColor Green
} else {
    $hermesInstaller = Join-Path $env:TEMP ("hermes-install-" + [guid]::NewGuid().ToString() + ".ps1")
    try {
        Invoke-WebRequest -Uri 'https://hermes-agent.nousresearch.com/install.ps1' -OutFile $hermesInstaller -UseBasicParsing -ErrorAction Stop
        & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $hermesInstaller -NonInteractive
        if ($LASTEXITCODE -ne 0) { throw "Hermes installer exited with code $LASTEXITCODE." }
        Write-Host "Hermes installed. Run 'hermes setup' in a new terminal." -ForegroundColor Green
    } catch {
        Write-Host "Hermes installation failed: $_" -ForegroundColor Red
        $failCount++
        $failedPackages += 'Hermes Agent'
    } finally {
        if (Test-Path -LiteralPath $hermesInstaller) { Remove-Item -LiteralPath $hermesInstaller -Force }
    }
}

# Step 5: Final Summary
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Installation Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Selected tier: $Tier" -ForegroundColor White
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
if ($failCount -gt 0) {
    Write-Host "Setup completed with package failures." -ForegroundColor Red
    exit 1
}
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Please restart your computer for all changes to take effect." -ForegroundColor Yellow
Write-Host ""
Write-Host "Script by @mrfixit027" -ForegroundColor Cyan
Write-Host "GitHub: https://github.com/peeweeh/pc-setup" -ForegroundColor Cyan
Write-Host ""

################################################################################
# End of windows_install.ps1
# Author: @mrfixit027
# GitHub: https://github.com/peeweeh/pc-setup
################################################################################

