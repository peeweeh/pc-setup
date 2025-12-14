# macOS Setup Scripts Specification

Simple and straightforward setup for macOS development and productivity.

---

## 1. `brew_install.sh` - Application Installation

**Purpose**: Install applications and CLI tools via Homebrew.

**What It Does**:

### 1.1 Homebrew Setup
- Updates Homebrew
- Upgrades existing packages

### 1.2 CLI Tools
- git, awscli, aws-nuke
- bat (cat with syntax highlighting)
- fzf (fuzzy finder)
- eza (modern ls replacement)
- tree, diff-so-fancy
- powerlevel10k (zsh theme)

### 1.3 Applications (via Cask)
**Productivity**: 1Password, Rectangle/Moom, Alfred, Clipy, Toggl, Evernote, The Unarchiver

**Browsers**: Google Chrome, Brave, Arc

**Development**: VS Code, Sourcetree, DevToys, Postman, Fig

**Communication**: Microsoft Teams, Discord, Telegram, WhatsApp, Signal, Amazon Chime, Amazon Workspaces, Zoom, Beeper

**Media**: VLC

**Cloud**: Google Drive, Proton Mail, Proton Drive, NordVPN

**Office**: Microsoft Office, Microsoft Remote Desktop

**Gaming**: Steam

**AI**: ChatGPT

### 1.4 Fonts
- Hack Nerd Font
- FiraCode Nerd Font

### 1.5 Zsh Configuration
- Adds Powerlevel10k to `.zshrc`
- Sets up aliases: `ls` → `eza --icons`, `cat` → `bat`
- Adds `fcd` function (fuzzy directory change with preview)
- Installs zsh plugins: syntax-highlighting, autosuggestions
- Updates plugins in `.zshrc`

**Runtime**: 20-40 minutes

---

## 2. `mac_install.sh` - System Customization

**Purpose**: Optimize macOS settings and customize the UI.

**What It Does**:

### 2.1 Oh My Zsh
- Installs Oh My Zsh framework

### 2.2 Dock Tweaks
- Auto-hide dock
- Clear all dock items
- Resize to 36px
- Hide recent apps
- Remove auto-hide delay
- Faster animations

### 2.3 Terminal Theme
- Downloads Nord terminal theme
- Installs automatically

### 2.4 Finder Enhancements
- Show all file extensions
- Show hidden files
- Show path bar and status bar
- Column view by default
- Folders on top when sorting
- Search current folder by default
- Remove spring loading delay
- Home directory as default
- Hide recent tags
- Sidebar: Home, AirDrop, Downloads, iCloud only

### 2.5 Performance Tweaks
- Faster Mission Control (0.1s)
- Disable Dashboard
- No animations in Dock/Finder
- Blazing fast keyboard repeat (rate: 1, delay: 10)

### 2.6 Productivity Settings
- Expand save/print panels by default
- No .DS_Store on network/USB
- Screenshots → `~/Documents/Screenshots`
- Disable smart quotes/dashes (better for code)
- Disable auto-correct
- Enable tap to click
- Three-finger drag enabled
- Battery percentage in menu bar

### 2.7 Security
- Require password immediately after sleep
- No "Are you sure?" dialogs for apps

### 2.8 Automatic Updates
- Enable automatic macOS updates
- Enable automatic App Store updates

**Runtime**: 1-2 minutes

---

## 3. `vscode.sh` - VS Code Extensions

**Purpose**: Install VS Code extensions.

**Extensions** (40+):
- **GitHub**: Copilot, Git History
- **Languages**: Python, Go, GraphQL, YAML
- **Cloud/DevOps**: AWS Toolkit, Docker, Kubernetes, Terraform
- **Formatting**: Prettier, ESLint, Markdownlint
- **Productivity**: Live Server, Auto Close Tag, Turbo Console Log
- **Themes**: Nord, Material Icons, VS Code Icons
- **Remote**: Remote Containers, Live Share
- **Tools**: Snyk Security, Import Cost

**Runtime**: 5-10 minutes

---

## Script Execution Order

```bash
# 1. Install apps and CLI tools
chmod +x brew_install.sh
./brew_install.sh

# 2. Customize macOS settings
chmod +x mac_install.sh
./mac_install.sh

# 3. Install VS Code extensions (optional)
chmod +x vscode.sh
./vscode.sh
```

---

## Design Principles

- **Simple**: No complex logic, just install and configure
- **Safe**: Uses macOS defaults system for settings
- **Modular**: Each script has one clear purpose
- **Fast**: Most changes apply immediately

---

## Troubleshooting

**Homebrew not found**: Install with `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

**VS Code command not found**: Restart terminal after VS Code installation

**Settings not applying**: Run `killall Finder Dock SystemUIServer`

---

*Last Updated: December 14, 2025*