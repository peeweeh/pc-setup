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
2. **Optimize System & Harden Privacy** (mac_optimize.sh)
3. **Install ALL** (recommended for fresh Mac)

---

## Script Overview

### install.sh - Interactive Installer
**Purpose**: Main entry point with menu-driven script selection.

**Features**:
- Colored menu interface
- 3 installation options
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

### mac_optimize.sh - Optimize System & Harden Privacy
**Purpose**: Performance/UI optimization combined with privacy & security hardening for macOS.

**What it does**:
- **Performance**: Disables Photos AI, Media AI, Game Center, Siri
- **UI Speed**: Instant animations, faster Dock, instant Finder
- **System Config**: Dock auto-hide, Finder customization, keyboard/trackpad tuning
- **Terminal**: Nord theme, Oh My Zsh plugins
- **Privacy**: Comprehensive Siri disabling, telemetry blocking (Firefox, Office, .NET,
  PowerShell, Homebrew), AirDrop/Bonjour/advertising identifier disabling
- **Security**: Firewall (incl. stealth mode), Guest user removal, remote access hardening
- **Cleanup**: System/Xcode/DNS caches, quarantine and install logs, app caches (Docker,
  npm, Yarn, Homebrew, etc.)

**Run directly**:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/mac_optimize.sh)
```

**Time**: 5-10 minutes

**⚠️ Warning**: Advanced script covering both optimization and privacy/security hardening. Review before running.

**Note**: Restart recommended for full effect.

---

## Common Tasks

### Just Install Applications (No Optimization)
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/brew_install.sh)
```

### Just Optimize System & Harden Privacy
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/mac_optimize.sh)
```

### Install Everything (Fresh Mac Setup)
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/install.sh)
# Select option 3, then choose tier 2 (Slow) when prompted by brew_install.sh
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

`brew_install.sh` prompts for a tier (Fast or Slow); Slow installs everything in
Fast plus the heavier/slower items.

**Fast tier**:
- Core utilities: 1Password, Arc, Comet, BetterMouse, Clipy, Moom, Rectangle, Raycast, The Unarchiver
- Dev tools: GitHub Desktop, Postman, Sourcetree, VS Code, Warp, Fig, DevToys, Copilot CLI
- Browsers: Brave, Google Chrome
- Communication: Signal, Telegram, WhatsApp, Discord, Slack, Beeper
- Productivity: ChatGPT, Claude, Obsidian, VLC, Zoom

**Slow tier** (adds on top of Fast):
- Cloud & VPN: ProtonVPN, Proton Mail, Proton Drive, Google Drive, OneDrive
- Microsoft Office, Teams, Remote Desktop
- Amazon Workspaces
- Docker Desktop, Figma, Home Assistant, iStat Menus, Steam

**CLI Tools** (both tiers):
- git, gh, awscli, aws-nuke, bat, btop, diff-so-fancy, docker, eza, fzf, go, node,
  ollama, pandoc, pipx, powerlevel10k, serverless, telnet, tree, uv
- Python linters/formatters: ruff, black, isort, flake8, vulture

**Fonts**:
- Fira Code, Fira Code Nerd Font, Hack Nerd Font

**Background activity**: after installing, `brew_install.sh` removes all login
items and disables any newly-added background LaunchAgents, so nothing runs
in the background automatically - open apps manually when you need them.

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

### Icons Show as Boxes/`[?]` (Powerlevel10k, `eza --icons`)
The Nerd Fonts installed by `brew_install.sh` (Fira Code Nerd Font, Hack Nerd Font) are
correctly placed in `~/Library/Fonts`, but macOS Terminal.app doesn't automatically switch
to them. `mac_optimize.sh`'s Terminal theme step now applies a Nerd Font to the Nord/Basic
Terminal profiles automatically (run `brew_install.sh` **before** `mac_optimize.sh`, which
is the default order in `install.sh`'s "Install ALL" flow). If icons still look wrong:
```bash
# Verify the fonts are actually installed
ls ~/Library/Fonts | grep -i nerd

# Manually set the font: Terminal > Settings > Profiles > Text > Font
# Choose "Hack Nerd Font Mono" (default) or "FiraCode Nerd Font Mono"
```

### Permission Denied
```bash
# Individual commands in mac_optimize.sh elevate with sudo as needed and
# will prompt for your password - run the script as your normal user,
# not with `sudo` in front of the whole script.
bash ./mac_optimize.sh
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
| **mac_optimize.sh** | — | Dock, Finder, keyboard, terminal, firewall | Siri, telemetry, Photos AI, animations | 5-10m |

---

## Recommended Installation Order

For a fresh Mac:
1. Run `install.sh` and select "Install ALL"
2. Or manually in this order:
   - brew_install.sh (applications)
   - mac_optimize.sh (optimization + privacy hardening)

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