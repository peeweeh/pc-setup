# PC Setup Scripts

Automated setup scripts for Windows, macOS and Omarchy to quickly configure a new development environment with essential applications, tools, and system tweaks.

## ⚡ TL;DR - Quick Start

### Windows (Run as Administrator)
```powershell
powershell -ExecutionPolicy Bypass -Command "iwr -useb https://raw.githubusercontent.com/peeweeh/pc-setup/master/win/install.ps1 | iex"
```

### macOS
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/install.sh)
```

### Omarchy (run as your normal user, not root)
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/omarchy/install.sh)
```

**Windows** installer opens a menu with 4 options:
1. **Install Light** (core apps, development tools and fonts)
2. **Install Heavy** (Light plus cloud, Docker, games and other large apps)
3. **Install Optimizations** (privacy policies and optional background-task review)
4. **Install ALL** (Heavy followed by optimizations)

**macOS** installer opens a menu with 4 options:
1. **Install Light** (core apps, development tools and fonts)
2. **Install Heavy** (Light plus Office, Docker, cloud and other large apps)
3. **Install Optimizations** (performance and privacy hardening)
4. **Install ALL** (Heavy followed by optimizations)

**Omarchy** setup opens a menu with 4 options (run once on an installed system):
1. **Install Light** (core apps, developer tools and fonts)
2. **Install Heavy** (Light plus VPN, Steam and Discord)
3. **Install Optimizations** (local Voxtype dictation instead of cloud)
4. **Install All** (Heavy followed by optimizations)

---

## 📋 Table of Contents

- [Quick Start](#tldr---quick-start)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Detailed Usage](#detailed-usage)
- [What Gets Installed](#what-gets-installed)
- [Detailed Script Reference](#detailed-script-reference)
- [Customization](#customization)
- [Privacy & Security](#privacy--security)
- [Important Notes](#important-notes)
- [Contributing](#contributing)
- [Support](#support)

---

## ✨ Features

### Windows
- **Interactive Installer** - Light, Heavy, Optimizations, or All
- **Retro terminal UI** - Matrix-rain intro, sheen-flash banner, boot log and a `party` easter egg
- **Applications and tools** via Chocolatey; Hermes Agent via its official installer
- **Nerd Fonts** - Fira Code and Hack
- **Optional optimization** - Privacy policies and individually approved background-task changes, with a restore command
- **Optional standalone development setup** - WSL2 and additional development configuration

### macOS
- **Interactive Installer** - Choose Light, Heavy, Optimizations, or All
- **Retro terminal UI** - Matrix-rain intro, sheen-flash banner, boot log and a `party` easter egg
- **Homebrew Package Installation** - Light / Heavy tiers and CLI tools
- **System Optimization** - Performance, battery, and UI speed improvements
- **Disables Siri, Photos AI, Media AI** - Significant battery savings
- **Privacy & Security Hardening** - Combined with system optimization in a single script
- **Shell Enhancement** - Powerlevel10k for Zsh, plugins, aliases
- **Dock & Finder Customization** - Auto-hide, speed improvements, clean layout
- **Terminal Theme** - Nord color scheme for beautiful terminal

### Omarchy
- **Interactive Setup** - Light, Heavy, Optimizations (local dictation), or All, run once after installation
- **Retro terminal UI** - Matrix-rain intro, sheen-flash banner, boot log and a `party` easter egg
- **Signed Omarchy packages** - Installed with `omarchy-pkg-add`; no AUR builds
- **Steam with drivers** - Uses Omarchy's gaming installer for graphics libraries
- **Local dictation option** - Switches Omarchy's dictation to local Voxtype processing
- **Isolated tests** - Mocked installer tests in `omarchy/test_install.sh`

---

## 📋 Prerequisites

### Windows
- Windows 10/11
- **Administrator privileges required**
- PowerShell 5.1 or later
- Internet connection

### Omarchy
- Omarchy 4.5 installed on x86_64 or aarch64 hardware
- Run as your normal desktop user, not root or with `sudo`
- Internet connection

### macOS
- Individual apps may require newer versions; Yogurt needs Apple Silicon and macOS 14.4+
- Internet connection
- Xcode Command Line Tools (automatically prompted during Homebrew installation)

---

## 🚀 Detailed Usage

### Windows Setup

**Author**: [@mrfixit027](https://github.com/mrfixit027)

#### Interactive Installer (Recommended)

**Run this command in PowerShell as Administrator**:

```powershell
powershell -ExecutionPolicy Bypass -Command "iwr -useb https://raw.githubusercontent.com/peeweeh/pc-setup/master/win/install.ps1 | iex"
```

Or run locally after cloning:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
& ".\win\install.ps1"
```

The installer shows a menu:
```
========================================
     PC Setup - Master Installer
========================================
Choose an option:

1) Install Light
2) Install Heavy
3) Install Optimizations
4) Install All
0) Exit
```

#### Just Install Applications

```powershell
.\win\windows_install.ps1 -Tier light
# Or: .\win\windows_install.ps1 -Tier heavy
```

#### Just Development Setup

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iwr -useb https://raw.githubusercontent.com/peeweeh/pc-setup/master/win/dev_setup.ps1 | iex
```

### macOS Setup

**Author**: [@mrfixit027](https://github.com/mrfixit027)

#### Interactive Installer (Recommended)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/install.sh)
```

Shows menu:
```
╔═══════════════════════════════════════════════════╗
║   🍎 macOS Setup Script - Choose an Option       ║
╚═══════════════════════════════════════════════════╝

1) Install Light
2) Install Heavy
3) Install Optimizations
4) Install ALL

0) Exit
```

#### Just Install Applications

```bash
# Prompt for Light or Heavy
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/brew_install.sh)
# Or select a tier directly
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/brew_install.sh) light
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/brew_install.sh) heavy
```

Both tiers also upgrade existing Homebrew packages, which may prompt for authorization
or quit applications. They attempt to remove all current login items and disable new
LaunchAgents.

#### Just Optimize System & Harden Privacy

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/mac_optimize.sh)
```

