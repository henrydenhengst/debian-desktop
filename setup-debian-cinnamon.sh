#!/bin/bash
set -e

LOGFILE="$HOME/debian-postinstall.log"
exec > >(tee -a "$LOGFILE") 2>&1

#!/bin/bash

# Check of het systeem Debian is
if ! grep -qi "debian" /etc/os-release; then
    echo "Dit script is alleen bedoeld voor Debian. Installatie afgebroken."
    exit 1
fi

# check voor Debian 12
if ! grep -q 'VERSION="12' /etc/os-release; then
    echo "Let op: dit script is getest op Debian 12 (Bookworm). Je gebruikt een andere versie."
fi

echo ">>> Test internetverbinding..."
if ! ping -c 1 1.1.1.1 &>/dev/null; then
  echo "❌ Geen internetverbinding. Annuleer installatie."
  exit 1
fi

echo "=== Post-installatie Debian Cinnamon ==="

# Locale en tijdzone
echo ">>> Locale en tijdzone instellen..."
sudo locale-gen nl_NL.UTF-8
sudo update-locale LANG=nl_NL.UTF-8
sudo timedatectl set-timezone Europe/Amsterdam

# Ensure 'contrib' is enabled in APT sources
if ! grep -q '^deb .*bookworm.*contrib' /etc/apt/sources.list; then
    echo "Adding 'contrib' component to APT sources..."
    sudo sed -i '/^deb .*bookworm/ s/main/main contrib/' /etc/apt/sources.list
fi

# Ensure 'non-free' is enabled in APT sources
if ! grep -q '^deb .*bookworm.*non-free' /etc/apt/sources.list; then
    echo "Adding 'non-free' component to APT sources..."
    sudo sed -i '/^deb .*bookworm/ s/main.*$/& non-free/' /etc/apt/sources.list
fi

# Ensure 'non-free-firmware' is enabled in APT sources (Debian 12+)
if ! grep -q '^deb .*bookworm.*non-free-firmware' /etc/apt/sources.list; then
    echo "Adding 'non-free-firmware' component to APT sources..."
    sudo sed -i '/^deb .*bookworm/ s/main.*$/& non-free-firmware/' /etc/apt/sources.list
fi

# Updates
echo ">>> APT updates uitvoeren..."
sudo apt update && sudo apt -y upgrade 

echo ">>> APT cli tools toevoegen..."
sudo apt install -y kitty shellcheck namebench preload clamav clamav-daemon clamtk restic bash-completion bat binutils btop coreutils crunch curl exa ffmpeg firmware-iwlwifi firmware-linux firmware-misc-nonfree flameshot geany hplip iftop imagemagick lolcat lsof mc mtr neofetch neovim p7zip pandoc pciutils  printer-driver-all printer-driver-cups-pdf ranger ripgrep rsync smartmontools terminator tmux toilet tomb traceroute unzip usbutils vnstat wget whois lshw wget git ttf-mscorefonts-installer

sudo apt install -y build-essential dkms linux-headers-$(uname -r)

# Firewall instellen
echo ">>> Firewall instellen (ufw)..."
sudo apt install -y ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
sudo ufw logging on

# Force enable unattended upgrades
sudo apt install -y unattended-upgrades
sudo tee /etc/apt/apt.conf.d/20auto-upgrades >/dev/null <<EOF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
EOF


# Flatpak installeren
echo ">>> Flatpak installeren..."
sudo apt install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Flatpak apps installeren
echo ">>> Brave en Chrome installeren via Flatpak..."
flatpak install -y flathub com.google.Chrome
flatpak install -y flathub com.brave.Browser

# Automatische Flatpak updates instellen via systemd
echo ">>> Flatpak automatische updates instellen..."
sudo tee /etc/systemd/system/flatpak-update.service >/dev/null <<EOF
[Unit]
Description=Flatpak update uitvoeren

[Service]
Type=oneshot
ExecStart=/usr/bin/flatpak update -y
EOF

sudo tee /etc/systemd/system/flatpak-update.timer >/dev/null <<EOF
[Unit]
Description=Dagelijkse Flatpak update

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOF

sudo systemctl daemon-reexec
sudo systemctl enable --now flatpak-update.timer

echo "✅ Post-installatie voltooid."

echo ">>> Installatie voltooid. Wil je nu herstarten? (j/N)"
read -r REBOOT
if [[ "$REBOOT" =~ ^[JjYy]$ ]]; then
  sudo reboot
fi
