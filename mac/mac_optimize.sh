#!/bin/bash
#
# macOS System Optimization & Privacy Hardening Script
# Author: mrfixit027
# Repository: https://github.com/peeweeh/pc-setup
#
# Combines performance/UI optimization (formerly mac_install.sh) with
# privacy & security hardening (formerly privacy.sh, generated via
# privacy.sexy v0.13.8, plus a couple of manually-added hardening items)
# into a single script.
#
# Targets recent macOS releases, including macOS 27 "Golden Gate" and
# macOS Tahoe (26). Some tweaks (e.g. Spotlight indexing, TCC resets)
# may behave slightly differently across versions - review before running
# on unfamiliar systems.
#
# Individual commands elevate with `sudo` only where required, so this
# script should be run as your normal user (it will prompt for your
# password when needed) rather than with `sudo` in front of it.
#
# Quick start:
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/peeweeh/pc-setup/master/mac/mac_optimize.sh)"
#

# Colors for output
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
CYAN="\033[0;36m"
NC="\033[0m" # No Color

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

print_header "macOS System Optimization & Privacy Hardening"
echo -e "${CYAN}Author: mrfixit027 | https://github.com/peeweeh/pc-setup${NC}\n"
print_warning "This script makes extensive system changes (performance tweaks, cache/log"
print_warning "clearing, and privacy/security hardening). Review before running."

print_header "PERFORMANCE & BATTERY OPTIMIZATION"

print_info "Disabling Photos AI analysis (huge battery saver)..."
launchctl disable gui/$UID/com.apple.photoanalysisd 2>/dev/null || true
launchctl kill -TERM gui/$UID/com.apple.photoanalysisd 2>/dev/null || true

print_info "Disabling Media AI analysis (video indexing)..."
launchctl disable gui/$UID/com.apple.mediaanalysisd 2>/dev/null || true
launchctl kill -TERM gui/$UID/com.apple.mediaanalysisd 2>/dev/null || true

print_info "Disabling Game Center daemon..."
defaults write com.apple.gamed Disabled -bool true
launchctl kill -TERM gui/$UID/com.apple.gamed 2>/dev/null || true

print_info "Disabling NSAutoHeuristicEnabled (works around Finder/UI lag on some macOS versions)..."
defaults write -g NSAutoHeuristicEnabled -bool false
killall cfprefsd 2>/dev/null || true

print_info "Optimizing Electron app GPU usage (Chrome/Slack/etc)..."
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

# Capture the user's current default/startup Terminal profile BEFORE touching anything.
# We never want to force Nord (or any theme) as the default - only offer it as an
# optional profile - and we restore the previous default in case Terminal's own
# "use as default?" import dialog changes it.
CURRENT_DEFAULT_PROFILE=$(defaults read com.apple.Terminal "Default Window Settings" 2>/dev/null || echo "Basic")
CURRENT_STARTUP_PROFILE=$(defaults read com.apple.Terminal "Startup Window Settings" 2>/dev/null || echo "$CURRENT_DEFAULT_PROFILE")

print_info "Downloading Nord Terminal theme (added as an optional profile, not forced as default)..."
if curl -fsSL "$url" -o "$file"; then
  open "$file"
  # Give Terminal a moment to import the new profile before we touch it via AppleScript
  sleep 2

  # Restore whatever default/startup profile the user had before, in case importing
  # Nord silently changed it.
  osascript <<OSA 2>/dev/null || true
tell application "Terminal"
  try
    set default settings to settings set "${CURRENT_DEFAULT_PROFILE}"
    set startup settings to settings set "${CURRENT_STARTUP_PROFILE}"
  end try
end tell
OSA
else
  print_error "Failed to download Nord.terminal file"
fi

# Pick a Nerd Font installed by brew_install.sh so Powerlevel10k/eza icons render
# correctly instead of showing as "[?]" tofu boxes. Hack Nerd Font is preferred (falls
# back to Fira Code Nerd Font if Hack isn't present, e.g. brew_install.sh wasn't run,
# or install failed).
NERD_FONT="HackNerdFontMono-Regular"
if [[ ! -f "$HOME/Library/Fonts/${NERD_FONT}.ttf" ]] && [[ ! -f "/Library/Fonts/${NERD_FONT}.ttf" ]]; then
  NERD_FONT="FiraCodeNerdFontMono-Regular"
