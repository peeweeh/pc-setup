# PC and Mac Setup #

## win/windows_install.ps1 ##

This code is a Powershell script that is used to install various programs and applications. The first part of the code echoes "Installing 1Password" and then uses Invoke-WebRequest to download the latest version of 1PasswordSetup.exe from the specified URL. It then uses Start-Process to run the installer with the "/S" argument, which indicates silent installation. 

The second part of the code echoes "Installing Choco" and then sets the execution policy to bypass and downloads the Chocolatey package manager. It then uses choco to install a variety of programs such as Google Chrome, Node.js, Powertoys, Steam, Visual Studio Code, VLC, WinRAR, Brave, Ferdium, Slack, Amazon Chime, Amazon Workspaces, and Plex. 

The third part of the code echoes "Oh My Posh Choco" and then uses winget to install JanDeDobbeleer's OhMyPosh package. It then gets the source of the command and creates a new item in the profile path. It then adds a line to the file that runs oh-my-posh init pwsh | Invoke-Expression. 

The fourth part of the code echoes "Installing WSL" and then uses wsl to install Ubuntu and restarts the computer.

## mac/brew_install.sh ##

This code is a shell script that uses the Homebrew package manager to install various applications and tools. The first two lines update and upgrade any existing packages. The following lines install various applications, such as Git, 1Password, Google Chrome, Visual Studio Code, AWS Nuke, AWS CLI, Brave Browser, Slack, VLC, Ferdium, Google Drive, Microsoft Teams, NordVPN, Zoom, Microsoft Office, Amazon Chime, Amazon Workspaces, Microsoft Remote Desktop, Rectangle, Discord, Adobe Creative Cloud, Fig, Devtoys, Postman, fonts, Powerlevel10k, Bat, FZF, Exa, Docker, and Steam.


## mac/mac_install.sh ##

This code is a shell script that performs various tasks related to customizing the user's macOS environment. The first line of code (#!/bin/bash) indicates that this is a bash script. 

The following lines of code perform various tasks such as auto-hiding the dock, removing all items from the dock, resizing the dock to 50%, restarting the dock for changes to take effect, deleting favoriteitems from the sidebarlists, showing only Home, AirDrop, Downloads, and iCloud in the sidebarlists, setting the target of Finder window 1 to the home folder, hiding recent tags in Finder, downloading the Nord.terminal file, opening the Nord.terminal file to install the theme in Terminal, adding powerlevel10k.zsh-theme to the .zshrc file, adding an alias for ls command, and sourcing the .zshrc file. 

Finally, the code uses curl to download the Nord.terminal file from the specified URL and open it to install the theme in Terminal.