#### Run Locally from Cloned Repository

```bash
git clone https://github.com/peeweeh/pc-setup.git
cd pc-setup/mac
chmod +x *.sh
./install.sh
```

### Omarchy Setup

Run once on an installed Omarchy system, as your normal user (not root):

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/omarchy/install.sh)
```

The menu offers Light, Heavy, Optimizations (switches dictation to local Voxtype)
and All. Packages come from Omarchy's signed repositories through `omarchy-pkg-add`,
so no AUR builds are needed. Microsoft 365 is intentionally skipped. Apps that have
no Omarchy package, such as Comet, Perplexity and Raycast, are not included.
Failures are reported and the script exits unsuccessfully. Run the isolated tests with:

```bash
bash omarchy/test_install.sh
```

---

## 📦 What Gets Installed

### Windows Applications

Light includes the existing Windows utilities and communication/development apps,
plus Helium, Comet, Claude, Warp, DevToys, AWS CLI, uv, Fira Code and Hack Nerd
Fonts. Heavy adds cloud apps, Docker Desktop, Figma, Ollama and game launchers.
The installer uses Chocolatey and the official Windows shell installer for Hermes.
VS Code extensions are managed by your VS Code profiles.

Office and the Perplexity desktop app are not installed automatically on Windows;
use the vendor's installer or Microsoft Store where available. macOS-only apps
such as Yogurt have no Windows equivalent in this installer.

### Omarchy Applications

**Light**: 1Password and CLI, Helium, Brave, Google Chrome, Claude, VS Code, GitHub
Copilot CLI, Signal, Telegram, Slack, Obsidian, VLC, actionlint, git-delta, Ruff,
pipx, and Fira Code and Hack Nerd Fonts.

**Heavy** adds Proton VPN and Steam. Discord is installed on x86_64 only because
Omarchy does not publish it for aarch64.

**Optimizations** switches dictation to local Voxtype and downloads its model.

Microsoft 365 is intentionally skipped. Apps without an Omarchy package are not
included.

### macOS Applications

#### Development
- Git, AWS CLI, AWS Nuke, Visual Studio Code, Docker, Postman, DevToys
- CocoaPods (CLI tools)
- Hermes Agent (official shell installer, not Homebrew)

#### Browsers
- Google Chrome, Brave, Comet, Helium

#### Productivity
- 1Password
- Rectangle (window management)
- Claude, ChatGPT, Perplexity
- ArtCraft and ArtCraft Launcher (creative and AI)
- Microsoft Word, Excel, PowerPoint and Outlook (official Microsoft installers)
- Yogurt (official Homebrew tap; Apple Silicon, macOS 14.4+)

#### Communication
- Slack, Microsoft Teams, Discord
- Zoom, Amazon Workspaces, Windows App

#### Media
- VLC

#### Utilities
- Google Drive, OneDrive, Proton VPN, Task Manager TMOG, CrossOver (runs Windows apps)

#### CLI Tools
- actionlint, bash, bat, coreutils, fzf, eza, tailscale, lame
- Powerlevel10k

---

## 📚 Detailed Script Reference

### Windows Scripts

#### `install.ps1` (Interactive Menu)
Master installer with menu-driven setup orchestration:
- Beautiful colored menu interface with emoji status
- Select individual scripts or run all
- Proper error handling and progress tracking
- Automatically handles PowerShell execution policy
- Downloads scripts from GitHub on-the-fly (no manual cloning required)

#### `windows_install.ps1` (Applications)
Installs Chocolatey when needed, then installs the selected Light or Heavy tier.
Heavy additionally installs NVIDIA packages when detected; AMD drivers are manual.
Package failures are reported. This script does not apply system optimizations.

#### `windows_optimize.ps1` (Optimizations)
On supported Windows 10/11 Pro, Enterprise and Education editions and Server,
requests minimal diagnostic data, disables the advertising ID and update
peer-sharing, restricts web search, and disables clipboard sync and online
speech recognition. It asks before disabling individual Customer Experience
Improvement Program tasks. Power, visual effects, Defender and updates are
unchanged. Windows Home is unsupported and the script stops without changes.
Policy effectiveness can vary, and Windows and apps still make connections.
See [Windows setup](win/spec.md) for limitations and update-diagnostic
tradeoffs. Restart and verify effective settings.

Original values are backed up; older power/visual backups are also supported.
Restore from the same Windows account using a local checkout:
```powershell
.\win\windows_optimize.ps1 -Restore
```

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

### macOS Scripts

#### `install.sh` (Interactive Menu)
Main entry point for setting up macOS:
- Beautiful colored menu interface with emoji status
- Select individual scripts or run all
- Proper error handling and progress tracking
- Automatically elevates to sudo when needed
- Downloads scripts from GitHub on-the-fly (no manual cloning required)

#### `brew_install.sh` (Applications and CLI Tools)
Comprehensive Homebrew installation script with:
- **Automatic Homebrew installation** if not present (handles Apple Silicon & Intel)
- **Two install tiers**:
  - **Light** – Dev tools, browsers, communication and productivity apps
  - **Heavy** – Light plus Office, Docker, cloud/VPN, Yogurt and other larger apps
- **Microsoft Office** – Installs missing Word, Excel, PowerPoint and Outlook from signed Microsoft packages; existing copies, including App Store installs, are preserved
- **Hermes Agent** – Uses the official shell installer and preserves existing source installations
- **Nerd Fonts** – Registers the fonts with macOS and applies FiraCode Nerd Font Mono to Terminal's default and startup profiles
- **Idempotent design** - Safe to run multiple times without duplication
- **Error handling** - Reports failed installations and exits nonzero
- **Authorization** - Privileged installers prompt when needed
- **CLI tools** (20+ formulae): bat, fzf, eza, btop, git, gh, ruff, black, awscli, docker, etc.
- **Formula inventory** - Includes the Mac's installed Homebrew libraries and dependencies, which may be marked as explicitly installed on a new Mac
- **Oh My Zsh configuration** with Powerlevel10k, syntax highlighting, auto-suggestions
- **Background activity** - Attempts to remove all current login items and disable newly added LaunchAgents

**Runtime**: ~15-20 min (Light) / ~40-70 min (Heavy), depending on downloads

#### `mac_optimize.sh` (System Optimization & Privacy Hardening)
Combined macOS performance/UI optimization and privacy & security hardening
(formerly two separate scripts, `mac_install.sh` and `privacy.sh`):

**Performance Enhancements:**
- Disables Siri and Siri suggestions (reclaims system resources)
- Disables Photos AI processing (stops memory/storage drain)
- Disables Media AI features (eliminates background processing)
- Disables Game Center and related services
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

**Privacy & Security Hardening:**
- **Framework**: Privacy portions generated from [privacy.sexy](https://privacy.sexy) framework
- **Comprehensive Siri disabling**: All Siri services, suggestions, and data collection
- **Telemetry blocking**: Firefox, Microsoft Office, Homebrew, .NET Core, PowerShell
- **System cleaning**: Cache clearing, DNS purging, Xcode cache, trash, logs
- **Privacy features**: AirDrop, Bonjour, advertising identifiers, iCloud document storage
- **Security hardening**: Firewall (incl. stealth mode), remote access disabling, guest user removal

⚠️ **Note**: This is an advanced script combining optimization with 800+ lines of
privacy/security hardening rules. Review specific sections before running if you have
concerns about compatibility with your workflow. Individual commands elevate with `sudo`
as needed - run the script as your normal user, not with `sudo` in front of it.

**Runtime**: 5-10 minutes

### Omarchy Scripts

#### `omarchy/install.sh` (One-Time Setup)
Interactive setup for an installed Omarchy system:
- Refuses to run as root and stops when Omarchy commands are unavailable
- Installs each package separately with `omarchy-pkg-add`
- Uses `omarchy-install-gaming-steam` for Steam and graphics libraries
- Uses `omarchy-install-dictation-voxtype` for local dictation
- Reports failed packages and exits nonzero

**Runtime**: depends on package downloads

#### `omarchy/test_install.sh` (Mocked Tests)
Checks each menu option, architecture-specific packages, failure reporting, invalid
input, the non-Omarchy guard, and the absence of Microsoft 365 packages. Run with:

```bash
bash omarchy/test_install.sh
```

---

## 🎨 Customization

### Windows

**Modify Package List**: Edit the essential, optional, and additional package
arrays and Heavy classification in `windows_install.ps1`.

### macOS

**Modify Brew Packages**: Edit `brew_install.sh` and add/remove `brew install` commands

**Customize System Settings**: Edit `mac_optimize.sh` to adjust Dock size, Finder settings, etc.

**Change Terminal Theme**: Replace the Nord theme URL in `mac_optimize.sh`

### Omarchy

**Modify Packages**: Edit the `light_packages`, `heavy_packages` and
`heavy_x86_packages` arrays in `omarchy/install.sh`. Check each package in Omarchy's
repository for both architectures before adding it.

## 🔒 Privacy & Security

### Windows Optimization Privacy (windows_optimize.ps1)
The Windows optimization option applies a limited, reversible set of privacy policies:
diagnostic data (Required on Pro, off on Enterprise, Education and Server), advertising
ID, Delivery Optimization peer sharing, cross-device clipboard sync, online speech, and
Windows web search. It also asks before disabling each Customer Experience Improvement
Program task. It doesn't change power settings, visual effects, Defender or updates.
Policy effectiveness depends on your Windows edition and management, and Windows and
apps still make necessary connections. See [win/spec.md](win/spec.md) for details.

### Windows Privacy (privacy_tweaks.ps1)
This legacy advanced script is separate from the installer. It changes services,
app permissions and other privacy settings and deletes diagnostic data; review it
before running. The optimization option does not run it.

### macOS Privacy (mac_optimize.sh)
Advanced privacy hardening (privacy portions from privacy.sexy framework), combined with
system optimization in a single script:
- **Disables Siri completely** - Removes all Siri services and data collection
- **Blocks telemetry** - Firefox, Office, Homebrew, .NET, PowerShell
- **Security hardening** - Firewall (incl. stealth mode), removes guest user, disables remote access
- **Clears data** - System caches, CUPS, Xcode, DNS, trash

## ⚠️ Important Notes

### Animations
The installers animate only in an interactive terminal. Output is plain when it is piped
or redirected (for example in CI). To turn animations off, set `PC_SETUP_NO_ANIM=1` before
running a script. Type `party` at any installer menu for a rainbow banner and a matrix-rain
encore.

### Windows
- **Requires Administrator privileges** - Run PowerShell as Administrator
- **Optimization backup**: restore using `windows_optimize.ps1 -Restore`
- **Windows Home is unsupported** by the privacy optimizer; it stops without changes
- **GPU packages**: NVIDIA auto-detected for Heavy; AMD requires manual download
- **Restart recommended** - Some features require reboot to take effect
- **dev_setup.ps1 is optional** - Only needed for development environment
- **privacy_tweaks.ps1 can be reviewed** - Edit registry keys before running if desired
- **WSL2 requires Hyper-V** - Check BIOS for virtualization support

### macOS
- **Homebrew installs automatically** if not present
- **Xcode Command Line Tools** installed automatically by Homebrew
- **System restart recommended** - For full effect of system tweaks
- **Some settings require logout** - Especially shell configuration changes
- **mac_optimize.sh is advanced** - Review before running on critical systems

### Omarchy
- **Run once as your normal user** - Don't use `sudo`
- **Microsoft 365 is skipped** by this script
- **Discord is x86_64 only** - Omarchy doesn't publish it for aarch64
- **Local dictation downloads a model** - Optimizations option downloads Voxtype's model

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