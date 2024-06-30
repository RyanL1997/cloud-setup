# Cloud Setup Scripts

This repository contains scripts to set up a development environment on an Ubuntu EC2 instance. The setup includes installing Git, Zsh, Oh My Zsh, fzf, zsh-syntax-highlighting, and zsh-autosuggestions.

## Table of Contents

- [Cloud Setup Scripts](#cloud-setup-scripts)
  - [Table of Contents](#table-of-contents)
  - [Prerequisites](#prerequisites)
  - [Usage](#usage)
    - [Cloning the Repository](#cloning-the-repository)
    - [Running the Setup Script](#running-the-setup-script)
  - [Details](#details)
  - [Troubleshooting](#troubleshooting)
  - [License](#license)

## Prerequisites

- An Ubuntu EC2 instance.
- SSH access to the EC2 instance.
- Basic knowledge of using the terminal.

## Usage

### Running the Setup Script Without Cloning

You can run the setup script directly without cloning the repository using the following command:

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/RyanL1997/cloud-setup/main/setup_env.sh)"
```

### Cloning the Repository

First, clone this repository to your local machine or directly to your EC2 instance:

```sh
git clone https://github.com/RyanL1997/cloud-setup.git
cd cloud-setup
```

### Running the Setup Script

1. Make the setup script executable:

    ```sh
    chmod +x setup_env.sh
    ```

2. Run the setup script:

    ```sh
    ./setup_env.sh
    ```

    This script will:
    - Check if Git is installed and install it if necessary.
    - Check if Zsh is installed and install it if necessary.
    - Switch to Zsh and run the Zsh-specific setup script.

## Details

### Main Setup Script (`setup_env.sh`)

The main setup script performs the following tasks:

1. Checks if the `workspace` directory is created and create it if necessary
2. Checks if Git is installed and installs it if necessary.
3. Checks if Zsh is installed and installs it if necessary.
4. Checks if Java is installed and installs it if necessary.
5. Switches to Zsh and runs the Zsh-specific setup script (`zsh_setup.sh`).

### Zsh-Specific Setup Script (`zsh_setup.sh`)

The Zsh-specific setup script performs the following tasks:

1. Checks if Oh My Zsh is installed and installs it if necessary.
2. Checks if `fzf` is installed and installs it if necessary.
3. Checks if `zsh-syntax-highlighting` is installed and installs it if necessary.
4. Checks if `zsh-autosuggestions` is installed and installs it if necessary.
5. Configures the `.zshrc` file to source the installed plugins and adds key bindings.
6. Reloads the Zsh configuration.

## Troubleshooting

- If the script fails, check the `install.log` and `zsh_setup.log` files for detailed error messages.
- Ensure you have the correct permissions to execute the scripts and install software on your EC2 instance.
