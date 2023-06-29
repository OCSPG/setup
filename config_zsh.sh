#!/bin/bash

set -e

install_zsh_with_agnoster() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' ~/.zshrc
}

# Main script execution
echo "Setting up Zsh with Agnoster theme..."
install_zsh_with_agnoster
echo
