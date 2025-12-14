# PC Setup Scripts Specification

**Author**: [@mrfixit027](https://github.com/mrfixit027)

This document describes the purpose, functionality, and relationships between all setup scripts in this repository.

## Overview

The PC Setup project provides modular, automated setup scripts for Windows and macOS. Each script has a specific purpose to ensure separation of concerns and allow users to pick and choose which setup components to apply.

### macOS Execution Order (Recommended)

1. **install.sh** (Interactive Menu) - Choose which scripts to run
   - **Option 1**: brew_install.sh - Install 40+ applications (required)
   - **Option 2**: mac_install.sh - Performance & UI optimization (recommended)
   - **Option 3**: vscode.sh - Install 68+ VS Code extensions (optional)
   - **Option 4**: privacy.sh - Advanced privacy hardening (optional)
   - **Option 5**: All of the above (best for fresh Mac)

### Windows Execution Order (Recommended)

1. **windows_install.ps1** - Install essential packages (required)
2. **vscode_extensions.ps1** - Install VS Code extensions (optional)

---

## Section 1: macOS Scripts

**Author**: [@mrfixit027](https://github.com/mrfixit027)

### 1.1 install.sh (Interactive Installer)

**Purpose:** Main entry point for macOS setup with interactive menu to select which scripts to run.

**Location**: `/mac/install.sh`

**Features:**
- Beautiful colored menu interface with emoji status indicators
- 5 installation options: Applications, System Optimization, VS Code, Privacy, or All
- Downloads scripts dynamically from GitHub (no pre-cloning required)
- Proper sudo elevation for privacy.sh
- Progress tracking with colored output (✓ ✗ ⚠)
- Comprehensive error handling
- Clean temporary file management

**Menu Options:**
```
1️⃣  Install Applications (brew_install.sh) - 40+ apps via Homebrew
2️⃣  Optimize System (mac_install.sh) - Performance, battery, UI tweaks  
3️⃣  Install VS Code Extensions (vscode.sh) - 68+ extensions
4️⃣  Privacy Hardening (privacy.sh) - Advanced privacy settings
5️⃣  Install ALL - Run all scripts in sequence
```

**Execution:**
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/install.sh)
```

**Requirements:**
- macOS 10.15 or later
- Internet connection
- curl (pre-installed on macOS)

**Output:**
- Colored menu with clear option descriptions
- Progress messages as each script runs
- Summary of completed installations
- Error messages with suggestions if issues occur

---

### 1.2 brew_install.sh (Application Installation)

**Purpose:** Install applications and development tools via Homebrew package manager.

**Location**: `/mac/brew_install.sh`

**Features:**
- **Automatic Homebrew installation** if not present (includes Apple Silicon PATH setup)
- **Priority app installation** - 1Password and Arc installed first for immediate access
- **Smart ordering** - Faster/smaller apps first, heavy apps (Docker, Figma) last
- **40+ applications** organized by category:
  - **Essentials**: 1Password (password manager), Arc (browser), VS Code (IDE)
  - **Browsers**: Google Chrome, Brave, Arc Browser
  - **Development**: Git, GitHub Desktop, Postman, Warp terminal, Docker, AWS CLI, AWS Nuke
  - **Communication**: Slack, Microsoft Teams, Discord, Signal, WhatsApp, Zoom, Telegram
  - **Utilities**: Rectangle (window management), Raycast (productivity), BetterMouse, Finder enhancements
  - **Productivity**: ChatGPT, Claude, Evernote, Obsidian, Microsoft Office
  - **Media**: VLC, Ferdium
  - **Enterprise**: Amazon Chime, Amazon Workspaces, Google Drive, Microsoft Remote Desktop
  - **Cloud/VPN**: NordVPN, ProtonVPN, OneDrive
  - **Development Tools**: Fig, DevToys
  - **Heavy Apps**: Docker Desktop, Figma (installed last)

- **CLI Tools** (20+ formulae): 
  - Core: git, awscli, aws-nuke
  - Text processing: bat (cat with syntax), ripgrep, fd
  - Navigation: fzf (fuzzy finder), zoxide (smart cd)
  - System monitoring: btop (better top)
  - Shells: go, node, ollama, python
  - File utilities: eza (ls replacement), exa

- **Fonts**: Fira Code, Fira Code Nerd Font, Hack Nerd Font

- **Shell Configuration**:
  - Oh My Zsh installation and configuration
  - Powerlevel10k theme (beautiful, fast prompt)
  - zsh-syntax-highlighting plugin
  - zsh-autosuggestions plugin
  - Custom aliases (eza for ls, bat for cat, fzf_cd for smart navigation)

- **Service Management**:
  - Disables auto-start for Docker Desktop
  - Disables auto-start for Ollama
  - Disables auto-start for VPN services (NordVPN, ProtonVPN)
  - Keeps user-facing apps available while removing background resource drain

- **Idempotent Design** - Safe to run multiple times
  - Checks if packages already installed before installing
  - Doesn't remove existing packages
  - Updates Homebrew quietly if needed

- **Error Handling** - Exits cleanly on failures
  - Uses `set -e` and `set -u` for strict error handling
  - Colored output (RED for errors, GREEN for success)
  - Shows installation progress

**Requirements:**
- macOS 10.15 or later
- Internet connection
- Xcode Command Line Tools (auto-prompted during Homebrew install)
- ~5-10 minutes depending on internet speed

**Execution Options:**

Via interactive installer:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/install.sh)
# Select option 1
```

Direct installation:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/brew_install.sh)
```

Manual from cloned repo:
```bash
git clone https://github.com/peeweeh/pc-setup.git
cd pc-setup/mac
chmod +x brew_install.sh
./brew_install.sh
```

**Output:**
- Color-coded status messages:
  - ✓ (GREEN) - Installation successful
  - ✗ (RED) - Installation failed
  - ⚠ (YELLOW) - Already installed, skipping
- Shows progress for each package
- Final summary with completion time
- Next step suggestion (run mac_install.sh for optimization)

---

### 1.3 mac_install.sh (System Optimization)

**Purpose:** Comprehensive macOS customization for performance, battery life, and UI speed.

**Location**: `/mac/mac_install.sh`

**Features:**

#### Performance & Battery Optimization
- **Disables Photos AI analysis** - Prevents facial recognition, object detection (major battery saver)
- **Disables Media AI** - Stops video scene detection and indexing
- **Disables Game Center** - Removes unused gaming service
- **Fixes macOS Sonoma lag** - Addresses 26-second heuristic lag bug
- **Optimizes Electron apps** - Disables unnecessary GPU usage in Chrome, Slack, VS Code
- **Disables crash reporter** - Removes intrusive dialogs
- **Memory optimization** - Clears inactive memory cache

#### UI Speed Improvements
- **Instant window resizing** - NSWindowResizeTime = 0.001
- **Instant Dock appearance** - No hover delay when showing hidden Dock
- **No Finder animations** - Instant folder opening
- **Faster Mission Control** - Speeds up Exposé animations
- **No Launchpad animations** - Instant app grid display
- **Instant Dock launch animations** - Apps appear immediately when clicked
- **Removes all visual delays** - Smooth becomes instantaneous

#### Dock Customization
- **Auto-hide enabled** - Saves vertical screen space
- **Removes default apps** - Clean slate with only your installed apps
- **Resizes to 50%** - Compact icon size for more visibility
- **Hides recent applications** - Cleaner Dock appearance
- **Disables Dashboard** - Removes unused feature

#### Finder Configuration
- **Shows all file extensions** - Reveals complete filenames (.txt, .py, etc)
- **Shows hidden files** - Makes . and .. files visible (system files, dotfiles)
- **Shows path bar** - Displays full file path at bottom of Finder
- **Shows status bar** - Displays file/folder count and used space
- **Keeps folders on top** - Folders always appear before files when sorting
- **Column view by default** - Better for navigation than Icon view
- **Prevents .DS_Store on network/USB** - Stops macOS littering external drives
- **Smart search scope** - Search starts in current folder, not entire computer
- **Spring loading enabled** - Drag files into folders without holding button
- **Fast tracking speed** - 1/10 second sensitivity for trackpad

#### System Preferences & Security
- **Fast keyboard repeat rate** - KeyRepeat = 1 (much faster than default 2)
- **Tap to click enabled** - Click with trackpad tap, not physical button press
- **Three-finger drag** - Drag windows and items with three-finger swipe
- **Disables auto-correct** - Prevents embarrassing text replacements
- **Disables smart quotes/dashes** - Keeps straight quotes for code
- **Expands save/print panels** - Shows full options by default
- **Screenshots to ~/Documents/Screenshots** - Organized screenshot folder
- **Battery percentage in menu bar** - Know your battery status at a glance
- **Automatic software updates** - Keeps system patched and secure
- **Trackpad sensitivity at maximum** - Best trackpad experience
- **Key repeat speed at maximum** - Fast text entry

#### Shell & Terminal Setup
- **Oh My Zsh installation** - Community-driven Zsh framework (if not already installed)
- **zsh-syntax-highlighting** - Highlights valid commands in green, errors in red
- **zsh-autosuggestions** - Shows command suggestions from history
- **Nord Terminal theme** - Beautiful, easy-on-eyes color scheme
- **Proper PATH setup** - Ensures correct shell command resolution

**Requirements:**
- macOS 10.15 or later
- Administrator privileges (sudo) for system changes
- Logout/restart may be required for full effect
- ~2-3 minutes runtime

**Execution Options:**

Via interactive installer:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/install.sh)
# Select option 2
```

