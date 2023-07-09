#!/bin/bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Auto hide the dock
defaults write com.apple.dock autohide -bool true

# Remove all items from the dock
defaults write com.apple.dock persistent-apps -array

# Resize the dock to 50%
defaults write com.apple.dock tilesize -int 36

# Restart the dock for changes to take effect
killall Dock

#!/bin/bash
defaults delete com.apple.sidebarlists favoriteitems

# Show only Home, AirDrop, Downloads, and iCloud
defaults write com.apple.sidebarlists favoriteitems -array-add "com.apple.HomeDirectory"
defaults write com.apple.sidebarlists favoriteitems -array-add "com.apple.NetworkBrowser"
defaults write com.apple.sidebarlists favoriteitems -array-add "com.apple.Locales"
defaults write com.apple.sidebarlists favoriteitems -array-add "com.apple.mac.iCloud"
defaults write com.apple.sidebarlists favoriteitems -array-add "com.apple.Downloads"

osascript -e 'tell application "Finder" to set target of Finder window 1 to (path to home folder)'

defaults write com.apple.finder ShowRecentTags -bool false

killall Finder

# Define the URL of the Nord.terminal file
url="https://raw.githubusercontent.com/nordtheme/terminal-app/develop/src/xml/Nord.terminal"

# Define the local file path
file="$HOME/Downloads/Nord.terminal"

# Download the Nord.terminal file
curl -L $url -o $file

# Open the Nord.terminal file, which will install the theme in Terminal
open $file

echo "source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
echo 'alias ls="exa"' >> ~/.zshrc
source ~/.zshrc

