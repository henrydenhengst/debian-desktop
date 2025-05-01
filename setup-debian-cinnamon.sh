#!/bin/bash

set -e

# Check for root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root: sudo $0"
  exit 1
fi

# Check for active WiFi connection
echo "Checking WiFi connectivity..."
if ! ping -c 1 debian.org &>/dev/null; then
  echo "No internet connection detected. Connect to WiFi and try again."
  exit 1
fi
echo "WiFi is connected."

# Install basic packages
echo "Installing flatpak, curl, and ufw..."
apt update
apt install -y flatpak gnome-software-plugin-flatpak curl ufw

# Enable Flathub
echo "Setting up Flathub..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install Chrome, Brave, LibreOffice
echo "Installing apps via Flatpak..."
flatpak install -y flathub com.google.Chrome
flatpak install -y flathub com.brave.Browser
flatpak install -y flathub org.libreoffice.LibreOffice

# Setup Firewall
echo "Enabling UFW..."
ufw default deny incoming
ufw default allow outgoing
ufw --force enable

# Enable automatic APT updates
echo "Setting up automatic APT updates..."
apt install -y unattended-upgrades
dpkg-reconfigure -plow unattended-upgrades

# Enable automatic Flatpak updates
echo "Enabling Flatpak autoupdates..."
mkdir -p /etc/systemd/system/flatpak-update.timer.d
cat <<EOF > /etc/systemd/system/flatpak-update.timer.d/custom.conf
[Timer]
OnBootSec=10min
OnUnitActiveSec=1d
EOF

systemctl enable --now flatpak-update.timer

# Optional: ensure current user has sudo
CURRENT_USER=$(logname)
usermod -aG sudo "$CURRENT_USER"

echo "✅ Setup complete! You can now reboot or start using your system."
