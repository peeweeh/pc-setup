# macOS Setup Scripts - Quick Reference

**Author**: [@mrfixit027](https://github.com/mrfixit027)

This document is a quick reference guide for the macOS setup scripts. For comprehensive documentation, see the [root spec.md](../spec.md).

## Quick Start

**Run the interactive installer:**
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/install.sh)
```

Then select from the menu:
1. **Install Applications** (brew_install.sh)
2. **Optimize System** (mac_install.sh)
3. **Install VS Code Extensions** (vscode.sh)
4. **Privacy Hardening** (privacy.sh)
5. **Install ALL** (recommended for fresh Mac)

---

## Script Overview

### install.sh - Interactive Installer
**Purpose**: Main entry point with menu-driven script selection.

**Features**:
- Colored menu interface
- 5 installation options
- Downloads scripts from GitHub
- Handles sudo elevation automatically
- Progress tracking

**Run directly**:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/install.sh)
```

---

### brew_install.sh - Install Applications
**Purpose**: Install 40+ applications and CLI tools via Homebrew.

**What it does**:
- Installs Homebrew (if needed)
- Installs 40+ applications (1Password, Arc, VS Code, Docker, Git, Node, etc)
- Installs 20+ CLI tools (bat, fzf, btop, ripgrep, eza, etc)
- Sets up Oh My Zsh with Powerlevel10k
- Disables auto-start for heavy services (Docker, Ollama, VPNs)

**Run directly**:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/brew_install.sh)
```

**Time**: 5-10 minutes

---

### mac_install.sh - Optimize System
**Purpose**: Performance and UI optimization for macOS.

**What it does**:
- **Performance**: Disables Photos AI, Media AI, Game Center, Siri
- **UI Speed**: Instant animations, faster Dock, instant Finder
- **System Config**: Dock auto-hide, Finder customization, keyboard/trackpad tuning
- **Terminal**: Nord theme, Oh My Zsh plugins
- **Security**: Firewall, fast keyboard repeat, auto-update

**Run directly**:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/mac_install.sh)
```

**Time**: 2-3 minutes

**Note**: Restart recommended for full effect.

---

### vscode.sh - Install VS Code Extensions
**Purpose**: Install 68+ professionally-selected VS Code extensions.

**What it includes**:
- AI Assistants (Copilot, Amazon Q, Claude)
- Themes (Nord, Dracula, Tokyo Night)
- Languages (Python, JavaScript, Go, GraphQL, Rust)
- DevOps (Docker, Kubernetes, Terraform, AWS)
- Git tools (GitLens, Git History)
- Jupyter notebooks, Markdown, REST Client
- Gaming/modding tools

**Run directly**:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/vscode.sh)
```

**Requirements**:
- VS Code installed
- VS Code CLI in PATH (Cmd+Shift+P → "Shell Command: Install 'code' command in PATH")

**Time**: 5-10 minutes

---

### privacy.sh - Privacy & Security Hardening
**Purpose**: Comprehensive privacy and security hardening (831 lines).

**What it does**:
- Disables all Siri services
- Blocks telemetry (Firefox, Office, .NET, PowerShell)
- Clears caches (system, CUPS, Xcode, DNS)
- Hardens security (firewall, removes guest user, disables remote access)
- Configures privacy settings (location, Bluetooth, camera/mic)

**Run directly**:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/privacy.sh)
```

**⚠️ Warning**: Advanced script. Review before running.

**Time**: 5-10 minutes

**Note**: System restart recommended.

---

## Common Tasks

### Just Install Applications (No Optimization)
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/brew_install.sh)
```

### Just Optimize System Performance
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/mac_install.sh)
```

### Just Install VS Code Extensions
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/vscode.sh)
```

### Install Everything (Fresh Mac Setup)
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/install.sh)
# Select option 5
```

### Run Script from Cloned Repository
```bash
git clone https://github.com/peeweeh/pc-setup.git
cd pc-setup/mac
chmod +x *.sh
./install.sh
```

---

## Applications Installed

**Essentials** (installed first):
- 1Password, Arc, VS Code

**Browsers**:
- Google Chrome, Brave

**Communication**:
- Slack, Teams, Discord, Signal, WhatsApp, Zoom, Telegram

**Development**:
- Git, GitHub Desktop, Postman, Warp, Docker, AWS CLI, AWS Nuke, Fig, DevToys, Node.js, Go, Python, Ollama

**Utilities**:
- Rectangle, Raycast, BetterMouse, Clipy, Moom, Alfred

**CLI Tools**:
- bat, fzf, btop, eza, exa, ripgrep, fd, jq, zoxide

