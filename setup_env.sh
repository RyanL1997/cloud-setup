#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# 1. Check if git is installed
if command_exists git; then
  echo "git is already installed"
else
  echo "git is not installed. Installing git..."
  sudo apt-get update
  sudo apt-get install -y git
  if command_exists git; then
    echo "git successfully installed"
  else
    echo "git installation failed"
    exit 1
  fi
fi

# 2. Check if Oh My Zsh is installed
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "Oh My Zsh is already installed"
else
  echo "Oh My Zsh is not installed. Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh successfully installed"
  else
    echo "Oh My Zsh installation failed"
    exit 1
  fi
fi

# 3. Check if fzf is installed
if command_exists fzf; then
  echo "fzf is already installed"
else
  echo "fzf is not installed. Installing fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all
  if command_exists fzf; then
    echo "fzf successfully installed"
  else
    echo "fzf installation failed"
    exit 1
  fi
fi

# 4. Check if zsh-syntax-highlighting is installed
if [ -d "$HOME/.zsh/zsh-syntax-highlighting" ]; then
  echo "zsh-syntax-highlighting is already installed"
else
  echo "zsh-syntax-highlighting is not installed. Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
  if [ -d "$HOME/.zsh/zsh-syntax-highlighting" ]; then
    echo "zsh-syntax-highlighting successfully installed"
  else
    echo "zsh-syntax-highlighting installation failed"
    exit 1
  fi
fi

# 5. Check if zsh-autosuggestions is installed
if [ -d "$HOME/.zsh/zsh-autosuggestions" ]; then
  echo "zsh-autosuggestions is already installed"
else
  echo "zsh-autosuggestions is not installed. Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
  if [ -d "$HOME/.zsh/zsh-autosuggestions" ]; then
    echo "zsh-autosuggestions successfully installed"
  else
    echo "zsh-autosuggestions installation failed"
    exit 1
  fi
fi

# Ensure the plugins are sourced in ~/.zshrc
ZSHRC="$HOME/.zshrc"

if ! grep -q "source ~/.fzf.zsh" "$ZSHRC"; then
  echo "[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh" >> "$ZSHRC"
fi

if ! grep -q "source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" "$ZSHRC"; then
  echo "source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$ZSHRC"
fi

if ! grep -q "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" "$ZSHRC"; then
  echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> "$ZSHRC"
fi

if ! grep -q "bindkey '^R' fzf-history-widget" "$ZSHRC"; then
  echo "bindkey '^R' fzf-history-widget" >> "$ZSHRC"
fi

# Copy .zshrc to the specified directory
TARGET_DIR="$HOME/.zshhrc/workspace/cloud-setup"
mkdir -p "$TARGET_DIR"
cp ~/.zshrc "$TARGET_DIR"

# Verify the copy
if [ -f "$TARGET_DIR/.zshrc" ]; then
  echo ".zshrc has been copied to $TARGET_DIR"
else
  echo "Failed to copy .zshrc to $TARGET_DIR"
  exit 1
fi

# Reload Zsh configuration
source "$ZSHRC"

echo "Setup completed successfully!"
