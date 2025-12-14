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

### Scripts

#### `brew_install.sh`
Installs applications and tools via Homebrew:
- Development tools (Git, VS Code, Docker, Postman)
- Browsers (Chrome, Brave)
- Communication (Slack, Teams, Discord)
- Utilities (1Password, VLC, Rectangle)
- CLI tools (bat, fzf, exa)

#### `mac_install.sh`
Customizes macOS system settings:
- Dock configuration (auto-hide, size, cleanup)
- Finder customization
- Terminal theme (Nord)
- Shell configuration (Powerlevel10k)

#### `vscode.sh`
Installs Visual Studio Code extensions

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

1. **Download the script**:
   ```powershell
   # Clone the repository
   git clone https://github.com/peeweeh/pc-setup.git
   cd pc-setup/win
   ```

2. **Run as Administrator**:
   ```powershell
   # Right-click PowerShell and select "Run as Administrator"
   .\windows_install.ps1
   ```

3. **One-liner (run as Administrator)**:
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force; iwr -useb https://raw.githubusercontent.com/peeweeh/pc-setup/main/win/windows_install.ps1 | iex
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