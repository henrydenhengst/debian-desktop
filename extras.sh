#!/bin/bash
set -e

echo "=== Interactieve installatie van populaire Flatpaks ==="
echo
echo "Let op: deze extra toepassingen zijn handig, maar kunnen behoorlijk wat geheugen, opslag of CPU gebruiken."
echo "Installeer deze alleen op laptops met voldoende prestaties (bijv. minimaal 4 GB RAM en een SSD)."
echo
echo "Zware applicaties in deze lijst:"
echo " - OBS Studio (videobewerking)"
echo " - Games"
echo " - Zoom (videobellen)"
echo " - Jitsi Meet (videobellen via browser)"
echo " - Signal (chat + versleuteling)"
echo " - Telegram"
echo " - WhatsApp (Electron)"
echo
read -p "Weet je zeker dat je deze extra's wilt installeren? [j/N] " confirm

if [[ ! "$confirm" =~ ^[Jj]$ ]]; then
    echo "Installatie van extra software is overgeslagen."
    exit 0
fi

# Hierna volgt de installatiecode...

# Zorg dat Flatpak is geïnstalleerd
if ! command -v flatpak &> /dev/null; then
  echo "❌ Flatpak is niet geïnstalleerd. Installeer dit eerst."
  exit 1
fi

# Voeg Flathub toe indien nodig
if ! flatpak remote-list | grep -q flathub; then
  echo ">>> Flathub wordt toegevoegd..."
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

ADD_FLATHUB_BETA=0

declare -A apps

# Populaire tools
apps+=(
  ["VLC"]="org.videolan.VLC"
  ["GIMP"]="org.gimp.GIMP"
  ["Krita"]="org.kde.krita"
  ["Inkscape"]="org.inkscape.Inkscape"
  ["Audacity"]="org.audacityteam.Audacity"
  ["OBS Studio"]="com.obsproject.Studio"
  ["Kdenlive"]="org.kde.kdenlive"
  ["PDF Arranger"]="com.github.jeromerobert.pdfarranger"
  ["Syncthing GTK"]="me.kozec.syncthingtk"
  ["Metadata Cleaner"]="fr.handbrake.ghb"
  ["HandBrake"]="fr.handbrake.ghb"
  ["Draw.io (diagrams.net)"]="com.jgraph.drawio.desktop"
  ["Geary (e-mail)"]="org.gnome.Geary"
  ["Transmission"]="com.transmissionbt.Transmission"
  ["Foliate (e-book reader)"]="com.github.johnfactotum.Foliate"
  ["Shortwave (internetradio)"]="de.haeckerfelix.Shortwave"
  ["NewsFlash (RSS reader)"]="org.gabmus.newsflash"
)

# Communicatie
apps+=(
  ["Signal"]="org.signal.Signal"
  ["WhatsApp Desktop"]="io.github.mimbrero.WhatsAppDesktop"
  ["Telegram"]="org.telegram.desktop"
  ["Zoom"]="us.zoom.Zoom"
  ["Slack"]="com.slack.Slack"
  ["Discord"]="com.discordapp.Discord"
  ["Jitsi Meet"]="org.jitsi.jitsi-meet"
  ["Microsoft Teams"]="com.github.IsmaelMartinez.teams_for_linux"
  ["Fractal (Matrix)"]="org.gnome.Fractal"
)

# Web & wachtwoordbeheer
apps+=(
  ["Spotify"]="com.spotify.Client"
  ["Bitwarden"]="com.bitwarden.desktop"
  ["KeePassXC"]="org.keepassxc.KeePassXC"
)

# Gaming
apps+=(
  ["Steam"]="com.valvesoftware.Steam"
  ["Heroic Games Launcher"]="com.heroicgameslauncher.hgl"
)

for name in "${!apps[@]}"; do
  read -rp "Wil je $name installeren? (j/N): " answer
  if [[ "$answer" =~ ^[JjYy]$ ]]; then
    if [[ "${apps[$name]}" == "org.signal.Signal" ]]; then
      ADD_FLATHUB_BETA=1
    fi
    echo ">>> Installeer: $name"
    flatpak install -y flathub "${apps[$name]}" || flatpak install -y flathub-beta "${apps[$name]}"
  else
    echo ">>> Overslaan: $name"
  fi
done

# Voeg Flathub Beta toe indien nodig
if [[ $ADD_FLATHUB_BETA -eq 1 ]] && ! flatpak remote-list | grep -q flathub-beta; then
  echo ">>> Flathub Beta wordt toegevoegd (voor Signal)..."
  flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
fi

echo
echo "✅ Klaar! De gekozen Flatpaks zijn geïnstalleerd."