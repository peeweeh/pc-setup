#!/bin/bash
#
# VS Code Extensions Installation Script
# Author: mrfixit027
# Repository: https://github.com/peeweeh/pc-setup
#

set -e  # Exit on error
set -u  # Exit on undefined variable

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

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

# VS Code extensions organized by category
vscodeExtensions=(
    # AI & Coding Assistants
    "amazonwebservices.amazon-q-vscode"
    "github.copilot"
    "github.copilot-chat"
    "saoudrizwan.claude-dev"
    
    # Themes & Icons
    "arcticicestudio.nord-visual-studio-code"
    "ahmadawais.shades-of-purple"
    "enkia.tokyo-night"
    "liviuschera.noctis"
    "zhuangtongfa.material-theme"
    "vscode-icons-team.vscode-icons"
    
    # AWS & Cloud
    "amazonwebservices.aws-toolkit-vscode"
    "4ops.terraform"
    "hashicorp.terraform"
    "aws-scripting-guy.cform"
    "kddejong.vscode-cfn-lint"
    
    # Code Quality & Formatting
    "adpyke.codesnap"
    "chakrounanas.turbo-console-log"
    "davidanson.vscode-markdownlint"
    "dbaeumer.vscode-eslint"
    "dzhavat.bracket-pair-toggler"
    "formulahendry.auto-close-tag"
    "wix.vscode-import-cost"
    
    # Git & Version Control
    "donjayamanne.githistory"
    "eamodio.gitlens"
    "atlassian.atlascode"
    
    # Languages - Python
    "ms-python.autopep8"
    "ms-python.debugpy"
    "ms-python.isort"
    "ms-python.python"
    "ms-python.vscode-pylance"
    "ms-python.vscode-python-envs"
    
    # Languages - JavaScript/React
    "bradlc.vscode-tailwindcss"
    "burkeholland.simple-react-snippets"
    "dsznajder.es7-react-js-snippets"
    
    # Languages - Go
    "golang.go"
    
    # Languages - GraphQL
    "graphql.vscode-graphql"
    "graphql.vscode-graphql-execution"
    "graphql.vscode-graphql-syntax"
    "micheldiz.vscode-dgraph-snippets"
    "mquandalle.graphql"
    
    # Containers & DevOps
    "docker.docker"
    "ms-azuretools.vscode-containers"
    "ms-vscode-remote.remote-containers"
    "ms-vscode-remote.remote-wsl"
    "ms-kubernetes-tools.vscode-kubernetes-tools"
    "tchoupinax.tilt"
    "github.vscode-github-actions"
    "mindaro-dev.file-downloader"
    
    # Jupyter & Data Science
    "ms-toolsai.jupyter"
    "ms-toolsai.jupyter-keymap"
    "ms-toolsai.jupyter-renderers"
    "ms-toolsai.vscode-jupyter-cell-tags"
    "ms-toolsai.vscode-jupyter-slideshow"
    
    # Markdown
    "bierner.markdown-preview-github-styles"
    "yzhang.markdown-all-in-one"
    
    # Utilities
    "ms-edgedevtools.vscode-edge-devtools"
    "ms-vscode.powershell"
    "ms-vsliveshare.vsliveshare"
    "phu1237.vs-browser"
    "redhat.vscode-yaml"
    "supperchong.pretty-json"
    "dotjoshjohnson.xml"
    "github.codespaces"
    
    # Gaming/Modding (Paradox)
    "dragon-archer.paradox-highlight"
    "jakobharder.anno-modding-tools"
    "n1nja.ck2"
    "tboby.cwtools-vscode"
    "tboby.paradox-syntax"
    "unlomtrois.ck3tiger-for-vscode"
)

print_header "VS Code Extensions Installation"
echo -e "${CYAN}Author: mrfixit027 | https://github.com/peeweeh/pc-setup${NC}\n"

# Check if VS Code CLI is available
if ! command -v code &> /dev/null; then
    print_error "VS Code CLI not found. Please install VS Code and ensure 'code' command is in PATH."
    print_info "In VS Code: Cmd+Shift+P → 'Shell Command: Install code command in PATH'"
    exit 1
fi

print_info "Found ${#vscodeExtensions[@]} extensions to install"
echo ""

# Counter for statistics
installed=0
skipped=0
failed=0

# Install the extensions
for extension in "${vscodeExtensions[@]}"; do
    # Skip empty lines and comments
    [[ -z "$extension" || "$extension" =~ ^# ]] && continue
    
    # Check if already installed
    if code --list-extensions | grep -qi "^${extension}$"; then
        print_warning "Already installed: $extension"
        ((skipped++))
    else
        if code --install-extension "$extension" --force > /dev/null 2>&1; then
            print_info "Installed: $extension"
            ((installed++))
        else
            print_error "Failed to install: $extension"
            ((failed++))
        fi
    fi
done

print_header "Installation Summary"

echo -e "${GREEN}✓ Installed: ${installed}${NC}"
echo -e "${YELLOW}⚠ Skipped (already installed): ${skipped}${NC}"
echo -e "${RED}✗ Failed: ${failed}${NC}"
echo ""

if [ $failed -eq 0 ]; then
    print_info "${GREEN}All extensions processed successfully!${NC}"
else
    print_warning "Some extensions failed to install. Please check manually."
fi

# Generate backup script
backup_script="InstallVsCodeExtensions.sh"
print_info "Generating backup script: $backup_script"

cat > "$backup_script" << 'EOF'
#!/bin/bash
# VS Code Extensions Installation Script
# Generated automatically - do not edit manually

extensions=(
EOF

for ext in "${vscodeExtensions[@]}"; do
    [[ -z "$ext" || "$ext" =~ ^# ]] && continue
    echo "    \"$ext\"" >> "$backup_script"
done

cat >> "$backup_script" << 'EOF'
)

for extension in "${extensions[@]}"; do
    code --install-extension "$extension" --force
done
EOF

chmod +x "$backup_script"
print_info "Backup script created: $backup_script"
