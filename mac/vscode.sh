#!/bin/bash

vscodeExtensions=(
    "aaron-bond.better-comments"
    "adpyke.codesnap"
    "amazonwebservices.aws-toolkit-vscode"
    "arcticicestudio.nord-visual-studio-code"
    "atlassian.atlascode"
    "bradlc.vscode-tailwindcss"
    "ChakrounAnas.turbo-console-log"
    "DanielSanMedium.dscodegpt"
    "DavidAnson.vscode-markdownlint"
    "dbaeumer.vscode-eslint"
    "donjayamanne.githistory"
    "dzhavat.bracket-pair-toggler"
    "esbenp.prettier-vscode"
    "formulahendry.auto-close-tag"
    "formulahendry.auto-rename-tag"
    "GitHub.copilot"
    "golang.go"
    "GraphQL.vscode-graphql"
    "GraphQL.vscode-graphql-execution"
    "GraphQL.vscode-graphql-syntax"
    "hashicorp.terraform"
    "MichelDiz.vscode-dgraph-snippets"
    "mindaro-dev.file-downloader"
    "mquandalle.graphql"
    "ms-azuretools.vscode-docker"
    "ms-edgedevtools.vscode-edge-devtools"
    "ms-kubernetes-tools.vscode-kubernetes-tools"
    "ms-python.autopep8"
    "ms-python.isort"
    "ms-python.python"
    "ms-python.vscode-pylance"
    "ms-toolsai.jupyter"
    "ms-toolsai.jupyter-keymap"
    "ms-toolsai.jupyter-renderers"
    "ms-toolsai.vscode-jupyter-cell-tags"
    "ms-toolsai.vscode-jupyter-slideshow"
    "ms-vscode-remote.remote-containers"
    "ms-vscode.powershell"
    "ms-vsliveshare.vsliveshare"
    "PKief.material-icon-theme"
    "redhat.vscode-yaml"
    "ritwickdey.LiveServer"
    "snyk-security.snyk-vulnerability-scanner"
    "supperchong.pretty-json"
    "syler.sass-indented"
    "vscode-icons-team.vscode-icons"
    "wix.vscode-import-cost"
)

# ASCII Art
echo '
  _ __ ___   __ _ _ __  
 | "_ ` _ \ / _` | "_ \ 
 | | | | | | (_| | | | |
 |_| |_| |_|\__,_|_| |_|
'

# Install the extensions
for extension in ${vscodeExtensions[@]}; do
    code --install-extension $extension
    echo -e "\033[0;36mInstalled $extension\033[0m
"
done

# Output to install script
printf 'code --install-extension %s
' "${vscodeExtensions[@]}" > 'InstallVsCodeExtensions.sh'
