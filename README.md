# PC Setup Scripts

Automated setup scripts for Windows and macOS to quickly configure a new development environment with essential applications, tools, and system tweaks.

## 📋 Table of Contents

- [Features](#features)
- [Windows Setup](#windows-setup)
- [macOS Setup](#macos-setup)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [What Gets Installed](#what-gets-installed)
- [Customization](#customization)
- [License](#license)

## ✨ Features

### Windows
- **Interactive Installer** - Menu-driven setup with 5 options (Apps, Dev Setup, VS Code, Privacy, All)
- **Automated Package Installation** via Chocolatey (74+ packages)
- **GPU Detection & Drivers** - Automatically detects and installs NVIDIA/AMD drivers
- **Development Environment Setup** - WSL2, Docker, Node.js, Python, AWS CLI, Git
- **Privacy & Performance Tweaks** - Comprehensive telemetry disabling (471 lines)
- **Disables Cortana, GameDVR, Telemetry** - Reclaims system resources
- **Oh My Posh Configuration** - Beautiful PowerShell prompt with Nerd Fonts
- **PowerShell Enhancement** - PSReadLine and Terminal-Icons modules
- **System Restore Point** - Created before applying tweaks for safety

### macOS
- **Interactive Installer** - Menu-driven setup with 5 options (Apps, Optimize, VS Code, Privacy, All)
- **Homebrew Package Installation** - 40+ essential applications and 20+ CLI tools
- **System Optimization** - Performance, battery, and UI speed improvements
- **Disables Siri, Photos AI, Media AI** - Significant battery savings
- **Privacy Hardening** - Comprehensive 831-line privacy configuration
- **Shell Enhancement** - Powerlevel10k for Zsh, plugins, aliases
- **Dock & Finder Customization** - Auto-hide, speed improvements, clean layout
- **Terminal Theme** - Nord color scheme for beautiful terminal

## 🪟 Windows Setup

**Author**: [@mrfixit027](https://github.com/mrfixit027)

### 🚀 Interactive Installer (Recommended)

**Run this command in PowerShell as Administrator**:

```powershell
powershell -ExecutionPolicy Bypass -Command "iwr -useb https://raw.githubusercontent.com/peeweeh/pc-setup/master/win/install.ps1 | iex"
```

Or run locally:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
& ".\win\install.ps1"
```

The installer presents a colored menu where you can choose which components to install:

```
========================================
     PC Setup - Master Installer
========================================
Choose an option:

1) 📦 Install Applications (windows_install.ps1)
2) 🔧 Development Setup (dev_setup.ps1)
3) 🎨 Install VS Code Extensions (vscode_extensions.ps1)
4) 🔒 Privacy Tweaks (privacy_tweaks.ps1)
5) 🚀 Install ALL (recommended for fresh Windows)

q) ❌ Quit
```

**Choose from:**
- **Option 1** - Install 74+ applications via Chocolatey
- **Option 2** - Setup development environment (WSL2, Docker, Node, Python, AWS)
- **Option 3** - Install 50+ VS Code extensions
- **Option 4** - Privacy hardening (telemetry, Cortana, feedback)
- **Option 5** - Run all scripts in sequence (best for fresh Windows)

### Scripts Overview

#### `install.ps1` (Interactive Menu)
Master installer with menu-driven setup orchestration:
- Beautiful colored menu interface with emoji status
- Select individual scripts or run all
- Proper error handling and progress tracking
- Automatically handles PowerShell execution policy
- Downloads scripts from GitHub on-the-fly (no manual cloning required)

#### `windows_install.ps1` (74+ Applications)
Comprehensive Windows setup script with:
- **Automatic Chocolatey installation** if not present
- **GPU detection** - Detects NVIDIA/AMD and installs appropriate drivers
  - NVIDIA: Installs nvidia-app and nvidia-physx
  - AMD: Prompts user to download drivers manually
- **System restore point** created before applying tweaks
- **74+ applications** organized by category:
  - **Productivity**: 1Password, PowerToys, 7-Zip, WinRAR, Sysinternals, Everything, TreeSizeFree
  - **Browsers**: Chrome, Edge, Brave, Arc
  - **Development**: Git, VS Code, Node.js, Python, Postman, DevToys, Neovim
  - **CLI Tools**: fzf, bat, ripgrep, fd, jq, git-delta, zoxide, curl, ffmpeg
  - **Communication**: Slack, Teams, Discord, Signal, Telegram, WhatsApp, Beeper, Amazon Chime
  - **Media**: VLC, Plex Media Player
  - **Gaming**: Steam, Epic Games, EA App, GOG Galaxy, Ubisoft Connect
  - **Cloud Storage**: Google Drive, iCloud, Proton Drive
  - **System Monitoring**: HWiNFO, MSI Afterburner, RivaTuner
  - **Security**: Proton VPN, Proton Mail
  - **Graphics**: GPU detection and driver installation
- **Windows Privacy & Performance Tweaks**:
  - Disables telemetry and diagnostic data collection
  - Disables location tracking and Wi-Fi Sense
  - Disables consumer features and app suggestions
  - Disables GameDVR and Xbox features
  - Disables cortana and feedback collection
  - Enables "End Task" right-click on taskbar
  - Runs disk cleanup
  - Disables hibernation (saves SSD space)
  - Disables storage sense optimization
- **Oh My Posh Configuration**:
  - Installs Oh My Posh with atomic theme
  - Installs Nerd Fonts (FiraMono, FiraCode)
  - Creates/backs up PowerShell profile
- **PowerShell Modules**:
  - PSReadLine (enhanced command-line editing)
  - Terminal-Icons (file/folder icons in directory listings)

**Runtime**: 20-60 minutes depending on internet speed

#### `dev_setup.ps1` (Development Environment)
Development environment setup with:
- **WSL2 (Windows Subsystem for Linux) Installation**
  - Installs WSL with Ubuntu
  - Configures WSL resources and networking
- **Docker Desktop Setup**
  - Installs Docker Desktop via Chocolatey
  - Enables Docker integration with WSL2
- **Development Tools**:
  - Node.js and npm package manager
  - Python with pip and common packages (requests, flask, numpy, pandas)
  - Git configuration (user.name, user.email, core.editor)
- **AWS Configuration**
  - AWS CLI installation and configuration
  - AWS credentials setup with interactive prompts
- **Version Control**:
  - Git configuration
  - GitHub CLI (gh) setup
  - SSH key generation for GitHub
- **Language SDKs**:
  - Go installation and path setup
  - Rust installation (via rustup)
  - Java JDK installation

**Runtime**: 30-45 minutes

#### `privacy_tweaks.ps1` (Advanced Privacy)
Comprehensive Windows privacy hardening (471 lines):
- **Disables telemetry**: Diagnostic data, feedback collection, activity history
- **Removes tracking**: Location services, Wi-Fi Sense, cloud-based speech recognition
- **Disables spyware**: Cortana, Siri integration, consumer features
- **Privacy policies**: Opts out of Windows privacy consent, personalization
- **App diagnostics**: Disables app data collection
- **Input privacy**: Disables text/handwriting data collection
- **Start menu**: Removes app suggestions and tiles
- **Network privacy**: Disables network suggestions
- **General privacy**: Removes default user accounts, minimizes DISM data

**Runtime**: 3-5 minutes

#### `vscode_extensions.ps1` (50+ Extensions)
Installs 50+ professionally-selected VS Code extensions:

**AI & Productivity**:
- GitHub Copilot, Amazon Q, Claude, Continue, DS Code GPT

**Themes & Icons**:
- Nord, Dracula, One Dark Pro, Material Theme, vscode-icons

**AWS & Cloud**:
- AWS Toolkit, Terraform, CloudFormation, Kubernetes

**Code Quality**:
- ESLint, Prettier, CodeSnap, Turbo Console Log, Better Comments

**Git & Version Control**:
- GitLens, Git History, Atlassian

**Languages**:
- Python (Autopep8, isort, Pylance), Go, GraphQL, JavaScript, TypeScript

**DevOps & Infrastructure**:
- Docker, Kubernetes, AWS Toolkit, Terraform, Remote Containers, GitHub Actions

**Data & Analysis**:
- Jupyter, Python, Pandas extensions, REST Client, Thunder Client

**Utilities**:
- Edge DevTools, PowerShell, Live Share, YAML, Markdown, Excel Viewer

**Runtime**: 10-15 minutes

## 🍎 macOS Setup

**Author**: [@mrfixit027](https://github.com/mrfixit027)

### 🚀 Interactive Installer (Recommended)

**Run this command in Terminal** for an interactive menu:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/install.sh)
```

