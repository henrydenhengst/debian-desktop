# Debian Cinnamon Desktop Setup

Een eenvoudig en krachtig project om laptops te hergebruiken en mensen digitaal te betrekken.

## ✨ Doelstelling

Dit project geeft afgeschreven laptops van bedrijven een tweede leven én helpt mensen om verbonden te blijven met onze digitale samenleving.

## Wat we doen

- **Bedrijven** doneren hun oude, nog bruikbare laptops.  
- **Vrijwilligers** installeren een gebruiksvriendelijke Debian Linux-desktop, met deze GitHub-repo als basis.  
- **Laptops worden uitgedeeld** aan mensen die boodschappen doen bij de voedselbank.  
- In samenwerking met lokale **Repair Cafés** bieden we:
  - hulp bij installatie en gebruik
  - eenvoudige computertrainingen
  - persoonlijke begeleiding

Iedereen die een laptop meeneemt wordt **gratis geholpen**.  
En natuurlijk kunnen mensen ook **zelf aan de slag** met de software uit deze repository.

## Waarom dit belangrijk is

Digitale uitsluiting is een groeiend probleem. Toegang tot een computer en internet is geen luxe meer, maar een **basisvoorwaarde voor volwaardig meedoen** in de maatschappij.  
Met dit project voorkomen we een digitale tweedeling en maken we technologie toegankelijk voor iedereen.

## Wat zit er in dit project?

Deze repository bevat eenvoudige shellscripts om een Debian Cinnamon-desktop automatisch in te richten met:

- Google Chrome en Brave browser (via Flatpak)
- Extra scripts: `apps-extras` en `extras-privacy`
- UFW-firewall dichtgezet voor inkomend verkeer
- Automatische updates voor APT en Flatpak
- WiFi-verbindingstest vóór installatie
- Optionele extra’s voor populaire Flatpak-apps
- Toevoegen van gebruiker aan de sudo-groep

## Systeemvereisten

- Minimaal 4 GB RAM
- Minimaal 50 GB SSD
- Werkende internetverbinding (wifi of bekabeld)
- AMD of Intel processor

**Download ISO:** [Debian Cinnamon Live ISO (amd64)](https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/)

---

## Installatie-instructies

1. **Start vanaf Live-USB**  
   Gebruik de Debian Cinnamon ISO op een USB-stick. Start je laptop opnieuw op en kies de USB als opstartmedium (vaak via F2, F12, ESC of DEL).

2. **Verbind met internet** (wifi of UTP)

3. **Start Calamares Installer**  
   Zoek op het bureaublad of in het menu naar ‘Install’ en open Calamares.

4. **Kies instellingen in de wizard:**
   - Taal: Nederlands
   - Tijdzone: Amsterdam
   - Toetsenbord: US - International
   - Partities: Automatisch (de hele schijf wissen)
   - Gebruiker: Vul naam en wachtwoord in  
     - Automatisch inloggen: uit
     - Root-wachtwoord gelijk aan gebruiker: aan

5. **Controleer en installeer**  
   Klik op "Installeren" en bevestig je keuzes.

6. **Herstart**  
   Na installatie: verwijder de USB-stick en start opnieuw op.

---

## Post-installatie: setup uitvoeren

1. **Login met je gebruikersnaam**

2. **Open een terminal en voer uit:**

```bash
sudo apt install git -y
git clone https://github.com/henrydenhengst/debian-desktop
cd debian-desktop
chmod +x setup-debian-cinnamon.sh
sudo ./setup-debian-cinnamon.sh
