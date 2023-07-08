#!/bin/bash

set -e

# Function to install prerequisites
install_prerequisites() {
    sudo pacman -Syu base-devel git zsh
}

# Main script execution
echo "Installing prerequisites..."
install_prerequisites
echo
