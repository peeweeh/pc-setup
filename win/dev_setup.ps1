# dev_setup.ps1
# Development environment setup for Windows
# Installs WSL, Docker, Node.js, Python tools, and configures Git & AWS

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "This script requires Administrator privileges. Please run as Administrator." -ForegroundColor Red
    exit 1
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Development Environment Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$successCount = 0
$failCount = 0
$installedTools = @{}

# Helper function for status messages
function Write-Step {
    param($Message)
    Write-Host "→ $Message" -ForegroundColor Cyan
}

function Write-Success {
    param($Message)
    Write-Host "✓ $Message" -ForegroundColor Green
    $script:successCount++
}

function Write-Fail {
    param($Message)
    Write-Host "✗ $Message" -ForegroundColor Red
    $script:failCount++
}

# ===========================================
# 1. WSL Installation
# ===========================================
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Step 1: Installing WSL" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Step "Checking if WSL is installed..."
$wslInstalled = (Get-Command wsl -ErrorAction SilentlyContinue) -ne $null

if ($wslInstalled) {
    $wslStatus = wsl --status 2>&1
    if ($wslStatus -match "Default Version: 2" -or $wslStatus -match "WSL 2") {
        Write-Success "WSL2 is already installed"
        $installedTools["WSL2"] = "Installed"
    } else {
        Write-Step "Upgrading WSL to version 2..."
        try {
            wsl --set-default-version 2
            Write-Success "WSL2 set as default"
            $installedTools["WSL2"] = "Configured"
        } catch {
            Write-Fail "Failed to set WSL2 as default: $_"
        }
    }
} else {
    Write-Step "Installing WSL2 with Ubuntu..."
    try {
        wsl --install -d Ubuntu
        Write-Success "WSL2 with Ubuntu installed - restart required"
        Write-Host "  After restart, run this script again to continue setup" -ForegroundColor Yellow
        $installedTools["WSL2"] = "Installed (restart required)"
        
        # Exit and prompt for restart
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Yellow
        Write-Host "RESTART REQUIRED" -ForegroundColor Yellow
        Write-Host "========================================" -ForegroundColor Yellow
        Write-Host "Please restart your computer, then run this script again." -ForegroundColor Yellow
        Write-Host ""
        Read-Host "Press Enter to exit"
        exit 0
    } catch {
        Write-Fail "Failed to install WSL: $_"
        Write-Host "  Try running manually: wsl --install" -ForegroundColor Yellow
    }
}

# Configure Ubuntu in WSL
Write-Host ""
Write-Step "Configuring Ubuntu in WSL..."
$ubuntuInstalled = wsl -l -q | Select-String "Ubuntu"

if ($ubuntuInstalled) {
    Write-Success "Ubuntu is installed in WSL"
    
    Write-Step "Installing essential build tools in Ubuntu..."
    try {
        # Update and install essential packages
        wsl -d Ubuntu -- bash -c "sudo apt update && sudo apt install -y build-essential curl wget git vim htop neofetch"
        Write-Success "Essential build tools installed in Ubuntu"
    } catch {
        Write-Fail "Failed to install build tools in Ubuntu: $_"
    }
    
    # Install Docker CLI in WSL
    Write-Step "Installing Docker CLI in Ubuntu..."
    try {
        wsl -d Ubuntu -- bash -c "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable' | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && sudo apt update && sudo apt install -y docker-ce-cli"
        Write-Success "Docker CLI installed in Ubuntu"
    } catch {
        Write-Fail "Failed to install Docker CLI: $_"
    }
    
    $installedTools["Ubuntu"] = "Configured"
} else {
    Write-Fail "Ubuntu is not installed in WSL"
    Write-Host "  Run 'wsl --install -d Ubuntu' manually" -ForegroundColor Yellow
}

Write-Host ""

# ===========================================
# 2. Docker Desktop Installation
# ===========================================
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Step 2: Installing Docker Desktop" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$dockerDesktopInstalled = Get-Command docker -ErrorAction SilentlyContinue

