#!/bin/bash

set -e

LOG_FILE="install.log"

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to print section headers
print_header() {
  echo "###############################################"
  echo "# $1"
  echo "###############################################"
}

# Function to print success messages
print_success() {
  echo -e "\e[32m[SUCCESS]\e[0m $1"
}

# Function to print failure messages and show logs
print_failure() {
  echo -e "\e[31m[FAILURE]\e[0m $1"
  cat "$LOG_FILE"
  exit 1
}

# Redirect all output to a log file
exec > >(tee -i "$LOG_FILE") 2>&1

# 1. Check if workspace directory exists
print_header "Checking if workspace directory exists"
WORKSPACE_DIR="$HOME/workspace"
if [ -d "$WORKSPACE_DIR" ]; then
  print_success "workspace directory already exists"
else
  echo "workspace directory does not exist. Creating workspace directory..."
  mkdir -p "$WORKSPACE_DIR"
  if [ -d "$WORKSPACE_DIR" ]; then
    print_success "workspace directory successfully created"
  else
    print_failure "Failed to create workspace directory"
  fi
fi

# 2. Check if git is installed
print_header "Checking if git is installed"
if command_exists git; then
  print_success "git is already installed"
else
  echo "git is not installed. Installing git..."
  sudo apt-get update && sudo apt-get install -y git || print_failure "git installation failed"
  command_exists git && print_success "git successfully installed" || print_failure "git installation failed"
fi

# 3. Check if zsh is installed
print_header "Checking if zsh is installed"
if command_exists zsh; then
  print_success "zsh is already installed"
else
  echo "zsh is not installed. Installing zsh..."
  sudo apt-get install -y zsh || print_failure "zsh installation failed"
  command_exists zsh && print_success "zsh successfully installed" || print_failure "zsh installation failed"
fi

# 4. Switch to zsh and run zsh-specific setup script
print_header "Switching to zsh to complete setup"
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/RyanL1997/cloud-setup/main/zsh_setup.sh)" || print_failure "zsh-specific setup script failed"