Direct installation:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/mac_install.sh)
```

**Output:**
- Section headers (Performance, UI Speed, Dock, Finder, etc)
- Color-coded completion messages
- Summary of all changes made
- Recommendation to restart computer

**Related:**
- For comprehensive Siri disabling and privacy hardening, run privacy.sh
- For extensive system tweaking beyond this script, use privacy.sh

---

### 1.4 vscode.sh (VS Code Extension Installation)

**Purpose:** Install 68+ VS Code extensions organized by category and functionality.

**Location**: `/mac/vscode.sh`

**Features:**
- **68+ professionally selected extensions** organized by category
- **Automatic VS Code CLI detection** - Finds code command in PATH
- **Skip detection for existing extensions** - Doesn't reinstall already-installed extensions
- **Installation statistics** - Shows total, installed, skipped, and failed counts
- **Generates backup script** - Creates InstallVsCodeExtensions.sh for re-running

**Extension Categories:**

**AI & Productivity (5 extensions)**
- GitHub Copilot - AI code completion
- GitHub Copilot Chat - Conversational AI
- Amazon Q - AWS AI assistant  
- Continue - Codebase AI assistant
- Claude (Anthropic) - Claude AI integration

**Themes & Visual (6 extensions)**
- Nord - Beautiful, arctic blue color scheme
- Shades of Purple - Purple theme for aesthetic
- Tokyo Night - Clean dark theme
- Material Theme - Modern Material Design
- vscode-icons - Beautiful file/folder icons
- One Dark - One Dark color scheme

**AWS & Cloud (5 extensions)**
- AWS Toolkit - AWS service integration
- Terraform - Infrastructure as code support
- CloudFormation - AWS CloudFormation support
- CloudFormation Linter - CloudFormation validation
- AWS Lambda - Lambda function management

**Code Quality & Linting (6 extensions)**
- CodeSnap - Beautiful code screenshots
- Turbo Console Log - Enhanced console.log
- ESLint - JavaScript linting
- Markdown Lint - Markdown validation
- Prettier - Code formatter
- Code Spell Checker - Spelling checker

**Git & Version Control (3 extensions)**
- GitLens - Git superpower for VS Code
- Git History - Browse git history
- Atlassian - Jira & Bitbucket integration

**Python Development (7 extensions)**
- Autopep8 - Python formatter
- Debugpy - Python debugger
- isort - Python import sorter
- Pylance - Python language server
- Python - Official Python extension
- Python Envs - Python environment manager
- Jupyter - Jupyter notebook support

**JavaScript & React (7 extensions)**
- Tailwind CSS - Utility-first CSS framework
- JavaScript (ES6) snippets - Code snippets
- React snippets - React component snippets
- npm Intellisense - npm package autocomplete
- ES7 React/Redux - Modern React snippets
- Thunder Client - API testing tool
- REST Client - REST API testing

**Go Development (1 extension)**
- Go - Official Go language support

**GraphQL (3 extensions)**
- GraphQL - GraphQL syntax highlighting
- GraphQL Execution - GraphQL execution in editor
- DGraph snippets - DGraph query snippets

**Docker & DevOps (8 extensions)**
- Docker - Docker container support
- Kubernetes - Kubernetes cluster management
- Remote - Remote SSH/WSL/Container support
- Dev Containers - Development container support
- GitHub Actions - GitHub Actions workflow editor
- Tilt - Local Kubernetes development
- Container Tools - Enhanced container features
- Remote Repositories - Clone and work on remote repos

**Jupyter & Data Science (3 extensions)**
- Jupyter - Jupyter notebook support
- Jupyter Keymap - Familiar Jupyter shortcuts
- Jupyter Renderers - Enhanced Jupyter output rendering

**Markdown & Documentation (3 extensions)**
- Preview GitHub Style - GitHub markdown preview
- Markdown All in One - Complete markdown toolkit
- Markdown Lint - Markdown validation

**Utilities & Tools (8 extensions)**
- Edge DevTools - Microsoft Edge DevTools
- PowerShell - PowerShell language support
- Live Share - Real-time collaboration
- YAML - YAML syntax highlighting
- Pretty JSON - JSON formatting and validation
- XML - XML language support
- Excel Viewer - Excel file viewing
- CSV - CSV file viewing

**Gaming & Modding (5 extensions)**
- Paradox Crusader Kings 2 - CK2 modding
- Paradox Crusader Kings 3 - CK3 modding
- Paradox Anno 1800 - Anno 1800 modding
- Modding support - General game modding tools
- Game development - Game engine integration

**Requirements:**
- VS Code installed
- VS Code CLI available in PATH
  - To install: Open VS Code → Cmd+Shift+P → "Shell Command: Install 'code' command in PATH"
- Internet connection
- ~5-10 minutes depending on internet speed

**Execution Options:**

Via interactive installer:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/install.sh)
# Select option 3
```