**Productivity**:
- ChatGPT, Claude, Evernote, Obsidian, Microsoft Office

**Enterprise**:
- Microsoft Teams, Amazon Chime, Amazon Workspaces, Microsoft Remote Desktop, Google Drive, OneDrive

**Cloud/VPN**:
- NordVPN, ProtonVPN

**Media**:
- VLC, Ferdium

**Heavy Apps** (installed last):
- Docker Desktop, Figma, Steam

**Fonts**:
- Fira Code, Fira Code Nerd Font, Hack Nerd Font

---

## VS Code Extensions Installed

**By Category:**

**AI**: Copilot, Copilot Chat, Amazon Q, Continue, Claude
**Themes**: Nord, Tokyo Night, Dracula, One Dark, Shades of Purple, vscode-icons
**AWS**: AWS Toolkit, Terraform, CloudFormation, CFN Lint
**Code Quality**: ESLint, Prettier, Pylance, CodeSnap, Turbo Console Log
**Git**: GitLens, Git History, Atlassian
**Languages**: Python, JavaScript, Go, GraphQL, Rust, C++, SQL, Markdown
**DevOps**: Docker, Kubernetes, Remote SSH, Dev Containers, GitHub Actions, Tilt
**Data**: Jupyter, REST Client, Thunder Client
**Gaming**: CK2/CK3/Anno 1800 modding tools

---

## Troubleshooting

### Script Won't Run
```bash
# Make executable
chmod +x install.sh

# Run with bash explicitly
bash ./install.sh
```

### Homebrew Not in PATH
```bash
# Add to ~/.zprofile (Apple Silicon)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
source ~/.zprofile

# Intel Macs
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
source ~/.zprofile
```

### VS Code Extensions Won't Install
```bash
# Check VS Code CLI
code --version

# If not found, open VS Code and run:
# Cmd+Shift+P → "Shell Command: Install 'code' command in PATH"
```

### Permission Denied
```bash
# Run with sudo for system optimization scripts
sudo bash ./mac_install.sh
sudo bash ./privacy.sh
```

### Revert Changes
Most changes are configuration-based and can be reverted manually:

- **Dock settings**: System Preferences → Dock
- **Finder settings**: Finder → Preferences
- **Keyboard**: System Preferences → Keyboard
- **Trackpad**: System Preferences → Trackpad

For Spotlight re-enabling:
```bash
sudo mdutil -i on -a
```

---

## What Each Script Does (Quick Reference)

| Script | Installs | Configures | Disables | Time |
|--------|----------|-----------|----------|------|
| **brew_install.sh** | 40+ apps, 20+ CLIs, fonts | Oh My Zsh, shell aliases | Docker/Ollama/VPN auto-start | 5-10m |
| **mac_install.sh** | — | Dock, Finder, keyboard, terminal | Siri, Photos AI, animations | 2-3m |
| **vscode.sh** | 68+ extensions | Extension categories | — | 5-10m |
| **privacy.sh** | — | Firewall, security | Siri, telemetry, location | 5-10m |

---

## Recommended Installation Order

For a fresh Mac:
1. Run `install.sh` and select "Install ALL"
2. Or manually in this order:
   - brew_install.sh (applications)
   - mac_install.sh (optimization)
   - vscode.sh (extensions)
   - privacy.sh (privacy hardening)

---

## File Locations

After installation, key files are located at:

**Homebrew**: `/opt/homebrew/` (Apple Silicon) or `/usr/local/` (Intel)
**Oh My Zsh**: `~/.oh-my-zsh/`
**Powerlevel10k**: `~/.powerlevel10k/`
**VS Code Config**: `~/.config/Code/` or `~/Library/Application Support/Code/`
**Nord Terminal Theme**: Downloaded to temporary location during script

---

## For More Information

- **Root README.md**: Full feature descriptions and prerequisites
- **Root spec.md**: Comprehensive technical documentation
- **GitHub**: https://github.com/peeweeh/pc-setup
- **Issues**: https://github.com/peeweeh/pc-setup/issues

---

## Performance Impact

After running all scripts, expect:

- ✅ **Faster system responses** - No lag in Finder, Mission Control, Dock
- ✅ **Reduced battery drain** - No background Siri, Photos AI, Game Center
- ✅ **Cleaner interface** - Hidden Dock, cleaned up Finder, minimal animations
- ✅ **Better development setup** - All tools pre-configured and ready
- ✅ **Enhanced privacy** - Telemetry disabled, firewall enabled

---

**Last Updated**: 2024
**Author**: [@mrfixit027](https://github.com/mrfixit027)