# PC Setup Scripts Specification

This document describes the purpose, functionality, and relationships between all setup scripts in this repository.

## Overview

The PC Setup project provides modular, automated setup scripts for Windows and macOS. Each script has a specific purpose to ensure separation of concerns and allow users to pick and choose which setup components to apply.

### Windows Execution Order (Recommended)

1. **windows_install.ps1** - Install essential packages (required)
2. **privacy_tweaks.ps1** - Apply privacy and telemetry settings (optional)
3. **vscode_extensions.ps1** - Install VS Code extensions (optional)
4. **dev_setup.ps1** - Configure development environment (optional)

### macOS Execution Order (Recommended)

1. **brew_install.sh** - Install applications via Homebrew (required)
2. **mac_install.sh** - Performance & UI optimizations (recommended)
3. **vscode.sh** - Install VS Code extensions (optional)
4. **privacy.sh** - Advanced privacy hardening (optional)

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
- 60+ registry modifications for privacy and security
- Service management (disables DiagTrack, dmwappushservice, WerSvc)
- Removes telemetry and tracking:
  - Windows diagnostic data and feedback
  - Cortana and Bing search tracking
  - Activity history and app launch tracking
  - Advertising ID and personalized ads
  - Cloud-based speech recognition
  - Inking and typing personalization
  - Typing feedback and input personalization
  - .NET Core and PowerShell telemetry
- System cleanup:
  - Removes controversial `defaultuser0` account
  - Removes default app associations
  - Clears SRUM (System Resource Usage Monitor) database
- User experience settings:
  - Disables app suggestions and Start menu suggestions
  - Disables connected experiences
  - Disables clipboard history
  - Disables settings synchronization
  - Disables lock screen camera and app notifications
- Security hardening:
  - Disables PowerShell 2.0 (downgrade protection)
  - Enables SEHOP (Structured Exception Handling Protection)
  - Disables Windows Installer elevated privileges
  - Disables LAN Manager password hash storage
  - Disables Windows DRM internet access
  - Disables device sensors
- Device management:
  - Disables AutoPlay and AutoRun
  - Disables Windows Connect Now wizard
  - Disables automatic map downloads
  - Blocks 30+ malicious telemetry domains in hosts file

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
- **Maps** - AutoDownloadAndUpdateMapData disabled
- **GameDVR** - AllowGameDVR disabled
- **WMDRM** - DisableOnline (DRM internet access)
- **TIPC** - Typing feedback disabled
- **Sensors** - Device sensors disabled
- **Explorer** - NoDriveTypeAutoRun, NoAutorun, NoAutoplayfornonVolume
- **Security** - SEHOP enabled, PowerShell 2.0 disabled, LAN hashes disabled
- **Hosts File** - 30+ telemetry domains blocked

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

---

## Section 5: macOS Scripts

### 5.1 brew_install.sh

**Purpose:** Install applications and development tools via Homebrew package manager.

**Features:**
- Auto-installs Homebrew if not present (including Apple Silicon PATH setup)
- Priority app installation (1Password, Arc) for immediate access
- 40+ essential applications organized by category:
  - **Priority**: 1Password, Arc
  - **Utilities**: Alfred, Clipy, Moom, Rectangle, Raycast, BetterMouse
  - **Browsers**: Chrome, Brave
  - **Communication**: Slack, Teams, Discord, Signal, WhatsApp
  - **Development**: GitHub, Postman, Sourcetree, VSCode, Warp, Docker Desktop
  - **Productivity**: ChatGPT, Claude, Evernote, Obsidian
  - **Enterprise**: Microsoft Office, Teams, Amazon Chime/Workspaces
  - **Cloud/VPN**: NordVPN, ProtonVPN, Google Drive, OneDrive
  - **Heavy Apps**: Docker Desktop, Figma, Steam (installed last)
- CLI tools (20+ formulae): git, aws-nuke, awscli, bat, btop, docker, eza, fzf, go, node, ollama, etc.
- Fonts: Fira Code, Fira Code Nerd Font, Hack Nerd Font
- Shell configuration (Oh My Zsh, Powerlevel10k, zsh plugins)
- Disables auto-start for heavy services (Docker, Ollama, VPNs)
- Idempotent - safe to run multiple times
- Colored output with progress tracking

**Key Functions:**
- Homebrew installation check and setup
- Package existence verification before installation
- Service auto-start management
- Shell configuration with aliases (eza, bat, fzf_cd)

**Requirements:**
- macOS 10.15 or later
- Internet connection
- Xcode Command Line Tools (auto-prompted during Homebrew install)

