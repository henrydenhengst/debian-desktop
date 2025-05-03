#!/bin/bash

set -e

echo "==> Controleren op NVIDIA GPU..."

if lspci | grep -i nvidia > /dev/null; then
    echo "NVIDIA GPU gevonden!"

    # Voeg non-free componenten toe indien nodig
    echo "==> Controleren op non-free in sources.list..."
    SOURCE_FILE="/etc/apt/sources.list"
    sudo cp "$SOURCE_FILE" "$SOURCE_FILE.bak"

    sudo sed -i '/^deb .*bookworm/ {
      /contrib/! s/$/ contrib/
      /non-free/! s/$/ non-free/
      /non-free-firmware/! s/$/ non-free-firmware/
    }' "$SOURCE_FILE"

    echo "==> Pakketlijst bijwerken..."
    sudo apt update

    echo "==> Installeren van NVIDIA driver..."
    sudo apt install -y nvidia-driver firmware-misc-nonfree

    echo "==> Configuratie afronden..."
    sudo update-initramfs -u
    sudo update-grub

    echo "==> Herstart aanbevolen voor activeren NVIDIA driver."
else
    echo "Geen NVIDIA GPU gevonden. Dit script is niet nodig."
fi