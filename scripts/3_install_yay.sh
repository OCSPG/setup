#!/bin/bash

set -e

# Function to install yay
install_yay() {

    git clone https://aur.archlinux.org/yay.git
    (cd yay && makepkg -si)
}

# Function to install packages from a text file
install_packages() {
    IFS=' ' read -ra packages <<< "$(cat packages.txt)"
    yay -S "${packages[@]}"
}

# Main script execution
echo "Installing yay..."
install_yay
echo

echo "Installing packages from the text file..."
install_packages
echo