**Execution:**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/brew_install.sh)"
```

**Output:**
- Colored status messages (✓ success, ⚠ warning, ✗ error)
- Installation progress for each package
- Final cleanup message

---

### 5.2 mac_install.sh

**Purpose:** System optimization for performance, battery life, and UI speed.

**Features:**

#### Performance & Battery Optimization
- Disables Photos AI analysis (facial recognition, huge battery saver)
- Disables Media AI analysis (video indexing/scene detection)
- Disables Game Center daemon
- Fixes macOS 26 heuristic lag bug
- Optimizes Electron app GPU usage (Chrome/Slack/VSCode)
- Disables Spotlight disk indexing (saves I/O, breaks search)
- Disables crash reporter dialogs
- Clears inactive memory cache

#### UI Speed Optimizations
- Instant window resizing (NSWindowResizeTime = 0.001)
- Instant Dock appearance (no hover delay)
- Disables all Finder animations
- Speeds up Mission Control animations
- Disables Launchpad page animations
- Disables Dock launch animations

#### Dock Configuration
- Auto-hide enabled
- Removes all default apps
- Resizes to 50%
- Hides recent applications
- Disables Dashboard

#### Finder Configuration
- Shows all file extensions
- Shows hidden files
- Shows path bar and status bar
- Keeps folders on top when sorting
- Sets default view to column view
- Prevents .DS_Store on network/USB
- Search scope set to current folder
- Spring loading enabled with no delay

#### System Preferences
- Fast keyboard repeat rate (KeyRepeat = 1)
- Tap to click enabled
- Three-finger drag enabled
- Disables auto-correct, smart quotes, smart dashes
- Expands save/print panels by default
- Screenshots saved to ~/Documents/Screenshots
- Battery percentage shown in menu bar
- Automatic software updates enabled

#### Shell Setup
- Installs Oh My Zsh (if not present)
- Installs zsh-syntax-highlighting plugin
- Installs zsh-autosuggestions plugin
- Nord Terminal theme installation

**Requirements:**
- macOS 10.15 or later
- Administrator privileges for some operations (sudo)

**Execution:**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/mac_install.sh)"
```

**Output:**
- Section headers for each configuration area
- Colored progress messages
- Revert instructions for major changes
- Restart recommendation

**Notes:**
- For comprehensive Siri/privacy settings, run privacy.sh separately
- Some changes require restart to take full effect
- Spotlight disabling breaks file search (revert: sudo mdutil -i on -a)

---

### 5.3 vscode.sh

**Purpose:** Install 68+ VS Code extensions organized by category.

**Features:**
- Automatic VS Code CLI availability check
- Skip detection for already installed extensions
- Installation statistics (installed/skipped/failed)
- Generates backup installation script
- Categories:
  - **AI Assistants**: GitHub Copilot, Copilot Chat, Amazon Q, Claude Dev
  - **Themes**: Nord, Shades of Purple, Tokyo Night, Material Theme
  - **Icons**: vscode-icons
  - **AWS/Cloud**: AWS Toolkit, Terraform, CloudFormation, CFN Lint
  - **Code Quality**: CodeSnap, Turbo Console Log, ESLint, Markdown Lint
  - **Git**: GitLens, Git History, Atlassian
  - **Python**: Autopep8, Debugpy, isort, Pylance, Python Envs
  - **JavaScript/React**: Tailwind CSS, React snippets, ES7 snippets
  - **Go**: Go extension
  - **GraphQL**: GraphQL syntax, execution, DGraph snippets
  - **Containers/DevOps**: Docker, Kubernetes, Remote Containers, WSL, GitHub Actions, Tilt
  - **Jupyter**: Jupyter, Jupyter Keymap, Jupyter Renderers
  - **Markdown**: Preview GitHub Styles, Markdown All in One
  - **Utilities**: Edge DevTools, PowerShell, Live Share, YAML, Pretty JSON, XML
  - **Gaming/Modding**: Paradox tools (CK2, CK3, Anno)

**Requirements:**
- VS Code installed
- VS Code CLI in PATH (Command: "Shell Command: Install 'code' command in PATH")
- Internet connection

**Execution:**
```bash
/Users/paul/dev/pc-setup/mac/vscode.sh
```

**Output:**
- Colored status for each extension
- Installation summary with counts
- Generated backup script: InstallVsCodeExtensions.sh

---

### 5.4 privacy.sh

**Purpose:** Comprehensive privacy and security hardening (831 lines).

**⚠️ WARNING:** Advanced script with extensive system changes. Review before running!

**Features:**

#### Privacy & Telemetry
- Comprehensive Siri disabling (user, gui, system levels)
- Disables Siri data collection and analytics
- Removes Siri from menu bar and status menu
- Disables telemetry for:
  - Firefox
  - Microsoft Office
  - Homebrew
  - .NET Core CLI
  - PowerShell Core

#### System Cleaning
- Clears CUPS printer job cache
- Empties trash on all volumes
- Clears system caches (/Library/Caches, ~/Library/Caches)
- Clears Xcode derived data and archives
- Flushes DNS cache
- Purges inactive memory

#### Security Hardening
- Enables application firewall
- Removes guest user account
- Disables Apple Remote Desktop
- Disables automatic iCloud Drive document storage
- Configures stricter security settings

#### Remote Access
- Disables remote management services
- Removes remote desktop preferences
- Clears remote desktop support files

**Requirements:**
- macOS 10.15 or later
- Administrator privileges (runs with sudo elevation)
- Some features require SIP disabled (System Integrity Protection)

**Execution:**
```bash
sudo /Users/paul/dev/pc-setup/mac/privacy.sh
```

**Output:**
- Progress messages for each operation
- Warning if SIP needs to be disabled

**Notes:**
- Generated from privacy.sexy framework
- mac_install.sh includes essential performance optimizations
- Use privacy.sh for comprehensive privacy hardening beyond performance

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
│   ├── README.md         # macOS scripts documentation
│   ├── install.sh        # Interactive installer for macOS
│   ├── brew_install.sh   # Homebrew application installation
│   ├── mac_install.sh    # Performance & UI optimization
│   ├── vscode.sh         # VS Code extensions
│   └── privacy.sh        # Advanced privacy hardening
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

