#!/bin/bash

set -e

# Function to install Chaotic AUR
install_chaotic_aur() {
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key 3056513887B78AEB
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

    # Append [chaotic-aur] to /etc/pacman.conf if it doesn't exist
    if ! grep -q '^\[chaotic-aur\]' /etc/pacman.conf; then
        echo -e '\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist' | sudo tee -a /etc/pacman.conf
    fi
}

# Main script execution
echo "Installing Chaotic AUR..."
install_chaotic_aur
echo
