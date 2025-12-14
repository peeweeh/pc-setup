# Windows Setup Scripts Specification

This document outlines the purpose, scope, and functionality of each PowerShell script in the `win/` directory.

---

## 1. `windows_install.ps1` - Main System Setup

**Purpose**: Primary setup script for a fresh Windows installation. Installs core applications, applies system tweaks, and configures the shell environment.

**Target Audience**: 
- Fresh Windows installations
- Users wanting a comprehensive productivity setup
- Both gaming and professional workstations

**What It Does**:

### 1.1 Prerequisites & Validation
- ✅ Checks for Administrator privileges (exits if not admin)
- ✅ Installs Chocolatey if not present
- ✅ Refreshes environment variables

### 1.2 GPU Detection & Drivers
- Detects GPU hardware (NVIDIA, AMD, or Unknown)
- **NVIDIA**: Installs `nvidia-app` and `nvidia-physx`
- **AMD**: Displays message to download drivers manually from AMD website
- **Unknown/Intel**: Skips GPU driver installation

### 1.3 Application Installation (74 packages via Chocolatey)
Categories include:
- **Productivity**: 1Password, 7-Zip, PowerToys, WinRAR, Sysinternals
- **Browsers**: Chrome, Edge, Brave, Arc
- **Development**: Git, VS Code, Node.js, Python, Neovim, Postman
- **CLI Tools**: fzf, bat, ripgrep, fd, zoxide, git-delta, jq, less, curl
- **Communication**: Slack, Teams, Discord, Signal, Telegram, WhatsApp, Beeper
- **Media**: VLC, Plex Media Player
- **Gaming**: Steam, Epic Games, EA App, GOG Galaxy, Ubisoft Connect
- **Cloud Storage**: Google Drive, iCloud, Proton Drive
- **System Tools**: Everything, TreeSizeFree, WizTree, HWiNFO, MSI Afterburner
- **Security**: Proton VPN, Proton Mail
- **Utilities**: Chocolatey GUI, Boxstarter, Calibre, Clipchamp

**Installation Process**:
- Installs GPU-specific packages first
- Loops through main package list
- Tracks success/failure counts
- Displays summary with failed packages (if any)

### 1.4 Windows Privacy & Performance Tweaks
Registry modifications and system changes:
- Creates system restore point before changes
- Deletes temporary files (`%TEMP%`, `C:\Windows\Temp`)
- Disables telemetry (multiple registry keys)
- Disables consumer features (suggested apps)
- Disables activity history
- Disables Explorer automatic folder discovery
- Disables GameDVR
- Disables hibernation (`powercfg /hibernate off`)
- Disables location tracking
- Disables storage sense
- Disables Wi-Fi sense
- Enables "End Task" with right-click on taskbar
- Runs disk cleanup
- Disables PowerShell 7 telemetry
- Sets certain services to manual start

### 1.5 Oh My Posh Configuration
- Checks if Oh My Posh is installed (via Chocolatey)
- Creates PowerShell profile if it doesn't exist
- Backs up existing profile with timestamp
- Configures Oh My Posh with `atomic` theme
- Installs Nerd Fonts: `FiraMono Nerd` and `FiraCode Nerd Font`
- Adds initialization to PowerShell profile

### 1.6 PowerShell Module Installation
- **PSReadLine**: Enhanced command-line editing, history, and autocomplete
- **Terminal-Icons**: File/folder icons in directory listings
- Installs from PowerShell Gallery with `-Scope CurrentUser`

### 1.7 O&O ShutUp10++
- Downloads OOSU10.exe to `%TEMP%`
- Launches the application (non-blocking)
- User can configure additional privacy settings manually

### 1.8 Final Summary
- Displays success/failure counts
- Reminds user to restart computer
- Provides link to Chris Titus Tech Windows Utility (optional)

**Error Handling**:
- Try/catch blocks around risky operations
- Exit codes checked for Chocolatey installations
- Failed packages tracked and reported
- Non-critical failures don't stop execution

**Expected Runtime**: 20-60 minutes (depending on internet speed and package count)

**Post-Script Actions**:
- Restart computer for changes to take effect
- Configure O&O ShutUp10++ privacy settings
- Reload PowerShell profile or restart terminal

---

## 2. `vscode_extensions.ps1` - VS Code Extensions Setup

**Purpose**: Installs a curated set of Visual Studio Code extensions for development productivity.

**Target Audience**:
- Developers using VS Code
- Fresh VS Code installations
- Users wanting a standardized extension set

**Prerequisites**:
- Visual Studio Code must be installed (installed via `windows_install.ps1`)
- `code` command must be in PATH (restart terminal after VS Code install)

**What It Does**:

### 2.1 Extension Categories

#### Language Support
- Python, JavaScript/TypeScript, C#, Java, Go, Rust
- HTML/CSS/JSON/YAML/XML
- Markdown support

#### Frameworks & Tools
- React, Vue, Angular
- Docker, Kubernetes
- SQL, MongoDB

#### Productivity
- GitLens (Git supercharged)
- Live Share (collaborative editing)
- Remote Development (SSH, Containers, WSL)
- Path Intellisense
- Bracket Pair Colorizer
- Auto Rename Tag

#### Code Quality
- ESLint, Prettier
- Language-specific linters
- Error Lens (inline error display)

#### Themes & UI
- Material Icon Theme
- Popular color themes

#### AI & Copilot
- GitHub Copilot
- IntelliCode

**Installation Method**:
- Uses `code --install-extension <extension-id>` command
- Loops through extension list
- Displays progress for each installation

**Error Handling**:
- Checks if `code` command exists
- Warns if VS Code is not installed or not in PATH
- Continues on individual extension failures

**Expected Runtime**: 5-15 minutes

