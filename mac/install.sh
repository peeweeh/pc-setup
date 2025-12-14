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

# Welcome banner
clear
print_header "macOS Setup - Interactive Installer"
echo -e "${CYAN}Author: mrfixit027 | https://github.com/peeweeh/pc-setup${NC}\n"

echo -e "${BOLD}Available Setup Scripts:${NC}"
echo ""
echo -e "${GREEN}1.${NC} ${BOLD}brew_install.sh${NC}     - Install 40+ applications via Homebrew"
echo -e "   ${CYAN}→${NC} 1Password, Arc, VSCode, Docker, Slack, and more"
echo -e "   ${CYAN}→${NC} Configures shell with Powerlevel10k"
echo -e "   ${CYAN}→${NC} Disables auto-start for heavy services"
echo -e "   ${YELLOW}⏱${NC}  ~30-60 minutes"
echo ""
echo -e "${GREEN}2.${NC} ${BOLD}mac_install.sh${NC}      - Performance & UI optimizations"
echo -e "   ${CYAN}→${NC} Disables AI analysis (Photos, Media) - huge battery saver"
echo -e "   ${CYAN}→${NC} Instant animations, faster UI"
echo -e "   ${CYAN}→${NC} Dock, Finder, Trackpad configuration"
echo -e "   ${YELLOW}⏱${NC}  ~2-3 minutes"
echo ""
echo -e "${GREEN}3.${NC} ${BOLD}vscode.sh${NC}           - Install 68+ VS Code extensions"
echo -e "   ${CYAN}→${NC} AI assistants (Copilot, Amazon Q, Claude)"
echo -e "   ${CYAN}→${NC} Language support (Python, JS, Go, GraphQL)"
echo -e "   ${CYAN}→${NC} DevOps tools (Docker, K8s, Terraform)"
echo -e "   ${YELLOW}⏱${NC}  ~5-10 minutes"
echo ""
echo -e "${GREEN}4.${NC} ${BOLD}privacy.sh${NC}          - Advanced privacy hardening ${YELLOW}(831 lines)${NC}"
echo -e "   ${CYAN}→${NC} Comprehensive Siri disabling"
echo -e "   ${CYAN}→${NC} Telemetry blocking (Firefox, Office, Homebrew)"
echo -e "   ${CYAN}→${NC} Security hardening, cache cleaning"
echo -e "   ${YELLOW}⚠${NC}  Advanced - review before running"
echo -e "   ${YELLOW}⏱${NC}  ~3-5 minutes"
echo ""
echo -e "${GREEN}5.${NC} ${BOLD}Install ALL${NC}         - Run all scripts in sequence"
echo -e "   ${YELLOW}⏱${NC}  ~40-80 minutes total"
echo ""
echo -e "${GREEN}0.${NC} ${BOLD}Exit${NC}"
echo ""

# Get user choice
while true; do
    echo -ne "${BOLD}Select an option [0-5]: ${NC}"
    read -r choice
    
    case $choice in
        1)
            print_header "Installing Applications (brew_install.sh)"
            print_info "Downloading and executing brew_install.sh..."
            /bin/bash -c "$(curl -fsSL ${GITHUB_RAW}/brew_install.sh)"
            break
            ;;
        2)
            print_header "Optimizing System (mac_install.sh)"
            print_info "Downloading and executing mac_install.sh..."
            /bin/bash -c "$(curl -fsSL ${GITHUB_RAW}/mac_install.sh)"
            break
            ;;
        3)
            print_header "Installing VS Code Extensions (vscode.sh)"
            if ! command -v code &> /dev/null; then
                print_error "VS Code CLI not found. Please install VS Code first or run option 1."
                print_info "In VS Code: Cmd+Shift+P → 'Shell Command: Install code command in PATH'"
                exit 1
            fi
            print_info "Downloading and executing vscode.sh..."
            bash <(curl -fsSL ${GITHUB_RAW}/vscode.sh)
            break
            ;;
        4)
            print_header "Privacy Hardening (privacy.sh)"
            print_warning "This is an advanced script with 831 lines of system changes."
            echo -ne "${YELLOW}Are you sure you want to continue? [y/N]: ${NC}"
            read -r confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                print_info "Downloading privacy.sh..."
                TEMP_PRIVACY=$(mktemp /tmp/privacy.sh.XXXXXX)
                if curl -fsSL ${GITHUB_RAW}/privacy.sh -o "$TEMP_PRIVACY"; then
                    chmod +x "$TEMP_PRIVACY"
                    print_info "Running privacy.sh (will prompt for sudo password)..."
                    "$TEMP_PRIVACY" || print_error "privacy.sh failed"
                    rm -f "$TEMP_PRIVACY"
                else
                    print_error "Failed to download privacy.sh"
                fi
            else
                print_info "Skipped privacy.sh"
            fi
            break
            ;;
        5)
            print_header "Installing ALL Scripts"
            echo -ne "${YELLOW}This will run all setup scripts. Continue? [y/N]: ${NC}"
            read -r confirm
            if [[ ! $confirm =~ ^[Yy]$ ]]; then
                print_info "Installation cancelled."
                exit 0
            fi
            
            # Step 1: brew_install.sh
            print_header "Step 1/4: Installing Applications"
            print_info "Running brew_install.sh..."
            /bin/bash -c "$(curl -fsSL ${GITHUB_RAW}/brew_install.sh)" || {
                print_error "brew_install.sh failed. Stopping."
                exit 1
            }
            
            # Step 2: mac_install.sh
            print_header "Step 2/4: Optimizing System"
            print_info "Running mac_install.sh..."
            /bin/bash -c "$(curl -fsSL ${GITHUB_RAW}/mac_install.sh)" || {
                print_error "mac_install.sh failed. Continuing..."
            }
            
            # Step 3: vscode.sh
            print_header "Step 3/4: Installing VS Code Extensions"
            if command -v code &> /dev/null; then
                print_info "Running vscode.sh..."
                bash <(curl -fsSL ${GITHUB_RAW}/vscode.sh) || {
                    print_error "vscode.sh failed. Continuing..."
                }
            else
                print_warning "VS Code CLI not found. Skipping vscode.sh"
                print_info "Install with: Cmd+Shift+P → 'Shell Command: Install code command in PATH'"
            fi
            
            # Step 4: privacy.sh (optional)
            print_header "Step 4/4: Privacy Hardening (Optional)"
            echo -ne "${YELLOW}Run privacy.sh (advanced privacy hardening)? [y/N]: ${NC}"
            read -r privacy_confirm
            if [[ $privacy_confirm =~ ^[Yy]$ ]]; then
                print_info "Downloading privacy.sh..."
                TEMP_PRIVACY=$(mktemp /tmp/privacy.sh.XXXXXX)
                if curl -fsSL ${GITHUB_RAW}/privacy.sh -o "$TEMP_PRIVACY"; then
                    chmod +x "$TEMP_PRIVACY"
                    print_info "Running privacy.sh (will prompt for sudo password)..."
                    "$TEMP_PRIVACY" || print_error "privacy.sh failed"
                    rm -f "$TEMP_PRIVACY"
                else
                    print_error "Failed to download privacy.sh"
                fi
            else
                print_info "Skipped privacy.sh"
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
            print_error "Invalid option. Please enter 0-5."
            ;;
    esac
done

echo ""
print_header "Setup Complete!"
print_info "Thank you for using the macOS Setup Scripts."
print_info "For more information, visit: ${CYAN}https://github.com/peeweeh/pc-setup${NC}"
echo ""
