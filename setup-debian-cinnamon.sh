#!/bin/bash
set -e

LOGFILE="$HOME/debian-postinstall.log"
exec > >(tee -a "$LOGFILE") 2>&1

echo "=== Post-installatie Debian Cinnamon ==="

# Locale en tijdzone
echo ">>> Locale en tijdzone instellen..."
sudo locale-gen nl_NL.UTF-8
sudo update-locale LANG=nl_NL.UTF-8
sudo timedatectl set-timezone Europe/Amsterdam

# Updates
echo ">>> APT updates uitvoeren..."
sudo apt update && sudo apt -y upgrade

# Firewall instellen
echo ">>> Firewall instellen (ufw)..."
sudo apt install -y ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
sudo ufw logging on

echo ">>> APT automatische updates inschakelen..."
sudo apt install -y unattended-upgrades git lshw wget curl

# Zorg dat automatische updates aanstaan
sudo dpkg-reconfigure --priority=low unattended-upgrades


# Flatpak installeren
echo ">>> Flatpak installeren..."
sudo apt install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Flatpak apps installeren
echo ">>> Brave, Chromium en LibreOffice installeren via Flatpak..."
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
