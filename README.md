# shellPass - Secure Password Generator for Terminal

[![Release](https://img.shields.io/badge/version-4.0.0-blue)](https://github.com/mateuscomh/shellPass/releases/latest)
[![License](https://img.shields.io/badge/license-GPL--3.0-orange)](https://github.com/mateuscomh/shellPass/blob/main/LICENSE)
[![Build Status](https://github.com/mateuscomh/shellPass/actions/workflows/super-linter.yml/badge.svg)](https://github.com/mateuscomh/shellPass/actions/workflows/super-linter.yml)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/mateuscomh/shellPass/pulls)

A lightweight, secure, and customizable password generator for command-line enthusiasts.

## ✨ Features

- Generate cryptographically secure passwords using /dev/random
- Blazing fast execution with zero dependencies
- Customizable password length and complexity
- Cross-platform support (Linux, macOS, WSL2)
- Copy to clipboard functionality (where available)
- Multiple password generation in one command
- Strength indicator for generated passwords

## 🚀 Installation

### Basic Installation
```bash
git clone https://github.com/mateuscomh/shellPass.git
cd shellPass
chmod +x shellPass.sh
```
### System-wide Installation (Optional)
```bash
sudo cp shellPass.sh /usr/local/bin/shellpass
```
Basic password generation:
    To generate a default 12-character password, run:
```bash
$ ./shellPass.sh
```

To generate a password with specific length (ex: 20 chars):
```bash
$ ./shellPass.sh 20
```
To generate multiple passwords (ex: 5 passwords of 16 chars each):
```bash
$ ./shellPass.sh 16 5
```
To show the help menu with all available options:
```bash
$ ./shellPass.sh -h
```

Pro Tip:
For quick access, add this alias to your shell configuration file (.bashrc, .zshrc, etc.):
```bash
$ alias passgen='~/path/to/shellPass.sh'
```

## Contribution
Contributions to this project are welcome. If you have any suggestions, bug fixes, or improvements, feel free to open an issue or submit a pull request.

## License
This project is licensed under the GPL-3.0 License. See the [LICENSE](https://github.com/mateuscomh/shellPass/blob/main/LICENSE) file for more details.

Made with ❤️ by [Matheus Martins](https://www.linkedin.com/in/matheushsmartins)