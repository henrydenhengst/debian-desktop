#!/bin/bash
# =====================================================
# FULL HOME ASSISTANT HOMELAB STACK
# Debian Linux - Docker based
# Ports: 8120–8140
# =====================================================

set -e

echo "===================================================="
echo "PRE-INSTALLATIE CONTROLES"
echo "===================================================="

# ---- Disk check
MIN_DISK_GB=14
FREE_DISK_GB=$(df / | tail -1 | awk '{print int($4/1024/1024)}')
echo "Vrije schijfruimte: ${FREE_DISK_GB} GB"
if [ "$FREE_DISK_GB" -lt "$MIN_DISK_GB" ]; then
  echo "❌ Minimaal ${MIN_DISK_GB} GB vrije schijfruimte vereist."
  exit 1
fi

# ---- RAM check
MIN_RAM_MB=3000
TOTAL_RAM_MB=$(free -m | awk '/Mem:/ {print $2}')
echo "Beschikbaar RAM: ${TOTAL_RAM_MB} MB"
if [ "$TOTAL_RAM_MB" -lt "$MIN_RAM_MB" ]; then
  echo "❌ Minimaal ${MIN_RAM_MB} MB RAM vereist."
  exit 1
fi

echo "✅ Pre-checks OK"

# =====================================================
# SYSTEM SETUP
# =====================================================
sudo apt update && sudo apt upgrade -y
sudo apt install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  ufw \
  openssh-server \
  usbutils

# =====================================================
# DOCKER INSTALL
# =====================================================
curl -fsSL https://download.docker.com/linux/debian/gpg \
 | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] \
https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
| sudo tee /etc/apt/sources.list.d/docker.list

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo usermod -aG docker $USER

# =====================================================
# FIREWALL
# =====================================================
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
for port in {8120..8140}; do
  sudo ufw allow ${port}/tcp
done
sudo ufw --force enable

# =====================================================
# USB DETECTIE
# =====================================================
echo "Beschikbare USB devices:"
ls -1 /dev/serial/by-id || true

read -p "Zigbee USB pad (/dev/serial/by-id/...): " ZIGBEE_PATH
read -p "Z-Wave USB pad (/dev/serial/by-id/...): " ZWAVE_PATH

for DEV in "$ZIGBEE_PATH" "$ZWAVE_PATH"; do
  if [ ! -e "$DEV" ]; then
    echo "❌ USB device niet gevonden: $DEV"
    exit 1
  fi
done

if [ "$ZIGBEE_PATH" = "$ZWAVE_PATH" ]; then
  echo "❌ Zigbee en Z-Wave mogen niet hetzelfde device zijn"
  exit 1
fi

# =====================================================
# DIRECTORY STRUCTUUR
# =====================================================
STACK_DIR="$HOME/ha-docker"
mkdir -p "$STACK_DIR"
cd "$STACK_DIR"

# =====================================================
# DOCKER COMPOSE
# =====================================================
cat > docker-compose.yml <<EOF
version: "3.9"

services:

  homeassistant:
    image: ghcr.io/home-assistant/home-assistant:stable
    container_name: homeassistant
    privileged: true
    restart: unless-stopped
    ports: ["8123:8123"]
    volumes: ["./homeassistant:/config"]
    environment: ["TZ=Europe/Amsterdam"]

  mosquitto:
    image: eclipse-mosquitto
    container_name: mosquitto
    restart: unless-stopped
    ports: ["8120:1883"]
    volumes: ["./mosquitto:/mosquitto"]

  zigbee2mqtt:
    image: koenkk/zigbee2mqtt
    container_name: zigbee2mqtt
    restart: unless-stopped
    ports: ["8121:8080"]
    volumes: ["./zigbee2mqtt:/app/data"]
    devices:
      - $ZIGBEE_PATH:/dev/ttyUSB0
    environment: ["TZ=Europe/Amsterdam"]
    depends_on: [mosquitto]

  zwavejs2mqtt:
    image: zwavejs/zwavejs2mqtt
    container_name: zwavejs2mqtt
    restart: unless-stopped
    ports: ["8129:8091"]
    volumes: ["./zwavejs2mqtt:/usr/src/app/store"]
    devices:
      - $ZWAVE_PATH:/dev/ttyUSB0
    environment: ["TZ=Europe/Amsterdam"]

  esphome:
    image: ghcr.io/esphome/esphome
    container_name: esphome
    restart: unless-stopped
    ports: ["8122:6052"]
    volumes: ["./esphome:/config"]

  portainer:
    image: portainer/portainer-ce
    container_name: portainer
    restart: unless-stopped
    ports: ["8124:9000","8125:9443"]
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data

  watchtower:
    image: containrrr/watchtower
    container_name: watchtower
    restart: unless-stopped
    volumes: ["/var/run/docker.sock:/var/run/docker.sock"]
    command: --cleanup --interval 86400

  dozzle:
    image: amir20/dozzle
    container_name: dozzle
    restart: unless-stopped
    ports: ["8126:8080"]
    volumes: ["/var/run/docker.sock:/var/run/docker.sock"]

  influxdb:
    image: influxdb:2.7
    container_name: influxdb
    restart: unless-stopped
    ports: ["8127:8086"]
    volumes: ["./influxdb:/var/lib/influxdb2"]

  grafana:
    image: grafana/grafana-oss
    container_name: grafana
    restart: unless-stopped
    ports: ["8128:3000"]
    volumes: ["./grafana:/var/lib/grafana"]

  gptai:
    image: ghcr.io/openai/gpt4all:latest
    container_name: gptai
    restart: unless-stopped
    ports: ["8130:5000"]
    environment:
      - OPENAI_API_KEY=CHANGE_ME
    volumes: ["./gptai:/data"]

  netdata:
    image: netdata/netdata
    container_name: netdata
    restart: unless-stopped
    ports: ["8131:19999"]
    cap_add: [SYS_PTRACE]
    security_opt: [apparmor:unconfined]
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro

  uptime-kuma:
    image: louislam/uptime-kuma
    container_name: uptime-kuma
    restart: unless-stopped
    ports: ["8132:3001"]
    volumes: ["./uptime-kuma:/app/data"]

  homer:
    image: b4bz/homer
    container_name: homer
    restart: unless-stopped
    ports: ["8133:8080"]
    volumes: ["./homer:/www/assets"]
    environment: ["INIT_ASSETS=1"]

volumes:
  portainer_data:
EOF

# =====================================================
# START STACK
# =====================================================
docker compose up -d

echo "===================================================="
echo "INSTALLATIE VOLTOOID 🎉"
echo "Homer Dashboard: http://$(hostname -I | awk '{print $1}'):8133"
echo "Home Assistant:  http://$(hostname -I | awk '{print $1}'):8123"
echo "===================================================="
echo "⚠️ Log UIT en weer IN voor Docker zonder sudo"