fi

if [[ -f "$HOME/Library/Fonts/${NERD_FONT}.ttf" ]] || [[ -f "/Library/Fonts/${NERD_FONT}.ttf" ]]; then
  print_info "Applying Nerd Font '${NERD_FONT}' to your current profile ('${CURRENT_DEFAULT_PROFILE}') - theme/colors untouched..."
  if osascript <<OSA
tell application "Terminal"
  try
    set font name of settings set "${CURRENT_DEFAULT_PROFILE}" to "${NERD_FONT}"
    set font size of settings set "${CURRENT_DEFAULT_PROFILE}" to 13
  end try
end tell
OSA
  then
    print_info "Nerd Font applied to '${CURRENT_DEFAULT_PROFILE}'. Open a new Terminal window/tab to see icons correctly."
  else
    print_warning "Could not set Terminal font automatically. Set it manually: Terminal > Settings > Profiles > Text > Font."
  fi
else
  print_warning "No Nerd Font found (font-hack-nerd-font / font-fira-code-nerd-font)."
  print_warning "Run brew_install.sh first, then re-run this script, or set the font manually in Terminal > Settings > Profiles > Text."
fi

print_header "PRIVACY & SECURITY HARDENING"
print_warning "The section below performs deeper system changes: clearing caches/logs,"
print_warning "removing the Guest user, disabling telemetry, and hardening privacy settings."
print_warning "Commands below elevate with 'sudo' individually as needed and will prompt"
print_warning "for your password."

