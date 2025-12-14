# Development Guide

This document describes the development workflow, coding style, and philosophies used in this project.

## 🎯 Development Philosophy

### Keep It Simple
- Scripts should be straightforward and easy to understand
- Prefer clarity over cleverness
- One script, one purpose - but comprehensive within that purpose

### Test What You Ship
- Run scripts on actual machines before committing
- Test both fresh installs and existing configurations
- Verify package installations actually work

### Error Handling Matters
- Always wrap risky operations in try/catch
- Provide meaningful error messages
- Count successes and failures for user visibility
- Don't silently fail - log what went wrong

### User Experience First
- Show progress clearly with color-coded output
- Summarize what happened at the end
- Don't block the script unnecessarily
- Let users know what to expect (time, reboots, manual steps)

## 🛠️ Coding Style

### PowerShell Scripts

**Variable Naming**
```powershell
# Use descriptive camelCase
$packageList = @()
$successCount = 0
$isAdmin = $true
```

**Output Style**
```powershell
# Consistent formatting with colors
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Section Title" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Actions with arrows
Write-Host "→ Doing something..." -ForegroundColor Cyan

# Success with checkmarks
Write-Host "✓ Task completed successfully" -ForegroundColor Green

# Errors with X marks
Write-Host "✗ Task failed: error details" -ForegroundColor Red

# Warnings
Write-Host "⚠ Warning message" -ForegroundColor Yellow
```

**Error Handling Pattern**
```powershell
try {
    # Risky operation
    choco install package -y
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Success" -ForegroundColor Green
        $successCount++
    } else {
        Write-Host "✗ Failed" -ForegroundColor Red
        $failCount++
    }
} catch {
    Write-Host "✗ Error: $_" -ForegroundColor Red
    $failCount++
}
```

**Arrays & Lists**
```powershell
# Alphabetically sorted for maintainability
$packages = @(
    "app-a",
    "app-b",
    "app-c"
)

# Loop pattern
foreach ($package in $packages) {
    # Process each item
    Write-Host "Installing $package..." -ForegroundColor Cyan
}
```

### Bash Scripts

**Variable Naming**
```bash
# Use lowercase with underscores
package_list=""
success_count=0
is_installed=true
```

**Function Style**
```bash
# Clear function names
install_package() {
    local package_name=$1
    echo "Installing $package_name..."
}
```

## 📦 Adding New Packages

### Windows (Chocolatey)

1. **Verify package exists**:
   ```powershell
   choco search package-name
   ```

2. **Add to array in alphabetical order**:
   ```powershell
   $packages = @(
       "existing-package",
       "new-package",  # Add here
       "next-package"
   )
   ```

3. **Test installation**:
   ```powershell
   choco install new-package -y
   ```

4. **Update README.md** if it's a significant addition

### macOS (Homebrew)

1. **Verify formula/cask exists**:
   ```bash
   brew search package-name
   ```

2. **Add to script**:
   ```bash
   brew install package-name
   # or
   brew install --cask package-name
   ```

3. **Test on actual macOS**

## 🎨 Code Organization

### Script Structure (PowerShell)
```powershell
# 1. Header comments
# Script purpose and description

# 2. Admin/prerequisite checks
if (-not $isAdmin) { exit 1 }

# 3. Initial setup (Chocolatey, Homebrew, etc.)

# 4. Package installation with GPU detection if needed

# 5. System tweaks/configuration

# 6. Shell customization

# 7. Additional tools (PowerShell modules, etc.)

# 8. Final steps (O&O ShutUp10++, etc.)

# 9. Summary and next steps
```

### File Organization
```
pc-setup/
├── win/
│   ├── windows_install.ps1    # Main Windows script
│   └── vscode_extensions.ps1  # VS Code setup
├── mac/
│   ├── brew_install.sh         # Homebrew packages
│   ├── mac_install.sh          # System customization
│   └── vscode.sh               # VS Code setup
├── README.md
├── LICENSE
├── CONTRIBUTING.md
└── DEVELOPMENT.md
```

## 🧪 Testing Workflow

### Before Committing
1. ✅ Run the script on a test system
2. ✅ Check for syntax errors
3. ✅ Verify package names are correct
4. ✅ Test error handling (try invalid package)
5. ✅ Review output messages for clarity
6. ✅ Update documentation if needed

### Testing Checklist
- [ ] Script runs without errors
- [ ] Admin check works properly
- [ ] Packages install successfully
- [ ] Error messages are helpful
- [ ] Success/failure counts are accurate
- [ ] No breaking changes to existing functionality
- [ ] README reflects any significant changes

## 🎭 The Vibe

### Be Pragmatic
- If something works and is maintainable, ship it
- Don't over-engineer simple solutions
- Prefer working code over perfect code

### Be Helpful
- Comments should explain *why*, not *what*
- Error messages should guide users to solutions
- Documentation should be scannable and practical

### Be Consistent
- Follow existing patterns in the codebase
- Use the same formatting throughout
- Keep similar scripts similar in structure

### Be Bold
- Try new approaches if they improve UX
- Don't be afraid to refactor if it makes things clearer
- Add features that solve real problems

## 🔧 Tools & Environment

### Recommended Tools
- **VS Code** with PowerShell extension
- **Git** for version control
- **Windows Terminal** for testing PowerShell scripts
- **Virtual Machine** for testing fresh installs (ideal but not required)

### VS Code Extensions
- PowerShell
- GitLens
- Markdown All in One
- ShellCheck (for bash scripts)

## 📝 Commit Style

```bash
# Good commit messages
git commit -m "Add ripgrep and fd to Windows package list"
git commit -m "Fix error handling in GPU detection"
git commit -m "Update README with new privacy tweaks"

# Group related changes
git add win/windows_install.ps1 README.md
git commit -m "Add CLI productivity tools (fzf, bat, ripgrep, fd, zoxide)"
```

## 🚀 Release Process

1. Test on actual hardware
2. Update version/date comments if applicable
3. Update README.md with changes
4. Commit with clear message
5. Push to GitHub
6. Tag if it's a significant update
7. Update releases section on GitHub

## 💡 Ideas for Future

### Potential Improvements
- [ ] Add Windows package categories/groups
- [ ] Optional package selection
- [ ] Configuration file for personal customization
- [ ] Automated testing with GitHub Actions
- [ ] Silent/unattended mode
- [ ] Rollback/uninstall script
- [ ] Linux support (apt/dnf scripts)
- [ ] Package update script

### Won't Do (Keep It Simple)
- ❌ Complex GUI - terminal is fine
- ❌ Package manager abstraction - Chocolatey/Homebrew work great
- ❌ Cross-platform single script - separate scripts are clearer

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on contributing to this project.

---

**Remember**: Code is read more than it's written. Make it clear, make it work, make it maintainable.
