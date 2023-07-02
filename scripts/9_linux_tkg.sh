#!/bin/bash

# Clone the linux-tkg repository
git clone https://github.com/Frogging-Family/linux-tkg.git

# Change to the linux-tkg directory
cd linux-tkg

# Optional: Edit the "customization.cfg" file
# Uncomment the following line and modify the file as desired
# nano customization.cfg

# Build and install the package
makepkg -si