The installer presents a beautiful colored menu where you can choose which components to install:

```
╔═══════════════════════════════════════════════════╗
║   🍎 macOS Setup Script - Choose an Option       ║
╚═══════════════════════════════════════════════════╝

1) 📦 Install Applications (brew_install.sh)
2) ⚙️  Optimize System (mac_install.sh)
3) 🎨 Install VS Code Extensions (vscode.sh)
4) 🔒 Privacy Hardening (privacy.sh)
5) 🚀 Install ALL (recommended for fresh Mac)

q) ❌ Quit
```

**Choose from:**
- **Option 1** - Install 40+ applications via Homebrew
- **Option 2** - Optimize system performance, UI speed, and battery life
- **Option 3** - Install 68+ VS Code extensions
- **Option 4** - Advanced privacy and security hardening
- **Option 5** - Run all scripts in sequence (recommended for fresh Mac)

### Quick Start (Individual Scripts)

**Just install apps:**
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/brew_install.sh)
```

**Just optimize system:**
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/mac_install.sh)
```

**Just install VS Code extensions:**
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/vscode.sh)
```

**Just harden privacy:**
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/privacy.sh)
```

### Scripts Overview

#### `install.sh` (Interactive Menu)
Main entry point for setting up macOS:
- Beautiful colored menu interface with emoji status
- Select individual scripts or run all
- Proper error handling and progress tracking
- Automatically elevates to sudo when needed
- Downloads scripts from GitHub on-the-fly (no manual cloning required)

