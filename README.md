
# Debian Cinnamon Desktop Setup

Dit project bevat een eenvoudig shellscript om een net geïnstalleerde Debian Cinnamon-desktop automatisch in te richten met:

- **Chrome** en **Brave browser** via Flatpak
- **LibreOffice Fresh** via Flatpak
- **UFW-firewall**, dicht voor inkomend verkeer
- **Automatische updates** voor APT en Flatpak
- **WiFi-verbindingstest** vóór installatie
- Voeg jezelf toe aan de `sudo` groep indien nodig

---

## Systeemvereisten

- Debian 12 "Bookworm" met Cinnamon Desktop (Live ISO)
- Werkende internetverbinding (WiFi of kabel)
- Systeem is al geïnstalleerd vanaf de officiële ISO

Download ISO:  
[Debian Cinnamon Live ISO (amd64)](https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/)

---

## Installatie-instructies

1. **Installeer Debian Cinnamon** vanaf de ISO op je laptop.
2. **Herstart en log in** met je gebruikersnaam.
3. **Open een Terminal** en voer het volgende uit:

```bash / desktop
sudo apt install git -y
git clone https://github.com/henrydenhengst/debian-desktop
cd debian-desktop
chmod +x setup-debian-cinnamon.sh
cp setup-debian-cinnamon.desktop ~/.local/share/applications/
sudo ./setup-debian-cinnamon.sh


