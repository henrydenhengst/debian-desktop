#!/usr/bin/env bash
#
# setup_radio_sticks.sh
#
# Definitieve setup voor Zigbee en Z-Wave USB sticks:
# - Detecteert USB serial devices
# - Valideert gekozen device
# - Maakt udev rules aan
# - Creëert vaste paden: /dev/zigbee en /dev/zwave
#
# Geschikt voor Debian / Ubuntu / Home Assistant hosts
#

set -e

echo "========================================"
echo " Smart Home Radio Definitieve Setup"
echo "========================================"
echo

# Root check
if [[ $EUID -ne 0 ]]; then
  echo "❌ Dit script moet als root worden uitgevoerd (sudo)"
  exit 1
fi

# Zoek USB serial devices
USB_DEVICES=$(ls /dev/ttyUSB* /dev/ttyACM* 2>/dev/null || true)

if [[ -z "$USB_DEVICES" ]]; then
  echo "❌ Geen USB serial devices gevonden."
  echo "   Sluit Zigbee / Z-Wave sticks aan en probeer opnieuw."
  exit 1
fi

echo "🔎 Gevonden USB devices:"
echo "$USB_DEVICES"
echo

# Functie om device info op te halen
get_udev_info() {
  udevadm info -a -n "$1"
}

# Zigbee selectie
read -rp "➡️  Pad naar Zigbee stick (bijv. /dev/ttyUSB0, leeg = overslaan): " ZIGBEE_PATH
if [[ -n "$ZIGBEE_PATH" ]]; then
  if [[ ! -e "$ZIGBEE_PATH" ]]; then
    echo "❌ Zigbee device bestaat niet: $ZIGBEE_PATH"
    exit 1
  fi

  ZIGBEE_VENDOR=$(udevadm info -n "$ZIGBEE_PATH" | grep ID_VENDOR_ID | cut -d= -f2)
  ZIGBEE_PRODUCT=$(udevadm info -n "$ZIGBEE_PATH" | grep ID_MODEL_ID | cut -d= -f2)

  echo "✅ Zigbee gevonden: $ZIGBEE_PATH"
  echo "   Vendor ID : $ZIGBEE_VENDOR"
  echo "   Product ID: $ZIGBEE_PRODUCT"
fi
echo

# Z-Wave selectie
read -rp "➡️  Pad naar Z-Wave stick (bijv. /dev/ttyACM0, leeg = overslaan): " ZWAVE_PATH
if [[ -n "$ZWAVE_PATH" ]]; then
  if [[ ! -e "$ZWAVE_PATH" ]]; then
    echo "❌ Z-Wave device bestaat niet: $ZWAVE_PATH"
    exit 1
  fi

  ZWAVE_VENDOR=$(udevadm info -n "$ZWAVE_PATH" | grep ID_VENDOR_ID | cut -d= -f2)
  ZWAVE_PRODUCT=$(udevadm info -n "$ZWAVE_PATH" | grep ID_MODEL_ID | cut -d= -f2)

  echo "✅ Z-Wave gevonden: $ZWAVE_PATH"
  echo "   Vendor ID : $ZWAVE_VENDOR"
  echo "   Product ID: $ZWAVE_PRODUCT"
fi
echo

# Udev rules bestand
RULES_FILE="/etc/udev/rules.d/99-smart-home-radios.rules"
echo "📝 Udev rules aanmaken: $RULES_FILE"

echo "# Smart Home radio devices" > "$RULES_FILE"

if [[ -n "$ZIGBEE_PATH" ]]; then
  echo "SUBSYSTEM==\"tty\", ATTRS{idVendor}==\"$ZIGBEE_VENDOR\", ATTRS{idProduct}==\"$ZIGBEE_PRODUCT\", SYMLINK+=\"zigbee\"" >> "$RULES_FILE"
fi

if [[ -n "$ZWAVE_PATH" ]]; then
  echo "SUBSYSTEM==\"tty\", ATTRS{idVendor}==\"$ZWAVE_VENDOR\", ATTRS{idProduct}==\"$ZWAVE_PRODUCT\", SYMLINK+=\"zwave\"" >> "$RULES_FILE"
fi

# Udev reload
echo
echo "🔄 Udev rules herladen..."
udevadm control --reload-rules
udevadm trigger

sleep 2

echo
echo "✅ Definitieve paden:"
[[ -e /dev/zigbee ]] && echo "   ✔ /dev/zigbee"
[[ -e /dev/zwave ]] && echo "   ✔ /dev/zwave"

echo
echo "========================================"
echo " Setup voltooid – reboot-proof geregeld"
echo "========================================"