#### `brew_install.sh` (40+ Applications)
Comprehensive Homebrew installation script with:
- **Automatic Homebrew installation** if not present (handles Apple Silicon & Intel)
- **Priority app installation** - Critical apps (1Password, Arc) installed first
- **Smart ordering** - Smaller/faster apps first, heavy apps last for better user experience
- **Idempotent design** - Safe to run multiple times without duplication
- **Error handling** - Exits cleanly on any installation failure
- **Colored output** with emoji status indicators

**Applications installed:**
- **Essentials**: 1Password, Arc, Google Chrome, Brave, VS Code, Docker
- **Development**: Git, AWS CLI, Postman, Warp, Node.js, Go, Python, Ollama
- **Communication**: Slack, Teams, Discord, Signal, WhatsApp, Zoom
- **Utilities**: Rectangle, Raycast, BetterMouse, Finder enhancements
- **CLI Tools**: bat, fzf, eza, btop, jq, ripgrep, exa
- **Configuration**: Oh My Zsh with Powerlevel10k, syntax highlighting, auto-suggestions
- **Service Management**: Disables auto-start for Docker, Ollama, VPNs

#### `mac_install.sh` (System Optimization)
Comprehensive macOS customization and performance optimization:

**Performance Enhancements:**
- Disables Siri and Siri suggestions (reclaims system resources)
- Disables Photos AI processing (stops memory/storage drain)
- Disables Media AI features (eliminates background processing)
- Disables Game Center and related services
- Fixes macOS Sonoma lag issues
- Optimizes launchd services

**UI Speed Improvements:**
- Instant window resize animations
- Instant Dock appearance on hover
- Removes all UI animation delays
- Speeds up Mission Control and Exposé
- Disables smooth scrolling delays
- Faster screenshot saving

**Dock & Finder Configuration:**
- Auto-hide Dock (saves screen space)
- Removes recents from Dock
- Shows hidden files and file extensions
- Enables path bar and status bar
- Single-click proxy icons
- Proper directory default views

**Input & System Settings:**
- Fast keyboard repeat rate
- Trackpad gestures configuration
- Modifier key mapping
- Screen resolution optimization
- Click speed adjustment
- Hot corner configuration

**Terminal & Shell:**
- Nord theme installation (beautiful color scheme)
- Oh My Zsh setup with plugins
- Powerlevel10k prompt configuration
- Syntax highlighting and auto-suggestions enabled

#### `vscode.sh` (68+ Extensions)
Automated VS Code extension installation with categorized setup:

**AI & Productivity:**
- GitHub Copilot, Amazon Q, Claude (Anthropic)
- Tabnine, Continue Dev

**Visual Themes:**
- Nord, Dracula, One Dark, Material Icon Theme
- Icons, Nerd Font icons