if ($dockerDesktopInstalled) {
    Write-Success "Docker Desktop is already installed"
    $dockerVersion = docker --version
    $installedTools["Docker Desktop"] = $dockerVersion
} else {
    Write-Step "Installing Docker Desktop via Chocolatey..."
    
    try {
        choco install docker-desktop -y --ignore-checksums
        Write-Success "Docker Desktop installed"
        $installedTools["Docker Desktop"] = "Installed (requires restart)"
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        
        Write-Host ""
        Write-Host "  Note: Restart required for Docker Desktop to work" -ForegroundColor Yellow
    } catch {
        Write-Fail "Failed to install Docker Desktop via Chocolatey: $_"
        Write-Host "  Download manually from: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    }
}

# Set Docker service to Manual startup
Write-Step "Setting Docker service to Manual startup (for gaming performance)..."
try {
    $dockerService = Get-Service -Name "com.docker.service" -ErrorAction SilentlyContinue
    if ($dockerService) {
        Set-Service -Name "com.docker.service" -StartupType Manual
        Write-Success "Docker service set to Manual startup"
        Write-Host "  Docker won't auto-start on boot - start manually when needed" -ForegroundColor Yellow
    } else {
        Write-Host "  Docker service not found (will be available after restart)" -ForegroundColor Yellow
    }
} catch {
    Write-Fail "Failed to set Docker service to Manual: $_"
}

Write-Host ""

# ===========================================
# 3. Node.js with NVM
# ===========================================
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Step 3: Installing Node.js" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$nodeInstalled = Get-Command node -ErrorAction SilentlyContinue

if (-not $nodeInstalled) {
    Write-Step "Installing Node.js via Chocolatey..."
    try {
        choco install nodejs-lts -y
        Write-Success "Node.js LTS installed"
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        $nodeVersion = node --version
        $installedTools["Node.js"] = $nodeVersion
    } catch {
        Write-Fail "Failed to install Node.js: $_"
    }
} else {
    $nodeVersion = node --version
    Write-Success "Node.js is already installed: $nodeVersion"
    $installedTools["Node.js"] = $nodeVersion
}

# Install global npm packages
Write-Step "Installing global npm packages..."
$npmPackages = @("yarn", "pnpm", "typescript", "eslint", "prettier", "nodemon")

foreach ($package in $npmPackages) {
    try {
        npm install -g $package --silent
        Write-Host "  ✓ Installed $package" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ Failed to install $package" -ForegroundColor Red
    }
}

Write-Success "Global npm packages installed"

Write-Host ""

# ===========================================
# 4. Python Tools
# ===========================================
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Step 4: Configuring Python" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$pythonInstalled = Get-Command python -ErrorAction SilentlyContinue

if ($pythonInstalled) {
    $pythonVersion = python --version
    Write-Success "Python is installed: $pythonVersion"
    $installedTools["Python"] = $pythonVersion
    
    # Install Python development tools via pip
    Write-Step "Installing Python development tools..."
    $pythonTools = @("poetry", "black", "pytest", "jupyter", "ipython")
    
    foreach ($tool in $pythonTools) {
        try {
            python -m pip install --user $tool --quiet
            Write-Host "  ✓ Installed $tool" -ForegroundColor Green
        } catch {
            Write-Host "  ✗ Failed to install $tool" -ForegroundColor Red
        }
    }
    
    Write-Success "Python development tools installed"
} else {
    Write-Fail "Python is not installed"
    Write-Host "  Run windows_install.ps1 first to install Python" -ForegroundColor Yellow
}

Write-Host ""

# ===========================================
# 5. Git Configuration
# ===========================================
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Step 5: Configuring Git" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$gitInstalled = Get-Command git -ErrorAction SilentlyContinue

if ($gitInstalled) {
    $gitVersion = git --version
    Write-Success "Git is installed: $gitVersion"
    $installedTools["Git"] = $gitVersion
    
    # Check if Git is already configured
    $gitUserName = git config --global user.name 2>$null
    $gitUserEmail = git config --global user.email 2>$null
    
    if (-not $gitUserName -or -not $gitUserEmail) {
        Write-Host ""
        Write-Host "Git Configuration" -ForegroundColor Yellow
        Write-Host "----------------" -ForegroundColor Yellow
        
        if (-not $gitUserName) {
            $userName = Read-Host "Enter your Git username"
            git config --global user.name "$userName"
        }
        
        if (-not $gitUserEmail) {
            $userEmail = Read-Host "Enter your Git email"
            git config --global user.email "$userEmail"
        }
        
        Write-Success "Git user configured"
    } else {
        Write-Success "Git is already configured: $gitUserName <$gitUserEmail>"
    }
    
    # Configure Git settings
    Write-Step "Configuring Git settings..."
    git config --global init.defaultBranch main
    git config --global credential.helper manager
    git config --global core.editor "code --wait"
    git config --global diff.tool vscode
    git config --global difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'
    git config --global merge.tool vscode
    git config --global mergetool.vscode.cmd 'code --wait $MERGED'
    
    # Set up Git aliases
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.st status
    git config --global alias.lg "log --graph --oneline --all"
    
    Write-Success "Git settings and aliases configured"
    
    # Configure Git in WSL if available
    if ($ubuntuInstalled) {
        Write-Step "Configuring Git in WSL..."
        try {
            wsl -d Ubuntu -- bash -c "git config --global user.name '$gitUserName' && git config --global user.email '$gitUserEmail' && git config --global init.defaultBranch main"
            Write-Success "Git configured in WSL"
        } catch {
            Write-Fail "Failed to configure Git in WSL: $_"
        }
    }
} else {
    Write-Fail "Git is not installed"
    Write-Host "  Run windows_install.ps1 first to install Git" -ForegroundColor Yellow
}

Write-Host ""

# ===========================================
# 6. AWS Configuration
# ===========================================
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Step 6: Configuring AWS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$awsInstalled = Get-Command aws -ErrorAction SilentlyContinue

if ($awsInstalled) {
    $awsVersion = aws --version
    Write-Success "AWS CLI is installed: $awsVersion"
    $installedTools["AWS CLI"] = $awsVersion
    
    # Check if AWS is configured
    $awsConfigured = Test-Path "$env:USERPROFILE\.aws\credentials"
    
    if (-not $awsConfigured) {
        Write-Host ""
        Write-Host "AWS Configuration" -ForegroundColor Yellow
        Write-Host "----------------" -ForegroundColor Yellow
        $configureAws = Read-Host "Would you like to configure AWS credentials now? (y/n)"
        
        if ($configureAws -eq "y") {
            aws configure
            Write-Success "AWS credentials configured"
        } else {
            Write-Host "  Skipping AWS configuration - run 'aws configure' later" -ForegroundColor Yellow
        }
    } else {
        Write-Success "AWS credentials are already configured"
        
        # Test AWS connection
        Write-Step "Testing AWS connection..."
        try {
            $identity = aws sts get-caller-identity --output json 2>&1 | ConvertFrom-Json
            Write-Success "AWS connection successful: $($identity.Arn)"
        } catch {
            Write-Host "  Could not verify AWS connection (credentials may need updating)" -ForegroundColor Yellow
        }
    }
    
    # Install AWS SAM CLI via Chocolatey
    Write-Step "Installing AWS SAM CLI..."
    try {
        choco install aws-sam-cli -y --ignore-checksums
        Write-Success "AWS SAM CLI installed"
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    } catch {
        Write-Fail "Failed to install AWS SAM CLI: $_"
    }
    
    # Install AWS CDK via npm (no Chocolatey package)
    Write-Step "Installing AWS CDK via npm..."
    try {
        npm install -g aws-cdk --silent
        Write-Success "AWS CDK installed"
    } catch {
        Write-Fail "Failed to install AWS CDK: $_"
    }
} else {
    Write-Fail "AWS CLI is not installed"
    Write-Host "  Run windows_install.ps1 first to install AWS CLI" -ForegroundColor Yellow
}

Write-Host ""

# ===========================================
# 7. Verification
# ===========================================
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Step 7: Verification" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Step "Verifying installations..."
Write-Host ""

# Check versions
$tools = @{
    "WSL" = { wsl --status 2>&1 | Select-String "WSL" }
    "Ubuntu" = { wsl -l -v | Select-String "Ubuntu" }
    "Docker" = { docker --version 2>&1 }
    "Node.js" = { node --version 2>&1 }
    "npm" = { npm --version 2>&1 }
    "Python" = { python --version 2>&1 }
    "pip" = { python -m pip --version 2>&1 }
    "Git" = { git --version 2>&1 }
    "AWS CLI" = { aws --version 2>&1 }
}

Write-Host "Installed Tools:" -ForegroundColor Cyan
Write-Host "----------------" -ForegroundColor Cyan

foreach ($tool in $tools.GetEnumerator()) {
    try {
        $version = & $tool.Value
        if ($version) {
            Write-Host "✓ $($tool.Key): $version" -ForegroundColor Green
        }
    } catch {
        Write-Host "✗ $($tool.Key): Not found" -ForegroundColor Red
    }
}

Write-Host ""

# Run basic tests
Write-Step "Running basic tests..."

# Test Docker (if running)
try {
    $dockerRunning = docker ps 2>&1
    if ($dockerRunning -notmatch "error") {
        docker run --rm hello-world 2>&1 | Out-Null
        Write-Host "  ✓ Docker test passed" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ Docker is not running (start Docker Desktop to test)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ⚠ Docker test skipped (start Docker Desktop to test)" -ForegroundColor Yellow
}

# Test WSL
try {
    $wslTest = wsl -d Ubuntu -- bash -c "echo 'WSL test'"
    if ($wslTest -eq "WSL test") {
        Write-Host "  ✓ WSL test passed" -ForegroundColor Green
    }
} catch {
    Write-Host "  ✗ WSL test failed" -ForegroundColor Red
}

Write-Host ""

# ===========================================
# Summary
# ===========================================
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Installation Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Successfully configured: $successCount items" -ForegroundColor Green
if ($failCount -gt 0) {
    Write-Host "Failed: $failCount items" -ForegroundColor Red
}

Write-Host ""
Write-Host "Installed Tools:" -ForegroundColor Cyan
foreach ($tool in $installedTools.GetEnumerator()) {
    Write-Host "  • $($tool.Key): $($tool.Value)" -ForegroundColor White
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Development Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Restart your computer for all changes to take effect" -ForegroundColor White
Write-Host "2. After restart, open Ubuntu from Start menu and set up your user" -ForegroundColor White
Write-Host "3. Start Docker Desktop when you need it (set to manual startup)" -ForegroundColor White
Write-Host "4. Configure SSH keys for GitHub in both Windows and WSL" -ForegroundColor White
Write-Host "5. Test your setup by creating a sample project" -ForegroundColor White
Write-Host ""

Write-Host "Useful Commands:" -ForegroundColor Yellow
Write-Host "  • Start WSL: wsl" -ForegroundColor White
Write-Host "  • Start Docker: Start Docker Desktop from Start menu" -ForegroundColor White
Write-Host "  • Check Node version: node --version" -ForegroundColor White
Write-Host "  • Check Python version: python --version" -ForegroundColor White
Write-Host "  • Check Git config: git config --global --list" -ForegroundColor White
Write-Host "  • AWS CLI: aws configure" -ForegroundColor White
Write-Host ""

$restart = Read-Host "Would you like to restart now? (y/n)"
if ($restart -eq "y") {
    Write-Host "Restarting computer in 10 seconds..." -ForegroundColor Yellow
    Start-Sleep -Seconds 10
    Restart-Computer -Force
}