print_header "Clear CUPS printer job cache"
sudo rm -rfv /var/spool/cups/c0*
sudo rm -rfv /var/spool/cups/tmp/*
sudo rm -rfv /var/spool/cups/cache/job.cache*

print_header "Empty trash on all volumes"
# on all mounted volumes
sudo rm -rfv /Volumes/*/.Trashes/* &>/dev/null
# on main HDD
sudo rm -rfv ~/.Trash/* &>/dev/null

print_header "Clear system cache"
sudo rm -rfv /Library/Caches/* &>/dev/null
sudo rm -rfv /System/Library/Caches/* &>/dev/null
sudo rm -rfv ~/Library/Caches/* &>/dev/null

print_header "Clear Xcode's derived data and archives"
rm -rfv ~/Library/Developer/Xcode/DerivedData/* &>/dev/null
rm -rfv ~/Library/Developer/Xcode/Archives/* &>/dev/null
rm -rfv ~/Library/Developer/Xcode/iOS Device Logs/* &>/dev/null

print_header "Clear DNS cache"
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder

print_header "Clear inactive memory"
sudo purge

print_header "Remove Guest User"
if ! command -v 'sysadminctl' &> /dev/null; then
    echo 'Skipping because "sysadminctl" is not found.'
else
    sudo sysadminctl -deleteUser Guest
fi
if ! command -v 'fdesetup' &> /dev/null; then
    echo 'Skipping because "fdesetup" is not found.'
else
    sudo fdesetup remove -user Guest
fi
if ! command -v 'dscl' &> /dev/null; then
    echo 'Skipping because "dscl" is not found.'
else
    sudo dscl . delete /Users/Guest
fi

print_header "Disable Firefox telemetry"
# Enable Firefox policies so the telemetry can be configured.
sudo defaults write /Library/Preferences/org.mozilla.firefox EnterprisePoliciesEnabled -bool TRUE
# Disable sending usage data
sudo defaults write /Library/Preferences/org.mozilla.firefox DisableTelemetry -bool TRUE

print_header "Disable Microsoft Office telemetry"
defaults write com.microsoft.office DiagnosticDataTypePreference -string ZeroDiagnosticData

print_header "Remove Google Software Update service"
googleUpdateFile=~/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle/Contents/Resources/ksinstall
if [ -f "$googleUpdateFile" ]; then
    $googleUpdateFile --nuke
    echo 'Uninstalled Google update'
else
    echo 'Google update file does not exist'
fi

print_header "Disable Homebrew user behavior analytics"
command='export HOMEBREW_NO_ANALYTICS=1'
declare -a profile_files=("$HOME/.bash_profile" "$HOME/.zprofile")
for profile_file in "${profile_files[@]}"
do
    touch "$profile_file"
    if ! grep -q "$command" "${profile_file}"; then
        echo "$command" >> "$profile_file"
        echo "[$profile_file] Configured"
    else
        echo "[$profile_file] No need for any action, already configured"
    fi
done

print_header "Disable NET Core CLI telemetry"
command='export DOTNET_CLI_TELEMETRY_OPTOUT=1'
declare -a profile_files=("$HOME/.bash_profile" "$HOME/.zprofile")
for profile_file in "${profile_files[@]}"
do
    touch "$profile_file"
    if ! grep -q "$command" "${profile_file}"; then
        echo "$command" >> "$profile_file"
        echo "[$profile_file] Configured"
    else
        echo "[$profile_file] No need for any action, already configured"
    fi
done

print_header "Disable PowerShell Core telemetry"
command='export POWERSHELL_TELEMETRY_OPTOUT=1'
declare -a profile_files=("$HOME/.bash_profile" "$HOME/.zprofile")
for profile_file in "${profile_files[@]}"
do
    touch "$profile_file"
    if ! grep -q "$command" "${profile_file}"; then
        echo "$command" >> "$profile_file"
        echo "[$profile_file] Configured"
    else
        echo "[$profile_file] No need for any action, already configured"
    fi
done

print_header "Disable remote Apple events"
sudo systemsetup -setremoteappleevents off

print_header "Disable automatic storage of documents in iCloud Drive"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

print_header "Disable AirDrop file sharing"
defaults write com.apple.NetworkBrowser DisableAirDrop -bool true

# Disable personalized advertisements and identifier tracking
print_header "Disable personalized advertisements and identifier tracking"
defaults write com.apple.AdLib allowIdentifierForAdvertising -bool false
defaults write com.apple.AdLib allowApplePersonalizedAdvertising -bool false
defaults write com.apple.AdLib forceLimitAdTracking -bool true

print_header "Disable date and time in screenshot filenames"
defaults write 'com.apple.screencapture' 'include-date' -bool false
killall SystemUIServer

print_header "Disable captive portal detection"
sudo defaults write '/Library/Preferences/SystemConfiguration/com.apple.captive.control.plist' Active -bool false

print_header "Clear bash history"
rm -f ~/.bash_history

print_header "Clear zsh history"
rm -f ~/.zsh_history

print_header "Clear Apple System Logs (ASL)"
# Clear directory contents: "/private/var/log/asl"
glob_pattern="/private/var/log/asl/*"
sudo rm -rfv $glob_pattern
# Delete files matching pattern: "/private/var/log/asl.log"
glob_pattern="/private/var/log/asl.log"
sudo rm -fv $glob_pattern
# Delete files matching pattern: "/private/var/log/asl.db"
glob_pattern="/private/var/log/asl.db"
sudo rm -fv $glob_pattern

print_header "Clear installation logs"
# Delete files matching pattern: "/private/var/log/install.log"
glob_pattern="/private/var/log/install.log"
sudo rm -fv $glob_pattern

print_header "Clear all system logs"
# Clear directory contents: "/private/var/log"
glob_pattern="/private/var/log/*"
sudo rm -rfv $glob_pattern

print_header "Clear system application logs"
# Clear directory contents: "/Library/Logs"
glob_pattern="/Library/Logs/*"
sudo rm -rfv $glob_pattern

print_header "Clear user application logs"
# Clear directory contents: "$HOME/Library/Logs"
glob_pattern="$HOME/Library/Logs/*"
 rm -rfv $glob_pattern

print_header "Clear Mail app logs"
# Clear directory contents: "$HOME/Library/Containers/com.apple.mail/Data/Library/Logs/Mail"
glob_pattern="$HOME/Library/Containers/com.apple.mail/Data/Library/Logs/Mail/*"
 rm -rfv $glob_pattern

print_header "Clear user activity audit logs (login, logout, authentication, etc.)"
# Clear directory contents: "/private/var/audit"
glob_pattern="/private/var/audit/*"
sudo rm -rfv $glob_pattern

print_header "Clear system maintenance logs"
# Delete files matching pattern: "/private/var/log/daily.out"
glob_pattern="/private/var/log/daily.out"
sudo rm -fv $glob_pattern
# Delete files matching pattern: "/private/var/log/weekly.out"
glob_pattern="/private/var/log/weekly.out"
sudo rm -fv $glob_pattern
# Delete files matching pattern: "/private/var/log/monthly.out"
glob_pattern="/private/var/log/monthly.out"
sudo rm -fv $glob_pattern

print_header "Clear app installation logs"
# Clear directory contents: "/private/var/db/receipts"
glob_pattern="/private/var/db/receipts/*"
sudo rm -rfv $glob_pattern
# Delete files matching pattern: "/Library/Receipts/InstallHistory.plist"
glob_pattern="/Library/Receipts/InstallHistory.plist"
 rm -fv $glob_pattern

print_header "Clear Adobe cache"
sudo rm -rfv ~/Library/Application\ Support/Adobe/Common/Media\ Cache\ Files/* &>/dev/null

print_header "Clear Gradle cache"
if [ -d "~/.gradle/caches" ]; then
    rm -rfv ~/.gradle/caches/ &> /dev/null
fi

print_header "Clear Dropbox cache"
if [ -d "~/Dropbox/.dropbox.cache" ]; then
    sudo rm -rfv ~/Dropbox/.dropbox.cache/* &>/dev/null
fi

print_header "Clear Google Drive File Stream cache"
killall "Google Drive File Stream"
rm -rfv ~/Library/Application\ Support/Google/DriveFS/[0-9a-zA-Z]*/content_cache &>/dev/null

