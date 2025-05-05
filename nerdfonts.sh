#!/bin/bash

# Nerd Font installer for Debian

# List of available Nerd Fonts (you can add more if needed)
NERD_FONTS=("FiraCode" "Hack" "JetBrainsMono" "DejaVuSansMono")

# Function to install the chosen font
install_font() {
    FONT_NAME=$1
    echo "Installing $FONT_NAME Nerd Font..."

    # Download and install Nerd Font
    FONT_DIR="$HOME/.local/share/fonts/$FONT_NAME"
    FONT_ZIP="$FONT_NAME.zip"

    # Create directory for the fonts if it doesn't exist
    mkdir -p "$FONT_DIR"

    # Download the font zip
    wget "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$FONT_ZIP" -O "$FONT_ZIP"

    # Unzip the fonts into the appropriate directory
    unzip "$FONT_ZIP" -d "$FONT_DIR"

    # Clean up the zip file
    rm "$FONT_ZIP"

    # Refresh the font cache
    fc-cache -fv

    echo "$FONT_NAME installed successfully!"
}

# Display available fonts
echo "Available Nerd Fonts:"
for i in "${!NERD_FONTS[@]}"; do
    echo "$((i+1)). ${NERD_FONTS[$i]}"
done

# Ask the user to select a font
read -p "Choose a font to install (1-${#NERD_FONTS[@]}): " FONT_CHOICE

# Validate input
if [[ "$FONT_CHOICE" -ge 1 && "$FONT_CHOICE" -le ${#NERD_FONTS[@]} ]]; then
    SELECTED_FONT="${NERD_FONTS[$FONT_CHOICE-1]}"
    install_font "$SELECTED_FONT"
else
    echo "Invalid selection. Exiting."
    exit 1
fi