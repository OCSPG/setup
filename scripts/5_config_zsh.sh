#!/bin/bash

set -e

install_zsh() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

configure_agnoster_theme() {
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' ~/.zshrc
}

# Main script execution
echo "Installing Zsh..."
install_zsh
echo

echo "Configuring Agnoster theme..."
configure_agnoster_theme
echo
