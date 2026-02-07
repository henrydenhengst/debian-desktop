#!/usr/bin/env bash
set -euo pipefail

# ==========================================
# CONFIGURATIE
# ==========================================
ISO_URL="https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.0.0-amd64-netinst.iso"
ISO_FILE="debian-13.0.0-amd64-netinst.iso"
USB_DEVICE="/dev/sdX"       # Vervang dit door jouw USB-stick
WORKDIR="./ha-iso-build"
OUTPUT_ISO="debian-13-ha-appliance.iso"

# Map met scripts + compose
HA_SETUP_DIR="./ha-appliance"  # postinstall.sh + docker-compose.yml + ha-firstboot.service
PRESEED_FILE="./preseed.cfg"

# Controleer vereiste tools
for cmd in wget dd rsync xorriso sudo; do
  if ! command -v $cmd &>/dev/null; then
    echo "❌ Vereiste tool ontbreekt: $cmd"
    exit 1
  fi
done

# ==========================================
# Debian ISO downloaden
# ==========================================
if [[ ! -f "$ISO_FILE" ]]; then
    echo "⬇ Download Debian 13 netinst ISO..."
    wget -O "$ISO_FILE" "$ISO_URL"
else
    echo "✔ ISO bestaat al: $ISO_FILE"
fi

# ==========================================
# Werkmap aanmaken
# ==========================================
rm -rf "$WORKDIR"
mkdir -p "$WORKDIR/mnt" "$WORKDIR/extract"

echo "🔹 Mount ISO..."
sudo mount -o loop "$ISO_FILE" "$WORKDIR/mnt"

echo "🔹 Kopieer ISO content..."
rsync -a --exclude=TRANS.TBL "$WORKDIR/mnt/" "$WORKDIR/extract/"

sudo umount "$WORKDIR/mnt"

# ==========================================
# Voeg HA setup toe
# ==========================================
echo "🔹 Kopieer HA setup..."
cp -r "$HA_SETUP_DIR" "$WORKDIR/extract/opt/ha-setup/"

# Voeg preseed.cfg toe
if [[ -f "$PRESEED_FILE" ]]; then
    echo "🔹 Voeg preseed.cfg toe..."
    cp "$PRESEED_FILE" "$WORKDIR/extract/preseed.cfg"
fi

# ==========================================
# Bouw bootable ISO
# ==========================================
echo "📦 Bouw bootable appliance ISO..."
xorriso -as mkisofs \
  -r -J -l -b isolinux/isolinux.bin \
  -c isolinux/boot.cat \
  -no-emul-boot -boot-load-size 4 -boot-info-table \
  -o "$OUTPUT_ISO" \
  "$WORKDIR/extract"

echo
echo "✅ Appliance ISO klaar: $OUTPUT_ISO"

# ==========================================
# ISO naar USB stick schrijven
# ==========================================
read -p "⚠️ WEES ZEKER: alle data op $USB_DEVICE gaat verloren! Typ JA om door te gaan: " CONFIRM
if [[ "$CONFIRM" != "JA" ]]; then
    echo "❌ Afgebroken door gebruiker."
    exit 1
fi

echo "⬇ Schrijven naar USB-stick..."
sudo dd if="$OUTPUT_ISO" of="$USB_DEVICE" bs=4M status=progress conv=fsync

echo
echo "✅ USB-stick klaar!"
echo "➡️ Plaats USB in mini-PC en boot."
echo "➡️ Debian installatie + Home Assistant installatie worden automatisch uitgevoerd."