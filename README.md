
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

Iedereen die een laptop meeneemt wordt **gratis geholpen**. En natuurlijk kunnen mensen ook **zelf aan de slag** met de software uit deze repository.

## Waarom dit belangrijk is

Digitale uitsluiting is een groeiend probleem.  
Toegang tot een computer en internet is geen luxe meer, maar een **basisvoorwaarde voor volwaardig meedoen** in de maatschappij.  
Met dit project voorkomen we een digitale tweedeling en maken we technologie toegankelijk voor iedereen.

## Wat zit er in dit project?

Deze repository bevat eenvoudige shellscripts om een Debian Cinnamon-desktop automatisch in te richten met:

- Google Chrome en Brave browser (via Flatpak)
- Aanvullende scripts: `apps-extras` en `extras-privacy`
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

**Download hier de [Debian Cinnamon Live ISO (64-bit)](https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/)**

---

## Installatie-instructies

### 1. Start vanaf Live-USB

Gebruik de Debian Cinnamon ISO op een USB-stick.  
Start je laptop opnieuw op en kies de USB als opstartmedium (vaak via F2, F12, ESC of DEL).

Maak een opstartbare USB-stick

Gebruik een van de volgende gratis tools om de ISO op een USB-stick te zetten:

- **Windows:** [Rufus](https://rufus.ie/)
- **macOS:** [balenaEtcher](https://www.balena.io/etcher/)
- **Linux:** Gebruik `gnome-multi-writer`, `dd` of `balenaEtcher`

Let op: USB-stick van minimaal 4 GB vereist. Selecteer bij voorkeur "ISO mode" als dat wordt gevraagd.

Start op vanaf USB

- Plaats de USB-stick in de laptop
- Herstart de computer
- Tijdens het opstarten druk je op de toets om het opstartmenu te openen:
  - Veelgebruikte toetsen: `F12`, `ESC`, `DEL`, `F2`
- Kies daar de USB-stick als opstartmedium

Soms moet je in het BIOS/UEFI opstartvolgorde aanpassen of Secure Boot uitschakelen. Zoek indien nodig naar “Boot order” of “Secure Boot” in het BIOS-menu.

### 2. Verbind met internet

Gebruik een bekabelde verbinding of wifi.

### 3. Start de Calamares Installer

Zoek op het bureaublad of in het menu naar “Install” en open de installer.

### 4. Doorloop de installatie

- **Taal**: Nederlands  
- **Tijdzone**: Europa/Amsterdam  
- **Toetsenbord**: US - International  
- **Partities**: Automatisch (gehele schijf wissen)  
- **Gebruiker**: vul naam en wachtwoord in  
  - Automatisch inloggen: **uit**  
  - Root-wachtwoord gelijk aan gebruiker: **aan**

### 5. Start installatie

Controleer je instellingen en klik op “Installeren”.  
Bevestig en wacht 5–15 minuten tot de installatie voltooid is.

### 6. Herstart

Na installatie: verwijder de USB-stick en start opnieuw op.

---

## Post-installatie

### 1. Log in met je gebruikersnaam

### 2. Open een terminal en voer het volgende uit:

```bash
sudo apt install git -y
git clone https://github.com/henrydenhengst/debian-desktop
cd debian-desktop
chmod +x setup-debian-cinnamon.sh
sudo ./setup-debian-cinnamon.sh

```

---

## 🤲 Bijdragen

Wil je helpen? Bekijk het [CONTRIBUTING.md](CONTRIBUTING.md)-bestand voor richtlijnen en manieren om bij te dragen.

## meer informatie over ons

📄 Meer informatie: zie [ABOUT.md](ABOUT.md)
