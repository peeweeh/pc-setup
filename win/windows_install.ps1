echo "================ Installing 1Password"

Invoke-WebRequest -Uri "https://downloads.1password.com/win/1PasswordSetup-latest.exe" -OutFile "https://downloads.1password.com/win/1PasswordSetup-latest.exe"
Start-Process -FilePath "1PasswordInstaller.exe" -ArgumentList "/S"

echo "================ Installing Choco"

Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install -y GoogleChrome nodejs powertoys steam visualstudiocode vlc vscode winrar brave ferdium slack amazon-chime amazon-workspaces plex

echo "================ Oh My Posh Choco"
winget install JanDeDobbeleer.OhMyPosh -s winget
(Get-Command oh-my-posh).Source
New-Item -Path $PROFILE -Type File -Force
$filePath = $PROFILE
$lineToAdd = "oh-my-posh init pwsh | Invoke-Expression"
Add-Content -Path $filePath -Value $lineToAdd

echo "================ Installing WSL"
wsl --install -d Ubuntu; Restart-Computer