**Language Support:**
- Python, JavaScript/TypeScript, Go, GraphQL
- Rust, C/C++, Java, SQL

**DevOps & Infrastructure:**
- Docker, Kubernetes, Terraform
- AWS Toolkit, CloudFormation
- Azure Tools, Google Cloud Code

**Git & Version Control:**
- GitLens, Git History, Git Graph
- GitHub Copilot (for PR reviews)

**Development Tools:**
- Jupyter, REST Client, Thunder Client
- Prettier, ESLint, Pylint
- Postman

**Utilities:**
- Markdown Preview, Better Comments
- Code Spell Checker, Peacock
- Error Lens, Peacock Favorites
- Todo Tree, Bookmarks

**Gaming Mods:**
- Minecraft tools, Game Modding support

**Features:**
- Colored progress output with statistics
- Automatically skips already-installed extensions
- Generates backup installation script (InstallVsCodeExtensions.sh)
- Shows total count and installation time
- Requires VS Code CLI in PATH (automatically detected)

#### `privacy.sh` (Advanced Privacy Hardening)
Comprehensive privacy and security hardening (831 lines):
- **Framework**: Generated from [privacy.sexy](https://privacy.sexy) framework
- **Comprehensive Siri disabling**: All Siri services, suggestions, and data collection
- **Telemetry blocking**: Firefox, Microsoft Office, Homebrew, .NET Core, PowerShell
- **System cleaning**: Cache clearing, DNS purging, Xcode cache, trash, logs
- **Privacy features**: Location services, Bluetooth, accessibility permissions
- **Security hardening**: Firewall configuration, remote access disabling, guest user removal
- **iCloud settings**: Document storage, photo sync, keychain settings
- **Advanced features**: System integrity protection checks, firmware updates, secure boot

⚠️ **Note**: This is an advanced script with 831 lines of hardening rules. Review specific sections before running if you have concerns about compatibility with your workflow.

## 📦 Prerequisites

### Windows
- Windows 10/11
- **Administrator privileges required**
- PowerShell 5.1 or later
- Internet connection

### macOS
- macOS 10.15 or later
- Internet connection
- Xcode Command Line Tools (automatically prompted during Homebrew installation)

## 🚀 Usage

### Windows

**Recommended: Interactive Installer** (run as Administrator):

1. **Right-click PowerShell** and select **"Run as Administrator"**
2. **Copy and paste this command**:
   ```powershell
   powershell -ExecutionPolicy Bypass -Command "iwr -useb https://raw.githubusercontent.com/peeweeh/pc-setup/master/win/install.ps1 | iex"
   ```

The installer will show a menu where you can choose:
- **Option 1**: Install Applications (windows_install.ps1)
- **Option 2**: Setup Development Environment (dev_setup.ps1)
- **Option 3**: Install VS Code Extensions (vscode_extensions.ps1)
- **Option 4**: Privacy Hardening (privacy_tweaks.ps1)
- **Option 5**: Install ALL (recommended for fresh Windows)

**Just windows_install.ps1:**
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iwr -useb https://raw.githubusercontent.com/peeweeh/pc-setup/master/win/windows_install.ps1 | iex
```

The script will:
- Install Chocolatey (if not present)
- Detect your GPU and install drivers (NVIDIA auto-detected, AMD manual)
- Install 74+ applications via Chocolatey
- Apply Windows privacy & performance tweaks
- Configure Oh My Posh with Nerd Fonts
- Install PowerShell modules (PSReadLine, Terminal-Icons)
- Create system restore point for safety

**Alternative: Run locally from cloned repo**:
```powershell
git clone https://github.com/peeweeh/pc-setup.git
cd pc-setup/win
Set-ExecutionPolicy Bypass -Scope Process -Force
& ".\install.ps1"
```

### macOS

**Recommended: Interactive Installer**:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/install.sh)
```

The installer will show a menu where you can choose:
- **Option 1**: Install Applications (brew_install.sh)
- **Option 2**: Optimize System (mac_install.sh)
- **Option 3**: Install VS Code Extensions (vscode.sh)
- **Option 4**: Privacy Hardening (privacy.sh)
- **Option 5**: Install ALL (recommended for fresh Mac)

**Alternative: Run locally from cloned repo**:
```bash
git clone https://github.com/peeweeh/pc-setup.git
cd pc-setup/mac
chmod +x *.sh
./install.sh
```

## 📦 What Gets Installed

### Windows Applications (74+ via Chocolatey)

#### Productivity & System Tools
- 1Password (password manager)
- PowerToys (Windows productivity utilities)
- Sysinternals (system administration tools)
- Everything (instant file search)
- TreeSizeFree (disk space analyzer)
- WizTree (fast disk space visualization)
- Chocolatey GUI (package manager GUI)
- 7-Zip, WinRAR (compression utilities)

#### Browsers
- Google Chrome
- Microsoft Edge
- Brave Browser
- Arc Browser

#### Development & Programming
- Git, GitHub Desktop (version control)
- Visual Studio Code (IDE)
- Node.js, npm (JavaScript/TypeScript)
- Python (Python runtime)
- Go (Go programming language)
- Postman (API testing)
- Neovim (terminal editor)
- LINQPad (C# scripting)
- Fig (CLI autocompletion)
- DevToys (developer utilities)
- FFmpeg (video processing)

#### CLI Tools & Utilities
- bat (cat with syntax highlighting)
- fzf (fuzzy finder)
- ripgrep (fast grep)
- fd (fast find)
- zoxide (smart directory navigation)
- git-delta (enhanced git diffs)
- jq (JSON processor)
- curl (data transfer)
- less (pager)

#### Communication & Chat
- Slack (team messaging)
- Microsoft Teams (enterprise chat)
- Discord (community chat)
- Signal (secure messaging)
- Telegram (messaging app)
- WhatsApp (messaging app)
- Amazon Chime (AWS video conferencing)
- Beeper (unified messaging)

#### Media & Entertainment
- VLC (media player)
- Plex Media Player (streaming)
- Steam (gaming platform)
- Spotify (music streaming)

#### Gaming & Gaming Platforms
- Epic Games Launcher
- EA App (Electronic Arts)
- GOG Galaxy (DRM-free games)
- Ubisoft Connect (Ubisoft games)

#### Cloud Storage & Backup
- Google Drive (cloud storage)
- iCloud (Apple cloud storage)
- Proton Drive (encrypted storage)

#### System Monitoring & Performance
- HWiNFO (hardware info)
- DDU (Display Driver Uninstaller)
- MSI Afterburner (GPU overclocking)
- RivaTuner (GPU monitoring)

#### Graphics & Design
- Calibre (ebook management)
- Clipchamp (video editor)

#### Security & Privacy
- Proton VPN (virtual private network)
- Proton Mail (encrypted email)

#### Shell & Terminal Customization
- Oh My Posh (PowerShell prompt theming)
- Nerd Fonts (FiraMono, FiraCode with icons)

#### Development Environment (dev_setup.ps1)
- WSL2 (Windows Subsystem for Linux)
- Docker Desktop (containerization)
- AWS CLI (Amazon Web Services CLI)
- GitHub CLI (gh command)
- Rust (Rust programming language)
- Java JDK (Java development)

#### PowerShell Modules
- PSReadLine (enhanced command-line editing)
- Terminal-Icons (file/folder icons in listings)

### Windows VS Code Extensions (50+)

**AI & Productivity**: GitHub Copilot, Amazon Q, Claude, Continue, DS Code GPT

**Themes & Icons**: Nord, Dracula, One Dark Pro, Material Theme, vscode-icons

**Languages**: Python (Autopep8, isort, Pylance), Go, GraphQL, JavaScript, TypeScript, Rust, C++, SQL

**Development Tools**: ESLint, Prettier, CodeSnap, Turbo Console Log, Better Comments

**Git & Version Control**: GitLens, Git History, Atlassian (Jira/Bitbucket)

**DevOps & Infrastructure**: Docker, Kubernetes, AWS Toolkit, Terraform, Remote Containers, GitHub Actions

**Data & Analysis**: Jupyter, Python, REST Client, Thunder Client

**Utilities**: Edge DevTools, PowerShell, Live Share, YAML, Markdown, Excel Viewer, File Downloader

### Windows Privacy & Telemetry Disabled (privacy_tweaks.ps1)
- Disables diagnostic data collection
- Removes Cortana and Cortana search
- Disables location tracking
- Disables activity history
- Disables cloud-based speech recognition
- Removes consumer features and app suggestions
- Disables text and handwriting data collection
- Opts out of Windows feedback
- Removes default user accounts
- Disables various telemetry services
- Disables consumer feature recommendations
- Opt-out of privacy consent and personalization

### macOS Applications (via Homebrew)

#### Development
- Git, AWS CLI, AWS Nuke
- Visual Studio Code
- Docker
- Postman
- Fig, DevToys

#### Browsers
- Google Chrome, Brave

#### Productivity
- 1Password
- Rectangle (window management)
- Microsoft Office

#### Communication
- Slack, Microsoft Teams, Discord
- Zoom, Amazon Chime, Amazon Workspaces
- Microsoft Remote Desktop

#### Media
- VLC, Ferdium

#### Utilities
- Google Drive, NordVPN
- Adobe Creative Cloud

#### CLI Tools
- bat, fzf, exa
- Powerlevel10k

## 🎨 Customization

### Windows

**Modify Package List**: Edit the `$packages` array in `windows_install.ps1`

```powershell
$packages = @(
    "package-name",
    # Add or remove packages here
)
```

**Skip Privacy Tweaks**: Comment out the "Windows Privacy & Performance Tweaks" section

**Change Oh My Posh Theme**: After installation, edit your PowerShell profile:
```powershell
notepad $PROFILE
# Change 'atomic.omp.json' to your preferred theme
# View themes: Get-PoshThemes
```

### macOS

**Modify Brew Packages**: Edit `brew_install.sh` and add/remove `brew install` commands

**Customize System Settings**: Edit `mac_install.sh` to adjust Dock size, Finder settings, etc.

**Change Terminal Theme**: Replace the Nord theme URL in `mac_install.sh`

## 🔒 Privacy & Security

### Windows Privacy (privacy_tweaks.ps1)
Comprehensive privacy hardening with 471 lines of registry tweaks:
- **Disables telemetry** - Diagnostic data, feedback collection, activity history
- **Removes tracking** - Location services, Wi-Fi Sense, cloud-based speech recognition
- **Disables spyware** - Cortana, consumer features, app suggestions
- **Opts out** - Windows privacy consent, personalization, content delivery
- **Input privacy** - Disables text and handwriting data collection
- **Network privacy** - Removes network suggestions and defaults
- **General privacy** - Removes default user accounts, minimizes DISM data
- **Creates restore point** - Allows reverting changes if needed

### macOS Privacy (privacy.sh)
Advanced privacy hardening with 831 lines from privacy.sexy framework:
- **Disables Siri completely** - Removes all Siri services and data collection
- **Blocks telemetry** - Firefox, Office, Homebrew, .NET, PowerShell
- **Security hardening** - Firewall, removes guest user, disables remote access
- **Clears data** - System caches, CUPS, Xcode, DNS, trash

## ⚠️ Important Notes

### Windows
- **Requires Administrator privileges** - Run PowerShell as Administrator
- **System restore point created** - Safe to revert if issues occur
- **GPU drivers**: NVIDIA auto-detected, AMD requires manual download
- **Restart recommended** - Some features require reboot to take effect
- **dev_setup.ps1 is optional** - Only needed for development environment
- **privacy_tweaks.ps1 can be reviewed** - Edit registry keys before running if desired
- **WSL2 requires Hyper-V** - Check BIOS for virtualization support

### macOS
- **Homebrew installs automatically** if not present
- **Xcode Command Line Tools** installed automatically by Homebrew
- **System restart recommended** - For full effect of system tweaks
- **Some settings require logout** - Especially shell configuration changes
- **privacy.sh is advanced** - Review before running on critical systems

## 🤝 Contributing

Feel free to submit issues, fork the repository, and create pull requests for any improvements.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Chocolatey](https://chocolatey.org/) - Package manager for Windows
- [Homebrew](https://brew.sh/) - Package manager for macOS
- [Oh My Posh](https://ohmyposh.dev/) - PowerShell prompt theming
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - Zsh prompt theme
- [privacy.sexy](https://privacy.sexy/) - Privacy configuration framework
- [@mrfixit027](https://github.com/mrfixit027) - Script author and maintainer

## 📞 Support

If you encounter any issues or have questions:
1. Check existing [Issues](https://github.com/peeweeh/pc-setup/issues)
2. Create a new issue with detailed information and error messages
3. Include your OS version (Windows 10/11, macOS version)
4. Specify which script caused the issue