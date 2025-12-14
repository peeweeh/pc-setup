################################################################################
# install.ps1
# Master installer for PC Setup automation
# Interactive menu-driven setup orchestrator
#
# Author: @mrfixit027
# GitHub: https://github.com/peeweeh/pc-setup
################################################################################

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "Administrator Privileges Required" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "This installer requires Administrator privileges." -ForegroundColor Yellow
    Write-Host "Please run PowerShell as Administrator and try again." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "To run as Administrator:" -ForegroundColor Cyan
    Write-Host "1. Right-click PowerShell" -ForegroundColor Cyan
    Write-Host "2. Select 'Run as Administrator'" -ForegroundColor Cyan
    Write-Host "3. Run this script again" -ForegroundColor Cyan
    Write-Host ""
    pause
    exit 1
}

Write-Host ""
Write-Host "PC Setup Installer by @mrfixit027" -ForegroundColor Cyan
Write-Host "GitHub: https://github.com/peeweeh/pc-setup" -ForegroundColor Cyan
Write-Host ""

# Determine script location (local or web)
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
if ([string]::IsNullOrEmpty($scriptPath)) {
    # Running from web, download to temp
    $scriptPath = $env:TEMP
    $isWebMode = $true
} else {
    $isWebMode = $false
}

function Show-Banner {
    Clear-Host
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "     PC Setup - Master Installer       " -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "         by @mrfixit027                " -ForegroundColor Gray
    Write-Host ""
}

function Show-Menu {
    Write-Host "Select components to install:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  [1] Windows Package Installation" -ForegroundColor White
    Write-Host "      - 74 packages via Chocolatey" -ForegroundColor Gray
    Write-Host "      - Essential + Optional packages" -ForegroundColor Gray
    Write-Host "      - GPU detection and driver installation" -ForegroundColor Gray
    Write-Host "      - Estimated time: 30-60 minutes" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  [2] Privacy and Security Tweaks" -ForegroundColor White
    Write-Host "      - 80+ registry modifications" -ForegroundColor Gray
    Write-Host "      - App permission controls" -ForegroundColor Gray
    Write-Host "      - Telemetry and tracking disabled" -ForegroundColor Gray
    Write-Host "      - Estimated time: 5-10 minutes" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  [3] VS Code Extensions" -ForegroundColor White
    Write-Host "      - Productivity extensions" -ForegroundColor Gray
    Write-Host "      - Development tools" -ForegroundColor Gray
    Write-Host "      - Estimated time: 5 minutes" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  [4] Development Environment Setup" -ForegroundColor White
    Write-Host "      - WSL2, Docker Desktop" -ForegroundColor Gray
    Write-Host "      - Node.js, Python, Git" -ForegroundColor Gray
    Write-Host "      - AWS CLI and tools" -ForegroundColor Gray
    Write-Host "      - Estimated time: 15-30 minutes" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  [5] ALL OF THE ABOVE" -ForegroundColor Green
    Write-Host "      - Complete system setup (60-120 minutes)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  [Q] Quit" -ForegroundColor Red
    Write-Host ""
}

function Run-Script {
    param(
        [string]$ScriptName,
        [string]$Description
    )
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "$Description" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    
    $scriptFile = Join-Path $scriptPath $ScriptName
    
    if ($isWebMode) {
        # Download and execute from web
        $url = "https://raw.githubusercontent.com/peeweeh/pc-setup/master/win/$ScriptName"
        Write-Host "Downloading $ScriptName from GitHub..." -ForegroundColor Yellow
        try {
            $scriptContent = (New-Object System.Net.WebClient).DownloadString($url)
            $tempScript = Join-Path $env:TEMP $ScriptName
            $scriptContent | Out-File -FilePath $tempScript -Encoding UTF8
            Write-Host "Executing $ScriptName..." -ForegroundColor Green
            & powershell.exe -ExecutionPolicy Bypass -File $tempScript
            Remove-Item $tempScript -Force -ErrorAction SilentlyContinue
        } catch {
            Write-Host "Failed to download or execute $ScriptName" -ForegroundColor Red
            Write-Host "Error: $_" -ForegroundColor Red
            return $false
        }
    } else {
        # Execute from local file
        if (Test-Path $scriptFile) {
            Write-Host "Executing $ScriptName..." -ForegroundColor Green
            & powershell.exe -ExecutionPolicy Bypass -File $scriptFile
        } else {
            Write-Host "Script not found: $scriptFile" -ForegroundColor Red
            Write-Host "Please ensure you're running from the correct directory." -ForegroundColor Yellow
            return $false
        }
    }
    
    Write-Host ""
    Write-Host "Completed: $Description" -ForegroundColor Green
    Write-Host ""
    return $true
}

