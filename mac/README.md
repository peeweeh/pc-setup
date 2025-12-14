# macOS Setup Scripts

## Overview

This directory contains three main scripts for setting up and optimizing your Mac:

### 🚀 `brew_install.sh` - Application Installation
**Purpose**: Install applications and development tools via Homebrew  
**Run with**: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/brew_install.sh)"`

**Features**:
- Auto-installs Homebrew if not present
- Installs 40+ essential applications (1Password, Arc, VSCode, Docker, etc.)
- Smart ordering: priority apps first, heavy apps last
- Configures shell with Powerlevel10k
- Installs CLI tools (git, go, node, docker, etc.)
- Disables auto-start for heavy services (Docker, Ollama, VPNs)
- Safe to run multiple times (idempotent)

---

### ⚡ `mac_install.sh` - Performance & UI Optimization
**Purpose**: Optimize macOS for better performance, battery life, and UI speed  
**Run with**: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/mac_install.sh)"`

**Features**:

#### Performance & Battery
- ✓ Disables Siri daemon and analytics
- ✓ Disables Photos AI analysis (huge battery saver)
- ✓ Disables Media AI analysis (video indexing)
- ✓ Disables Game Center daemon
- ✓ Fixes macOS 26 heuristic lag bug
- ✓ Optimizes Electron app GPU usage (Chrome/Slack/VSCode)
- ✓ Disables Spotlight indexing (saves I/O)
- ✓ Disables crash reporter dialogs
- ✓ Disables print spooler (CUPS)

#### UI Speed
- ✓ Instant window resizing
- ✓ Instant Dock appearance (no hover delay)
- ✓ Disables all Finder animations
- ✓ Faster Mission Control
- ✓ No Launchpad animation

#### System Configuration
- ✓ Dock: auto-hide, clean layout, instant appearance
- ✓ Finder: show hidden files, extensions, path bar, status bar
- ✓ Trackpad: tap to click, three-finger drag
- ✓ Keyboard: fast repeat rate
- ✓ Screenshots saved to ~/Documents/Screenshots
- ✓ Installs Nord Terminal theme
- ✓ Configures Oh My Zsh plugins

---

### 🔒 `privacy.sh` - Advanced Privacy Hardening
**Purpose**: Comprehensive privacy and security hardening (831 lines)  
**Run with**: `sudo /Users/paul/dev/pc-setup/mac/privacy.sh`

**⚠️ WARNING**: This is an advanced script with extensive system changes. Review before running!

**Features**:

#### Privacy & Telemetry
- Comprehensive Siri disabling (all services and data collection)
- Disables telemetry for: Firefox, Microsoft Office, Homebrew, .NET Core, PowerShell
- Disables location services
- Disables remote management services

#### System Cleaning
- Clears CUPS printer cache
- Empties trash on all volumes
- Clears system and user caches
- Clears Xcode derived data
- Flushes DNS cache
- Purges inactive memory

#### Security Hardening
- Enables application firewall
- Removes guest user account
- Disables remote access services
- Configures iCloud privacy settings

**Note**: `mac_install.sh` includes the most important performance/battery optimizations. Use `privacy.sh` for comprehensive privacy hardening.

---

### 🔧 `vscode.sh` - VS Code Extensions
**Purpose**: Install 68+ VS Code extensions  
**Run with**: `/Users/paul/dev/pc-setup/mac/vscode.sh`

**Features**:
- AI assistants (GitHub Copilot, Amazon Q, Claude Dev)
- Themes (Nord, Tokyo Night, Material Theme, etc.)
- Language support (Python, JavaScript, Go, GraphQL)
- DevOps tools (Docker, Kubernetes, Terraform)
- Git tools (GitLens, Git History)
- Colored progress output
- Generates backup script

---

## Recommended Setup Order

For a fresh Mac setup, run in this order:

1. **Install applications**: `brew_install.sh`
2. **Optimize system**: `mac_install.sh`
3. **Install extensions**: `vscode.sh`
4. **Privacy hardening** (optional): `privacy.sh`

---

## Script Comparison

| Feature | mac_install.sh | privacy.sh |
|---------|----------------|------------|
| **Siri** | ✓ Disables daemon & analytics | ✓ Comprehensive (all services) |
| **Photos/Media AI** | ✓ Disables | ❌ Not included |
| **Game Center** | ✓ Disables | ❌ Not included |
| **Spotlight** | ✓ Disables indexing | ❌ Not included |
| **Crash Reporter** | ✓ Disables dialogs | ❌ Not included |
| **CUPS Printer** | ✓ Disables service | ✓ Clears cache |
| **UI Optimizations** | ✓ Extensive | ❌ Not included |
| **Finder Config** | ✓ Complete setup | ❌ Not included |
| **Dock Config** | ✓ Complete setup | ❌ Not included |
| **Telemetry** | ❌ Not included | ✓ All apps (Firefox, Office, etc.) |
| **Cache Cleaning** | ❌ Not included | ✓ Comprehensive |
| **Firewall** | ❌ Not included | ✓ Enabled |
| **Remote Access** | ❌ Not included | ✓ Disabled |
| **iCloud Privacy** | ❌ Not included | ✓ Configured |

---

## Support

All scripts include:
- ✓ Error handling
- ✓ Colored output
- ✓ Progress messages
- ✓ Revert instructions (where applicable)
- ✓ Syntax validation

For issues or questions, check the main repository README.
