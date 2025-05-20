#!/bin/bash

echo "Wil je extra gebruikers aanmaken? (ja/nee)"
read -r antwoord

if [[ "$antwoord" == "ja" || "$antwoord" == "j" ]]; then
  while true; do
    echo "Voer de gebruikersnaam in (of druk op Enter om te stoppen):"
    read -r gebruikersnaam

    if [[ -z "$gebruikersnaam" ]]; then
      echo "Klaar met gebruikers toevoegen."
      break
    fi

    if id "$gebruikersnaam" &>/dev/null; then
      echo "Gebruiker '$gebruikersnaam' bestaat al. Kies een andere naam."
    else
      echo "Voer een wachtwoord in voor '$gebruikersnaam':"
      read -rs wachtwoord
      echo

      echo "Wens je een andere shell dan /bin/bash? (standaard: Enter voor /bin/bash)"
      read -r shell
      shell=${shell:-/bin/bash}

      echo "Wens je een aangepaste home directory? (standaard: /home/$gebruikersnaam)"
      read -r homedir
      homedir=${homedir:-/home/$gebruikersnaam}

      # Gebruiker aanmaken
      useradd -m -d "$homedir" -s "$shell" "$gebruikersnaam"

      # Wachtwoord instellen
      echo "$gebruikersnaam:$wachtwoord" | chpasswd

      echo "Moet '$gebruikersnaam' sudo-rechten krijgen? (ja/nee)"
      read -r admin_antwoord
      if [[ "$admin_antwoord" == "ja" || "$admin_antwoord" == "j" ]]; then
        usermod -aG sudo "$gebruikersnaam"
        echo "Gebruiker '$gebruikersnaam' is toegevoegd aan de 'sudo'-groep."
      fi

      echo "Wil je een SSH public key toevoegen voor '$gebruikersnaam'? (ja/nee)"
      read -r ssh_antwoord
      if [[ "$ssh_antwoord" == "ja" || "$ssh_antwoord" == "j" ]]; then
        echo "Plak hieronder de SSH public key:"
        read -r ssh_key

        mkdir -p "$homedir/.ssh"
        echo "$ssh_key" > "$homedir/.ssh/authorized_keys"
        chmod 700 "$homedir/.ssh"
        chmod 600 "$homedir/.ssh/authorized_keys"
        chown -R "$gebruikersnaam:$gebruikersnaam" "$homedir/.ssh"

        echo "SSH key toegevoegd voor '$gebruikersnaam'."
      fi

      echo "Gebruiker '$gebruikersnaam' volledig aangemaakt."
    fi
  done
else
  echo "Geen extra gebruikers aangemaakt."
fi