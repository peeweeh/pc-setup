#!/bin/bash
#
# macOS System Optimization & Configuration Script
# Author: mrfixit027
# Repository: https://github.com/peeweeh/pc-setup
#
# This script applies performance optimizations and UI improvements.
# For comprehensive privacy hardening, also run: privacy.sh
#
# Quick start:
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/mac_install.sh)"
#

set -e  # Exit on error
set -u  # Exit on undefined variable

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_header() {
    echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${MAGENTA}$1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_header "macOS System Optimization & Configuration"
echo -e "${CYAN}Author: mrfixit027 | https://github.com/peeweeh/pc-setup${NC}\n"

# Install Oh My Zsh
if [[ ! -d ~/.oh-my-zsh ]]; then
    print_info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    print_warning "Oh My Zsh already installed, skipping..."
fi

print_header "PERFORMANCE & BATTERY OPTIMIZATION"

print_warning "For comprehensive Siri/privacy settings, also run: privacy.sh"

print_info "Disabling Photos AI analysis (huge battery saver)..."
launchctl disable gui/$UID/com.apple.photoanalysisd 2>/dev/null || true
launchctl kill -TERM gui/$UID/com.apple.photoanalysisd 2>/dev/null || true

print_info "Disabling Media AI analysis (video indexing)..."
launchctl disable gui/$UID/com.apple.mediaanalysisd 2>/dev/null || true
launchctl kill -TERM gui/$UID/com.apple.mediaanalysisd 2>/dev/null || true

print_info "Disabling Game Center daemon..."
defaults write com.apple.gamed Disabled -bool true
launchctl kill -TERM gui/$UID/com.apple.gamed 2>/dev/null || true

print_info "Fixing macOS 26 heuristic lag bug..."
defaults write -g NSAutoHeuristicEnabled -bool false
killall cfprefsd 2>/dev/null || true

print_info "Optimizing Electron app GPU usage (Chrome/Slack/VSCode)..."
launchctl setenv CHROME_HEADLESS 1

print_info "Disabling Spotlight disk indexing (saves I/O, breaks file search)..."
print_warning "Note: This will disable Spotlight search functionality"
sudo mdutil -i off -a 2>/dev/null || true

print_info "Disabling crash reporter dialogs..."
defaults write com.apple.CrashReporter DialogType -string "none"

print_header "UI SPEED OPTIMIZATIONS"

print_info "Making window resize instant..."
defaults write -g NSWindowResizeTime -float 0.001

print_info "Making Dock appear instantly (no hover delay)..."
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0

print_info "Disabling Finder animations..."
defaults write com.apple.finder DisableAllAnimations -bool true

print_info "Speeding up Mission Control animations..."
defaults write com.apple.dock expose-animation-duration -float 0.1

print_info "Disabling Launchpad page change animation..."
defaults write com.apple.dock springboard-page-duration -float 0

print_info "Disabling Dock launch animation..."
defaults write com.apple.dock launchanim -bool false

print_info "Disabling Finder Info window animation..."
defaults write com.apple.finder AnimateInfoPanes -bool false

print_header "DOCK CONFIGURATION"

print_info "Enabling auto-hide for Dock..."
defaults write com.apple.dock autohide -bool true

print_info "Removing all items from Dock..."
defaults write com.apple.dock persistent-apps -array

print_info "Resizing Dock to 50%..."
defaults write com.apple.dock tilesize -int 36

print_info "Hiding recent applications in Dock..."
defaults write com.apple.dock show-recents -bool false

print_info "Disabling Dashboard..."
defaults write com.apple.dashboard mcx-disabled -bool true
defaults write com.apple.dock dashboard-in-overlay -bool true

print_header "FINDER CONFIGURATION"

print_info "Setting new Finder windows to open Home folder..."
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

print_info "Showing Finder sidebar and toolbar..."
defaults write com.apple.finder ShowSidebar -bool true
defaults write com.apple.finder ShowToolbar -bool true

print_info "Showing all file extensions..."
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

print_info "Showing hidden files..."
defaults write com.apple.finder AppleShowAllFiles -bool true

print_info "Showing path bar..."
defaults write com.apple.finder ShowPathbar -bool true

print_info "Showing status bar..."
defaults write com.apple.finder ShowStatusBar -bool true

print_info "Keeping folders on top when sorting..."
defaults write com.apple.finder _FXSortFoldersFirst -bool true

print_info "Setting Finder to sort by date modified..."
defaults write com.apple.finder FXPreferredGroupBy -string "DateModified"

print_info "Setting search scope to current folder..."
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

print_info "Disabling file extension change warning..."
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

print_info "Preventing .DS_Store files on network/USB volumes..."
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

print_info "Setting column view as default..."
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

print_info "Expanding File Info panes..."
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true

print_info "Hiding recent tags..."
defaults write com.apple.finder ShowRecentTags -bool false

print_info "Enabling spring loading for directories..."
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

print_info "Removing spring loading delay..."
defaults write NSGlobalDomain com.apple.springing.delay -float 0

print_header "SYSTEM PREFERENCES"

print_info "Expanding save panel by default..."
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

print_info "Expanding print panel by default..."
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

print_info "Auto-quit printer app after jobs complete..."
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

print_info "Disabling app quarantine dialog..."
defaults write com.apple.LaunchServices LSQuarantine -bool false

print_info "Disabling boot sound effects..."
sudo nvram SystemAudioVolume=" " 2>/dev/null || true

print_info "Disabling auto-correct..."
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

print_info "Disabling smart quotes..."
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

print_info "Disabling smart dashes..."
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

print_info "Disabling automatic period substitution..."
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

print_info "Disabling automatic text replacement..."
defaults write NSGlobalDomain NSAutomaticTextReplacementEnabled -bool false

print_info "Setting blazingly fast keyboard repeat rate..."
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

print_info "Requiring password immediately after sleep..."
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

print_info "Disabling automatic termination of inactive apps..."
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

print_header "TRACKPAD CONFIGURATION"

print_info "Enabling tap to click..."
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

print_info "Enabling three-finger drag..."
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

print_header "SCREENSHOTS CONFIGURATION"

print_info "Creating Screenshots folder..."
mkdir -p ~/Documents/Screenshots

print_info "Setting screenshot location to ~/Documents/Screenshots..."
defaults write com.apple.screencapture location ~/Documents/Screenshots

print_header "MENU BAR CONFIGURATION"

print_info "Showing battery percentage..."
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

print_header "SOFTWARE UPDATES"

print_info "Enabling automatic updates..."
sudo softwareupdate --schedule on 2>/dev/null || true
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
defaults write com.apple.commerce AutoUpdate -bool true
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

print_header "TERMINAL THEME INSTALLATION"

url="https://raw.githubusercontent.com/nordtheme/terminal-app/develop/src/xml/Nord.terminal"
file="$HOME/Downloads/Nord.terminal"

print_info "Downloading Nord Terminal theme..."
if curl -L "$url" -o "$file"; then
  print_info "Installing Nord theme (will open in Terminal)..."
  open "$file"
else
  print_error "Failed to download Nord.terminal file"
fi

print_header "APPLYING CHANGES"

print_info "Restarting Dock..."
killall Dock 2>/dev/null || true

print_info "Restarting Finder..."
killall Finder 2>/dev/null || true

print_info "Restarting SystemUIServer..."
killall SystemUIServer 2>/dev/null || true

print_header "INSTALLATION COMPLETE"

print_info "${GREEN}All optimizations applied successfully!${NC}"
print_info ""
print_warning "Please note:"
echo "  • Spotlight search has been disabled (saves battery/CPU)"
echo "  • Photos and Media AI analysis are disabled"
echo "  • For comprehensive Siri/privacy settings, run: privacy.sh"
echo ""
print_info "To revert any changes, check the documentation or use:"
echo "  • Spotlight: sudo mdutil -i on -a"
echo "  • Photos: launchctl enable gui/\$UID/com.apple.photoanalysisd"
echo "  • Media: launchctl enable gui/\$UID/com.apple.mediaanalysisd"
echo ""
print_info "${CYAN}Please restart your Mac for all changes to take full effect.${NC}"
