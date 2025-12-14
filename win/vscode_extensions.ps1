################################################################################
# vscode_extensions.ps1
# VS Code Extensions Installer
#
# Author: @mrfixit027
# GitHub: https://github.com/peeweeh/pc-setup
################################################################################

Write-Host ""
Write-Host "VS Code Extensions Installer by @mrfixit027" -ForegroundColor Cyan
Write-Host "GitHub: https://github.com/peeweeh/pc-setup" -ForegroundColor Cyan
Write-Host ""

# List all extensions installed in VS Code
$vscodeExtensions = @(
    "aaron-bond.better-comments",
    "adpyke.codesnap",
    "amazonwebservices.aws-toolkit-vscode",
    "arcticicestudio.nord-visual-studio-code",
    "atlassian.atlascode",
    "bradlc.vscode-tailwindcss",
    "ChakrounAnas.turbo-console-log",
    "DanielSanMedium.dscodegpt",
    "DavidAnson.vscode-markdownlint",
    "dbaeumer.vscode-eslint",
    "donjayamanne.githistory",
    "dzhavat.bracket-pair-toggler",
    "esbenp.prettier-vscode",
    "formulahendry.auto-close-tag",
    "formulahendry.auto-rename-tag",
    "GitHub.copilot",
    "golang.go",
    "GraphQL.vscode-graphql",
    "GraphQL.vscode-graphql-execution",
    "GraphQL.vscode-graphql-syntax",
    "hashicorp.terraform",
    "MichelDiz.vscode-dgraph-snippets",
    "mindaro-dev.file-downloader",
    "mquandalle.graphql",
    "ms-azuretools.vscode-docker",
    "ms-edgedevtools.vscode-edge-devtools",
    "ms-kubernetes-tools.vscode-kubernetes-tools",
    "ms-python.autopep8",
    "ms-python.isort",
    "ms-python.python",
    "ms-python.vscode-pylance",
    "ms-toolsai.jupyter",
    "ms-toolsai.jupyter-keymap",
    "ms-toolsai.jupyter-renderers",
    "ms-toolsai.vscode-jupyter-cell-tags",
    "ms-toolsai.vscode-jupyter-slideshow",
    "ms-vscode-remote.remote-containers",
    "ms-vscode.powershell",
    "ms-vsliveshare.vsliveshare",
    "PKief.material-icon-theme",
    "redhat.vscode-yaml",
    "ritwickdey.LiveServer",
    "snyk-security.snyk-vulnerability-scanner",
    "supperchong.pretty-json",
    "syler.sass-indented",
    "vscode-icons-team.vscode-icons",
    "wix.vscode-import-cost"
)

# ASCII Art
Write-Host @"
  ____ ____  ____  _     _____ _     ____    _____ ____
 /  _ \\  _ \\/  _ \\/ \\ |/  ___\\ \\ /\\  / \\  /  _ \\  _  \\
 | / \\| | \\| | \\|| |\\ |  \\__ \\_\\\\_//|  \\||  / \\| | \\|
 |\\_/| |_/| |_/|| | \\|  _/\\ ___ \\ /__\\| |_/| |_/|
 \\____\\____\\____/\\_/\\_\\____//   \\_/      \\____/\\____/
"@

# Create a new powershell script for installing the extensions with colors
$scriptContent = foreach ($extension in $vscodeExtensions) {
    Write-Host -ForegroundColor Cyan "`ncode --install-extension $extension"
}

$scriptContent | Out-File -Encoding UTF8 -FilePath 'InstallVsCodeExtensions.ps1'

Write-Host ""
Write-Host "Script by @mrfixit027" -ForegroundColor Cyan
Write-Host "GitHub: https://github.com/peeweeh/pc-setup" -ForegroundColor Cyan
Write-Host ""

################################################################################
# End of vscode_extensions.ps1
# Author: @mrfixit027
# GitHub: https://github.com/peeweeh/pc-setup
################################################################################
