#!/bin/bash

# Map om fonts op te slaan
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

# Tijdelijke map voor downloads
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR" || exit 1

echo "Bezig met downloaden en installeren van alle Nerd Fonts..."

# Lijst met alle Nerd Fonts (update mogelijk nodig bij nieuwe releases)
FONT_LIST=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep browser_download_url | grep '.zip' | cut -d '"' -f 4)

# Download en installeer alle fonts
for url in $FONT_LIST; do
    fname=$(basename "$url")
    echo "Downloaden: $fname"
    curl -LO "$url"
    echo "Uitpakken: $fname"
    unzip -q "$fname" -d "$FONT_DIR"
done

# Cache fonts opnieuw opbouwen
echo "Font cache wordt vernieuwd..."
fc-cache -fv

echo "Alle Nerd Fonts zijn geïnstalleerd."

# Opruimen
rm -rf "$TMP_DIR"