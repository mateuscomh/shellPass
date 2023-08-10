# shellPass - Shell Script Password Generator

[![Release](https://img.shields.io/badge/release-2.7-brightgreen)](https://github.com/mateuscomh/shellPass/releases)
[![Build Status](https://github.com/mateuscomh/shellPass/actions/workflows/super-linter.yml/badge.svg)](https://github.com/mateuscomh/shellPass/actions/workflows/super-linter.yml)

## Overview

shellPass is a fast, simple, and powerful open-source utility tool designed for generating unique and random passwords in the terminal. This script was authored by me and is compatible with macOS, GNU/Linux, and WSL2 environments.

The program offers options to customize both the length and complexity of generated passwords. It utilizes the special `/dev/random` folder to ensure the generation of secure and unique passwords.


![Screenshot](https://github.com/mateuscomh/shellPass/blob/main/screenshot.png)

## Motivation

The motivation behind the shellPass project was to fulfill my personal need for an accessible password generator in the terminal. With shellPass, I aimed to create a straightforward and effective solution for generating secure and unique passwords whenever needed.

## Key Features

- Fast and easy generation of secure passwords
- Customize the length of passwords
- Works on GNU/Linux and macOS terminals

## Installation and Usage

Follow the steps below to install and start using shellPass:

1. Clone this repository:

   ```bash
   git clone https://github.com/mateuscomh/shellPass.git && cd shellPass
   ```
   
2. Grant execution permission to the script:

```bash
chmod +x shellPass.sh
```

3. Run the script in the terminal, specifying the desired number of characters for the password:

```bash
./shellPass.sh 15
# or simply
./shellPass.sh
```

* Recommendation: Create an alias to expedite the process! *

  Contribution
Contributions to this project are welcome. If you have any suggestions, bug fixes, or improvements, feel free to open an issue or submit a pull request.

License
This project is licensed under the GPL-3.0 License. See the [LICENSE](https://github.com/mateuscomh/shellPass/blob/main/LICENSE) file for more details.

Made with ❤️ by [Matheus Martins](https://www.linkedin.com/in/matheushsmartins)