function Run-AllScripts {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Magenta
    Write-Host "Running Complete Setup" -ForegroundColor Magenta
    Write-Host "========================================" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "This will run all setup scripts sequentially." -ForegroundColor Yellow
    Write-Host "Estimated total time: 60-120 minutes" -ForegroundColor Yellow
    Write-Host ""
    $confirm = Read-Host "Continue? (Y/N)"
    
    if ($confirm -ne 'Y' -and $confirm -ne 'y') {
        Write-Host "Cancelled." -ForegroundColor Yellow
        return
    }
    
    $scripts = @(
        @{Name = "windows_install.ps1"; Desc = "Windows Package Installation"},
        @{Name = "privacy_tweaks.ps1"; Desc = "Privacy & Security Tweaks"},
        @{Name = "vscode_extensions.ps1"; Desc = "VS Code Extensions"},
        @{Name = "dev_setup.ps1"; Desc = "Development Environment Setup"}
    )
    
    $successCount = 0
    $totalScripts = $scripts.Count
    
    foreach ($script in $scripts) {
        if (Run-Script -ScriptName $script.Name -Description $script.Desc) {
            $successCount++
        }
        Write-Host "Progress: $successCount/$totalScripts completed" -ForegroundColor Cyan
    }
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "Setup Complete!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Successfully completed: $successCount/$totalScripts scripts" -ForegroundColor Green
    Write-Host ""
    Write-Host "IMPORTANT: Please restart your computer for all changes to take effect." -ForegroundColor Yellow
    Write-Host ""
}

# Main loop
do {
    Show-Banner
    Show-Menu
    
    $choice = Read-Host "Enter your choice (1-5, Q to quit)"
    
    switch ($choice.ToUpper()) {
        "1" {
            Run-Script -ScriptName "windows_install.ps1" -Description "Windows Package Installation"
            Write-Host "Press any key to continue..." -ForegroundColor Gray
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        "2" {
            Run-Script -ScriptName "privacy_tweaks.ps1" -Description "Privacy & Security Tweaks"
            Write-Host "Press any key to continue..." -ForegroundColor Gray
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        "3" {
            Run-Script -ScriptName "vscode_extensions.ps1" -Description "VS Code Extensions"
            Write-Host "Press any key to continue..." -ForegroundColor Gray
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        "4" {
            Run-Script -ScriptName "dev_setup.ps1" -Description "Development Environment Setup"
            Write-Host "Press any key to continue..." -ForegroundColor Gray
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        "5" {
            Run-AllScripts
            Write-Host "Press any key to continue..." -ForegroundColor Gray
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        "Q" {
            Write-Host ""
            Write-Host "Exiting installer. Goodbye!" -ForegroundColor Cyan
            Write-Host ""
            exit 0
        }
        default {
            Write-Host ""
            Write-Host "Invalid choice. Please select 1-5 or Q." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
} while ($true)

Write-Host ""
Write-Host "Script by @mrfixit027" -ForegroundColor Cyan
Write-Host "GitHub: https://github.com/peeweeh/pc-setup" -ForegroundColor Cyan
Write-Host ""

################################################################################
# End of install.ps1
# Author: @mrfixit027
# GitHub: https://github.com/peeweeh/pc-setup
################################################################################
