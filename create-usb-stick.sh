#!/usr/bin/env bash
set -euo pipefail

ISO_URL="https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.0.0-amd64-netinst.iso"
SUMS_URL="https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/SHA256SUMS"

ISO_FILE="debian-13.0.0-amd64-netinst.iso"
SUMS_FILE="SHA256SUMS"

echo "=== Debian 13 netinst USB creator (met checksum-validatie) ==="
echo

# -------------------------------------------------------------------
# Sanity checks
# -------------------------------------------------------------------
for cmd in wget dd lsblk sha256sum grep awk findmnt; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "❌ Vereiste tool ontbreekt: $cmd"
    exit 1
  fi
done

if [[ $EUID -eq 0 ]]; then
  echo "❌ Start dit script NIET als root."
  echo "   sudo wordt alleen gebruikt voor dd."
  exit 1
fi

# -------------------------------------------------------------------
# Download ISO
# -------------------------------------------------------------------
if [[ -f "$ISO_FILE" ]]; then
  echo "✔ ISO bestaat al: $ISO_FILE"
else
  echo "⬇ Downloading Debian 13 netinst ISO..."
  wget -O "$ISO_FILE" "$ISO_URL"
fi

# -------------------------------------------------------------------
# Download checksums
# -------------------------------------------------------------------
if [[ -f "$SUMS_FILE" ]]; then
  echo "✔ Checksum-bestand bestaat al: $SUMS_FILE"
else
  echo "⬇ Downloading SHA256SUMS..."
  wget -O "$SUMS_FILE" "$SUMS_URL"
fi

# -------------------------------------------------------------------
# Verify checksum
# -------------------------------------------------------------------
echo
echo "🔐 Controleren van checksum..."

EXPECTED_HASH=$(grep "$ISO_FILE" "$SUMS_FILE" | awk '{print $1}')
CALCULATED_HASH=$(sha256sum "$ISO_FILE" | awk '{print $1}')

if [[ -z "$EXPECTED_HASH" ]]; then
  echo "❌ Geen checksum gevonden voor $ISO_FILE"
  exit 1
fi

if [[ "$EXPECTED_HASH" != "$CALCULATED_HASH" ]]; then
  echo "❌ Checksum mismatch!"
  echo "Verwacht : $EXPECTED_HASH"
  echo "Gevonden: $CALCULATED_HASH"
  exit 1
fi

echo "✅ Checksum OK — ISO is betrouwbaar"

# -------------------------------------------------------------------
# Toon beschikbare disks
# -------------------------------------------------------------------
echo
echo "🔍 Beschikbare schijven:"
lsblk -d -o NAME,SIZE,MODEL,TRAN | grep -E "usb|NAME"

echo
read -rp "➡️  Geef het USB device op (bijv. /dev/sdX): " TARGET

# -------------------------------------------------------------------
# Validatie target
# -------------------------------------------------------------------
if [[ ! -b "$TARGET" ]]; then
  echo "❌ $TARGET is geen geldig block device"
  exit 1
fi

ROOT_DEV=$(findmnt -n -o SOURCE / | sed 's/[0-9]*$//')
if [[ "$TARGET" == "$ROOT_DEV" ]]; then
  echo "❌ $TARGET is je root disk. Afgebroken."
  exit 1
fi

echo
echo "⚠️  WAARSCHUWING"
echo "Alle data op $TARGET wordt DEFINITIEF GEWIST."
read -rp "Typ EXACT 'JA' om door te gaan: " CONFIRM

if [[ "$CONFIRM" != "JA" ]]; then
  echo "❌ Afgebroken door gebruiker."
  exit 1
fi

# -------------------------------------------------------------------
# Write ISO
# -------------------------------------------------------------------
echo
echo "🚀 ISO wordt naar $TARGET geschreven..."
sudo dd if="$ISO_FILE" of="$TARGET" bs=4M status=progress conv=fsync

echo
echo "✅ Klaar!"
echo "➡️  Debian 13 installatiestick is gereed."
echo "➡️  Je kunt nu rebooten en vanaf USB starten."