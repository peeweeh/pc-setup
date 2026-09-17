#!/bin/bash
#
# Homebrew Application Installation Script
# Author: mrfixit027
# Repository: https://github.com/peeweeh/pc-setup
#

set -e  # Exit on error
set -u  # Exit on undefined variable

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_header() {
    echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${MAGENTA}$1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# ── Spinner / animated progress ─────────────────────────────────────────────────
# Runs a command in the background with a fun animated spinner in front of it,
# hiding its (often very noisy) stdout/stderr unless it actually fails - in which
# case the captured output is dumped so you can debug it.
SPINNER_FRAMES=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)

run_spinner() {
  local msg="$1"; shift
  local logfile
  logfile=$(mktemp)
  "$@" > "$logfile" 2>&1 &
  local pid=$!
  local i=0
  tput civis 2>/dev/null || true
  while kill -0 "$pid" 2>/dev/null; do
    local frame="${SPINNER_FRAMES[$((i % ${#SPINNER_FRAMES[@]}))]}"
    printf "\r${CYAN}%s${NC} %s" "$frame" "$msg"
    i=$((i + 1))
    sleep 0.08
  done
  tput cnorm 2>/dev/null || true
  local status=0
  wait "$pid" || status=$?
  if [[ $status -eq 0 ]]; then
    printf "\r${GREEN}✓${NC} %s\n" "$msg"
  else
    printf "\r${RED}✗${NC} %s (failed)\n" "$msg"
    echo -e "${YELLOW}--- output ---${NC}"
    cat "$logfile"
    echo -e "${YELLOW}--------------${NC}"
  fi
  rm -f "$logfile"
  return $status
}

print_header "Homebrew Application Installation Script"
echo -e "${CYAN}Author: mrfixit027 | https://github.com/peeweeh/pc-setup${NC}\n"

# ── Refuse to run as root ────────────────────────────────────────────────────────
# Homebrew itself refuses to run as root, but other steps here (Oh My Zsh install,
# .zshrc edits) don't - and on macOS, `sudo <script>` preserves the invoking user's
# $HOME by default, so running this with sudo silently creates root-owned files
# inside YOUR home directory (e.g. ~/.oh-my-zsh), breaking later plugin installs
# with "Permission denied". Always run this script as your normal user; individual
# commands that need elevation prompt for sudo themselves.
if [[ "${EUID}" -eq 0 ]]; then
  print_error "Do not run this script with sudo or as root."
  echo "        Run it as your normal user: ./brew_install.sh"
  exit 1
fi

# ── Sudo keep-alive ─────────────────────────────────────────────────────────────
# Some cask installs need sudo (e.g. microsoft-office, docker-desktop).
# Ask once upfront and keep the session alive in the background.
echo ""
print_warning "Some Homebrew casks require sudo. Enter your password once now"
echo -e "       and it will be kept alive for the rest of the install.\n"
sudo -v
# Background loop: refresh sudo timestamp every 50s until this script exits
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &
SUDO_KEEPALIVE_PID=$!
trap 'kill $SUDO_KEEPALIVE_PID 2>/dev/null' EXIT

# Check if Homebrew is installed, install if not
if ! command -v brew &> /dev/null; then
    print_warning "Homebrew not found. Installing Homebrew..."
    # Not spinner-wrapped: the official installer needs interactive confirmation
    # (RETURN key press, password prompt) - hiding its output could hang silently.
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    print_info "Homebrew is already installed"
fi

# Update and upgrade Homebrew
run_spinner "Updating Homebrew..." brew update
run_spinner "Upgrading existing Homebrew packages..." brew upgrade

# ── App Tiers ───────────────────────────────────────────────────────────────────
#   Fast = everything except large/slow installs (office suites, Docker, VMs, games)
#   Slow = Fast + the heavy stuff that takes a long time to download/install

# ── Tier 1: Fast (core utilities, dev tools, browsers, comms, productivity) ────
fast_apps=(
  # Core utilities
  1password
  1password-cli
  arc
  comet
  bettermouse
  clipy
  moom
  rectangle
  raycast
  the-unarchiver

  # Dev tools
  github
  postman
  sourcetree
  visual-studio-code
  warp
  fig
  devtoys
  copilot-cli

  # Browsers
  brave-browser
  google-chrome

  # Communication
  signal
  telegram
  whatsapp
  discord
  slack
  beeper

  # Productivity
  chatgpt
  claude
  obsidian
  vlc
  zoom
)

# ── Tier 2: Slow (adds on top of Fast - large/slow installs) ───────────────────
slow_apps=(
  # Cloud & VPN
  protonvpn
  proton-mail
  proton-drive
  google-drive
  onedrive

  # Microsoft Office
  microsoft-office
  microsoft-teams
  microsoft-remote-desktop

  # Enterprise
  amazon-workspaces

  # Docker & heavy / large installs
  docker-desktop
  figma
  home-assistant
  istat-menus
  steam
)