Direct installation:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/vscode.sh)
```

Manual from cloned repo:
```bash
git clone https://github.com/peeweeh/pc-setup.git
cd pc-setup/mac
chmod +x vscode.sh
./vscode.sh
```

**Output:**
- Progress messages for each extension
- Color-coded status:
  - ✓ Installed
  - ⏩ Skipped (already present)
  - ✗ Failed
- Summary statistics:
  - Total extensions
  - Successfully installed
  - Already installed
  - Failed installations
- Backup script location (InstallVsCodeExtensions.sh)
- Total installation time

---

### 1.5 privacy.sh (Privacy & Security Hardening)

**Purpose:** Comprehensive privacy and security hardening for macOS (831 lines).

**Location**: `/mac/privacy.sh`

**⚠️ WARNING:** This is an advanced script with extensive system changes. Review specific sections before running if you have concerns.

**Author/Source**: Generated from [privacy.sexy](https://privacy.sexy) framework

**Features:**

#### Privacy & Telemetry (Comprehensive Siri Disabling)
- **Removes Siri from menu bar** - Frees menu bar space
- **Disables Siri data collection** - Stops audio/interaction logging
- **Disables Siri suggestions** - Removes assistant popup suggestions
- **Disables Siri analytics** - Prevents Siri tracking
- **Clears Siri cache** - Removes cached voice data

#### Telemetry Disabling
- **Firefox telemetry** - Stops Mozilla data collection
- **Microsoft Office telemetry** - Disables Office analytics
- **Homebrew analytics** - Prevents package manager tracking
- **.NET Core telemetry** - Disables .NET development telemetry
- **PowerShell telemetry** - Stops PowerShell usage tracking

#### System Cleaning & Cache Clearing
- **CUPS printer cache** - Removes print job history
- **Empty trash** - Securely removes trash files
- **System caches** - Clears /Library/Caches and ~/Library/Caches
- **Xcode derived data** - Removes compilation artifacts
- **Xcode archives** - Deletes old build archives
- **DNS cache flush** - Clears DNS resolver cache
- **Inactive memory purge** - Optimizes RAM usage

#### Security Hardening
- **Application Firewall** - Enables macOS firewall
- **Guest user removal** - Deletes guest account
- **Apple Remote Desktop disable** - Removes remote access
- **Remote management disable** - Prevents remote control
- **Automatic iCloud Document Storage** - Disables default sync

#### Privacy Features
- **Location services restrictions** - Limits location access
- **Bluetooth privacy** - Restricts BLE advertising
- **Camera/microphone access** - Limits app permissions
- **Accessibility permissions** - Stricter privacy controls

**Requirements:**
- macOS 10.15 or later
- Administrator privileges (script uses sudo)
- Some features may require SIP disabled (System Integrity Protection)
- ~5-10 minutes runtime
- System restart recommended after completion

**Execution Options:**

Via interactive installer (handles sudo automatically):
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/install.sh)
# Select option 4
```

