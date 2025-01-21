#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to determine the architecture (Intel or ARM)
get_architecture() {
    arch_name=$(uname -m)
    if [[ "$arch_name" == "x86_64" ]]; then
        echo "x86_64"
    elif [[ "$arch_name" == "arm64" ]]; then
        echo "arm64"
    else
        echo "Unsupported architecture: $arch_name"
        exit 1
    fi
}

# Define download URLs based on architecture
ARCH=$(get_architecture)
if [[ "$ARCH" == "x86_64" ]]; then
    DOWNLOAD_URL="https://repo.anaconda.com/archive/Anaconda3-2023.07-1-MacOSX-x86_64.sh"
    CHECKSUM_URL="https://repo.anaconda.com/archive/Anaconda3-2023.07-1-MacOSX-x86_64.sh.sha256"
elif [[ "$ARCH" == "arm64" ]]; then
    DOWNLOAD_URL="https://repo.anaconda.com/archive/Anaconda3-2023.07-1-MacOSX-arm64.sh"
    CHECKSUM_URL="https://repo.anaconda.com/archive/Anaconda3-2023.07-1-MacOSX-arm64.sh.sha256"
fi

# Download the installer and checksum
echo "Downloading Anaconda installer for $ARCH..."
curl -O $DOWNLOAD_URL
curl -O $CHECKSUM_URL

# Extract the filename from the URL
INSTALLER_FILENAME=$(basename $DOWNLOAD_URL)
CHECKSUM_FILENAME=$(basename $CHECKSUM_URL)

# Verify the checksum
echo "Verifying the checksum..."
shasum -a 256 -c $CHECKSUM_FILENAME

# Make the installer executable
chmod +x $INSTALLER_FILENAME

# Run the installer
echo "Running the Anaconda installer..."
./$INSTALLER_FILENAME

# Initialize Conda
echo "Initializing Conda..."
source ~/.bash_profile || source ~/.zshrc || true
conda init

# Cleanup
echo "Cleaning up installation files..."
rm -f $INSTALLER_FILENAME $CHECKSUM_FILENAME

echo "Anaconda installation completed successfully."
