# macOS Setup Scripts - Quick Reference

**Author**: [@mrfixit027](https://github.com/mrfixit027)

This document is a quick reference guide for the macOS setup scripts. For comprehensive documentation, see the [root spec.md](../spec.md).

## Quick Start

**Run the interactive installer:**
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/install.sh)
```

Then select from the menu:
1. **Install Light** (core apps, development tools and fonts)
2. **Install Heavy** (Light plus Office, Docker, cloud and other large apps)
3. **Install Optimizations** (system and privacy hardening)
4. **Install ALL** (Heavy followed by optimizations)

---

## Script Overview

### install.sh - Interactive Installer
**Purpose**: Main entry point with menu-driven script selection.

**Features**:
- Colored menu interface
- 4 installation options
- Uses local scripts when available, otherwise downloads from GitHub
- Prompts for authorization when required
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
- Installs 40+ applications (1Password, Helium, VS Code, Docker, Git, Node, etc)
- Installs 20+ CLI tools (bat, fzf, btop, ripgrep, eza, etc)
- Installs Hermes Agent using its official shell installer
- Installs missing Word, Excel, PowerPoint and Outlook from signed Microsoft packages
- Registers Nerd Fonts with macOS and applies one to Terminal's existing profiles
- Sets up Oh My Zsh with Powerlevel10k
- Attempts to remove current login items and disable newly added LaunchAgents

**Run directly**:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/brew_install.sh)
# Or pass light or heavy to select a tier directly
```

**Time**: approximately 15-70 minutes, depending on tier and downloads

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
# Select option 4 and confirm the optimization and privacy changes
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

`brew_install.sh` prompts for a tier (Light or Heavy); Heavy installs everything in
Light plus the heavier/slower items. The main menu passes the selected tier directly.

**Light tier**:
- Core utilities: 1Password, Comet, BetterMouse, Clipy, CrossOver, Moom, Rectangle, Raycast, Task Manager TMOG, The Unarchiver
- Creative & AI: ArtCraft and ArtCraft Launcher (the launcher updates itself)
- Dev tools: GitHub Desktop, Postman, Sourcetree, VS Code, Warp, DevToys, Copilot CLI
- Browsers: Brave, Google Chrome, Helium
- Communication: Signal, Telegram, WhatsApp, Discord, Slack, Beeper
- Productivity: ChatGPT, Claude, Obsidian, Perplexity, VLC, Zoom

**Heavy tier** (adds on top of Light):
- Cloud & VPN: ProtonVPN, Proton Mail, Proton Drive, Google Drive, OneDrive
- Microsoft Word, Excel, PowerPoint, Outlook, Teams and Windows App
- Amazon Workspaces
- Docker Desktop, Figma, Home Assistant, iStat Menus, Steam and Yogurt

Office apps already present are left untouched, including Mac App Store installs.
Missing apps are installed individually from Microsoft after checking their signatures.
Yogurt is installed through its official Homebrew tap, with the release checksum
verified; it requires Apple Silicon and macOS 14.4 or newer.

**CLI Tools** (both tiers):
- actionlint, git, gh, awscli, aws-nuke, bash, bat, btop, coreutils,
  diff-so-fancy, docker, eza, fontconfig, fzf, go, node, ollama, pandoc, pipx,
  powerlevel10k, Python 3.14 and 3.15, ripgrep, serverless, tailscale, telnet,
  tirith, tree, uv
- Python linters/formatters: ruff, black, isort, flake8, vulture
- Hermes Agent via its official shell installer; run `hermes setup` to configure it

Both tiers also include the current Homebrew formula inventory, including dependency
libraries. On a new Mac these may be marked as explicitly installed by Homebrew.
Hermes is the exception: it uses the official shell installer instead of its formula.

**Fonts**:
- Fira Code, Fira Code Nerd Font, Hack Nerd Font

**Background activity**: after installing, `brew_install.sh` attempts to remove all login
items and disables any newly-added background LaunchAgents, so nothing runs
in the background automatically - open apps manually when you need them.

---

## Troubleshooting

### Test Installer Changes
```bash
bash mac/test_install.sh
```
The tests use isolated mock commands; they do not install applications or run optimizations.

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
`brew_install.sh` registers Fira Code and Hack with macOS and applies FiraCode Nerd Font
Mono to Terminal's default and startup profiles without changing their colors or font
sizes. If icons still look wrong, open a new terminal tab or restart the terminal:
```bash
# Verify the fonts are actually installed
ls ~/Library/Fonts | grep -i nerd

# Manually set the font: Terminal > Settings > Profiles > Text > Font
# Choose "FiraCode Nerd Font Mono" or "Hack Nerd Font Mono"
```
For VS Code, set `terminal.integrated.fontFamily` to `'FiraCode Nerd Font Mono'`.
Other terminals, including Warp, may need the font selected in their settings.

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
| **brew_install.sh** | Apps, CLIs, Hermes, fonts | Oh My Zsh, shell aliases | Login items and new LaunchAgents | 15-70m |
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