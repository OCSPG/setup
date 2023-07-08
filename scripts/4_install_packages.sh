#!/bin/bash

set -e

# Function to install packages with yay
install_packages_with_yay() {
    while read -r package; do
        yay -S "$package"
    done < packages.txt
}

# Main script execution
echo "Installing packages with yay..."
install_packages_with_yay
echo
