# PC Setup Scripts Specification

This document describes the purpose, functionality, and relationships between all setup scripts in this repository.

## Overview

The PC Setup project provides modular, automated setup scripts for Windows and macOS. Each script has a specific purpose to ensure separation of concerns and allow users to pick and choose which setup components to apply.

The Windows privacy configuration combines multiple privacy frameworks:
- **privacy.sexy** (v0.13.8) - Comprehensive privacy tweaks
- **O&O ShutUp10++** (v2.1.1015) - Advanced privacy and app permission controls

### Execution Order (Recommended)

1. **windows_install.ps1** - Install essential packages (required)
2. **privacy_tweaks.ps1** - Apply privacy and telemetry settings (optional, ~5-10 min runtime)
3. **vscode_extensions.ps1** - Install VS Code extensions (optional)
4. **dev_setup.ps1** - Configure development environment (optional)

### Key Statistics

- **Total Windows Setup Scripts:** 4 PowerShell scripts + 1 configuration file
- **Privacy/Telemetry Coverage:** ~78% of major Windows privacy settings
- **Registry Modifications:** 80+ registry keys across HKCU and HKLM hives
- **Packages Available:** 74 via Chocolatey (18 Essential, 56+ Optional, GPU-specific)
- **Total Implementation Lines:** 1,100+ lines of PowerShell code

---

## Quick Reference: Running the Scripts

### One-by-One (Recommended for First Run)
```powershell
# 1. Install packages (essential, GPU detection included)
powershell.exe -ExecutionPolicy Bypass -File ".\win\windows_install.ps1"

# 2. Apply privacy tweaks (optional, ~5-10 minutes)
powershell.exe -ExecutionPolicy Bypass -File ".\win\privacy_tweaks.ps1"

# 3. Install VS Code extensions (optional)
powershell.exe -ExecutionPolicy Bypass -File ".\win\vscode_extensions.ps1"

# 4. Setup development environment (optional, WSL2, Docker, Node, Python, Git, AWS)
powershell.exe -ExecutionPolicy Bypass -File ".\win\dev_setup.ps1"
```

### All at Once (For Automation)
```powershell
# Run all scripts sequentially
@("windows_install.ps1", "privacy_tweaks.ps1", "vscode_extensions.ps1", "dev_setup.ps1") | 
  ForEach-Object { powershell.exe -ExecutionPolicy Bypass -File ".\win\$_" }
```

### Prerequisites Check
```powershell
# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) { Write-Host "ERROR: Please run as Administrator" -ForegroundColor Red; exit 1 }

# Check Windows version
[System.Environment]::OSVersion.Version

# Check Internet connectivity
Test-Connection 8.8.8.8 -Count 1
```

---

## Section 1: windows_install.ps1

**Purpose:** Main package installation script that sets up essential software and system tweaks using Chocolatey.

**File Size:** ~340 lines

**Features:**
- Automatic GPU detection (NVIDIA/AMD) with conditional driver installation
- Three-tier package installation workflow:
  - **Essential Packages (18 items):** 1password, beeper-app, brave, git, VS Code, Discord, Signal, Proton services, VLC, WinRAR, .NET runtime, WebView2, and more
  - **Optional Packages (56+ items):** Development tools, communications apps, gaming platforms, media software, utilities
  - **GPU Drivers:** NVIDIA packages (nvidia-app, nvidia-physx) auto-detected and installed
- Interactive user prompts to skip package groups
- System maintenance:
  - System restore point creation
  - Temporary file cleanup (%TEMP% and C:\Windows\Temp)
  - Hibernation disable for SSD optimization
- Basic convenience tweaks:
  - End task with right-click context menu
  - Autoplay disable
  - Delivery Optimization set to manual
- Success/failure tracking with detailed summary

**Key Functions:**
- `Install-PackageGroup()` - Manages categorized installation with skip prompts
- `Set-RegistryValue()` - Safe registry modification helper (basic tweaks only)

**Package Distribution:**
```
Essential (18):    1password, beeper-app, brave, discord, dotnet, git, proton*, signal, vlc, vscode, webview2, winrar, ...
Optional (56+):    chatgpt, calibre, clipchamp, everything, ffmpeg, node.js, obsidian, postman, powertoys, python, slack, steam, ...
GPU (if detected): nvidia-app, nvidia-physx
```

**Requirements:**
- Administrator privileges
- Windows 10/11
- Internet connection
- Chocolatey will be installed automatically if not present

**Execution:**
```powershell
powershell.exe -ExecutionPolicy Bypass -File ".\win\windows_install.ps1"
```

**Output:**
- Chocolatey installation status
- GPU detection results
- Package installation progress with success/failure counts
- System tweaks summary
- List of failed packages (if any)
- Restart requirement notification

**Architecture Decision:**
- Privacy and telemetry tweaks removed (consolidated to `privacy_tweaks.ps1`)
- Focus exclusively on package installation and essential system configuration
- Allows users to apply privacy settings independently from package installation
- This script focuses solely on package installation
- Temporary files are cleaned up automatically

