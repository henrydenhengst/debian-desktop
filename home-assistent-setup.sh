#!/bin/bash
# =====================================================
# FULL HOME ASSISTANT STACK SETUP SCRIPT (BULLETPROOF + BACKUPS + GPT AI)
# Debian Linux
# =====================================================

set -e

echo "===================================================="
echo "START PRE-INSTALLATIE CHECKS"
echo "===================================================="

# -------------------------------
# Pre-installatie: check vrije schijfruimte
# -------------------------------
MIN_DISK_GB=12   # Extra ruimte voor GPT container + backups
FREE_DISK_GB=$(df / | tail -1 | awk '{print int($4/1024/1024)}')
echo "Vrije schijfruimte: ${FREE_DISK_GB} GB"
if [ "$FREE_DISK_GB" -lt "$MIN_DISK_GB" ]; then
    echo "❌ FOUT: Minimaal ${MIN_DISK_GB} GB vereist. Stop installatie."
    exit 1
fi
echo "✅ Voldoende schijfruimte beschikbaar."

# -------------------------------
# Pre-installatie: check RAM
# -------------------------------
MIN_RAM_MB=2500  # Extra RAM voor GPT AI container
TOTAL_RAM_MB=$(free -m | awk '/Mem:/ {print $2}')
echo "Beschikbaar RAM: ${TOTAL_RAM_MB} MB"
if [ "$TOTAL_RAM_MB" -lt "$MIN_RAM_MB" ]; then
    echo "❌ FOUT: Minimaal ${MIN_RAM_MB} MB RAM vereist. Stop installatie."
    exit 1
fi
echo "✅ Voldoende RAM beschikbaar."

echo "===================================================="
echo "START INSTALLATIE HOME ASSISTANT STACK"
echo "===================================================="

# -------------------------------
# 1. Systeem update & vereisten
# -------------------------------
sudo apt update && sudo apt upgrade -y
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release ufw openssh-server usbutils

# -------------------------------
# 2. Docker installeren
# -------------------------------
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

docker --version
docker compose version

sudo usermod -aG docker $USER
echo "⚠️ Log uit en opnieuw in om Docker zonder sudo te gebruiken."

# -------------------------------
# 3. UFW configureren
# -------------------------------
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
for port in {8120..8130}; do
    sudo ufw allow ${port}/tcp
done
sudo ufw --force enable
sudo ufw status verbose

# -------------------------------
# 4. SSH starten
# -------------------------------
sudo systemctl enable ssh
sudo systemctl start ssh
sudo systemctl status ssh | grep Active

# -------------------------------
# 5a. Persistent USB check
# -------------------------------
if [ ! -d "/dev/serial/by-id" ]; then
    echo "⚠️ /dev/serial/by-id bestaat niet. USB stick paden zijn mogelijk instabiel."
    echo "Installeer usbutils: sudo apt install usbutils en herstart daarna."
fi

echo "=== Lijst van beschikbare USB sticks (persistent paths) ==="
ls -1 /dev/serial/by-id || true
echo "Let op: gebruik bij voorkeur de /dev/serial/by-id paden voor Zigbee & Z-Wave."

