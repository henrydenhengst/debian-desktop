#!/usr/bin/env bash
set -euo pipefail

LOG="/var/log/ha-firstboot.log"
exec > >(tee -a "$LOG") 2>&1

echo "=== Home Assistant First Boot Setup ==="
echo "Starttijd: $(date)"
echo

# ----------------------------
# Root check
# ----------------------------
if [[ $EUID -ne 0 ]]; then
    echo "❌ Dit script moet als root draaien!"
    exit 1
fi

# ----------------------------
# Systeem update
# ----------------------------
echo "🔄 Update systeem..."
apt update
apt -y upgrade

# ----------------------------
# Basis tools
# ----------------------------
echo "📦 Installeren basis tools..."
apt install -y sudo curl wget gnupg lsb-release ca-certificates \
               ufw git htop nano usbutils net-tools systemd-timesyncd

# ----------------------------
# SSH hardening
# ----------------------------
echo "🔐 SSH configuratie..."
sed -i 's/#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart ssh

# ----------------------------
# UFW configuratie
# ----------------------------
echo "🔥 UFW configuratie..."
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp          # SSH
ufw allow 8120:8140/tcp   # HA dashboards & apps
ufw allow 1883/tcp        # MQTT
ufw allow 8080/tcp        # Zigbee2MQTT frontend
ufw --force enable

# ----------------------------
# Docker installatie
# ----------------------------
echo "🐳 Docker installatie..."
curl -fsSL https://get.docker.com | sh
systemctl enable docker
systemctl start docker

if id "${SUDO_USER:-}" &>/dev/null; then
    usermod -aG docker "$SUDO_USER"
fi

# ----------------------------
# Docker Compose plugin
# ----------------------------
echo "🧩 Docker Compose plugin..."
mkdir -p /usr/local/lib/docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
    -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# ----------------------------
# Kernel modules (Zigbee / Z-Wave)
# ----------------------------
echo "🔌 Laden kernel modules..."
modprobe usbserial
modprobe cp210x
modprobe ftdi_sio

cat <<EOF >/etc/modules-load.d/homeassistant.conf
usbserial
cp210x
ftdi_sio
EOF

# ----------------------------
# Time sync
# ----------------------------
systemctl enable systemd-timesyncd
systemctl start systemd-timesyncd

# ----------------------------
# Start Docker stack
# ----------------------------
echo "🚀 Start Home Assistant Docker stack..."
cd /opt/ha-setup
docker compose up -d

# ----------------------------
# Verwijder service na eerste run
# ----------------------------
SERVICE_FILE="/etc/systemd/system/ha-firstboot.service"
if [[ -f "$SERVICE_FILE" ]]; then
    echo "🗑 Verwijder systemd service..."
    systemctl disable ha-firstboot.service
    rm -f "$SERVICE_FILE"
    systemctl daemon-reload
fi

echo
echo "✅ Eerste boot setup voltooid!"
echo "Logs beschikbaar: $LOG"