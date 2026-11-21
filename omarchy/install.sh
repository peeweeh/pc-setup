#!/bin/bash
#
# Omarchy one-time setup
# Repository: https://github.com/peeweeh/pc-setup
#
# Run as your desktop user on an installed Omarchy system:
#   bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/omarchy/install.sh)
#

set -u

ESC=$'\033'
if [[ -t 1 && -z ${NO_COLOR:-} ]]; then
  GREEN="${ESC}[38;5;46m"
  DIM_GREEN="${ESC}[38;5;22m"
  BRIGHT="${ESC}[1;97m"
  AMBER="${ESC}[38;5;214m"
  RED="${ESC}[38;5;196m"
  RESET="${ESC}[0m"
else
  GREEN=''; DIM_GREEN=''; BRIGHT=''; AMBER=''; RED=''; RESET=''
fi

ANIMATE=0
if [[ -t 1 && -z ${NO_COLOR:-} && -z ${PC_SETUP_NO_ANIM:-} && ${TERM:-dumb} != dumb ]]; then
  ANIMATE=1
fi

trap 'printf "%s%s" "$RESET" "${ESC}[?25h"' EXIT

print_info() { echo -e "${GREEN}[ >> ]${RESET} $1"; }
print_ok() { echo -e "${GREEN}[ OK ]${RESET} $1"; }
print_warning() { echo -e "${AMBER}[ !! ]${RESET} $1"; }
print_error() { echo -e "${RED}[FAIL]${RESET} $1" >&2; }

pause() {
  if (( ANIMATE )); then sleep "$1"; fi
  return 0
}