# -------------------------------
# 5b. Zigbee + Z-Wave detecteren
# -------------------------------
echo "=== Detecteer Zigbee USB sticks ==="
ZIGBEE_OPTIONS=($(ls -1 /dev/serial/by-id/ | grep -iE "zigbee|cc2531|conbee|sonoff" || true))
if [ ${#ZIGBEE_OPTIONS[@]} -eq 0 ]; then
    read -p "⚠️ Geen Zigbee stick gevonden. Voer handmatig het pad in (/dev/serial/by-id/...): " ZIGBEE_PATH
else
    echo "Gevonden Zigbee sticks:"
    select Z in "${ZIGBEE_OPTIONS[@]}"; do
        ZIGBEE_PATH="/dev/serial/by-id/$Z"
        echo "Gekozen Zigbee stick: $ZIGBEE_PATH"
        break
    done
fi

if [[ ! "$ZIGBEE_PATH" =~ ^/dev/serial/by-id/ ]] || [ ! -e "$ZIGBEE_PATH" ]; then
    echo "❌ FOUT: Zigbee pad '$ZIGBEE_PATH' is ongeldig."
    exit 1
fi
echo "✅ Zigbee pad is geldig."

echo "=== Detecteer Z-Wave USB sticks ==="
ZWAVE_OPTIONS=($(ls -1 /dev/serial/by-id/ | grep -iE "aeotec|zstick|zwave|zooz" || true))
if [ ${#ZWAVE_OPTIONS[@]} -eq 0 ]; then
    read -p "⚠️ Geen Z-Wave stick gevonden. Voer handmatig het pad in (/dev/serial/by-id/...): " ZWAVE_PATH
else
    echo "Gevonden Z-Wave sticks:"
    select Z in "${ZWAVE_OPTIONS[@]}"; do
        ZWAVE_PATH="/dev/serial/by-id/$Z"
        echo "Gekozen Z-Wave stick: $ZWAVE_PATH"
        break
    done
fi

if [[ ! "$ZWAVE_PATH" =~ ^/dev/serial/by-id/ ]] || [ ! -e "$ZWAVE_PATH" ]; then
    echo "❌ FOUT: Z-Wave pad '$ZWAVE_PATH' is ongeldig."
    exit 1
fi
echo "✅ Z-Wave pad is geldig."

if [ "$ZIGBEE_PATH" == "$ZWAVE_PATH" ]; then
    echo "❌ FOUT: Zigbee en Z-Wave mogen niet hetzelfde USB-pad gebruiken!"
    exit 1
fi

# -------------------------------
# 6a. Overzichtstabel services & poorten
# -------------------------------
echo "===================================================="
echo "OVERZICHT HOME ASSISTANT STACK"
echo "===================================================="
printf "%-20s %-10s %-30s\n" "Service" "Poort" "USB Pad"
printf "%-20s %-10s %-30s\n" "-------" "----" "-------"
printf "%-20s %-10s %-30s\n" "Home Assistant" "8123" "-"
printf "%-20s %-10s %-30s\n" "MQTT (Mosquitto)" "8120" "-"
printf "%-20s %-10s %-30s\n" "Zigbee2MQTT" "8121" "$ZIGBEE_PATH"
printf "%-20s %-10s %-30s\n" "ESPHome" "8122" "-"
printf "%-20s %-10s %-30s\n" "Portainer HTTP" "8124" "-"
printf "%-20s %-10s %-30s\n" "Portainer HTTPS" "8125" "-"
printf "%-20s %-10s %-30s\n" "Dozzle" "8126" "-"
printf "%-20s %-10s %-30s\n" "InfluxDB" "8127" "-"
printf "%-20s %-10s %-30s\n" "Grafana" "8128" "-"
printf "%-20s %-10s %-30s\n" "Z-Wave (zwavejs2mqtt)" "8129" "$ZWAVE_PATH"
printf "%-20s %-10s %-30s\n" "GPT AI" "8130" "-"
echo "===================================================="
read -p "Druk op ENTER om de stack te starten, of CTRL+C om te annuleren..."

# -------------------------------
# 6b. Automatische backup config-mappen vóór deploy
# -------------------------------
STACK_DIR="$HOME/ha-docker"
BACKUP_DIR="$STACK_DIR/backups/$(date +'%Y%m%d_%H%M%S')"
mkdir -p "$BACKUP_DIR"

echo "=== Backup van huidige config-mappen maken naar $BACKUP_DIR ==="
for SERVICE in homeassistant zigbee2mqtt zwavejs2mqtt esphome influxdb grafana; do
    if [ -d "$STACK_DIR/$SERVICE" ]; then
        cp -r "$STACK_DIR/$SERVICE" "$BACKUP_DIR/"
        echo "✅ Backup gemaakt van $SERVICE"
    else
        echo "⚠️ Geen bestaande map voor $SERVICE, geen backup nodig."
    fi
done
echo "✅ Alle beschikbare config-mappen gebackupt."

# -------------------------------
# 6c. Docker Compose stack
# -------------------------------
mkdir -p "$STACK_DIR"
cd "$STACK_DIR"

cat > docker-compose.yml <<EOF
version: "3.9"

services:
  homeassistant:
    container_name: homeassistant
    image: ghcr.io/home-assistant/home-assistant:stable
    restart: unless-stopped
    network_mode: bridge
    privileged: true
    environment:
      - TZ=Europe/Amsterdam
    ports:
      - "8123:8123"
    volumes:
      - ./homeassistant:/config
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
      - "com.centurylinklabs.dozzle.enable=true"

  mosquitto:
    container_name: mosquitto
    image: eclipse-mosquitto:latest
    restart: unless-stopped
    ports:
      - "8120:1883"
    volumes:
      - ./mosquitto:/mosquitto
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
      - "com.centurylinklabs.dozzle.enable=true"

  zigbee2mqtt:
    container_name: zigbee2mqtt
    image: koenkk/zigbee2mqtt
    restart: unless-stopped
    ports:
      - "8121:8080"
    volumes:
      - ./zigbee2mqtt:/app/data
    environment:
      - TZ=Europe/Amsterdam
    devices:
      - $ZIGBEE_PATH:/dev/ttyUSB0
    depends_on:
      - mosquitto
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
      - "com.centurylinklabs.dozzle.enable=true"

  zwavejs2mqtt:
    container_name: zwavejs2mqtt
    image: zwavejs/zwavejs2mqtt:latest
    restart: unless-stopped
    ports:
      - "8129:8091"
    volumes:
      - ./zwavejs2mqtt:/usr/src/app/store
    environment:
      - TZ=Europe/Amsterdam
    devices:
      - $ZWAVE_PATH:/dev/ttyUSB0
    depends_on:
      - mosquitto
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
      - "com.centurylinklabs.dozzle.enable=true"

  esphome:
    container_name: esphome
    image: ghcr.io/esphome/esphome
    restart: unless-stopped
    ports:
      - "8122:6052"
    volumes:
      - ./esphome:/config
    environment:
      - TZ=Europe/Amsterdam
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
      - "com.centurylinklabs.dozzle.enable=true"

  portainer:
    container_name: portainer
    image: portainer/portainer-ce:latest
    restart: unless-stopped
    ports:
      - "8124:9000"
      - "8125:9443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data

  watchtower:
    container_name: watchtower
    image: containrrr/watchtower
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    command: --interval 86400 --cleanup --label-enable

  dozzle:
    container_name: dozzle
    image: amir20/dozzle:latest
    restart: unless-stopped
    ports:
      - "8126:8080"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock

  influxdb:
    container_name: influxdb
    image: influxdb:2.7
    restart: unless-stopped
    ports:
      - "8127:8086"
    environment:
      - DOCKER_INFLUXDB_INIT_MODE=setup
      - DOCKER_INFLUXDB_INIT_USERNAME=ha
      - DOCKER_INFLUXDB_INIT_PASSWORD=StrongPasswordHere
      - DOCKER_INFLUXDB_INIT_ORG=homeassistant
      - DOCKER_INFLUXDB_INIT_BUCKET=ha_data
    volumes:
      - ./influxdb:/var/lib/influxdb2
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
      - "com.centurylinklabs.dozzle.enable=true"

  grafana:
    container_name: grafana
    image: grafana/grafana-oss:latest
    restart: unless-stopped
    ports:
      - "8128:3000"
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=StrongGrafanaPass
    volumes:
      - ./grafana:/var/lib/grafana
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
      - "com.centurylinklabs.dozzle.enable=true"

  gptai:
    container_name: gptai
    image: ghcr.io/openai/gpt4all:latest
    restart: unless-stopped
    ports:
      - "8130:5000"
    environment:
      - OPENAI_API_KEY=YOUR_OPENAI_API_KEY
    volumes:
      - ./gptai:/data
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
      - "com.centurylinklabs.dozzle.enable=true"

volumes:
  portainer_data:
EOF

# -------------------------------
# 7. Deploy stack
# -------------------------------
docker compose up -d

# -------------------------------
# 8. Cron job voor dagelijkse backups
# -------------------------------
CRON_JOB="0 3 * * * /bin/bash $STACK_DIR/ha_backup.sh >> $STACK_DIR/backups/cron_backup.log 2>&1"

cat > "$STACK_DIR/ha_backup.sh" <<'EOB'
#!/bin/bash
STACK_DIR="$HOME/ha-docker"
BACKUP_DIR="$STACK_DIR/backups/$(date +'%Y%m%d_%H%M%S')"
mkdir -p "$BACKUP_DIR"
for SERVICE in homeassistant zigbee2mqtt zwavejs2mqtt esphome influxdb grafana; do
    if [ -d "$STACK_DIR/$SERVICE" ]; then
        cp -r "$STACK_DIR/$SERVICE" "$BACKUP_DIR/"
        echo "$(date '+%Y-%m-%d %H:%M:%S') ✅ Backup gemaakt van $SERVICE"
    fi
done
# Hou alleen laatste 7 backups
find "$STACK_DIR/backups/" -maxdepth 1 -type d -mtime +7 -exec rm -rf {} \;
EOB

chmod +x "$STACK_DIR/ha_backup.sh"
(crontab -l 2>/dev/null | grep -v -F "$STACK_DIR/ha_backup.sh" ; echo "$CRON_JOB") | crontab -
echo "✅ Cron job ingesteld voor dagelijkse backups om 03:00 uur."

echo "===================================================="
echo "INSTALLATIE VOLTOOID!"
echo "Webinterfaces:"
echo "Home Assistant: http://$(hostname -I | awk '{print $1}'):8123"
echo "MQTT: 8120"
echo "Zigbee2MQTT: 8121"
echo "ESPHome: 8122"
echo "Portainer HTTP: 8124"
echo "Portainer HTTPS: 8125"
echo "Dozzle: 8126"
echo "InfluxDB: 8127"
echo "Grafana: 8128"
echo "Z-Wave (zwavejs2mqtt): 8129"
echo "GPT AI: 8130"
echo "⚠️ Controleer wachtwoorden, USB sticks en backups in $STACK_DIR/backups/"
echo "Log uit en weer in om Docker zonder sudo te gebruiken."
echo "===================================================="