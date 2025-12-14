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
- **Automated Package Installation** via Chocolatey (74+ packages)
- **GPU Detection** - Automatically installs NVIDIA drivers for NVIDIA GPUs
- **Privacy & Performance Tweaks** - Disables telemetry, location tracking, and unnecessary services
- **Shell Customization** - Oh My Posh with Nerd Fonts
- **PowerShell Enhancement** - PSReadLine and Terminal-Icons modules
- **Privacy Tool** - O&O ShutUp10++ for additional privacy configuration
- **System Restore Point** - Created before applying tweaks

### macOS
- **Homebrew Package Installation** - Essential development tools and applications
- **System Customization** - Dock, Finder, and Terminal configuration
- **Theme Installation** - Nord Terminal theme
- **Shell Enhancement** - Powerlevel10k for Zsh

## 🪟 Windows Setup

### Scripts

#### `windows_install.ps1`
Comprehensive setup script that includes:
1. Chocolatey installation
2. GPU detection and driver installation (NVIDIA only)
3. Application installation (74 packages)
4. Windows privacy and performance tweaks
5. Oh My Posh configuration with Nerd Fonts
6. PowerShell module installation (PSReadLine, Terminal-Icons)
7. O&O ShutUp10++ download and launch

#### `vscode_extensions.ps1`
Installs Visual Studio Code extensions

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

**Recommended: One-liner for fresh PC** (run as Administrator):

1. **Right-click PowerShell** and select **"Run as Administrator"**
2. **Copy and paste this command**:
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force; iwr -useb https://raw.githubusercontent.com/peeweeh/pc-setup/master/win/windows_install.ps1 | iex
   ```

That's it! The script will:
- Install Chocolatey (if not present)
- Detect your GPU and install drivers (NVIDIA only)
- Install all packages
- Apply privacy tweaks
- Configure Oh My Posh
- Install PowerShell modules
- Launch O&O ShutUp10++

**Alternative: Manual download** (if you have git):
```powershell
git clone https://github.com/peeweeh/pc-setup.git
cd pc-setup/win
.\windows_install.ps1
```

### macOS

1. **Download the scripts**:
   ```bash
   # Clone the repository
   git clone https://github.com/peeweeh/pc-setup.git
   cd pc-setup/mac
   ```

2. **Make scripts executable**:
   ```bash
   chmod +x brew_install.sh mac_install.sh vscode.sh
   ```

3. **Run the scripts**:
   ```bash
   # Install applications
   ./brew_install.sh
   
   # Customize system settings
   ./mac_install.sh
   
   # Install VS Code extensions (optional)
   ./vscode.sh
   ```

## 📦 What Gets Installed

### Windows Applications (via Chocolatey)

#### Productivity & Utilities
- 1Password, 7-Zip, WinRAR
- PowerToys, Sysinternals
- Everything, TreeSizeFree, WizTree
- Chocolatey GUI, Boxstarter

#### Browsers
- Google Chrome, Microsoft Edge, Brave, Arc Browser

#### Development Tools
- Git, GitHub Desktop, Visual Studio Code
- Node.js, Python 3.14
- Neovim, LINQPad
- Postman, Wireshark
- Docker (manual installation recommended)

#### CLI Productivity Tools
- fzf (fuzzy finder)
- bat (cat with syntax highlighting)
- ripgrep (fast grep)
- fd (fast find)
- zoxide (smart cd)
- git-delta (better git diffs)
- jq (JSON processor)
- less, curl

#### Communication
- Slack, Microsoft Teams, Discord
- Signal, Telegram, WhatsApp
- Beeper App

#### Media & Entertainment
- VLC, Plex Media Player
- Steam
- Spotify (optional)

#### Gaming Platforms
- Steam, Epic Games, EA App
- GOG Galaxy, Ubisoft Connect

#### Cloud Storage
- Google Drive, iCloud
- Proton Drive

#### Design & Creativity
- Calibre, Clipchamp

#### System & Hardware
- AMD Ryzen Chipset & Master (for AMD systems)
- MSI Afterburner, RivaTuner
- HWiNFO, HWMonitor
- DDU (Display Driver Uninstaller)

#### Security & Privacy
- Proton VPN, Proton Mail
- O&O ShutUp10++

#### Shell Customization
- Oh My Posh
- Starship (alternative prompt)
- Nerd Fonts (FiraMono, FiraCode)

#### PowerShell Modules
- PSReadLine (enhanced command-line editing)
- Terminal-Icons (file icons in directory listings)

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

### Windows Tweaks Applied
- Disables Windows telemetry
- Disables activity history
- Disables location tracking
- Disables Wi-Fi Sense
- Disables consumer features
- Disables GameDVR
- Disables storage sense
- Disables PowerShell 7 telemetry
- Creates system restore point before changes

### Additional Privacy
- O&O ShutUp10++ is downloaded and launched for manual privacy configuration
- All tweaks can be reviewed before running the script

## ⚠️ Important Notes

### Windows
- **Requires Administrator privileges**
- Some installations may require system restart
- AMD GPU drivers are NOT installed automatically (download from AMD website)
- O&O ShutUp10++ launches at the end - configure privacy settings manually
- Review the privacy tweaks before running if you have concerns

### macOS
- Homebrew will be installed if not present
- Some system changes may require logout/restart
- Xcode Command Line Tools will be installed automatically

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
- [Oh My Posh](https://ohmyposh.dev/) - Prompt theme engine
- [Chris Titus Tech](https://christitus.com/) - Windows utility inspiration
- [O&O Software](https://www.oo-software.com/en/shutup10) - ShutUp10++ privacy tool

## 📞 Support

If you encounter any issues or have questions:
1. Check existing [Issues](https://github.com/peeweeh/pc-setup/issues)
2. Create a new issue with detailed information
3. Include your OS version and error messages