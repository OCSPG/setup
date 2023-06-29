#!/bin/bash

set -e

# Function to install yay
install_yay() {
    # Check if Color option is uncommented in pacman.conf
    if ! grep -q '^#Color' /etc/pacman.conf; then
        sudo sed -i 's/^#Color$/Color/' /etc/pacman.conf
    fi

    # Check if ParallelDownloads option is uncommented in pacman.conf
    if ! grep -q '^#ParallelDownloads' /etc/pacman.conf; then
        sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
    fi

    git clone https://aur.archlinux.org/yay.git
    (cd yay && makepkg -si)
}

# Main script execution
echo "Installing yay..."
install_yay
echo
