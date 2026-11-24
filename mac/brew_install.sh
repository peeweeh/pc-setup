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

if [[ $# -gt 1 ]]; then
    print_error "Usage: $0 [light|heavy]"
    exit 2
fi

install_mode="${1:-}"
if [[ -z "$install_mode" ]]; then
    echo "1) Light - core apps, developer tools, fonts and shell"
    echo "2) Heavy - Light plus Office, Docker, cloud and other large apps"
    while true; do
        read -rp "Enter choice [1 or 2]: " choice
        case "$choice" in
            1) install_mode=light; break ;;
            2) install_mode=heavy; break ;;
            *) print_warning "Please enter 1 or 2" ;;
        esac
    done
fi
case "$install_mode" in
    light|heavy) ;;
    *) print_error "Usage: $0 [light|heavy]"; exit 2 ;;
esac

print_warning "This installer attempts to remove all login items and disable new LaunchAgents."
failed_installs=()

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
print_info "Upgrading existing Homebrew packages (some casks may request authorization)..."
brew upgrade

# ── App Tiers ───────────────────────────────────────────────────────────────────
#   Light = everything except large/slow installs (office suites, Docker, VMs, games)
#   Heavy = Light + the large/slow installs

# ── Tier 1: Light (core utilities, dev tools, browsers, comms, productivity) ────
light_apps=(
  # Core utilities
  1password
  1password-cli
  comet
  bettermouse
  clipy
  crossover
  moom
  rectangle
  raycast
  task-manager-tmog
  the-unarchiver

  # Creative & AI
  artcraft
  artcraft-launcher

  # Dev tools
  github
  postman
  sourcetree
  visual-studio-code
  warp
  devtoys
  copilot-cli

  # Browsers
  brave-browser
  google-chrome
  helium-browser

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
  perplexity
  vlc
  zoom
)

# ── Tier 2: Heavy (adds on top of Light - large/slow installs) ──────────────────
heavy_apps=(
  # Cloud & VPN
  protonvpn
  proton-mail
  proton-drive
  google-drive
  onedrive

  # Microsoft services
  microsoft-teams
  windows-app

  # Enterprise
  amazon-workspaces

  # Docker & heavy / large installs
  docker-desktop
  figma
  home-assistant
  istat-menus
  steam
  frigadehq/yogurt/yogurt
)

# Build the final app list (tiers are cumulative)
apps_to_install=("${light_apps[@]}")

if [[ "$install_mode" == heavy ]]; then
  apps_to_install+=("${heavy_apps[@]}")
fi

echo ""
print_info "Installing ${#apps_to_install[@]} $install_mode-tier Homebrew applications..."

# Snapshot existing user LaunchAgents so we can tell which ones get added by the
# casks we're about to install (used later to disable their auto-start behavior).
BEFORE_LAUNCH_AGENTS=$(ls "$HOME/Library/LaunchAgents" 2>/dev/null || true)

