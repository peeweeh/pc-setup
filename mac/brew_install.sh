#!/bin/bash

# Update and upgrade Homebrew
brew update
brew upgrade

# Install essential command-line tools
brew install git
brew install aws-nuke
brew install awscli
brew install bat
brew install fzf

brew install powerlevel10k
# Install essential applications
apps=(
  1password
  google-chrome
  visual-studio-code
  brave-browser
  vlc
  beeper
  arc
  google-drive
  microsoft-teams
  nordvpn
  proton-mail
  proton-drive
  zoom
  microsoft-office
  amazon-chime
  amazon-workspaces
  microsoft-remote-desktop
  moom
  rectangle
  discord
  sourcetree
  fig
  devtoys
  postman
  clipy
  toggl
  evernote
  alfred
  steam
  the-unarchiver
)

# Install applications using Homebrew Cask
for app in "${apps[@]}"; do
  brew install --cask "$app"
done

# Install fonts
brew tap homebrew/cask-fonts
fonts=(
  font-hack-nerd-font
  font-fira-code-nerd-font
)

for font in "${fonts[@]}"; do
  brew install "$font"
done

