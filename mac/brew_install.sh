#!/bin/bash
#
print_header "Homebrew Application Installation Script"
echo -e "${CYAN}Author: mrfixit027 | https://github.com/peeweeh/pc-setup${NC}\n"

# Check if Homebrew is installed, install if not
# Author: mrfixit027
# Repository: https://github.com/peeweeh/pc-setup
#

set -e  # Exit on error
set -u  # Exit on undefined variable

# ── Sudo keep-alive ─────────────────────────────────────────────────────────────
# Some cask installs need sudo (e.g. microsoft-office, docker-desktop).
# Ask once upfront and keep the session alive in the background.
echo ""
echo -e "\033[1;33m[NOTE]\033[0m Some Homebrew casks require sudo. Enter your password once now"
echo -e "       and it will be kept alive for the rest of the install.\n"
sudo -v
# Background loop: refresh sudo timestamp every 50s until this script exits
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &
SUDO_KEEPALIVE_PID=$!
trap 'kill $SUDO_KEEPALIVE_PID 2>/dev/null' EXIT

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

# Check if Homebrew is installed, install if not
if ! command -v brew &> /dev/null; then
    print_warning "Homebrew not found. Installing Homebrew..."
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
print_info "Updating Homebrew..."
brew update
brew upgrade

# ── App Tiers ───────────────────────────────────────────────────────────────────
#   Essential    = core utilities + web-dev tools (always included)
#   Productivity = Essential + browsers, comms, productivity (no heavy stuff)
#   Everything   = all of the above + office, cloud, enterprise, heavy apps

# ── Tier 1: Essential ───────────────────────────────────────────────────────────
essential_apps=(
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
  gh
  copilot-cli

  # Python linters / formatters
  ruff
  vulture
  black
  isort
  flake8
  docker-desktop
)

# ── Tier 2: Productivity (adds on top of Essential) ────────────────────────────
productivity_apps=(
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

# ── Tier 3: Everything (adds on top of Productivity) ───────────────────────────
everything_apps=(
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

  # Heavy / large installs
  
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
echo -e "${GREEN}║  1) Essential      – Dev tools & core utilities            ║${NC}"
echo -e "${GREEN}║     1password, arc, vscode, raycast, postman, etc.        ║${NC}"
echo -e "${GREEN}║     (~25 apps, ~5 min)                                     ║${NC}"
echo -e "${GREEN}║                                                            ║${NC}"
echo -e "${GREEN}║  2) Productivity   – Essential + browsers & comms          ║${NC}"
echo -e "${GREEN}║     + chrome, brave, slack, discord, obsidian, zoom        ║${NC}"
echo -e "${GREEN}║     (~40 apps, ~15-20 min)                                 ║${NC}"
echo -e "${GREEN}║                                                            ║${NC}"
echo -e "${GREEN}║  3) Everything     – All 50+ apps                          ║${NC}"
echo -e "${GREEN}║     + office, cloud, docker, figma, steam, etc.           ║${NC}"
echo -e "${GREEN}║     (~50+ apps, ~30-60 min)                                ║${NC}"
echo -e "${GREEN}║                                                            ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

while true; do
  read -rp "Enter choice [1, 2, or 3]: " install_mode
  case "$install_mode" in
    1|2|3) break ;;
    *) print_warning "Please enter 1, 2, or 3" ;;
  esac
done

# Build the final app list (tiers are cumulative)
apps_to_install=("${essential_apps[@]}")

if [[ "$install_mode" -ge 2 ]]; then
  apps_to_install+=("${productivity_apps[@]}")
fi

if [[ "$install_mode" -ge 3 ]]; then
  apps_to_install+=("${everything_apps[@]}")
fi

echo ""
print_info "Installing ${#apps_to_install[@]} applications..."

# Install selected applications using Homebrew Cask
for app in "${apps_to_install[@]}"; do
  if brew list --cask | grep -q "^${app}\$"; then
    print_warning "$app is already installed, skipping..."
  else
    print_info "Installing $app..."
    brew install --cask "$app" || print_error "Failed to install $app"
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
    print_info "Installing $font..."
    brew install --cask "$font" || print_error "Failed to install $font"
  fi
done


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
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi
    
    # Install zsh-autosuggestions
    if [[ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
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
)

for tool in "${cli_tools[@]}"; do
  if brew list --formula | grep -q "^${tool}\$"; then
    print_warning "$tool is already installed, skipping..."
  else
    print_info "Installing $tool..."
    brew install "$tool" || print_error "Failed to install $tool"
  fi
done

# Stop auto-starting services for heavy applications
print_info "Configuring services to not auto-start..."

# Stop and disable Docker Desktop auto-start
if brew list --cask | grep -q "docker-desktop"; then
  print_info "Disabling Docker Desktop auto-start..."
  osascript -e 'tell application "System Events" to delete login item "Docker"' 2>/dev/null || true
fi

# Stop and disable Ollama service
if brew list --formula | grep -q "ollama"; then
  print_info "Stopping Ollama service..."
  brew services stop ollama 2>/dev/null || true
fi

# Stop and disable VPN auto-start
for vpn in nordvpn protonvpn; do
  if brew list --cask | grep -q "$vpn"; then
    print_info "Disabling $vpn auto-start..."
    osascript -e "tell application \"System Events\" to delete login item \"$vpn\"" 2>/dev/null || true
  fi
done

print_info "Services configured for manual start"

# Cleanup
print_info "Cleaning up..."
brew cleanup

print_info "${GREEN}Installation complete!${NC}"
print_info "Please restart your terminal or run: source ~/.zshrc"
print_info ""
print_info "Note: Docker Desktop, Ollama, and VPN services are set to manual start."
print_info "Start them manually when needed."
