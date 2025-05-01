#!/bin/bash
set -e

LOGFILE="$HOME/debian-postinstall.log"
exec > >(tee -a "$LOGFILE") 2>&1

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

# Updates
echo ">>> APT updates uitvoeren..."
sudo apt update && sudo apt -y upgrade 

echo ">>> APT cli tools toevoegen..."
sudo apt install -y bash-completion bat binutils btop coreutils crunch curl exa ffmpeg firmware-iwlwifi firmware-linux firmware-misc-nonfree flameshot geany hplip iftop imagemagick lolcat lsof mc mtr neofetch neovim p7zip pandoc pciutils  printer-driver-all printer-driver-cups-pdf ranger ripgrep rsync smartmontools terminator tmux toilet tomb traceroute unzip usbutils vnstat wget whois lshw wget git

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