Direct installation:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/privacy.sh)
```

Manual from cloned repo:
```bash
git clone https://github.com/peeweeh/pc-setup.git
cd pc-setup/mac
chmod +x privacy.sh
./privacy.sh
```

**Output:**
- Progress messages for each operation
- Section headers (Siri, Telemetry, Security, etc)
- Warnings if SIP needs to be disabled
- Summary of changes applied
- Restart recommendation

**Notes:**
- This script is separate from mac_install.sh to avoid redundancy
- mac_install.sh handles essential performance tweaks
- privacy.sh provides comprehensive privacy hardening
- Run both for complete system optimization

---

## Section 2: Windows Scripts

### 2.1 windows_install.ps1

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

### 2.2 vscode_extensions.ps1

**Purpose:** Install VS Code extensions on Windows.

**Execution:**
```powershell
powershell.exe -ExecutionPolicy Bypass -File ".\win\vscode_extensions.ps1"
```

---

## Repository Structure

```
pc-setup/
├── README.md                    # Project overview and quick start
├── spec.md                      # This file - detailed specifications
├── DEVELOPMENT.md               # Development guidelines
├── CONTRIBUTING.md              # Contribution guidelines
├── LICENSE                      # MIT License
├── mac/                         # macOS setup scripts
│   ├── install.sh              # Interactive installer (main entry point)
│   ├── spec.md                 # macOS-specific documentation
│   ├── brew_install.sh         # Homebrew application installation
│   ├── mac_install.sh          # Performance & UI optimization
│   ├── vscode.sh               # VS Code extensions
│   └── privacy.sh              # Advanced privacy hardening
└── win/                        # Windows setup scripts
    ├── windows_install.ps1     # Main Windows setup
    └── vscode_extensions.ps1   # VS Code extensions
