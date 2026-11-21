#!/bin/bash
#
# Interactive macOS Setup Script
# Author: mrfixit027
# Repository: https://github.com/peeweeh/pc-setup
# Run from anywhere: bash <(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/install.sh)
#

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# GitHub raw content base URL
GITHUB_RAW="https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac"
SCRIPT_DIR=""
if [[ -f "${BASH_SOURCE[0]}" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

# Function to print colored output
print_header() {
    echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${MAGENTA}${BOLD}$1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_info() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_option() {
    echo -e "${BLUE}$1${NC} $2"
}

# ── Spinner / animated progress ─────────────────────────────────────────────────
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

# Fetches a remote script's contents into $FETCHED_SCRIPT (with an animated
# spinner while the download is in progress), then it can be executed locally
# via `bash -c "$FETCHED_SCRIPT"` without hitting the network again.
FETCHED_SCRIPT=""
fetch_script() {
  local script_url="$1"
  local tmpfile
  tmpfile=$(mktemp)
  local status=0
  run_spinner "Fetching $(basename "$script_url")..." curl -fsSL "$script_url" -o "$tmpfile" || status=$?
  FETCHED_SCRIPT=$(cat "$tmpfile")
  rm -f "$tmpfile"
  return $status
}

run_setup_script() {
    local script="$1"
    shift
    if [[ -n "$SCRIPT_DIR" && -f "$SCRIPT_DIR/$script" ]]; then
        /bin/bash "$SCRIPT_DIR/$script" "$@"
    else
        fetch_script "$GITHUB_RAW/$script" || {
            print_error "Failed to fetch $script"
            return 1
        }
        /bin/bash -c "$FETCHED_SCRIPT" "$script" "$@"
    fi
}

ESC=$'\033'
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
CYAN=$'\033[0;36m'
BOLD=$'\033[1m'
NC=$'\033[0m'
PHOSPHOR="${ESC}[38;5;46m"
DIM_PHOSPHOR="${ESC}[38;5;22m"
BRIGHT="${ESC}[1;97m"
ANIMATE=0
if [[ -t 1 && -z "${PC_SETUP_NO_ANIM:-}" && "${TERM:-dumb}" != dumb ]]; then
    ANIMATE=1
fi
trap 'printf "%s[0m%s[?25h" "$ESC" "$ESC"' EXIT

pause() {
    if (( ANIMATE )); then sleep "$1"; fi
    return 0
}

typewrite() {
    local text="$1" delay="${2:-0.01}" i
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
                frame+="${ESC}[$((r - 1));${c}H${PHOSPHOR}${glyphs:$(( RANDOM % ${#glyphs} )):1}"
            fi
            frame+="${ESC}[${r};${c}H${BRIGHT}${glyphs:$(( RANDOM % ${#glyphs} )):1}"
            heads[c]=$(( r >= rows ? 1 : r + 1 ))
        done
        printf '%s' "$frame"
        sleep 0.04
    done
    printf '%s[2J%s[H%s' "$ESC" "$ESC" "$NC"
}

show_banner() {
    local line i
    if (( ! ANIMATE )); then
        for line in "$@"; do printf '%s%s%s\n' "$PHOSPHOR" "$line" "$NC"; done
        return 0
    fi
    printf '%s[?25l' "$ESC"
    for line in "$@"; do
        printf '%s%s%s\n' "$PHOSPHOR" "$line" "$NC"
        sleep 0.05
    done
    for (( i = 0; i < 2; i++ )); do
        printf '%s[%dA' "$ESC" "$#"
        for line in "$@"; do printf '%s%s%s\n' "$BRIGHT" "$line" "$NC"; done
        sleep 0.07
        printf '%s[%dA' "$ESC" "$#"
        for line in "$@"; do printf '%s%s%s\n' "$PHOSPHOR" "$line" "$NC"; done
        sleep 0.07
    done
    printf '%s[?25h' "$ESC"
}

boot_line() {
    printf '%s' "$DIM_PHOSPHOR"
    typewrite "$1" 0.008
    printf ' %s[%s]%s\n' "$2" "$3" "$NC"
    pause 0.1
}

party_mode() {
    if (( ! ANIMATE )); then
        print_info "Party mode needs an interactive terminal."
        return 0
    fi
    local -a colours=(196 208 226 46 51 21 201)
    local line i n=${#PC_SETUP_BANNER[@]}
    matrix_rain
    for line in "${PC_SETUP_BANNER[@]}"; do printf '%s\n' "$line"; done
    for (( i = 0; i < 28; i++ )); do
        printf '%s[%dA' "$ESC" "$n"
        for line in "${PC_SETUP_BANNER[@]}"; do
            printf '%s[1;38;5;%sm%s%s\n' "$ESC" "${colours[i % ${#colours[@]}]}" "$line" "$NC"
        done
        sleep 0.08
    done
    printf '%s[2J%s[H' "$ESC" "$ESC"
}

menu_item() {
    printf '  %s[%s]%s %s%s%s ' "$BRIGHT" "$1" "$NC" "$BOLD" "$2" "$NC"
    printf '%s' "$PHOSPHOR"
    typewrite "$3" 0.004
    printf '%s\n' "$NC"
}

print_menu() {
    menu_item 1 "Install Light" "Core apps, developer tools, fonts and shell"
    menu_item 2 "Install Heavy" "Light + Office, Docker, cloud and other large apps"
    menu_item 3 "Install Optimizations" "Performance, UI and privacy hardening (advanced: cache/log clearing and system changes)"
    menu_item 4 "Install ALL" "Heavy apps followed by optimizations"
    print_warning "App installation also attempts to remove all login items and disable new LaunchAgents."
    menu_item 0 "Exit" ""
    echo ""
}

PC_SETUP_BANNER=(
    "██████╗  ██████╗    ███████╗███████╗████████╗██╗   ██╗██████╗ "
    "██╔══██╗██╔════╝    ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗"
    "██████╔╝██║         ███████╗█████╗     ██║   ██║   ██║██████╔╝"
    "██╔═══╝ ██║         ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ "
    "██║     ╚██████╗    ███████║███████╗   ██║   ╚██████╔╝██║     "
    "╚═╝      ╚═════╝    ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝     "
)

matrix_rain
show_banner "${PC_SETUP_BANNER[@]}"
printf '\n'
boot_line "booting setup menu" "$PHOSPHOR" " OK "
boot_line "tiers: light, heavy, optimizations" "$PHOSPHOR" "READY"
boot_line "awaiting selection" "$YELLOW" ">>"
printf '\n'
echo -e "${CYAN}Author: mrfixit027 | https://github.com/peeweeh/pc-setup${NC}"
echo ""
print_menu

# Get user choice
while true; do
    printf '%s> %sSelect an option [0-4]: %s' "$BRIGHT" "$BOLD" "$NC"
    if ! read -r choice; then
        print_error "No option selected."
        exit 1
    fi
    
    case $choice in
        1)
            print_header "Installing Light Applications"
            run_setup_script "brew_install.sh" light
            break
            ;;
        2)
            print_header "Installing Light and Heavy Applications"
            run_setup_script "brew_install.sh" heavy
            break
            ;;
        3)
            print_header "Optimizing System & Hardening Privacy (mac_optimize.sh)"
            print_warning "This is an advanced script covering performance/UI tweaks plus"
            print_warning "cache/log clearing, telemetry blocking, and privacy hardening."
            echo -ne "${YELLOW}Are you sure you want to continue? [y/N]: ${NC}"
            read -r confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                run_setup_script "mac_optimize.sh"
            else
                print_info "Skipped mac_optimize.sh"
            fi
            break
            ;;
        4)
            print_header "Installing ALL Scripts"
            print_warning "This installs heavy apps and runs the advanced optimization and privacy script."
            print_warning "Optimizations include system changes and cache/log clearing."
            echo -ne "${YELLOW}Continue? [y/N]: ${NC}"
            read -r confirm
            if [[ ! $confirm =~ ^[Yy]$ ]]; then
                print_info "Installation cancelled."
                exit 0
            fi
            
            print_header "Step 1/2: Installing Applications"
            run_setup_script "brew_install.sh" heavy || {
                print_error "brew_install.sh failed. Stopping."
                exit 1
            }
            
            print_header "Step 2/2: Optimizing System & Hardening Privacy"
            run_setup_script "mac_optimize.sh" || {
                print_error "mac_optimize.sh failed."
                exit 1
            }
            
            print_header "Installation Complete!"
            print_info "All setup scripts have been executed."
            print_warning "Please restart your Mac for all changes to take full effect."
            break
            ;;
        party)
            party_mode
            print_menu
            ;;
        0)
            print_info "Exiting installer."
            exit 0
            ;;
        *)
            print_error "Invalid option. Please enter 0-4."
            ;;
    esac
done

echo ""
print_header "Setup Complete!"
print_info "Thank you for using the macOS Setup Scripts."
print_info "For more information, visit: ${CYAN}https://github.com/peeweeh/pc-setup${NC}"
echo ""