install_yogurt() {
  local version major minor metadata expected cache_path actual
  if [[ "$(uname -m)" != arm64 ]]; then
    print_error "Yogurt requires an Apple Silicon Mac."
    return 1
  fi
  version=$(sw_vers -productVersion) || return 1
  major="${version%%.*}"
  minor="${version#*.}"
  minor="${minor%%.*}"
  if [[ ! "$major" =~ ^[0-9]+$ || ! "$minor" =~ ^[0-9]+$ ]] ||
     (( major < 14 || (major == 14 && minor < 4) )); then
    print_error "Yogurt requires macOS 14.4 or newer (found $version)."
    return 1
  fi

  brew tap frigadehq/yogurt || return 1
  if brew help trust >/dev/null 2>&1; then
    brew trust --cask frigadehq/yogurt/yogurt || return 1
  fi
  brew fetch --force --cask frigadehq/yogurt/yogurt || return 1

  # The upstream cask uses :latest without a checksum; verify the release asset.
  metadata=$(curl -fsSL https://api.github.com/repos/FrigadeHQ/yogurt/releases/latest) || return 1
  expected=$(printf '%s' "$metadata" | python3 -c '
import json, sys
release = json.load(sys.stdin)
asset = next(a for a in release["assets"] if a["name"] == "Yogurt-mac-arm64.dmg")
print(asset["digest"].removeprefix("sha256:"))
') || return 1
  if [[ ! "$expected" =~ ^[0-9a-f]{64}$ ]]; then
    print_error "Yogurt release does not provide a valid SHA-256 digest."
    return 1
  fi
  cache_path=$(brew --cache --cask frigadehq/yogurt/yogurt) || return 1
  actual=$(shasum -a 256 "$cache_path") || return 1
  actual="${actual%% *}"
  if [[ "$actual" != "$expected" ]]; then
    print_error "Yogurt download checksum does not match the official release."
    return 1
  fi
  brew install --cask frigadehq/yogurt/yogurt
}

install_office_app() {
  local app="$1" link_id="$2" target workdir pkg signature status=0
  target="/Applications/Microsoft $app.app"
  if [[ -d "$target" ]]; then
    print_info "Microsoft $app is already installed; preserving the existing copy."
    return 0
  fi

  workdir=$(mktemp -d) || return 1
  pkg="$workdir/Microsoft-$app.pkg"
  print_info "Downloading Microsoft $app directly from Microsoft..."
  if ! curl -fL "https://go.microsoft.com/fwlink/?linkid=$link_id" -o "$pkg"; then
    print_error "Failed to download Microsoft $app."
    status=1
  elif ! signature=$(pkgutil --check-signature "$pkg" 2>&1); then
    print_error "Could not verify the Microsoft $app installer: $signature"
    status=1
  elif ! printf '%s\n' "$signature" | grep -Fq 'Developer ID Installer: Microsoft Corporation (UBF8T346G9)'; then
    print_error "Microsoft $app installer is not signed by Microsoft."
    status=1
  elif ! spctl --assess --type install "$pkg"; then
    print_error "macOS did not trust the Microsoft $app installer."
    status=1
  else
    print_info "Installing Microsoft $app (authorization may be required)..."
    if [[ -n "${SUDO_ASKPASS:-}" ]]; then
      sudo -A /usr/sbin/installer -pkg "$pkg" -target / || status=1
    else
      sudo /usr/sbin/installer -pkg "$pkg" -target / || status=1
    fi
    if [[ "$status" -ne 0 || ! -d "$target" ]]; then
      print_error "Microsoft $app did not install successfully."
      status=1
    fi
  fi
  rm -f "$pkg"
  rmdir "$workdir"
  return "$status"
}

# Install selected applications using Homebrew Cask
for app in "${apps_to_install[@]}"; do
  if brew list --cask "$app" >/dev/null 2>&1; then
    print_warning "$app is already installed, skipping..."
  elif [[ "$app" == frigadehq/yogurt/yogurt ]]; then
    if ! install_yogurt; then
      print_error "Failed to install Yogurt."
      failed_installs+=("Yogurt")
    fi
  else
    print_info "Installing $app (authorization may be required)..."
    if ! brew install --cask "$app"; then
      print_error "Failed to install $app."
      failed_installs+=("$app")
    fi
  fi
done

if [[ "$install_mode" == heavy ]]; then
  install_office_app Word 525134 || failed_installs+=("Microsoft Word")
  install_office_app Excel 525135 || failed_installs+=("Microsoft Excel")
  install_office_app PowerPoint 525136 || failed_installs+=("Microsoft PowerPoint")
  install_office_app Outlook 525137 || failed_installs+=("Microsoft Outlook")
fi

# Install fonts
print_info "Installing fonts..."
fonts=(
  font-fira-code
  font-fira-code-nerd-font
  font-hack-nerd-font
)

for font in "${fonts[@]}"; do
  if brew list --cask "$font" >/dev/null 2>&1; then
    print_warning "$font is already installed, skipping..."
  elif ! run_spinner "Installing $font..." brew install --cask "$font"; then
    print_error "Failed to install $font."
    failed_installs+=("$font")
  fi
done

register_nerd_fonts() {
  local font_dir font_file
  local font_files=()
  for font_dir in "$HOME/Library/Fonts" /Library/Fonts; do
    for font_file in "$font_dir"/FiraCode*.ttf "$font_dir"/HackNerdFont*.ttf; do
      [[ -f "$font_file" ]] && font_files+=("$font_file")
    done
  done
  if [[ ${#font_files[@]} -eq 0 ]]; then
    print_error "No Fira Code or Hack Nerd Font files found. Reinstall the font casks."
    return 1
  fi

  osascript -l JavaScript - "${font_files[@]}" <<'JXA'
ObjC.import('Foundation');
ObjC.import('AppKit');
ObjC.import('CoreText');
ObjC.import('CoreFoundation');
function run(paths) {
  var failures = [];
  paths.forEach(function (path) {
    var error = Ref();
    var url = $.NSURL.fileURLWithPath($(path));
    if (!$.CTFontManagerRegisterFontsForURL(url, 2, error)) {
      var code = error[0] ? Number($.CFErrorGetCode(error[0])) : 'unknown';
      if (code !== 105) failures.push(path + ' (CoreText error ' + code + ')');
    }
  });
  if (failures.length) throw Error(failures.join('\n'));
  ['FiraCodeNFM-Reg', 'HackNFM-Regular'].forEach(function (name) {
    if ($.NSFont.fontWithNameSize($(name), 13).isNil()) {
      throw Error(name + ' is not registered. Reinstall its Homebrew font cask.');
    }
  });
  return 'Nerd Fonts registered with macOS.';
}
JXA
}

if ! register_nerd_fonts; then
  print_error "Could not register the Nerd Fonts with macOS."
  failed_installs+=("Nerd Font registration")
elif osascript - 'FiraCodeNFM-Reg' <<'OSA'
on run argv
  set desiredFont to item 1 of argv
  tell application "Terminal"
    set font name of default settings to desiredFont
    set font name of startup settings to desiredFont
    if font name of default settings is not desiredFont or font name of startup settings is not desiredFont then
      error "Terminal did not retain the requested Nerd Font"
    end if
  end tell
end run
OSA
then
  print_info "FiraCode Nerd Font Mono applied to Terminal's default and startup profiles."
else
  print_error "Could not apply the Terminal font. Set FiraCode Nerd Font Mono in Terminal settings."
  failed_installs+=("Terminal font configuration")
fi
print_info "For VS Code, set terminal.integrated.fontFamily to 'FiraCode Nerd Font Mono'."

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
  actionlint
  git
  aws-nuke
  awscli
  bash
  bat
  btop
  coreutils
  diff-so-fancy
  docker
  docker-completion
  eza
  fontconfig
  fzf
  gh
  go
  node
  ollama
  pandoc
  pipx
  powerlevel10k
  python@3.14
  python@3.15
  ripgrep
  serverless
  shellcheck
  tailscale
  telnet
  tirith
  tree
  uv

  # Python linters / formatters (formulas, not casks)
  ruff
  black
  isort
  flake8
  vulture

  # Developer SDKs and audio
  cocoapods
  lame
)

homebrew_dependencies=(
  abseil
  ada-url
  aom
  aws-c-auth
  aws-c-cal
  aws-c-common
  aws-c-compression
  aws-c-event-stream
  aws-c-http
  aws-c-io
  aws-c-mqtt
  aws-c-s3
  aws-c-sdkutils
  aws-checksums
  brotli
  c-ares
  ca-certificates
  cairo
  certifi
  cffi
  cryptography
  dav1d
  fmt
  freetype
  fribidi
  gettext
  giflib
  glib
  gmp
  graphite2
  harfbuzz
  hdrhistogram_c
  highway
  icu4c@79
  jpeg-turbo
  json-c
  libavif
  libde265
  libffi
  libgit2
  libheif
  libimagequant
  libnghttp2
  libpng
  libraqm
  libssh2
  libtiff
  libunistring
  libuv
  libvmaf
  libx11
  libxau
  libxcb
  libxdmcp
  libxext
  libxrender
  little-cms2
  llhttp
  lz4
  lzo
  merve
  mlx
  mlx-c
  mpdecimal
  nbytes
  ncurses
  oniguruma
  openjpeg
  openssl@4
  pcre2
  pillow
  pixman
  pycparser
  pydantic
  readline
  rpds-py
  s2n
  simdjson
  simdutf
  sqlite
  uvwasi
  webp
  x265
  xorgproto
  xz
  zstd
)

for tool in "${cli_tools[@]}" "${homebrew_dependencies[@]}"; do
  if brew list --formula "$tool" >/dev/null 2>&1; then
    print_warning "$tool is already installed, skipping..."
  elif ! run_spinner "Installing $tool..." brew install "$tool"; then
    print_error "Failed to install $tool."
    failed_installs+=("$tool")
  fi
done

install_hermes() {
  local launcher="$HOME/.local/bin/hermes"
  local source_dir="${HERMES_HOME:-$HOME/.hermes}/hermes-agent"
  local installer status=0

  if [[ -x "$launcher" && -d "$source_dir/.git" ]]; then
    if "$launcher" --version; then
      print_info "The source-installed Hermes Agent is already available."
      return 0
    fi
    print_error "The existing source-installed Hermes Agent is not working."
    return 1
  fi
  if [[ -e "$launcher" || -e "$source_dir" ]]; then
    print_error "An existing Hermes launcher or checkout needs manual attention; it was not overwritten."
    return 1
  fi

  installer=$(mktemp) || return 1
  if ! curl -fsSL https://hermes-agent.nousresearch.com/install.sh -o "$installer"; then
    print_error "Failed to download the official Hermes installer."
    status=1
  elif ! /bin/bash "$installer" --non-interactive; then
    print_error "The official Hermes installer failed."
    status=1
  elif [[ ! -x "$launcher" ]] || ! "$launcher" --version; then
    print_error "Hermes installed without a working launcher at $launcher."
    status=1
  fi
  rm -f "$installer"
  return "$status"
}

if ! install_hermes; then
  failed_installs+=("Hermes Agent")
elif [[ "$(command -v hermes || true)" != "$HOME/.local/bin/hermes" ]]; then
  print_warning "Put ~/.local/bin before Homebrew in PATH to use the source-installed Hermes command."
fi

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

if [[ ${#failed_installs[@]} -gt 0 ]]; then
  print_error "Installation finished with failures:"
  printf '  - %s\n' "${failed_installs[@]}"
  exit 1
fi

print_info "${GREEN}Installation complete!${NC}"
print_info "Please restart your terminal or run: source ~/.zshrc"
print_info ""
print_info "Note: all installed apps' login items and background agents have been"
print_info "disabled. Open any app manually when you actually need it."
