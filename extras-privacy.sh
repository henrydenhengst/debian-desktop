#!/bin/bash

echo "=== Privacysoftware: Selectieve Installatie ==="
echo "Je kunt nu per programma kiezen of je het wilt installeren."
echo

# Zorg dat Flatpak en Flathub zijn ingesteld
sudo apt install -y flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

install_app() {
    local name="$1"
    local id="$2"

    read -p "Wil je $name installeren? [j/N] " confirm
    if [[ "$confirm" =~ ^[Jj]$ ]]; then
        flatpak install -y flathub "$id"
    else
        echo "$name overgeslagen."
    fi
}

# Browsers
install_app "Brave Browser" com.brave.Browser
install_app "Firefox" org.mozilla.firefox
install_app "Ungoogled Chromium" com.github.Eloston.UngoogledChromium
install_app "QuteBrowser" org.qutebrowser.qutebrowser

# Video & Media
install_app "FreeTube (YouTube zonder tracking)" io.freetubeapp.FreeTube
install_app "GNOME Podcasts" org.gnome.Podcasts
install_app "Clementine muziekspeler" org.clementine_player.Clementine

# Messaging
install_app "Signal" org.signal.Signal
install_app "Telegram" org.telegram.desktop
install_app "Element (Matrix/Riot)" im.riot.Riot
install_app "Jami (p2p bellen)" net.jami.Jami
install_app "Jitsi Meet (via meet.jit.si of eigen server)" org.jitsi.jitsi-meet

# Utilities
install_app "KeePassXC (wachtwoordbeheerder)" org.keepassxc.KeePassXC
install_app "Thunderbird (e-mail)" org.mozilla.Thunderbird
install_app "Nextcloud desktop client" net.nextcloud.Nextcloud

echo
echo "Installatie voltooid (voor geselecteerde apps)."