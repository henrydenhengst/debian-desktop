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

## 🤝 Help mee

- Gezocht: Project Owner (agile, vrijwillig) voor dit project.
Een project owner – iemand die energie krijgt van organiseren, contact leggen, bedrijven benaderen, opslag/transport afstemmen, en het project zichtbaar maken. Wij zorgen voor de techniek. Jij zorgt ervoor dat het project groeit. Wat breng jij mee? Communicatief vermogen, Zelfstandig kunnen organiseren. Eventueel ervaring met vrijwilligerswerk, fondsenwerving of sociale initiatieven Wat krijg je terug? Impact maken in je eigen regio.Samenwerken aan een betekenisvol, technisch én sociaal initiatief. Creatieve vrijheid om het project vorm te geven
- We zoeken **systeembeheerders en IT-vrijwilligers** om laptops te installeren en uit te rollen.
- We komen graag in contact met **voedselbanken** en **Repair Cafés** om onze doelgroep te bereiken.
- We zijn op zoek naar **bedrijven of organisaties die laptops willen doneren** — jouw oude hardware kan écht het verschil maken.

> Neem contact met ons op via een [issue](https://github.com/henrydenhengst/debian-desktop/issues) of start je eigen lokale initiatief met deze documentatie!

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

- Debian 12 "Bookworm" **met Cinnamon Desktop**  
- Werkende internetverbinding (wifi of bekabeld)
- Systeem moet al zijn geïnstalleerd vanaf de officiële ISO

> **Download ISO:**  
> [Debian Cinnamon Live ISO (amd64)](https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/)

---

## Installatie-instructies

1. Installeer Debian Cinnamon vanaf de ISO op je laptop of met netboot.xyz kun je meerdere apparaten tegelijk installeren.
2. Herstart en log in met je gebruikersnaam.
3. Open een terminal en voer het volgende uit:

```bash
sudo apt install git -y
git clone https://github.com/henrydenhengst/debian-desktop
cd debian-desktop
chmod +x setup-debian-cinnamon.sh
sudo ./setup-debian-cinnamon.sh


