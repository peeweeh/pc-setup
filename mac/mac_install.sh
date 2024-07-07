#!/bin/bash

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Auto hide the dock
defaults write com.apple.dock autohide -bool true

# Remove all items from the dock
defaults write com.apple.dock persistent-apps -array

# Resize the dock to 50%
defaults write com.apple.dock tilesize -int 36

# Restart the dock for changes to take effect
killall Dock

# Define the URL of the Nord.terminal file
url="https://raw.githubusercontent.com/nordtheme/terminal-app/develop/src/xml/Nord.terminal"

# Define the local file path
file="$HOME/Downloads/Nord.terminal"

# Download the Nord.terminal file
if curl -L "$url" -o "$file"; then
  # Open the Nord.terminal file, which will install the theme in Terminal
  open "$file"
else
  echo "Failed to download Nord.terminal file"
  exit 1
fi


# Note: No need to source .zshrc here, changes will take effect in the next shell session

# Additional macOS optimizations

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Automatically quit the printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Remove the delay when hiding and showing the Dock
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.5

# Show all file extensions in Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Disable the animation when you change pages in the Launchpad
defaults write com.apple.dock springboard-page-duration -float 0

# Disable the animation when opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Speed up the animation when opening the Info window in Finder
defaults write com.apple.finder DisableAllAnimations -bool true

# Disable the animation when opening the Get Info window in Finder
defaults write com.apple.finder AnimateInfoPanes -bool false

# Set Spotlight search to use Control + Space instead of Command + Space
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:64:enabled true" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:64:value:parameters:0 32" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:64:value:parameters:1 49" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:64:value:parameters:2 262144" ~/Library/Preferences/com.apple.symbolichotkeys.plist

# Restart SystemUIServer to apply changes
killall SystemUIServer

# Show battery percentage in the menu bar
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Disable automatic period substitution
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable automatic text correction
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Disable automatic text replacement
defaults write NSGlobalDomain NSAutomaticTextReplacementEnabled -bool false

# Disable automatic quote substitution
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable automatic dash substitution
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Enable tap to click for the current user and the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Enable three-finger drag
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true


# Set the default location for screenshots to ~/Documents/Screenshots
mkdir -p ~/Documents/Screenshots
defaults write com.apple.screencapture location ~/Documents/Screenshots
killall SystemUIServer


# Set new Finder windows to open in the home folder, show the sidebar, and show the toolbar
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"
defaults write com.apple.finder ShowSidebar -bool true
defaults write com.apple.finder ShowToolbar -bool true

# Show all file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Set Finder to sort by date modified
defaults write com.apple.finder FXPreferredGroupBy -string "DateModified"


# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Remove the delay for spring loading
defaults write NSGlobalDomain com.apple.springing.delay -float 0

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Set Finder to default to column view for everything
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Expand the following File Info panes: “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true
# Remove Network from Locations but ensure Computer (Hostname) is there
defaults write com.apple.finder SidebarDevicesSectionDisclosedState -bool true
defaults write com.apple.finder SidebarNetworkSectionDisclosedState -bool false

# Show only Home, AirDrop, Downloads, and iCloud in the sidebar
defaults write com.apple.sidebarlists favoriteitems -array \
  '{"Name"="Home"; "EntryType"="com.apple.LSSharedFileList.FavoriteItems";}' \
  '{"Name"="AirDrop"; "EntryType"="com.apple.LSSharedFileList.FavoriteItems";}' \
  '{"Name"="Downloads"; "EntryType"="com.apple.LSSharedFileList.FavoriteItems";}' \
  '{"Name"="iCloud"; "EntryType"="com.apple.LSSharedFileList.FavoriteItems";}'

# Set Finder window to open Home directory by default
osascript -e 'tell application "Finder" to set target of Finder window 1 to (path to home folder)'

# Hide recent tags in Finder
defaults write com.apple.finder ShowRecentTags -bool false

# Restart Finder for changes to take effect

# Restart Finder to apply changes
killall Finder

# Restart affected applications
for app in "Dock" "Finder" "SystemUIServer"; do
  killall "${app}" &> /dev/null
done


# Enable automatic updates for macOS and App Store
sudo softwareupdate --schedule on
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
defaults write com.apple.commerce AutoUpdate -bool true
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true