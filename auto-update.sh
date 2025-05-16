#!/bin/bash


# Instructies
#
# 1. Sla het script op als auto-update.sh (bijv. in /usr/local/bin/).
# 2. Maak het uitvoerbaar:
# sudo chmod +x /usr/local/bin/auto-update.sh
# 3. Voeg een cronjob toe:
# sudo crontab -e
# Voeg deze regel toe om het script dagelijks
# om 3:00 's nachts uit te voeren:
# 0 3 * * * /usr/local/bin/
#
# Logbestand locatie (optioneel)
LOGFILE="/var/log/auto-update.log"

echo "== Start update: $(date) ==" >> "$LOGFILE"

# Update APT-pakketten
echo "Updating APT packages..." >> "$LOGFILE"
apt update >> "$LOGFILE" 2>&1
apt -y upgrade >> "$LOGFILE" 2>&1
apt -y full-upgrade >> "$LOGFILE" 2>&1

# Verwijder ongebruikte pakketten
echo "Cleaning APT packages..." >> "$LOGFILE"
apt -y autoremove >> "$LOGFILE" 2>&1
apt -y autoclean >> "$LOGFILE" 2>&1

# Update Flatpaks (als flatpak is geïnstalleerd)
if command -v flatpak &> /dev/null; then
    echo "Updating Flatpaks..." >> "$LOGFILE"
    flatpak update -y >> "$LOGFILE" 2>&1
fi

echo "== Update finished: $(date) ==" >> "$LOGFILE"