```

---

## Troubleshooting

### macOS Issues

#### Script Not Running
```bash
# Make script executable
chmod +x install.sh

# Run with explicit bash
bash ./install.sh
```

#### Homebrew Not Found After Installation
```bash
# Add Homebrew to PATH (Apple Silicon)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
source ~/.zprofile

# Intel Macs
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
source ~/.zprofile
```

#### Permission Denied Errors
```bash
# Run with sudo (for mac_install.sh and privacy.sh)
sudo bash ./mac_install.sh
sudo bash ./privacy.sh
```

#### VS Code Extension Installation Fails
```bash
# Ensure VS Code CLI is installed
code --version

# If not found, open VS Code and run:
# Cmd+Shift+P → "Shell Command: Install 'code' command in PATH"
```

### Windows Issues

#### Execution Policy Issues
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force
```

#### Admin Privileges Required
- Right-click PowerShell → "Run as Administrator"
- Or use Windows Terminal with elevated privileges

---

## Related Links

- [Homebrew Package Manager](https://brew.sh)
- [VS Code](https://code.visualstudio.com)
- [privacy.sexy](https://privacy.sexy) - Privacy framework source
- [GitHub Repository](https://github.com/peeweeh/pc-setup)
- [Issues & Discussions](https://github.com/peeweeh/pc-setup/issues)

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