print_header "Clear Composer cache"
if type "composer" &> /dev/null; then
    composer clearcache &> /dev/null
fi

print_header "Clear Homebrew cache"
if type "brew" &>/dev/null; then
    brew cleanup -s &>/dev/null
    rm -rfv $(brew --cache) &>/dev/null
    brew tap --repair &>/dev/null
fi

print_header "Clear old Ruby gem versions"
if type "gem" &> /dev/null; then
    gem cleanup &>/dev/null
fi

print_header "Clear unused Docker data"
if type "docker" &> /dev/null; then
    docker system prune -af
fi

print_header "Clear Pyenv-Virtualenv cache"
if [ "$PYENV_VIRTUALENV_CACHE_PATH" ]; then
    rm -rfv $PYENV_VIRTUALENV_CACHE_PATH &>/dev/null
fi

print_header "Clear NPM cache"
if type "npm" &> /dev/null; then
    npm cache clean --force
fi

print_header "Clear Yarn cache"
if type "yarn" &> /dev/null; then
    echo 'Cleanup Yarn Cache...'
    yarn cache clean --force
fi

print_header "Clear iOS app copies from iTunes"
rm -rfv ~/Music/iTunes/iTunes\ Media/Mobile\ Applications/* &>/dev/null

print_header "Clear iOS photo cache"
rm -rf ~/Pictures/iPhoto\ Library/iPod\ Photo\ Cache/*

print_header "Clear iOS Device Backups"
rm -rfv ~/Library/Application\ Support/MobileSync/Backup/* &>/dev/null

print_header "Clear iOS simulators"
if type "xcrun" &>/dev/null; then
    osascript -e 'tell application "com.apple.CoreSimulator.CoreSimulatorService" to quit'
    osascript -e 'tell application "iOS Simulator" to quit'
    osascript -e 'tell application "Simulator" to quit'
    xcrun simctl shutdown all
    xcrun simctl erase all
fi

print_header "Clear list of connected iOS devices"
sudo defaults delete /Users/$USER/Library/Preferences/com.apple.iPod.plist "conn:128:Last Connect"
sudo defaults delete /Users/$USER/Library/Preferences/com.apple.iPod.plist Devices
sudo defaults delete /Library/Preferences/com.apple.iPod.plist "conn:128:Last Connect"
sudo defaults delete /Library/Preferences/com.apple.iPod.plist Devices
sudo rm -rfv /var/db/lockdown/*

print_header "Clear "Speech Recognition" permissions"
if ! command -v 'tccutil' &> /dev/null; then
    echo 'Skipping because "tccutil" is not found.'
else
    declare serviceId='SpeechRecognition'
declare reset_output reset_exit_code
{
    reset_output=$(tccutil reset "$serviceId" 2>&1)
    reset_exit_code=$?
}
if [ $reset_exit_code -eq 0 ]; then
    echo "Successfully reset permissions for \"${serviceId}\"."
elif [ $reset_exit_code -eq 70 ]; then
    echo "Skipping, service ID \"${serviceId}\" is not supported on your operating system version."
elif [ $reset_exit_code -ne 0 ]; then
    >&2 echo "Failed to reset permissions for \"${serviceId}\". Exit code: $reset_exit_code."
    if [ -n "$reset_output" ]; then
        echo "Output from \`tccutil\`: $reset_output."
    fi
fi
fi

print_header "Clear diagnostic logs"
# Clear directory contents: "/private/var/db/diagnostics"
glob_pattern="/private/var/db/diagnostics/*"
sudo rm -rfv $glob_pattern

print_header "Clear diagnostic log details"
# Clear directory contents: "/private/var/db/uuidtext"
glob_pattern="/private/var/db/uuidtext/*"
sudo rm -rfv $glob_pattern

print_header "Disable Parallels Desktop advertisements"
defaults write 'com.parallels.Parallels Desktop' 'ProductPromo.ForcePromoOff' -bool yes
defaults write 'com.parallels.Parallels Desktop' 'WelcomeScreenPromo.PromoOff' -bool yes

print_header "Disable remote management service"
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -stop

print_header "Remove Apple Remote Desktop Settings"
sudo rm -rf /var/db/RemoteManagement
sudo defaults delete /Library/Preferences/com.apple.RemoteDesktop.plist
defaults delete ~/Library/Preferences/com.apple.RemoteDesktop.plist
sudo rm -rf /Library/Application\ Support/Apple/Remote\ Desktop/
rm -r ~/Library/Application\ Support/Remote\ Desktop/
rm -r ~/Library/Containers/com.apple.RemoteDesktop

print_header "Disable participation in Siri data collection"
defaults write com.apple.assistant.support 'Siri Data Sharing Opt-In Status' -int 2

print_header "Disable "Ask Siri""
defaults write com.apple.assistant.support 'Assistant Enabled' -bool false

print_header "Disable Siri voice feedback"
defaults write com.apple.assistant.backedup 'Use device speaker for TTS' -int 3

print_header "Disable Siri services (Siri and assistantd)"
launchctl disable "user/$UID/com.apple.assistantd"
launchctl disable "gui/$UID/com.apple.assistantd"
sudo launchctl disable 'system/com.apple.assistantd'
launchctl disable "user/$UID/com.apple.Siri.agent"
launchctl disable "gui/$UID/com.apple.Siri.agent"
sudo launchctl disable 'system/com.apple.Siri.agent'
if [ $(/usr/bin/csrutil status | awk '/status/ {print $5}' | sed 's/\.$//') = "enabled" ]; then
    >&2 echo 'This script requires SIP to be disabled. Read more: https://developer.apple.com/documentation/security/disabling_and_enabling_system_integrity_protection'
fi

print_header "Remove Siri from menu bar"
defaults write com.apple.systemuiserver 'NSStatusItem Visible Siri' 0

print_header "Remove Siri from status menu"
defaults write com.apple.Siri 'StatusMenuVisible' -bool false
defaults write com.apple.Siri 'UserHasDeclinedEnable' -bool true

print_header "Enable application firewall"
/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
sudo defaults write /Library/Preferences/com.apple.alf globalstate -bool true
defaults write com.apple.security.firewall EnableFirewall -bool true

print_header "Enable firewall logging"
/usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on
sudo defaults write /Library/Preferences/com.apple.alf loggingenabled -bool true

print_header "Enable stealth mode"
/usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -bool true
defaults write com.apple.security.firewall EnableStealthMode -bool true

print_header "Disable guest account login"
sudo defaults write '/Library/Preferences/com.apple.loginwindow' 'GuestEnabled' -bool NO
if ! command -v 'sysadminctl' &> /dev/null; then
    echo 'Skipping because "sysadminctl" is not found.'
else
    sudo sysadminctl -guestAccount off
fi

print_header "Disable guest file sharing over SMB"
sudo defaults write '/Library/Preferences/SystemConfiguration/com.apple.smb.server' 'AllowGuestAccess' -bool NO
if ! command -v 'sysadminctl' &> /dev/null; then
    echo 'Skipping because "sysadminctl" is not found.'
else
    sudo sysadminctl -smbGuestAccess off
fi

print_header "Disable guest file sharing over AFP"
sudo defaults write '/Library/Preferences/com.apple.AppleFileServer' 'guestAccess' -bool NO
if ! command -v 'sysadminctl' &> /dev/null; then
    echo 'Skipping because "sysadminctl" is not found.'
else
    sudo sysadminctl -afpGuestAccess off
fi
sudo killall -HUP AppleFileServer

print_header "Disable incoming SSH and SFTP remote logins"
echo 'yes' | sudo systemsetup -setremotelogin off

print_header "Disable the insecure TFTP service"
sudo launchctl disable 'system/com.apple.tftpd'

print_header "Disable Bonjour multicast advertising"
sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true

print_header "Disable insecure telnet protocol"
sudo launchctl disable system/com.apple.telnetd

print_header "Disable local printer sharing with other computers"
cupsctl --no-share-printers

# Disable printing from external addresses, including the internet
print_header "Disable printing from external addresses, including the internet"
cupsctl --no-remote-any

print_header "Disable remote printer administration"
cupsctl --no-remote-admin

print_header "Disable automatic incoming connections for signed apps"
sudo defaults write /Library/Preferences/com.apple.alf allowsignedenabled -bool false

# Disable automatic incoming connections for downloaded signed apps
print_header "Disable automatic incoming connections for downloaded signed apps"
sudo defaults write /Library/Preferences/com.apple.alf allowdownloadsignedenabled -bool false

print_header "Clear logs of all downloaded files from File Quarantine"
db_file=~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2
db_query='delete from LSQuarantineEvent'
if [ -f "$db_file" ]; then
    echo "Database exists at \"$db_file\""
    if ls -lO "$db_file" | grep --silent 'schg'; then
        sudo chflags noschg "$db_file"
        echo "Found and removed system immutable flag"
        has_system_immutable_flag=true
    fi
    if ls -lO "$db_file" | grep --silent 'uchg'; then
        sudo chflags nouchg "$db_file"
        echo "Found and removed user immutable flag"
        has_user_immutable_flag=true
    fi
    sqlite3 "$db_file" "$db_query"
    echo "Executed the query \"$db_query\""
    if [ "$has_system_immutable_flag" = true ] ; then
        sudo chflags schg "$db_file"
        echo "Added system immutable flag back"
    fi
    if [ "$has_user_immutable_flag" = true ] ; then
        sudo chflags uchg "$db_file"
        echo "Added user immutable flag back"
    fi
else
    echo "No action needed, database does not exist at \"$db_file\""
fi

print_header "Disable downloaded file logging in quarantine"
file_to_lock=~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2
if [ -f "$file_to_lock" ]; then
    sudo chflags schg "$file_to_lock"
    echo "Made file immutable at \"$file_to_lock\""
else
    echo "No action is needed, file does not exist at \"$file_to_lock\""
fi

print_header "Disable sending diagnostics to Apple"
sudo defaults write /Library/Application\ Support/CrashReporter/DiagnosticMessagesHistory.plist AutoSubmit -bool false
sudo defaults write /Library/Application\ Support/CrashReporter/DiagnosticMessagesHistory.plist AutoSubmitVersion -int 4
defaults write com.apple.CrashReporter DialogType -string none
defaults write com.apple.CrashReporter UseUNC -bool false

print_header "Disable Apple diagnostics & usage analytics"
defaults write com.apple.privacy.policyreporter sendDiagnostics -bool false
defaults write com.apple.SubmitDiagInfo AutoSubmit -bool false
defaults write com.apple.SubmitDiagInfo AutoSubmitVersion -int 4

print_header "Disable iCloud analytics data sharing"
defaults write com.apple.CloudDocs.container-metadata shareAnalyticsWithApple -bool false
defaults write com.apple.icloud.fmipcore ICFShareMyLocationEnabled -bool false

print_header "Disable Spotlight search data collection"
# Prevent Spotlight from sending queries to Apple/third parties
defaults write com.apple.spotlight orderedItems -array \
    '{"enabled" = 0;"name" = "INTERNET_ENABLED";}' \
    '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
    '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'
# Disable Spotlight universal search (phone-home)
sudo defaults write /Library/Preferences/com.apple.commerce.plist AutoDownload -bool false

print_header "Disable Safari telemetry, suggestions & prefetching"
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true
defaults write com.apple.Safari PreloadTopHit -bool false
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true
defaults write com.apple.Safari WebKitPreferences.privateClickMeasurementEnabled -bool false
defaults write com.apple.Safari SafariGeolocationPermissionPolicy -int 0
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false
# Prevent Safari from reading fraudulent website warnings (sends URLs to Apple/Google)
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool false

print_header "Disable Handoff & Universal Clipboard"
defaults write com.apple.coreduetd.overrides DeferSystemIdleSystemSleepWhileLockedEnabled -int 0
defaults write ~/Library/Preferences/ByHost/com.apple.coreduetd.plist ActivityAdvertisingAllowed -bool false
defaults write ~/Library/Preferences/ByHost/com.apple.coreduetd.plist ActivityReceivingAllowed -bool false
defaults write com.apple.ApplicationActivationPolicy.plist com.apple.sharingd -bool false
# Disable Handoff
defaults write com.apple.coreduetd.overrides HandoffEnabled -bool false
defaults write "com.apple.ActivityContinuation" "ActivityContinuationEnabled" -bool false

print_header "Disable location services"
sudo defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd LocationServicesEnabled -bool false
sudo launchctl disable 'system/com.apple.locationd'

print_header "Disable personalized recommendations & tracking consent prompts"
defaults write com.apple.SetupAssistant.managed SkipPrivacySetup -bool true
defaults write com.apple.privacy PrivacyUpdate -int 2
defaults write com.apple.assistant.support 'Search Queries Data Sharing Status' -int 2

print_header "Disable Screen Time analytics reporting"
defaults write com.apple.screentime EnabledState -int 0
defaults write com.apple.screentime SCAppUseDurationEnabled -bool false
defaults write com.apple.screentime SCScreenTimeEnabled -bool false

print_header "Disable NetBIOS"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string ''
sudo launchctl disable 'system/com.apple.netbiosd'
sudo launchctl bootout system /System/Library/LaunchDaemons/com.apple.netbiosd.plist 2>/dev/null || true

print_header "Clear recent items (apps, documents, servers)"
defaults write com.apple.recentitems RecentApplications -array
defaults write com.apple.recentitems RecentDocuments -array
defaults write com.apple.recentitems RecentServers -array
osascript -e 'tell application "System Events" to set the recent documents list to {}'
osascript -e 'tell application "System Events" to set the recent applications list to {}'
osascript -e 'tell application "System Events" to set the recent servers list to {}'
# Set recent items to 0 in System Settings
defaults write -g NSRecentDocumentsLimit -int 0
defaults write com.apple.LSSharedFileList.RecentDocuments MaxAmount -int 0
defaults write com.apple.LSSharedFileList.RecentApplications MaxAmount -int 0

print_header "Disable wake for network access and Power Nap"
sudo pmset -a womp 0
sudo pmset -a darkwakes 0
sudo pmset -a powernap 0


print_header "Enabling firewall stealth mode (ignore unsolicited probes)"
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -bool true
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on 2>/dev/null || true

print_header "Disabling Bonjour multicast advertising"
sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true

print_header "APPLYING CHANGES"

print_info "Restarting Dock..."
killall Dock 2>/dev/null || true

print_info "Restarting Finder..."
killall Finder 2>/dev/null || true

print_info "Restarting SystemUIServer..."
killall SystemUIServer 2>/dev/null || true

print_header "INSTALLATION COMPLETE"

print_info "All optimizations and privacy hardening applied successfully!"
print_info ""
print_warning "Please note:"
echo "  - Spotlight search has been disabled (saves battery/CPU)"
echo "  - Photos and Media AI analysis are disabled"
echo "  - Siri, telemetry, and various tracking features are disabled"
echo "  - The Guest user account has been removed"
echo ""
print_info "To revert some changes, check the documentation or use:"
echo "  - Spotlight: sudo mdutil -i on -a"
echo "  - Photos: launchctl enable gui/$UID/com.apple.photoanalysisd"
echo "  - Media: launchctl enable gui/$UID/com.apple.mediaanalysisd"
echo ""
print_info "${CYAN}Please restart your Mac for all changes to take full effect.${NC}"
