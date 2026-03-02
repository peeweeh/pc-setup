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
    "github.copilot-chat"
    "saoudrizwan.claude-dev"
    
    # Themes & Icons
    "arcticicestudio.nord-visual-studio-code"
    "ahmadawais.shades-of-purple"
    "enkia.tokyo-night"
    "liviuschera.noctis"
    "vscode-icons-team.vscode-icons"
    
    # AWS & Cloud
    "4ops.terraform"
    
    # Code Quality & Formatting
    "adpyke.codesnap"
    "dbaeumer.vscode-eslint"
    "dzhavat.bracket-pair-toggler"
    "esbenp.prettier-vscode"
    "formulahendry.auto-close-tag"
    "rvest.vs-code-prettier-eslint"
    
    # Git & Version Control
    "donjayamanne.githistory"
    "atlassian.atlascode"
    "github.vscode-pull-request-github"
    
    # Languages - Python
    "ms-python.autopep8"
    "ms-python.debugpy"
    "ms-python.flake8"
    "ms-python.isort"
    "ms-python.mypy-type-checker"
    "ms-python.pylint"
    "ms-python.python"
    "ms-python.vscode-pylance"
    "ms-python.vscode-python-envs"
    
    # Languages - JavaScript/React
    "bradlc.vscode-tailwindcss"
    "dsznajder.es7-react-js-snippets"
    "heybourn.headwind"
    
    # Languages - GraphQL
    "graphql.vscode-graphql"
    "graphql.vscode-graphql-execution"
    "graphql.vscode-graphql-syntax"
    
    # Containers & DevOps
    "docker.docker"
    "ms-vscode-remote.remote-wsl"
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
    
    # Database
    "dbcode.dbcode"
    
    # API Testing
    "rangav.vscode-thunder-client"
    
    # Utilities
    "ms-edgedevtools.vscode-edge-devtools"
    "phu1237.vs-browser"
    "redhat.vscode-yaml"
    "supperchong.pretty-json"
    "dotjoshjohnson.xml"
    "github.codespaces"
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