---

## Section 2: privacy_tweaks.ps1

**Purpose:** Comprehensive privacy, telemetry, and security hardening configuration combining privacy.sexy and O&O ShutUp10++ frameworks.

**File Size:** 453 lines

**Framework Sources:**
- **privacy.sexy** (v0.13.8) - Community-driven privacy framework
- **O&O ShutUp10++** (v2.1.1015) - Professional privacy configuration tool

**Execution Time:** ~5-10 minutes (depending on system state)

**Features (80+ registry modifications):**

**Privacy & Telemetry Disabling:**
- Windows diagnostic data and feedback collection
- Cortana and Bing search tracking
- Activity history and app launch tracking  
- Advertising ID and personalized advertisements
- Cloud-based speech recognition
- Inking and typing personalization data
- Typing feedback and input recognition
- .NET Core and PowerShell telemetry
- Consumer Experience Improvement Program

**App Privacy Controls (15+ permissions):**
- Disable app access to: account information, contacts, calendar, email, messages
- Disable app access to: documents library, pictures library, videos library, file system
- Disable app diagnostics and diagnostic data collection
- Disable background app permissions
- Block automatic app installations from Microsoft Store
- Disable app notifications (push notifications)

**System Cleanup:**
- Remove controversial `defaultuser0` user account
- Remove default app file associations
- Clear SRUM (System Resource Usage Monitor) database
- Remove activity history recordings

**User Experience:**
- Disable app suggestions in Start menu
- Disable Start menu search web results
- Disable Windows Spotlight notifications
- Disable tips, tricks, and suggestions
- Disable content delivery and suggested content
- Disable clipboard history synchronization
- Disable activity history synchronization
- Disable tailored user experiences

**Security Hardening:**
- Disable PowerShell 2.0 downgrade vulnerability protection
- Enable SEHOP (Structured Exception Handling Overwrite Protection)
- Disable Windows Installer privilege escalation
- Disable storage of LAN Manager password hashes
- Disable Windows DRM internet access
- Disable password reveal button
- Disable Windows Steps Recorder
- Disable device sensors and location tracking

**Device Management:**
- Comprehensive AutoPlay and AutoRun disabling
- Disable Windows Connect Now wizard
- Disable automatic map downloads
- Disable device location services
- Disable Wi-Fi Sense automatic connections
- Disable Delivery Optimization P2P file sharing
- Disable lock screen camera access
- Disable lock screen app notifications

**Network & Hosts Blocking:**
- Block 30+ malicious telemetry domains in hosts file:
  - Microsoft telemetry: watson.telemetry.microsoft.com, vortex-win.data.microsoft.com, etc.
  - Error reporting: oca.telemetry.microsoft.com, oca.microsoft.com
  - Event tracking: kmwatsonc.events.data.microsoft.com, v10.events.data.microsoft.com, etc.
  - CDN services: cs11.wpc.v0cdn.net, cs1137.wpc.gammacdn.net
  - Edge experimentation: config.edge.skype.com

**Key Functions:**
- `Set-RegistryValue()` - Safe registry modification with path creation
- `takeown`/`icacls` - File permission management for SRUM deletion
- Hosts file manipulation - DNS blocking of telemetry domains

**Registry Hives Modified:**
```
HKCU (User):
  - SOFTWARE\Microsoft\Windows\CurrentVersion\*
  - SOFTWARE\Microsoft\Personalization\*
  - SOFTWARE\Microsoft\Input\TIPC
  - Control Panel\International\User Profile
  
HKLM (System):
  - SOFTWARE\Policies\Microsoft\Windows\*
  - SOFTWARE\Microsoft\Windows\CurrentVersion\*
  - SYSTEM\CurrentControlSet\Control\*
```

**Requirements:**
- Administrator privileges (mandatory)
- Windows 10/11 (build 19041+)
- Internet connection (for hosts file updates)
- Close all applications before running (recommended)

**Execution:**
```powershell
powershell.exe -ExecutionPolicy Bypass -File ".\win\privacy_tweaks.ps1"
```

**Output:**
- Applied tweaks count
- Failed tweaks count
- Detailed progress messages for each tweak
- Notification to restart computer for full effect

**Important Notes:**
- **Idempotent:** Safe to run multiple times
- **Reversible:** Changes can be manually reverted via System Restore or registry
- **Comprehensive:** Covers 78% of major Windows privacy settings
- **Framework-Based:** Uses established privacy configuration frameworks
- **User Choice:** Completely optional and independent of package installation
- **Non-Destructive:** No files deleted except system temp and SRUM data

