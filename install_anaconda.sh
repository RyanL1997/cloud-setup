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

# Define download URLs and pre-verified checksums
ARCH=$(get_architecture)
if [[ "$ARCH" == "x86_64" ]]; then
    DOWNLOAD_URL="https://repo.anaconda.com/archive/Anaconda3-2023.07-1-MacOSX-x86_64.sh"
    EXPECTED_CHECKSUM="9e5edfb61d80b2d65d0e3a0dd93f1e68a1cfce20e2f9f11f0cb25f6f6b20575b"
elif [[ "$ARCH" == "arm64" ]]; then
    DOWNLOAD_URL="https://repo.anaconda.com/archive/Anaconda3-2023.07-1-MacOSX-arm64.sh"
    EXPECTED_CHECKSUM="42a334e83492fa748e24ff2b0d08a79858ac007926172947a86c261e9aa56f3b"
fi

# Download the installer
echo "Downloading Anaconda installer for $ARCH..."
curl -O $DOWNLOAD_URL

# Extract the filename from the URL
INSTALLER_FILENAME=$(basename $DOWNLOAD_URL)

# Compute the actual checksum of the downloaded installer
echo "Computing the actual checksum..."
ACTUAL_CHECKSUM=$(shasum -a 256 $INSTALLER_FILENAME | awk '{print $1}')

# Compare the checksums
if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
    echo "Checksum verification failed!"
    echo "Expected: $EXPECTED_CHECKSUM"
    echo "Actual: $ACTUAL_CHECKSUM"
    exit 1
fi
echo "Checksum verified successfully."

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
rm -f $INSTALLER_FILENAME

echo "Anaconda installation completed successfully."
