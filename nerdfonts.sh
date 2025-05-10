#!/bin/bash

FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

TMP_DIR=$(mktemp -d)
cd "$TMP_DIR" || exit 1

echo "Bezig met downloaden en installeren van alle Nerd Fonts..."

FONT_LIST=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep browser_download_url | grep '.zip' | cut -d '"' -f 4)

for url in $FONT_LIST; do
    fname=$(basename "$url")
    fontname="${fname%.zip}"
    echo "Downloaden: $fname"
    curl -LO "$url"
    echo "Uitpakken: $fname naar $FONT_DIR/$fontname"
    mkdir -p "$FONT_DIR/$fontname"
    unzip -q "$fname" -d "$FONT_DIR/$fontname"
done

echo "Font cache wordt vernieuwd..."
fc-cache -fv

echo "Alle Nerd Fonts zijn geïnstalleerd."

rm -rf "$TMP_DIR"