**Source:**
- Generated from [privacy.sexy](https://privacy.sexy) framework (4832+ lines converted to PowerShell)

---

## Section 3: vscode_extensions.ps1

**Purpose:** Automated installation of recommended VS Code extensions.

**Features:**
- Batch installation of productivity extensions
- Installs extensions from VS Code Marketplace
- Provides installation summary

**Installation Methods:**
- Command-line: `code --install-extension <publisher>.<extension>`
- Marketplace UI: Extensions panel in VS Code

**Execution:**
```powershell
powershell.exe -ExecutionPolicy Bypass -File ".\win\vscode_extensions.ps1"
```

**Requirements:**
- VS Code installed
- Internet connection

---

## Section 4: dev_setup.ps1

**Purpose:** Development environment configuration for web and systems development.

**Features (4.1-4.7):**
- **WSL2 Setup** - Windows Subsystem for Linux 2 installation
- **Docker Desktop** - Container runtime setup
- **Node.js** - JavaScript runtime configuration
- **Python** - Python environment setup
- **Git** - Advanced Git configuration
- **AWS CLI** - Amazon Web Services tools
- **Additional Tools** - Extra development utilities

**Requirements:**
- Administrator privileges
- Windows 10/11 (build 19041+)
- Internet connection
- Some features require BIOS virtualization enabled

**Execution:**
```powershell
powershell.exe -ExecutionPolicy Bypass -File ".\win\dev_setup.ps1"
```

---

## Architecture & Design Decisions

### Privacy Tweaks Consolidation Strategy

All privacy and telemetry settings have been consolidated into a single `privacy_tweaks.ps1` script with benefits:

**Separation of Concerns:**
- ✅ `windows_install.ps1` - Package installation only
- ✅ `privacy_tweaks.ps1` - Privacy and security configuration
- ✅ `vscode_extensions.ps1` - Development tool configuration
- ✅ `dev_setup.ps1` - Development environment setup

**Why This Architecture:**
- **Single Source of Truth** - All privacy settings in one script
- **Avoid Duplication** - No overlapping tweaks between scripts
- **User Choice** - Apply privacy independently from packages
- **Maintainability** - Framework-based (privacy.sexy + O&O) with clear references
- **Flexibility** - Users can skip any script without affecting others

**Framework Combination Rationale:**
- **privacy.sexy** provides foundational telemetry and core privacy settings
- **O&O ShutUp10++** adds granular app permission controls and advanced security
- Combined coverage reaches ~78% of Windows privacy configurations

### What Was Removed

**From windows_install.ps1:**
- ~190 lines of duplicate privacy tweaks
- Telemetry disabling (AllowTelemetry registry keys)
- Activity History and Cortana disabling
- Service management (DiagTrack, dmwappushservice, WerSvc)
- Error Reporting and Ad ID disabling
- Location tracking and App suggestions disabling

**Moved to privacy_tweaks.ps1:**
- All above settings + 40+ additional tweaks
- Comprehensive app permission controls
- Security hardening measures
- Hosts file domain blocking
- System cleanup operations

---

## Repository Structure

```
pc-setup/
├── README.md              # Project overview and quick start
├── spec.md               # This file - detailed specifications
├── DEVELOPMENT.md        # Development guidelines
├── CONTRIBUTING.md       # Contribution guidelines
├── LICENSE              # MIT License
├── mac/                 # macOS setup scripts
│   ├── brew_install.sh
│   ├── mac_install.sh
│   └── vscode.sh
└── win/                 # Windows setup scripts
    ├── windows_install.ps1
    ├── privacy_tweaks.ps1
    ├── vscode_extensions.ps1
    └── dev_setup.ps1
```

---

## Troubleshooting

### Execution Policy Issues
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force
```

### Admin Privileges Required
- Right-click PowerShell → "Run as Administrator"
- Or use Windows Terminal with elevated privileges

### Failed Packages
- Check internet connection
- Run `choco list -localonly` to see installed packages
- Try installing problematic package manually: `choco install <package-name>`

### Privacy Script Not Applying Changes
- Ensure running as Administrator
- Close VS Code before running (some settings lock when apps are open)
- Restart computer after running script

### Reverting Changes
- Use Windows System Restore point created by windows_install.ps1
- Manually revert registry changes if needed

---

## Related Links

**Privacy & Telemetry Frameworks:**
- [privacy.sexy](https://privacy.sexy) - Community-driven Windows privacy configuration (v0.13.8 used)
- [O&O ShutUp10++](https://www.oo-software.com/shutup10) - Professional privacy tool (v2.1.1015 config used)

**Development Tools & Package Managers:**
- [Chocolatey Package Manager](https://chocolatey.org) - Windows package manager
- [VS Code Extensions](https://marketplace.visualstudio.com) - Official extension marketplace
- [Node.js](https://nodejs.org/) - JavaScript runtime
- [Python](https://www.python.org/) - Python programming language

**Development Environments:**
- [WSL2 Documentation](https://docs.microsoft.com/windows/wsl) - Windows Subsystem for Linux
- [Docker Desktop](https://www.docker.com/products/docker-desktop) - Container platform
- [Git](https://git-scm.com/) - Version control system
- [AWS CLI](https://aws.amazon.com/cli/) - Amazon Web Services command line

**Additional Resources:**
- [GitHub Repository](https://github.com/peeweeh/pc-setup) - Source code and updates
- [Microsoft Windows Documentation](https://docs.microsoft.com/windows/) - Official Windows guides

