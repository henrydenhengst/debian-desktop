# Debian Cinnamon Desktop Setup

Een eenvoudig en krachtig project om laptops te hergebruiken en mensen digitaal te betrekken.

---

## ✨ Doelstelling

Dit project geeft afgeschreven laptops van bedrijven een tweede leven én helpt mensen om verbonden te blijven met onze digitale samenleving.

---

## Wat we doen

- **Bedrijven** doneren hun oude, nog bruikbare laptops.  
- **Vrijwilligers** installeren een gebruiksvriendelijke Debian Linux-desktop, op basis van deze GitHub-repository.  
- **Laptops worden uitgedeeld** aan mensen die gebruikmaken van de voedselbank.  
- In samenwerking met lokale **Repair Cafés** bieden we:  
  - hulp bij installatie en gebruik  
  - eenvoudige computertrainingen  
  - persoonlijke begeleiding  

Iedereen die een laptop ontvangt, wordt **gratis geholpen**.  
Natuurlijk kunnen mensen ook **zelf aan de slag** met de software uit deze repository.

## 🤲 Bijdragen

Wil je helpen? Bekijk dan het [CONTRIBUTING.md](CONTRIBUTING.md) bestand voor richtlijnen en suggesties.

---

## Waarom dit belangrijk is

Digitale uitsluiting is een groeiend probleem.  
Toegang tot een computer en internet is geen luxe meer, maar een **basisvoorwaarde om volwaardig mee te doen** in de maatschappij.

Met dit project:
- voorkomen we digitale tweedeling,
- hergebruiken we bestaande hardware,
- en maken we technologie toegankelijk voor iedereen.

---

## Wat zit er in dit project?

Deze repository bevat shellscripts om een Debian Cinnamon-desktop automatisch in te richten met onder andere:

- Google Chrome en Brave (via Flatpak)  
- Extra scripts: `apps-extras.sh` en `extras-privacy.sh`  
- UFW-firewall gesloten voor inkomend verkeer  
- Automatische updates voor APT en Flatpak  
- WiFi-verbindingstest vóór installatie  
- Toevoeging van de gebruiker aan de sudo-groep  
- Optionele extra’s voor populaire Flatpak-apps

---

## Systeemvereisten

- Minimaal **4 GB RAM**  
- Minimaal **50 GB SSD**  
- Werkende internetverbinding (wifi of bekabeld)  
- Computer met **AMD** of **Intel** processor  

**Download ISO:**  
[Debian Cinnamon Live ISO (amd64)](https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/)

---

## Installatie-instructies

### 1. Start vanaf een Live USB

Gebruik de ISO of `netboot.xyz`.  
Start de laptop vanaf USB (via F2, F12, ESC of DEL bij het opstarten).  
Kies “Live Session” of “Try without installing”.

### 2. Verbind met internet

Gebruik wifi of een UTP-kabel om verbinding te maken.

### 3. Start de Calamares Installer

Zoek op het bureaublad of in het menu naar "Install [Debian]".

### 4. Volg het installatieproces

- **Taal**: Nederlands  
- **Tijdzone**: Amsterdam (Nederland)  
- **Toetsenbord**: US - International  
- **Partities**: Automatisch (hele schijf wissen)  
- **Gebruiker aanmaken**: kies zelf een naam en wachtwoord  
  - *Niet automatisch inloggen*  
  - *Gebruik root-wachtwoord gelijk aan gebruikerswachtwoord*

### 5. Bevestigen en installeren

Controleer alle instellingen, klik op *Installeren*, wacht 5–15 minuten.  
Kies *Opnieuw opstarten* en verwijder de USB-stick als daarom wordt gevraagd.

---

## Post-installatie

### 1. Inloggen

Log in met je aangemaakte gebruikersnaam.

### 2. Voer het post-installatiescript uit

Open een terminal en voer het volgende uit:

```bash
sudo apt install git -y
git clone https://github.com/henrydenhengst/debian-desktop
cd debian-desktop
chmod +x setup-debian-cinnamon.sh
sudo ./setup-debian-cinnamon.sh
```

📄 Meer informatie: zie [ABOUT.md](ABOUT.md)
