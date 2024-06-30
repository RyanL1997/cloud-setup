#!/usr/bin/zsh

set -e

LOG_FILE="zsh_setup.log"

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

# 1. Check if Oh My Zsh is installed
print_header "Checking if Oh My Zsh is installed"
if [ -d "$HOME/.oh-my-zsh" ]; then
  print_success "Oh My Zsh is already installed"
else
  echo "Oh My Zsh is not installed. Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || print_failure "Oh My Zsh installation failed"
  [ -d "$HOME/.oh-my-zsh" ] && print_success "Oh My Zsh successfully installed" || print_failure "Oh My Zsh installation failed"
fi

# 2. Check if fzf is installed
print_header "Checking if fzf is installed"
if command_exists fzf; then
  print_success "fzf is already installed"
else
  echo "fzf is not installed. Cloning fzf repository..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf || print_failure "fzf repository cloning failed"
  echo "Running fzf installation script..."
  ~/.fzf/install --all || print_failure "fzf installation script failed"
  source ~/.zshrc || print_failure "Sourcing .zshrc failed"
  command_exists fzf && print_success "fzf successfully installed" || print_failure "fzf installation failed"
fi

# 3. Check if zsh-syntax-highlighting is installed
print_header "Checking if zsh-syntax-highlighting is installed"
if [ -d "$HOME/.zsh/zsh-syntax-highlighting" ]; then
  print_success "zsh-syntax-highlighting is already installed"
else
  echo "zsh-syntax-highlighting is not installed. Cloning zsh-syntax-highlighting repository..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting || print_failure "zsh-syntax-highlighting repository cloning failed"
  source ~/.zshrc || print_failure "Sourcing .zshrc failed"
  [ -d "$HOME/.zsh/zsh-syntax-highlighting" ] && print_success "zsh-syntax-highlighting successfully installed" || print_failure "zsh-syntax-highlighting installation failed"
fi

# 4. Check if zsh-autosuggestions is installed
print_header "Checking if zsh-autosuggestions is installed"
if [ -d "$HOME/.zsh/zsh-autosuggestions" ]; then
  print_success "zsh-autosuggestions is already installed"
else
  echo "zsh-autosuggestions is not installed. Cloning zsh-autosuggestions repository..."
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions || print_failure "zsh-autosuggestions repository cloning failed"
  source ~/.zshrc || print_failure "Sourcing .zshrc failed"
  [ -d "$HOME/.zsh/zsh-autosuggestions" ] && print_success "zsh-autosuggestions successfully installed" || print_failure "zsh-autosuggestions installation failed"
fi

# Ensure the plugins are sourced in ~/.zshrc
print_header "Configuring .zshrc"
ZSHRC="$HOME/.zshrc"

if ! grep -q "source ~/.fzf.zsh" "$ZSHRC"; then
  echo "[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh" >> "$ZSHRC"
  print_success "Added fzf source to .zshrc"
fi

if ! grep -q "source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" "$ZSHRC"; then
  echo "source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$ZSHRC"
  print_success "Added zsh-syntax-highlighting source to .zshrc"
fi

if ! grep -q "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" "$ZSHRC"; then
  echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> "$ZSHRC"
  print_success "Added zsh-autosuggestions source to .zshrc"
fi

if ! grep -q "bindkey '^R' fzf-history-widget" "$ZSHRC"; then
  echo "bindkey '^R' fzf-history-widget" >> "$ZSHRC"
  print_success "Added fzf-history-widget binding to .zshrc"
fi

# Copy .zshrc to the specified directory
print_header "Copying .zshrc to $HOME/.zshhrc/workspace/cloud-setup"
TARGET_DIR="$HOME/.zshhrc/workspace/cloud-setup"
mkdir -p "$TARGET_DIR"
cp ~/.zshrc "$TARGET_DIR"

# Verify the copy
if [ -f "$TARGET_DIR/.zshrc" ]; then
  print_success ".zshrc has been copied to $TARGET_DIR"
else
  print_failure "Failed to copy .zshrc to $TARGET_DIR"
fi

# Reload Zsh configuration
print_header "Reloading Zsh configuration"
source "$ZSHRC"

print_success "Setup completed successfully!"