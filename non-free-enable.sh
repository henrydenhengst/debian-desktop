#!/bin/bash

set -e

echo "==> Controleren of 'contrib', 'non-free' en 'non-free-firmware' aanwezig zijn in sources.list..."

SOURCE_FILE="/etc/apt/sources.list"
BACKUP_FILE="/etc/apt/sources.list.bak"

# Maak een backup
sudo cp "$SOURCE_FILE" "$BACKUP_FILE"
echo "Backup gemaakt van $SOURCE_FILE naar $BACKUP_FILE"

# Voeg componenten toe indien nodig
updated=0

sudo sed -i '/^deb .*bookworm/ {
  /contrib/! s/$/ contrib/
  /non-free/! s/$/ non-free/
  /non-free-firmware/! s/$/ non-free-firmware/
}' "$SOURCE_FILE" && updated=1

if [ $updated -eq 1 ]; then
  echo "Bronnenlijst bijgewerkt met 'contrib', 'non-free' en 'non-free-firmware'."
else
  echo "Bronnenlijst bevatte al alle vereiste componenten."
fi

# Update de pakketlijst
echo "==> Updaten van de APT pakketindex..."
sudo apt update