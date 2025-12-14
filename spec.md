# PC Setup Scripts Specification

This document describes the purpose, functionality, and relationships between all setup scripts in this repository.

## Overview

The PC Setup project provides modular, automated setup scripts for Windows and macOS. Each script has a specific purpose to ensure separation of concerns and allow users to pick and choose which setup components to apply.

### Execution Order (Recommended)

1. **windows_install.ps1** - Install essential packages (required)
2. **privacy_tweaks.ps1** - Apply privacy and telemetry settings (optional)
3. **vscode_extensions.ps1** - Install VS Code extensions (optional)
4. **dev_setup.ps1** - Configure development environment (optional)

---

## Section 1: windows_install.ps1

**Purpose:** Main package installation script that sets up essential software using Chocolatey.

**Features:**
- Automatic GPU detection (NVIDIA/AMD) for driver installation
- Three-tier package installation:
  - **Essential Packages** (18 items): Critical applications (1password, Brave, Discord, git, VS Code, VLC, WinRAR, etc.)
  - **Optional Packages** (56+ items): Nice-to-have applications (Discord, Telegram, Signal, Steam, Postman, etc.)
  - **GPU Drivers**: NVIDIA packages (if detected) - nvidia-app, nvidia-physx
- User prompts to skip optional package groups
- Success/failure tracking with detailed summary

**Key Functions:**
- `Install-PackageGroup` - Handles categorized installation with user prompts

**Requirements:**
- Administrator privileges
- Windows 10/11
- Internet connection

**Execution:**
```powershell
powershell.exe -ExecutionPolicy Bypass -File ".\win\windows_install.ps1"
```

**Output:**
- Installation summary with success/failure counts
- List of failed packages (if any)
- Prompts user to restart computer

**Notes:**
- Privacy tweaks have been consolidated into separate `privacy_tweaks.ps1` script
- This script focuses solely on package installation
- Temporary files are cleaned up automatically

---

## Section 2: privacy_tweaks.ps1

**Purpose:** Comprehensive privacy and telemetry configuration extracted from privacy.sexy framework.

**Features:**
- 40+ registry modifications for privacy settings
- Service management (disables DiagTrack, dmwappushservice, WerSvc)
- Removes telemetry and tracking:
  - Windows diagnostic data and feedback
  - Cortana and Bing search tracking
  - Activity history and app launch tracking
  - Advertising ID and personalized ads
  - Cloud-based speech recognition
  - Inking and typing personalization
- System cleanup:
  - Removes controversial `defaultuser0` account
  - Clears SRUM (System Resource Usage Monitor) database
- User experience settings:
  - Disables app suggestions and Start menu suggestions
  - Disables connected experiences
  - Disables clipboard history
  - Disables settings synchronization

**Key Functions:**
- `Set-RegistryValue` - Helper function for safe registry modifications

**Requirements:**
- Administrator privileges
- Windows 10/11

**Execution:**
```powershell
powershell.exe -ExecutionPolicy Bypass -File ".\win\privacy_tweaks.ps1"
```

**Output:**
- Applied tweaks count with success/failure tracking
- Prompts user to restart computer for full effect

**Registry Changes:**
- **HKCU & HKLM** - Various privacy policy and data collection settings
- **Services** - DiagTrack, dmwappushservice, WerSvc (disabled)
- **Content Delivery Manager** - App suggestions disabled
- **Windows Search** - Cortana disabled

**Warnings:**
- Some users may prefer Windows telemetry for troubleshooting
- Application of this script is optional and should match user privacy preferences
- Changes persist until manually reversed

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

## Consolidation Notes

### Privacy Tweaks Consolidation

All privacy and telemetry settings have been consolidated into `privacy_tweaks.ps1` to:
- **Avoid duplication** - Single source of truth for privacy settings
- **Improve maintainability** - Changes only need to be made in one place
- **Better organization** - Clear separation: packages vs. privacy vs. development
- **User choice** - Users can apply privacy settings independently of package installation

**Removed from windows_install.ps1:**
- Telemetry disabling (AllowTelemetry registry keys)
- Activity History disabling
- Cortana/Bing Search disabling
- Location tracking disabling
- App suggestions disabling
- Error Reporting service management
- Ad ID disabling
- Service management (DiagTrack, dmwappushservice, WerSvc)

**Now available in privacy_tweaks.ps1:**
- All above privacy settings
- Additional privacy configurations (clipboard history, settings sync, etc.)
- Comprehensive privacy framework from privacy.sexy

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

- [Chocolatey Package Manager](https://chocolatey.org)
- [privacy.sexy](https://privacy.sexy) - Privacy framework source
- [VS Code Extensions](https://marketplace.visualstudio.com)
- [WSL2 Documentation](https://docs.microsoft.com/windows/wsl)

