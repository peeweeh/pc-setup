# Contribution Guidelines

Thank you for considering contributing to PC Setup Scripts!

## How to Contribute

### Reporting Issues
- Check if the issue already exists
- Include your OS version
- Provide error messages and logs
- Describe steps to reproduce

### Suggesting Enhancements
- Clearly describe the enhancement
- Explain why it would be useful
- Provide examples if applicable

### Pull Requests
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Make your changes
4. Test thoroughly on your system
5. Commit with clear messages (`git commit -m 'Add feature: description'`)
6. Push to your fork (`git push origin feature/your-feature`)
7. Open a Pull Request

## Code Standards

### PowerShell Scripts
- Use meaningful variable names
- Add comments for complex logic
- Include error handling with try/catch
- Test on Windows 10 and 11
- Follow consistent formatting

### Bash Scripts
- Use shellcheck to validate
- Include shebang (`#!/bin/bash`)
- Add comments for clarity
- Test on multiple macOS versions

### Package Additions
When adding packages:
- Verify the package exists in Chocolatey/Homebrew
- Add to the appropriate alphabetical position
- Include package name in README if significant
- Test installation on clean system

### Documentation
- Update README.md for new features
- Keep documentation clear and concise
- Include usage examples
- Update version information

## Testing
- Test scripts on fresh installations when possible
- Verify packages install correctly
- Check for conflicts with existing software
- Test error handling

## Questions?
Open an issue for any questions or clarifications needed.

Thank you for contributing! 🎉
