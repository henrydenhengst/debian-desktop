
# Debian Cinnamon Desktop Setup

## Doelstelling

Dit project heeft als doel om afgeschreven laptops van bedrijven een tweede leven te geven én om mensen te blijven betrekken bij de samenleving.

### Wat we doen

- Bedrijven doneren hun oude, nog bruikbare laptops.
- Vrijwilligers installeren er een gebruiksvriendelijke Debian Linux-desktop op, volgens de configuratie in deze GitHub-repo.
- De laptops worden gratis uitgedeeld aan mensen die boodschappen doen bij de voedselbank.
- In samenwerking met lokale **Repair Cafés** bieden we:
  - hulp bij installatie en gebruik
  - eenvoudige computertrainingen
  - persoonlijke begeleiding

### Waarom dit belangrijk is

We willen digitale uitsluiting tegengaan en voorkomen dat mensen worden buitengesloten van informatie, communicatie en kansen.  
Toegang tot een computer en het internet is geen luxe meer — het is een basisvoorwaarde voor volwaardig meedoen in de maatschappij.

### Help mee

- We zoeken **systeembeheerders en IT-vrijwilligers** die kunnen helpen bij het installeren en uitrollen van Linux-laptops.
- We willen graag in contact komen met **voedselbanken** en **Repair Cafés** om onze doelgroep te bereiken en de laptops persoonlijk te kunnen overhandigen.

Neem contact op via een issue of pull request in deze GitHub-repo — of start een lokaal initiatief met deze documentatie als basis!


## Dit project bevat eenvoudige shellscripts om een net geïnstalleerde Debian Cinnamon-desktop automatisch in te richten met:

- **Chrome** en **Brave browser** via Flatpak
- **UFW-firewall**, dicht voor inkomend verkeer
- **Automatische updates** voor APT en Flatpak
- **WiFi-verbindingstest** vóór installatie
- **extras** voor aanvullende apps
- Voeg jezelf toe aan de `sudo` groep

---

### Systeemvereisten

- Debian 12 "Bookworm" met Cinnamon Desktop (Live ISO)
- Werkende internetverbinding (WiFi of kabel)
- Systeem is al geïnstalleerd vanaf de officiële ISO

Download ISO:  
[Debian Cinnamon Live ISO (amd64)](https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/)

---

### Installatie-instructies

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