**Post-Script Actions**:
- Restart VS Code to activate extensions
- Configure extension settings as needed

---

## 3. `dev_setup.ps1` - Development Environment Setup

**Purpose**: Sets up development-specific tools for software developers.

**Target Audience**:
- Software developers
- DevOps engineers
- Users needing WSL and Docker

**Prerequisites**:
- Windows 10 version 2004+ or Windows 11 (for WSL2)
- Administrator privileges
- Virtualization enabled in BIOS
- Run `windows_install.ps1` first


**What It Will Do**:

### 3.1 WSL (Windows Subsystem for Linux)
- Install WSL2 with Ubuntu (latest LTS)
- Enable systemd support
- Install essential build tools in Ubuntu:
  - `build-essential`, `curl`, `wget`, `git`
  - `vim`, `htop`, `neofetch`
- Install Docker CLI in WSL (connects to Docker Desktop)
- Configure Git in WSL (username, email)
- Set up SSH keys for GitHub

### 3.2 Docker Desktop
- Download and install Docker Desktop
- Configure to use WSL2 backend
- Enable WSL integration with Ubuntu
- **Important**: Set Docker service to **Manual** startup (for gaming performance)
  - Won't auto-start on boot
  - Can start manually when needed
- Pull common images: `alpine`, `ubuntu`, `node`, `python`, `nginx`
- Install Docker Compose
- Add Docker aliases to PowerShell profile

### 3.3 Node.js
- Install NVM (Node Version Manager) for Windows
- Install Node.js LTS version
- Install Node.js current version
- Configure npm global packages:
  - `yarn`, `pnpm`
  - `typescript`
  - `eslint`, `prettier`
  - `nodemon`

### 3.4 Python
- Verify Python is installed (from `windows_install.ps1`)
- Install `pipx` for global Python tools
- Install Python dev tools:
  - `poetry` (dependency management)
  - `black` (code formatter)
  - `pytest` (testing)
  - `jupyter` (notebooks)

### 3.5 Git Configuration
- Configure global Git settings:
  - Set username and email (prompts user)
  - Default branch: `main`
  - Credential manager: Windows
- Set up Git aliases:
  - `git co` = `checkout`
  - `git br` = `branch`
  - `git st` = `status`
  - `git lg` = `log --graph --oneline --all`
- Configure VS Code as default diff/merge tool

### 3.6 AWS Setup
- Verify AWS CLI is installed (from `windows_install.ps1`)
- Configure AWS credentials (prompts for access key and secret)
- Set default region
- Install AWS SAM CLI (Serverless Application Model)
- Install AWS CDK (Cloud Development Kit)
- Test AWS connection with `aws sts get-caller-identity`

### 3.7 Verification & Summary
- Check all tool versions:
  - WSL/Ubuntu, Docker, Node.js, Python, Git, AWS CLI
- Run basic tests:
  - `docker run hello-world`
  - `wsl --status`
  - `node --version`, `python --version`
- Display summary report with installed versions
- List any failures or warnings

**Expected Runtime**: 30-60 minutes

**Post-Script Actions**:
- Restart computer
- Configure cloud credentials if needed
- Test WSL and Docker setup

**Note**: This script is still being defined. Check back for updates.

---

## Script Execution Order

**Recommended sequence for fresh PC**:

```powershell
# 1. Core system setup (REQUIRED)
.\windows_install.ps1

# Restart computer

# 2. Development environment (for developers)
.\dev_setup.ps1

# Restart computer

# 3. VS Code extensions (optional, for VS Code users)
.\vscode_extensions.ps1
```

**Modular approach**: Each script can run independently, but optimal results come from running in order.

---

## Design Principles

### Idempotency
- Scripts can be run multiple times safely
- Check for existing installations before installing
- Skip already-configured settings

### Error Resilience
- Don't exit on single package failure
- Track and report failures at the end
- Provide meaningful error messages

### User Feedback
- Color-coded console output
- Progress indicators
- Summary reports
- Clear next steps

### Modularity
- Separate concerns (system setup vs. dev tools vs. editor)
- Easy to customize individual scripts
- Can run scripts independently

### Documentation
- Inline comments for complex operations
- README with usage instructions
- This specification document
- DEVELOPMENT.md for contribution guidelines

---

## Future Enhancements

### Planned Features
- [ ] Configuration file for package customization
- [ ] Optional package groups (gaming, design, streaming)
- [ ] Silent/unattended mode
- [ ] Update/upgrade script for existing installations
- [ ] Backup/restore script for configurations

### Won't Implement
- ❌ GUI interface (terminal is sufficient)
- ❌ Cross-platform single script (separate scripts are clearer)
- ❌ Package manager abstraction (Chocolatey works great)

---

## Troubleshooting

### Common Issues

**Script won't run**:
- Ensure running as Administrator
- Check execution policy: `Set-ExecutionPolicy Bypass -Scope Process`

**Chocolatey installation fails**:
- Check internet connection
- Disable antivirus temporarily
- Run: `[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072`

**Package installation fails**:
- Check Chocolatey package exists: `choco search <package>`
- Try manual installation
- Check logs: `C:\ProgramData\chocolatey\logs\`

**WSL installation fails**:
- Ensure Windows version supports WSL2 (2004+)
- Enable virtualization in BIOS
- Run: `wsl --install` manually

**Docker Desktop fails to start**:
- Ensure WSL2 is installed and running
- Check Hyper-V is enabled
- Restart computer after installation

---

## Support & Contributing

- **Issues**: https://github.com/peeweeh/pc-setup/issues
- **Contributing**: See [CONTRIBUTING.md](../CONTRIBUTING.md)
- **Development**: See [DEVELOPMENT.md](../DEVELOPMENT.md)

---

*Last Updated: December 14, 2025*