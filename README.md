# Debian Cinnamon Desktop Setup

Een eenvoudig en krachtig project om laptops te hergebruiken en mensen digitaal te betrekken.

---

## ✨ Doelstelling

Dit project geeft afgeschreven laptops van bedrijven een tweede leven én helpt mensen om verbonden te blijven met onze digitale samenleving.

---

## Wat we doen

- **Bedrijven** doneren hun oude, nog bruikbare laptops.
- **Vrijwilligers** installeren een gebruiksvriendelijke Debian Linux-desktop, met dit GitHub-project als basis.
- **Laptops worden uitgedeeld** aan mensen die boodschappen doen bij de voedselbank.
- In samenwerking met lokale **Repair Cafés** bieden we:
  - hulp bij installatie en gebruik  
  - eenvoudige computertrainingen  
  - persoonlijke begeleiding

Iedereen die een laptop meeneemt wordt **gratis geholpen**.  
En natuurlijk kunnen mensen ook **zelf aan de slag** met de software uit deze repository.

---

## Waarom dit belangrijk is

Digitale uitsluiting is een groeiend probleem.  
Toegang tot een computer en internet is geen luxe meer, maar een **basisvoorwaarde voor volwaardig meedoen** in de maatschappij.

Met dit project voorkomen we een digitale tweedeling en maken we technologie toegankelijk voor iedereen.

---

## Wat zit er in dit project?

Deze GitHub-repo bevat eenvoudige shellscripts om een Debian Cinnamon-desktop automatisch in te richten met:

- Google Chrome en Brave browser (via Flatpak)
- Er is een aanvullend apps extras en extras-privacy script.
- UFW-firewall dichtgezet voor inkomend verkeer
- Automatische updates voor APT en Flatpak
- WiFi-verbindingstest vóór installatie
- Extra's voor populaire Flatpak-apps (optioneel)
- Toevoegen van gebruiker aan sudo-groep

---

## Systeemvereisten

- 4 GB intern geheugen, minimaal
- 50 GB SSD harddisk, minimaal
- Werkende internetverbinding (wifi of bekabeld)
- AMD of Intel computer 

> **Download ISO:**  
> [Debian Cinnamon Live ISO (amd64)](https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/)

---

## Installatie Instructies 

1. Start vanaf Live-USB

Installeer Debian Cinnamon vanaf de ISO op je laptop of met netboot.xyz dan kun je meerdere apparaten tegelijk installeren.

Plaats de USB-stick met de Debian Linux distributie.

Start je computer opnieuw op en kies de USB-stick in het opstartmenu (vaak via F2, F12, ESC of DEL bij het opstarten).

Kies voor "Live Session" of "Try without installing" om de desktopomgeving te laden.

2. Netwerk 

Connect het UTP netwerk of WIFI

3. Start Calamares Installer

Zoek op het bureaublad of in het menu naar iets als Install [Debian] en klik erop om Calamares te starten.

4. Taal kiezen

Selecteer de gewenste taal (Nederlands) en klik op Volgende.

5. Tijdzone instellen

Kies je regio en tijdzone op de kaart (Amsterdam , Nederland) of via de lijst. Klik op Volgende.

6. Toetsenbordindeling

Selecteer je toetsenbordindeling (US - International). Je kunt het testen in het tekstvak onderaan.

7. Schijfpartities instellen

Automatisch (aanbevolen): Calamares zal de hele schijf wissen en Linux installeren.

Handmatig: NIET gebruiken.

Klik op Volgende wanneer je klaar bent.

8. Gebruikersaccount aanmaken

Vul je naam, gebruikersnaam, computernaam en wachtwoord in.

Je kunt kiezen om automatisch in te loggen (niet doen!) en/of het root-wachtwoord hetzelfde te maken (wel doen!)

9. Overzicht en Installatie starten

Controleer je instellingen.

Klik op Installeren en bevestig je keuze.

10. Installatieproces

Wacht tot het proces is voltooid (duurt meestal 5–15 minuten).

Als de installatie klaar is, kies Opnieuw opstarten en Verwijder de USB-stick wanneer daarom gevraagd wordt.

---

## Post-Install-Instructies

11. Login

Na herstart log in met je gebruikersnaam.

12. Run Post Install Script 

Open een terminal en voer het volgende uit:

```bash
sudo apt install git -y
git clone https://github.com/henrydenhengst/debian-desktop
cd debian-desktop
chmod +x setup-debian-cinnamon.sh
sudo ./setup-debian-cinnamon.sh


