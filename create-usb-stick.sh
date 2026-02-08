#!/usr/bin/env bash
set -euo pipefail

# ==========================================
# CONFIGURATIE
# ==========================================
ISO_URL="https://cdimage.debian.org/debian-cd/13.3.0/amd64/iso-cd/debian-13.3.0-amd64-netinst.iso"
ISO_FILE="debian-13.3.0-amd64-netinst.iso"
SHA_FILE="SHA256SUMS"
SHA_URL="https://cdimage.debian.org/debian-cd/13.3.0/amd64/iso-cd/SHA256SUMS"
USB_DEVICE="/dev/sdX"       # Pas aan naar jouw USB-stick

# Controleer vereiste tools
for cmd in wget dd sha256sum; do
    if ! command -v $cmd &>/dev/null; then
        echo "❌ Vereiste tool ontbreekt: $cmd"
        exit 1
    fi
done

# ==========================================
# Download ISO en checksum
# ==========================================
if [[ ! -f "$ISO_FILE" ]]; then
    echo "⬇ Download Debian 13.3 netinst ISO..."
    wget -O "$ISO_FILE" "$ISO_URL"
else
    echo "✔ ISO bestaat al: $ISO_FILE"
fi

if [[ ! -f "$SHA_FILE" ]]; then
    echo "⬇ Download SHA256SUMS..."
    wget -O "$SHA_FILE" "$SHA_URL"
else
    echo "✔ SHA256SUMS bestaat al"
fi

# ==========================================
# Controleer checksum
# ==========================================
echo "🔍 Controleer SHA256 checksum..."
ISO_HASH=$(sha256sum "$ISO_FILE" | awk '{print $1}')
EXPECTED_HASH=$(grep "$(basename "$ISO_FILE")" "$SHA_FILE" | awk '{print $1}')

if [[ "$ISO_HASH" != "$EXPECTED_HASH" ]]; then
    echo "❌ Checksum mismatch! ISO kan corrupt zijn."
    exit 1
else
    echo "✔ Checksum correct"
fi

# ==========================================
# Bevestiging gebruiker
# ==========================================
echo "⚠️ LET OP: alle data op $USB_DEVICE gaat verloren!"
read -p "Typ exact JA om door te gaan: " CONFIRM
if [[ "$CONFIRM" != "JA" ]]; then
    echo "❌ Afgebroken door gebruiker."
    exit 1
fi

# ==========================================
# Schrijf ISO naar USB
# ==========================================
echo "⬇ Schrijven naar USB-stick..."
sudo dd if="$ISO_FILE" of="$USB_DEVICE" bs=4M status=progress conv=fsync

sync
echo
echo "✅ USB-stick klaar! Boot op de mini-PC voor automatische Debian + HA installatie."