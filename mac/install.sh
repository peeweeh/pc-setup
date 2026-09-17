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

# Welcome banner
clear
print_header "macOS Setup - Interactive Installer"
echo -e "${CYAN}Author: mrfixit027 | https://github.com/peeweeh/pc-setup${NC}\n"

echo -e "${BOLD}Available Setup Scripts:${NC}"
echo ""
echo -e "${GREEN}1.${NC} ${BOLD}brew_install.sh${NC}     - Install applications via Homebrew"
echo -e "   ${CYAN}→${NC} 2 tiers: Fast / Slow (Fast + Office, Docker, cloud, heavy apps)"
echo -e "   ${CYAN}→${NC} Configures shell with Powerlevel10k"
echo -e "   ${CYAN}→${NC} Sudo handled once upfront (no repeated prompts)"
echo -e "   ${CYAN}→${NC} Disables login items/background agents for installed apps"
echo -e "   ${YELLOW}⏱${NC}  ~15-70 minutes (depends on tier)"
echo ""
echo -e "${GREEN}2.${NC} ${BOLD}mac_optimize.sh${NC}     - Performance, UI & privacy hardening ${YELLOW}(combined)${NC}"
echo -e "   ${CYAN}→${NC} Disables AI analysis (Photos, Media) - huge battery saver"
echo -e "   ${CYAN}→${NC} Instant animations, faster UI, Dock/Finder/Trackpad config"
echo -e "   ${CYAN}→${NC} Comprehensive Siri disabling & telemetry blocking"
echo -e "   ${CYAN}→${NC} Security hardening, cache/log cleaning"
echo -e "   ${YELLOW}⚠${NC}  Advanced - review before running"
echo -e "   ${YELLOW}⏱${NC}  ~5-10 minutes"
echo ""
echo -e "${GREEN}3.${NC} ${BOLD}Install ALL${NC}         - Run all scripts in sequence"
echo -e "   ${YELLOW}⏱${NC}  ~15-70 minutes total"
echo ""
echo -e "${GREEN}0.${NC} ${BOLD}Exit${NC}"
echo ""

# Get user choice
while true; do
    echo -ne "${BOLD}Select an option [0-3]: ${NC}"
    read -r choice
    
    case $choice in
        1)
            print_header "Installing Applications (brew_install.sh)"
            fetch_script "${GITHUB_RAW}/brew_install.sh" || { print_error "Failed to fetch brew_install.sh"; exit 1; }
            /bin/bash -c "$FETCHED_SCRIPT"
            break
            ;;
        2)
            print_header "Optimizing System & Hardening Privacy (mac_optimize.sh)"
            print_warning "This is an advanced script covering performance/UI tweaks plus"
            print_warning "cache/log clearing, telemetry blocking, and privacy hardening."
            echo -ne "${YELLOW}Are you sure you want to continue? [y/N]: ${NC}"
            read -r confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                fetch_script "${GITHUB_RAW}/mac_optimize.sh" || { print_error "Failed to fetch mac_optimize.sh"; exit 1; }
                /bin/bash -c "$FETCHED_SCRIPT"
            else
                print_info "Skipped mac_optimize.sh"
            fi
            break
            ;;
        3)
            print_header "Installing ALL Scripts"
            echo -ne "${YELLOW}This will run all setup scripts. Continue? [y/N]: ${NC}"
            read -r confirm
            if [[ ! $confirm =~ ^[Yy]$ ]]; then
                print_info "Installation cancelled."
                exit 0
            fi
            
            # Step 1: brew_install.sh
            print_header "Step 1/2: Installing Applications"
            fetch_script "${GITHUB_RAW}/brew_install.sh" || { print_error "Failed to fetch brew_install.sh"; exit 1; }
            /bin/bash -c "$FETCHED_SCRIPT" || {
                print_error "brew_install.sh failed. Stopping."
                exit 1
            }
            
            # Step 2: mac_optimize.sh (optional, advanced)
            print_header "Step 2/2: Optimizing System & Hardening Privacy (Optional)"
            print_warning "This is an advanced script covering performance/UI tweaks plus"
            print_warning "cache/log clearing, telemetry blocking, and privacy hardening."
            echo -ne "${YELLOW}Run mac_optimize.sh? [y/N]: ${NC}"
            read -r optimize_confirm
            if [[ $optimize_confirm =~ ^[Yy]$ ]]; then
                fetch_script "${GITHUB_RAW}/mac_optimize.sh" || { print_error "Failed to fetch mac_optimize.sh"; }
                /bin/bash -c "$FETCHED_SCRIPT" || {
                    print_error "mac_optimize.sh failed. Continuing..."
                }
            else
                print_info "Skipped mac_optimize.sh"
            fi
            
            print_header "Installation Complete!"
            print_info "${GREEN}All selected scripts have been executed.${NC}"
            print_warning "Please restart your Mac for all changes to take full effect."
            break
            ;;
        0)
            print_info "Exiting installer."
            exit 0
            ;;
        *)
            print_error "Invalid option. Please enter 0-3."
            ;;
    esac
done

echo ""
print_header "Setup Complete!"
print_info "Thank you for using the macOS Setup Scripts."
print_info "For more information, visit: ${CYAN}https://github.com/peeweeh/pc-setup${NC}"
echo ""
