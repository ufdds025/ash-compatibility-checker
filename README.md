# Ash Compatibility Checker

A comprehensive tool for checking and validating compatibility of Ash programming language components, libraries, and dependencies.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Usage](#usage)
- [Configuration](#configuration)
- [API Reference](#api-reference)
- [Examples](#examples)
- [Contributing](#contributing)
- [License](#license)
- [Support](#support)

## Overview

The Ash Compatibility Checker is a robust utility designed to streamline the process of validating compatibility across Ash language versions, libraries, and dependencies. This tool helps developers ensure their code and projects maintain compatibility standards and can identify potential issues before deployment.

### Key Benefits

- **Version Compatibility Validation**: Check if your code is compatible with specific Ash versions
- **Dependency Analysis**: Analyze and validate library and dependency compatibility
- **Automated Testing**: Run compatibility checks across multiple configurations
- **Detailed Reporting**: Generate comprehensive compatibility reports with actionable insights
- **CI/CD Integration**: Seamless integration with continuous integration and deployment pipelines

## Features

### Core Capabilities

- ✅ **Multi-version Support**: Test compatibility across multiple Ash language versions
- ✅ **Dependency Checker**: Validate library versions and their compatibility
- ✅ **Configuration Management**: Easy-to-use configuration files for custom checks
- ✅ **Detailed Reports**: Generate HTML, JSON, and text-based compatibility reports
- ✅ **CLI Interface**: Command-line tool for integration into build pipelines
- ✅ **API Access**: Programmatic access for integration into other tools
- ✅ **Caching**: Intelligent caching for improved performance
- ✅ **Extensible**: Plugin system for custom compatibility checks

## Installation

### Prerequisites

- Ash programming language (version 1.0 or higher)
- Python 3.8 or higher (for Python-based tools)
- Git for version control

### From Source

```bash
git clone https://github.com/ufdds025/ash-compatibility-checker.git
cd ash-compatibility-checker
./install.sh
```

### Using Package Manager

```bash
# For Ash package manager
ash pkg install ash-compatibility-checker

# For Python-based installation
pip install ash-compatibility-checker
```

### Docker

```bash
docker pull ufdds025/ash-compatibility-checker:latest
docker run -v $(pwd):/workspace ufdds025/ash-compatibility-checker:latest
```

## Quick Start

### Basic Usage

1. **Navigate to your project directory**:
```bash
cd /path/to/your/ash/project
```

2. **Run a basic compatibility check**:
```bash
ash-check
```

3. **View the results**:
```bash
cat compatibility-report.txt
```

### Check Specific Version

```bash
ash-check --version 1.5.0
```

### Generate HTML Report

```bash
ash-check --format html --output report.html
```

## Usage

### Command Line Interface

#### Basic Check

```bash
ash-check [options]
```

#### Available Options

| Option | Description | Example |
|--------|-------------|---------|
| `--version, -v` | Check compatibility with specific Ash version | `--version 1.5.0` |
| `--versions` | Check multiple versions | `--versions 1.4.0,1.5.0,1.6.0` |
| `--config, -c` | Use custom configuration file | `-c .ash-check.json` |
| `--format, -f` | Output format (text, json, html) | `-f json` |
| `--output, -o` | Output file path | `-o report.html` |
| `--strict` | Enable strict compatibility checking | `--strict` |
| `--verbose` | Enable verbose logging | `--verbose` |
| `--dependencies` | Check dependencies only | `--dependencies` |
| `--help, -h` | Display help information | `--help` |

#### Examples

```bash
# Check against multiple versions
ash-check --versions 1.4.0,1.5.0,1.6.0

# Generate JSON report with verbose output
ash-check --format json --output results.json --verbose

# Check only dependencies in strict mode
ash-check --dependencies --strict

# Use custom configuration
ash-check --config my-config.json --format html
```

### Programmatic Usage

```ash
import "ash-compatibility-checker" as checker

# Create a compatibility checker instance
let check = checker.new()

# Run a basic check
let result = check.validate()

# Check specific version
let result = check.validate_version("1.5.0")

# Check multiple versions
let results = check.validate_versions(["1.4.0", "1.5.0", "1.6.0"])

# Access results
if result.is_compatible {
    println("✓ Code is compatible")
} else {
    println("✗ Compatibility issues found:")
    for issue in result.issues {
        println("  - " + issue.message)
    }
}
```

## Configuration

### Configuration File Format

Create a `.ash-check.json` file in your project root:

```json
{
  "version": "1.0",
  "check": {
    "enabled": true,
    "strict_mode": false,
    "min_version": "1.0.0",
    "max_version": "2.0.0"
  },
  "dependencies": {
    "validate": true,
    "allowed_versions": {
      "lib-a": "^1.2.0",
      "lib-b": ">=1.0.0,<2.0.0"
    }
  },
  "ignore": [
    "deprecated_feature.ash",
    "legacy/**/*.ash"
  ],
  "custom_checks": [
    "checks/custom-validator.ash"
  ],
  "report": {
    "format": "json",
    "output": "./reports/compatibility.json",
    "include_warnings": true
  }
}
```

### Configuration Options

#### Check Section

- `enabled`: Enable/disable compatibility checking
- `strict_mode`: Enable strict mode for more rigorous checking
- `min_version`: Minimum compatible Ash version
- `max_version`: Maximum compatible Ash version

#### Dependencies Section

- `validate`: Enable dependency validation
- `allowed_versions`: Specify allowed versions for dependencies using semantic versioning

#### Ignore Section

- List of file patterns to exclude from checks (glob patterns supported)

#### Custom Checks

- Path to custom validation scripts

#### Report Section

- `format`: Output format (text, json, html)
- `output`: Output file path
- `include_warnings`: Include warnings in reports

## API Reference

### Core Methods

#### `Checker.new() -> Checker`

Creates a new compatibility checker instance.

```ash
let checker = Checker.new()
```

#### `Checker.validate() -> Result`

Runs compatibility validation on the current project.

```ash
let result = checker.validate()
```

**Returns**: `Result` object with compatibility information

#### `Checker.validate_version(version: String) -> Result`

Validates compatibility with a specific Ash version.

```ash
let result = checker.validate_version("1.5.0")
```

#### `Checker.validate_versions(versions: List<String>) -> List<Result>`

Validates compatibility with multiple Ash versions.

```ash
let results = checker.validate_versions(["1.4.0", "1.5.0", "1.6.0"])
```

#### `Checker.set_config(config: Config) -> Checker`

Sets a custom configuration for the checker.

```ash
let config = Config.load("path/to/config.json")
checker.set_config(config)
```

### Result Object

- `is_compatible: Boolean` - Whether code is compatible
- `version: String` - Ash version checked against
- `issues: List<Issue>` - List of compatibility issues found
- `warnings: List<String>` - List of warnings
- `timestamp: DateTime` - Time of check

### Issue Object

- `severity: String` - Issue severity (error, warning, info)
- `code: String` - Issue code for reference
- `message: String` - Human-readable message
- `file: String` - File where issue was found
- `line: Integer` - Line number of issue

## Examples

### Example 1: Basic Project Validation

```bash
#!/bin/bash
# Validate project compatibility with current Ash version
cd /path/to/project
ash-check --format text --output validation.txt
echo "Validation complete. Check validation.txt for details."
```

### Example 2: Multi-Version Testing

```bash
#!/bin/bash
# Test compatibility across versions
versions=("1.3.0" "1.4.0" "1.5.0" "1.6.0")
for version in "${versions[@]}"; do
    echo "Testing with Ash $version..."
    ash-check --version "$version" --output "report-$version.json" --format json
done
```

### Example 3: CI/CD Integration

```yaml
# GitHub Actions workflow example
name: Compatibility Check
on: [push, pull_request]

jobs:
  compatibility:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install Ash Compatibility Checker
        run: pip install ash-compatibility-checker
      - name: Run compatibility check
        run: ash-check --versions 1.4.0,1.5.0,1.6.0 --format json --output results.json
      - name: Upload results
        uses: actions/upload-artifact@v2
        with:
          name: compatibility-reports
          path: results.json
```

### Example 4: Custom Configuration

```json
{
  "check": {
    "enabled": true,
    "strict_mode": true,
    "min_version": "1.5.0"
  },
  "dependencies": {
    "validate": true,
    "allowed_versions": {
      "ash-stdlib": "^1.5.0",
      "ash-ui": "^2.0.0"
    }
  },
  "ignore": [
    "vendor/**/*",
    "build/**/*"
  ]
}
```

## Contributing

We welcome contributions from the community! Here's how you can help:

### Getting Started

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Write or update tests
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Development Setup

```bash
git clone https://github.com/ufdds025/ash-compatibility-checker.git
cd ash-compatibility-checker
./setup-dev.sh
```

### Running Tests

```bash
# Run all tests
./test.sh

# Run specific test suite
./test.sh --suite unit

# Generate coverage report
./test.sh --coverage
```

### Code Style

- Follow the [Ash Style Guide](https://ash-lang.org/docs/style-guide)
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions focused and concise

### Reporting Issues

Found a bug? Please open an issue with:

- Clear description of the problem
- Steps to reproduce
- Expected behavior
- Actual behavior
- Your environment (OS, Ash version, etc.)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

### Documentation

- [Official Documentation](https://github.com/ufdds025/ash-compatibility-checker/wiki)
- [API Reference](#api-reference)
- [FAQ](https://github.com/ufdds025/ash-compatibility-checker/wiki/FAQ)

### Getting Help

- 📖 [Documentation](https://github.com/ufdds025/ash-compatibility-checker/wiki)
- 💬 [Discussions](https://github.com/ufdds025/ash-compatibility-checker/discussions)
- 🐛 [Issue Tracker](https://github.com/ufdds025/ash-compatibility-checker/issues)
- 📧 Email: support@example.com

### Community

- Join our [Discord server](https://discord.gg/example)
- Follow on [Twitter](https://twitter.com/example)
- Check out [related projects](https://github.com/ufdds025)

---

**Last Updated**: 2025-12-30

For the latest updates, visit the [GitHub repository](https://github.com/ufdds025/ash-compatibility-checker).