typewrite() {
  local text=$1 delay=${2:-0.01} i
  if (( ! ANIMATE )); then
    printf '%s' "$text"
    return 0
  fi
  for (( i = 0; i < ${#text}; i++ )); do
    printf '%s' "${text:i:1}"
    sleep "$delay"
  done
}

matrix_rain() {
  (( ANIMATE )) || return 0
  local rows cols glyphs='0123456789ABCDEF<>/\|*+-=' frame c r i
  local -a heads=()
  rows=$(tput lines 2>/dev/null) || rows=24
  cols=$(tput cols 2>/dev/null) || cols=80
  for (( c = 1; c <= cols; c += 2 )); do
    heads[c]=$(( RANDOM % rows + 1 ))
  done
  printf '%s[2J%s[?25l' "$ESC" "$ESC"
  for (( i = 0; i < 30; i++ )); do
    frame=''
    for c in "${!heads[@]}"; do
      r=${heads[c]}
      if (( r > 1 )); then
        frame+="${ESC}[$((r - 1));${c}H${GREEN}${glyphs:$(( RANDOM % ${#glyphs} )):1}"
      fi
      frame+="${ESC}[${r};${c}H${BRIGHT}${glyphs:$(( RANDOM % ${#glyphs} )):1}"
      heads[c]=$(( r >= rows ? 1 : r + 1 ))
    done
    printf '%s' "$frame"
    sleep 0.04
  done
  printf '%s[2J%s[H%s' "$ESC" "$ESC" "$RESET"
}

show_banner() {
  local line i
  if (( ! ANIMATE )); then
    for line in "$@"; do printf '%s%s%s\n' "$GREEN" "$line" "$RESET"; done
    return 0
  fi
  printf '%s[?25l' "$ESC"
  for line in "$@"; do
    printf '%s%s%s\n' "$GREEN" "$line" "$RESET"
    sleep 0.05
  done
  for (( i = 0; i < 2; i++ )); do
    printf '%s[%dA' "$ESC" "$#"
    for line in "$@"; do printf '%s%s%s\n' "$BRIGHT" "$line" "$RESET"; done
    sleep 0.07
    printf '%s[%dA' "$ESC" "$#"
    for line in "$@"; do printf '%s%s%s\n' "$GREEN" "$line" "$RESET"; done
    sleep 0.07
  done
  printf '%s[?25h' "$ESC"
}

boot_line() {
  printf '%s' "$DIM_GREEN"
  typewrite "$1" 0.008
  printf ' %s[%s]%s\n' "$2" "$3" "$RESET"
  pause 0.1
}

OMARCHY_BANNER=(
  " ██████╗ ███╗   ███╗ █████╗ ██████╗  ██████╗██╗  ██╗██╗   ██╗"
  "██╔═══██╗████╗ ████║██╔══██╗██╔══██╗██╔════╝██║  ██║╚██╗ ██╔╝"
  "██║   ██║██╔████╔██║███████║██████╔╝██║     ███████║ ╚████╔╝ "
  "██║   ██║██║╚██╔╝██║██╔══██║██╔══██╗██║     ██╔══██║  ╚██╔╝  "
  "╚██████╔╝██║ ╚═╝ ██║██║  ██║██║  ██║╚██████╗██║  ██║   ██║   "
  " ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   "
)

if (( EUID == 0 )); then
  print_error "Run this as your desktop user, not root or with sudo."
  exit 1
fi

if ! command -v omarchy-pkg-add >/dev/null 2>&1 || ! command -v omarchy-install-dictation-voxtype >/dev/null 2>&1; then
  print_error "This script must run on an installed Omarchy system."
  exit 1
fi

# Omarchy's signed repositories provide these packages on x86_64 and aarch64.
light_packages=(
  1password
  1password-cli
  helium-browser-bin
  brave-bin
  google-chrome
  claude-desktop
  visual-studio-code-bin
  github-copilot-cli
  signal-desktop
  telegram-desktop
  slack-desktop
  obsidian
  vlc
  actionlint
  git-delta
  python-ruff
  python-pipx
  ttf-firacode-nerd
  ttf-hack-nerd
)

heavy_packages=(
  proton-vpn-gtk-app
)

# Not published for aarch64 in Omarchy's repositories.
heavy_x86_packages=(
  discord
)

failed_installs=()

install_packages() {
  local package
  for package in "$@"; do
    print_info "installing $package"
    if omarchy-pkg-add "$package"; then
      print_ok "$package"
    else
      print_error "Failed to install $package."
      failed_installs+=("$package")
    fi
  done
}

install_light() {
  install_packages "${light_packages[@]}"
}

install_heavy() {
  install_packages "${heavy_packages[@]}"
  if [[ "$(uname -m)" == x86_64 ]]; then
    install_packages "${heavy_x86_packages[@]}"
  else
    print_warning "Skipping ${heavy_x86_packages[*]}: not published for this architecture."
  fi
  print_info "Installing Steam with Omarchy's graphics drivers..."
  omarchy-install-gaming-steam || failed_installs+=("steam")
}

# Local dictation keeps speech on this machine. Omarchy's fresh installs use cloud Superwhisper.
install_local_dictation() {
  print_info "Switching dictation to local Voxtype..."
  omarchy-install-dictation-voxtype || failed_installs+=("voxtype dictation")
}

menu_item() {
  printf '  %s%s%s ' "$BRIGHT" "$1" "$RESET"
  printf '%s' "$GREEN"
  typewrite "$2" 0.004
  printf '%s\n' "$RESET"
}

matrix_rain
show_banner "${OMARCHY_BANNER[@]}"
printf '\n'
boot_line "booting setup menu" "$GREEN" " OK "
boot_line "light tier: ${#light_packages[@]} packages" "$GREEN" "READY"
boot_line "heavy tier: ${#heavy_packages[@]} packages, +${#heavy_x86_packages[@]} on x86_64" "$GREEN" "READY"
boot_line "awaiting selection" "$AMBER" ">>"
printf '\n'

menu_item "[1]" "Install Light - core apps, developer tools and fonts"
menu_item "[2]" "Install Heavy - Light plus VPN, Steam and Discord"
menu_item "[3]" "Install Optimizations - local dictation (Voxtype) instead of cloud dictation"
menu_item "[4]" "Install All - Heavy followed by optimizations"
menu_item "[0]" "Exit"
echo ""

while true; do
  if ! read -r -p "${BRIGHT}> ${RESET}Select an option [0-4]: " choice; then
    print_error "No option selected."
    exit 1
  fi
  case "$choice" in
    0) exit 0 ;;
    1) install_light ;;
    2) install_light; install_heavy ;;
    3) install_local_dictation ;;
    4) install_light; install_heavy; install_local_dictation ;;
    *) print_warning "Please enter 0-4."; continue ;;
  esac
  break
done

if (( ${#failed_installs[@]} > 0 )); then
  print_error "SYSTEM DEGRADED: setup finished with failures: ${failed_installs[*]}"
  print_warning "Run this script again after fixing the errors above."
  exit 1
fi

printf '\n%s' "$BRIGHT"
typewrite "SYSTEM READY. Restart Omarchy to finish applying changes." 0.01
printf '%s\n' "$RESET"
