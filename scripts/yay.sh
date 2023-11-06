#!/bin/bash

# Check if the user is running the script with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or with sudo."
  exit 1
fi

# Install necessary packages using Pacman
pacman -S --needed git base-devel

# Clone the Yay AUR helper repository and build/install it
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Clean up by removing the yay directory
cd ..
rm -rf yay