# ── Installation Mode Selection ─────────────────────────────────────────────────
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          Choose What to Install                            ║${NC}"
echo -e "${GREEN}╠══════════════════════════════════════════════════════════════╣${NC}"
echo -e "${GREEN}║                                                            ║${NC}"
echo -e "${GREEN}║  1) Fast   – Dev tools, browsers, comms, productivity      ║${NC}"
echo -e "${GREEN}║     1password, arc, vscode, raycast, chrome, slack, etc.  ║${NC}"
echo -e "${GREEN}║     (~40 apps, ~15-20 min)                                 ║${NC}"
echo -e "${GREEN}║                                                            ║${NC}"
echo -e "${GREEN}║  2) Slow   – Fast + Office, Docker, cloud, and other       ║${NC}"
echo -e "${GREEN}║     large/slow installs (figma, steam, VPNs, etc.)        ║${NC}"
echo -e "${GREEN}║     (~55+ apps, ~40-70 min)                                ║${NC}"
echo -e "${GREEN}║                                                            ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

while true; do
  read -rp "Enter choice [1 or 2]: " install_mode
  case "$install_mode" in
    1|2) break ;;
    *) print_warning "Please enter 1 or 2" ;;
  esac
done

# Build the final app list (tiers are cumulative)
apps_to_install=("${fast_apps[@]}")

if [[ "$install_mode" -ge 2 ]]; then
  apps_to_install+=("${slow_apps[@]}")
fi

echo ""
print_info "Installing ${#apps_to_install[@]} applications..."

# Snapshot existing user LaunchAgents so we can tell which ones get added by the
# casks we're about to install (used later to disable their auto-start behavior).
BEFORE_LAUNCH_AGENTS=$(ls "$HOME/Library/LaunchAgents" 2>/dev/null || true)

# Install selected applications using Homebrew Cask
for app in "${apps_to_install[@]}"; do
  if brew list --cask | grep -q "^${app}\$"; then
    print_warning "$app is already installed, skipping..."
  else
    run_spinner "Installing $app..." brew install --cask "$app" || print_error "Failed to install $app"
  fi
done

# Install fonts
print_info "Installing fonts..."
#brew tap homebrew/cask-fonts

fonts=(
  font-fira-code
  font-fira-code-nerd-font
  font-hack-nerd-font
)

for font in "${fonts[@]}"; do
  if brew list --cask | grep -q "^${font}\$"; then
    print_warning "$font is already installed, skipping..."
  else
    run_spinner "Installing $font..." brew install --cask "$font" || print_error "Failed to install $font"
  fi
done

# Some cask font installs leave a com.apple.quarantine flag on the .ttf files, which
# prevents macOS from actually registering/enabling them (they sit on disk but never
# show up as usable fonts in Terminal/Font Book). Strip it defensively.
if [[ -d "$HOME/Library/Fonts" ]]; then
  find "$HOME/Library/Fonts" \( -iname "*fira*code*" -o -iname "*hack*nerd*" \) -print0 2>/dev/null \
    | xargs -0 xattr -d com.apple.quarantine 2>/dev/null || true
fi


# Install Oh My Zsh BEFORE we customize .zshrc below. Its installer replaces ~/.zshrc
# with its own default template (backing up any existing file), so it must run first -
# otherwise it would wipe out the Powerlevel10k/alias customizations added further down.
if [[ ! -d ~/.oh-my-zsh ]]; then
    run_spinner "Installing Oh My Zsh..." sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    print_warning "Oh My Zsh already installed, skipping..."
fi

# Configure shell (zsh) if not already configured
print_info "Configuring zsh shell..."

# Backup .zshrc if it exists and hasn't been backed up
if [[ -f ~/.zshrc ]] && [[ ! -f ~/.zshrc.bak ]]; then
    print_info "Backing up .zshrc..."
    cp ~/.zshrc ~/.zshrc.bak
fi

# Add Powerlevel10k theme to .zshrc if not already present
if ! grep -q "powerlevel10k.zsh-theme" ~/.zshrc 2>/dev/null; then
    print_info "Adding Powerlevel10k to .zshrc..."
    echo "source $(brew --prefix)/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc
fi

# Add aliases if not already present
if ! grep -q "alias ls='eza --icons always'" ~/.zshrc 2>/dev/null; then
    print_info "Adding shell aliases..."
    cat >> ~/.zshrc << 'EOF'

# Enhanced aliases
alias ls='eza --icons always'
alias ll='eza -la --icons always'
alias cat='bat'
alias fcd="fzf_cd"

# fzf enhanced cd function
fzf_cd() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m --preview "tree -C {} | head -200") && cd "$dir"
}
EOF
fi

