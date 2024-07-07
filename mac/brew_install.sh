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
brew install eza
brew install tree
brew install powerlevel10k
brew install diff-so-fancy

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
  telegram
  whatsapp
  signal
  chatgpt
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


# Add Powerlevel10k theme to .zshrc
echo "source $(brew --prefix)/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
alias ls='eza --icons always'
alias cat='bat'
alias fcd="fzf_cd"
echo '
# fzf enhanced cd function
fzf_cd() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m --preview "tree -C {} | head -200") && cd "$dir"
}

# Alias for fzf_cd
alias fcd="fzf_cd"
' >> ~/.zshrc && source ~/.zshrc


cp ~/.zshrc ~/.zshrc.bak

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# Define the plugins to ensure are present
required_plugins=("git" "zsh-syntax-highlighting" "zsh-autosuggestions")

# Read the current plugins from .zshrc
current_plugins=$(awk '/^plugins=\(/,/\)/' ~/.zshrc | sed 's/plugins=(//' | sed 's/)//' | tr -d '\n')

# Convert the current plugins to an array
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

# Source the updated .zshrc
source ~/.zshrc

echo "Updated .zshrc with plugins: $new_plugins"
