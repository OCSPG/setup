#!/bin/bash

# Function to install prerequisites
install_prerequisites() {
    sudo pacman -Syu base-devel git
}

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
    cd yay
    makepkg -si
}

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

# Function to install packages with yay
install_packages_with_yay() {
    while read -r package; do
        yay -S "$package" 
    done < packages.txt
}
#test

# Main script execution
echo "Arch Linux Setup Script"
echo

echo "Installing prerequisites..."
install_prerequisites
echo

echo "Installing yay..."
install_yay
echo

echo "Installing Chaotic AUR..."
install_chaotic_aur
echo

echo "Installing packages with yay..."
install_packages_with_yay
echo

echo "Setup completed."