# Install oh-my-zsh plugins if oh-my-zsh is installed
if [[ -d ~/.oh-my-zsh ]]; then
    print_info "Installing oh-my-zsh plugins..."
    
    # Install zsh-syntax-highlighting
    if [[ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]]; then
        run_spinner "Installing zsh-syntax-highlighting plugin..." git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi
    
    # Install zsh-autosuggestions
    if [[ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]]; then
        run_spinner "Installing zsh-autosuggestions plugin..." git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
    
    # Update plugins in .zshrc
    required_plugins=("git" "zsh-syntax-highlighting" "zsh-autosuggestions")
    
    # Read the current plugins from .zshrc
    if grep -q "^plugins=(" ~/.zshrc; then
        current_plugins=$(awk '/^plugins=\(/,/\)/' ~/.zshrc | sed 's/plugins=(//' | sed 's/)//' | tr -d '\n')
        IFS=' ' read -r -a current_plugins_array <<< "$current_plugins"
        
        # Ensure required plugins are in the current plugins array
        for plugin in "${required_plugins[@]}"; do
            if [[ ! " ${current_plugins_array[@]} " =~ " ${plugin} " ]]; then
                current_plugins_array+=("$plugin")
            fi
        done
        
        # Convert the array back to a space-separated string
        new_plugins=$(printf "%s " "${current_plugins_array[@]}")
        
        # Update .zshrc with the new plugins array
        sed -i '' "s/^plugins=(.*)/plugins=($new_plugins)/" ~/.zshrc
        
        print_info "Updated .zshrc with plugins: $new_plugins"
    fi
else
    print_warning "oh-my-zsh not installed. Skipping plugin installation."
    print_info "Install oh-my-zsh with: sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
fi

# Install command-line tools at the end
print_info "Installing command-line tools..."

cli_tools=(
  git
  aws-nuke
  awscli
  bat
  btop
  diff-so-fancy
  docker
  docker-completion
  eza
  fzf
  gh
  go
  node
  ollama
  pandoc
  pipx
  powerlevel10k
  serverless
  telnet
  tree
  uv

  # Python linters / formatters (formulas, not casks)
  ruff
  black
  isort
  flake8
  vulture
)

for tool in "${cli_tools[@]}"; do
  if brew list --formula | grep -q "^${tool}\$"; then
    print_warning "$tool is already installed, skipping..."
  else
    run_spinner "Installing $tool..." brew install "$tool" || print_error "Failed to install $tool"
  fi
done

# ── No background activity ──────────────────────────────────────────────────────
# Many of the apps above (Docker, cloud-sync clients, chat apps, VPNs) add
# themselves as login items or install background LaunchAgents during
# installation. Strip all of that so nothing runs in the background unless you
# explicitly open it.
print_info "Disabling background/auto-start activity for installed apps..."

# 1) Remove every current login item (System Events "Open at Login" list).
#    This covers most apps that register themselves this way (Docker, OneDrive,
#    Google Drive, Slack, Discord, Zoom, ChatGPT, Claude, VPN clients, etc.).
login_items=$(osascript -e 'tell application "System Events" to get the name of every login item' 2>/dev/null || true)
if [[ -n "$login_items" ]]; then
  IFS=', ' read -ra items_array <<< "$login_items"
  for item in "${items_array[@]}"; do
    [[ -z "$item" ]] && continue
    print_info "Removing login item: $item"
    osascript -e "tell application \"System Events\" to delete login item \"$item\"" 2>/dev/null || true
  done
else
  print_info "No login items found."
fi

# 2) Disable any user LaunchAgents that appeared during this run (cask installers
#    often drop a background helper agent here even when it's not a login item).
AFTER_LAUNCH_AGENTS=$(ls "$HOME/Library/LaunchAgents" 2>/dev/null || true)
new_agents=$(comm -13 <(echo "$BEFORE_LAUNCH_AGENTS" | sort) <(echo "$AFTER_LAUNCH_AGENTS" | sort))
if [[ -n "$new_agents" ]]; then
  while IFS= read -r agent_file; do
    [[ -z "$agent_file" ]] && continue
    plist_path="$HOME/Library/LaunchAgents/$agent_file"
    label=$(plutil -extract Label raw -o - "$plist_path" 2>/dev/null || true)
    if [[ -n "$label" ]]; then
      print_info "Disabling background agent: $label"
      launchctl bootout "gui/$(id -u)/$label" 2>/dev/null || true
      launchctl disable "gui/$(id -u)/$label" 2>/dev/null || true
    fi
  done <<< "$new_agents"
else
  print_info "No new background agents detected."
fi

# 3) Explicitly stop any Homebrew services that may have been auto-started
#    (e.g. `brew services start ollama` run previously).
if command -v ollama &>/dev/null; then
  brew services stop ollama 2>/dev/null || true
fi

print_info "Background/auto-start activity disabled for installed apps."
print_info "Open any app manually when you actually need it."

# Cleanup
run_spinner "Cleaning up Homebrew caches..." brew cleanup

print_info "${GREEN}Installation complete!${NC}"
print_info "Please restart your terminal or run: source ~/.zshrc"
print_info ""
print_info "Note: all installed apps' login items and background agents have been"
print_info "disabled. Open any app manually when you actually need it."
