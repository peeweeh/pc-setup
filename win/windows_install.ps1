# ASCII Art and Colors
Write-Host -ForegroundColor Green "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Installing Applications ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

# ----------------------------------------------
# 1Password
# ----------------------------------------------
Write-Host "`n`t`t" -NoNewline -ForegroundColor Red; Write-Host "Installing 1Password" -ForegroundColor Yellow 
Invoke-WebRequest -Uri "https://downloads.1password.com/win/1PasswordSetup-latest.exe" -OutFile "https://downloads.1password.com/win/1PasswordSetup-latest.exe"
Start-Process -FilePath "1PasswordInstaller.exe" -ArgumentList "/S"

# ----------------------------------------------
# Chocolatey
# ----------------------------------------------
Write-Host "`n`t`t" -NoNewline -ForegroundColor Red; Write-Host "Installing Chocolatey" -ForegroundColor Yellow
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# ----------------------------------------------
# Applications List
# ----------------------------------------------
$appList = "git", "GoogleChrome", "nodejs", "powertoys", "visualstudiocode", 
"vlc", "vscode", "winrar", "brave", "ferdium", "slack", "amazon-chime", "amazon-workspaces", 
"googledrive", "plex", "nerd-fonts-firacode", "nerd-fonts-firamono", "postman", "fzf", "bat", 
"nordvpn", "steam"

# ----------------------------------------------
# Installing Applications via Chocolatey
# ----------------------------------------------
Write-Host "`n`t`t" -NoNewline -ForegroundColor Red; Write-Host "Installing applications via Chocolatey" -ForegroundColor Yellow
$appList | % { choco install -y $_ }


# ----------------------------------------------
# Oh My Posh
# ----------------------------------------------
Write-Host "`n`t`t" -NoNewline -ForegroundColor Red; Write-Host "Installing Oh My Posh" -ForegroundColor Yellow
winget install JanDeDobbeleer.OhMyPosh -s winget
(Get-Command oh-my-posh).Source
New-Item -Path $PROFILE -Type File -Force
$filePath = $PROFILE
$lineToAdd = "oh-my-posh init pwsh | Invoke-Expression"
Add-Content -Path $filePath -Value $lineToAdd

# ----------------------------------------------
# WSL - Ubuntu
# ----------------------------------------------
Write-Host "`n`t`t" -NoNewline -ForegroundColor Red; Write-Host "Installing WSL - Ubuntu" -ForegroundColor Yellow
wsl --install -d Ubuntu;


# ----------------------------------------------
# Docker Desktop
# ----------------------------------------------
Write-Host "`n`t`t" -NoNewline -ForegroundColor Red; Write-Host "Installing Docker Desktop" -ForegroundColor Yellow

$url = "https://download.docker.com/win/stable/Docker%20Desktop%20Installer.exe"
Invoke-WebRequest -Uri $url -OutFile "$env:TEMP\DockerDesktopInstaller.exe"

# Install Docker Desktop
Start-Process -FilePath "$env:TEMP\DockerDesktopInstaller.exe" -ArgumentList "/S" -Wait
Start-Service Docker

Write-Host "`n`t`t" -NoNewline -ForegroundColor Red; Write-Host "Installation Complete!" -ForegroundColor Yellow


Write-Host -ForegroundColor Green "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Asking for Github Details ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

Write-Host -ForegroundColor Cyan "Please enter your Github details"

$githubName = Read-Host -Prompt 'Input your Github name'
$githubEmail = Read-Host -Prompt 'Input your Github email'

Set-ExecutionPolicy Bypass -Scope Process -Force
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

git config --global user.name "$githubName"
git config --global user.email "$githubEmail"

$updatedGithubName = git config --global user.name
$updatedGithubEmail = git config --global user.email

Write-Host -ForegroundColor Yellow "Your Github details have been updated to:"
Write-Host -ForegroundColor White "Github name: $updatedGithubName"
Write-Host -ForegroundColor White "Github email: $updatedGithubEmail"

Write-Host -ForegroundColor Green "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"


Restart-Computer