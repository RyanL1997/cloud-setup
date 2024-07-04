#!/bin/bash

set -e

LOG_FILE="install.log"

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to print start messages
print_start() {
  echo -e "\e[33m[START]\e[0m $1"
}

# Function to print success messages
print_success() {
  echo -e "\e[32m[SUCCESS]\e[0m $1\n"
}

# Function to print failure messages and show logs
print_failure() {
  echo -e "\e[31m[FAILURE]\e[0m $1\n"
  cat "$LOG_FILE"
  exit 1
}

# Redirect all output to a log file
exec > >(tee -i "$LOG_FILE") 2>&1

# 1. Check if workspace directory exists
print_start "Checking if workspace directory exists"
WORKSPACE_DIR="$HOME/workspace"
if [ -d "$WORKSPACE_DIR" ]; then
  print_success "workspace directory already exists"
else
  echo -e "\e[34mworkspace directory does not exist. Creating workspace directory...\e[0m"
  mkdir -p "$WORKSPACE_DIR"
  if [ -d "$WORKSPACE_DIR" ]; then
    print_success "workspace directory successfully created"
  else
    print_failure "Failed to create workspace directory"
  fi
fi

# 2. Check if git is installed
print_start "Checking if git is installed"
if command_exists git; then
  print_success "git is already installed"
else
  echo -e "\e[34mgit is not installed. Installing git...\e[0m"
  sudo apt-get update && sudo apt-get install -y git || print_failure "git installation failed"
  command_exists git && print_success "git successfully installed" || print_failure "git installation failed"
fi

# 3. Check if zsh is installed
print_start "Checking if zsh is installed"
if command_exists zsh; then
  print_success "zsh is already installed"
else
  echo -e "\e[34mzsh is not installed. Installing zsh...\e[0m"
  sudo apt-get install -y zsh || print_failure "zsh installation failed"
  command_exists zsh && print_success "zsh successfully installed" || print_failure "zsh installation failed"
fi

# 4. Check if Java is installed
print_start "Checking if Java is installed"
if command_exists java; then
  print_success "Java is already installed"
else
  echo -e "\e[34mJava is not installed. Installing Amazon Corretto 11...\e[0m"
  sudo apt-get install -y wget
  wget -O- https://apt.corretto.aws/corretto.key | sudo apt-key add - || print_failure "Failed to add Corretto GPG key"
  sudo add-apt-repository 'deb https://apt.corretto.aws stable main' || print_failure "Failed to add Corretto repository"
  sudo apt-get update && sudo apt-get install -y java-11-amazon-corretto-jdk || print_failure "Java installation failed"
  command_exists java && print_success "Java successfully installed" || print_failure "Java installation failed"
fi

# 5. Check if zellij is installed
print_start "Checking if zellij is installed"
if command_exists zellij; then
  print_success "zellij is already installed"
else
  read -p "zellij is not installed. Do you want to install zellij? (y/n): " choice
  case "$choice" in 
    y|Y)
      echo -e "\e[34mInstalling zellij...\e[0m"
      sudo apt-get install -y cargo || print_failure "cargo installation failed"
      cargo install zellij || print_failure "zellij installation failed"
      command_exists zellij && print_success "zellij successfully installed" || print_failure "zellij installation failed"
      ;;
    n|N)
      echo -e "\e[33mSkipping zellij installation...\e[0m"
      ;;
    *)
      echo -e "\e[31mInvalid choice. Skipping zellij installation...\e[0m"
      ;;
  esac
fi

# 6. Switch to zsh and run zsh-specific setup script
print_start "Switching to zsh to continue the zsh specific setup"
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/RyanL1997/cloud-setup/main/zsh_setup.sh)" || print_failure "zsh-specific setup script failed"
