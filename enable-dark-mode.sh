#!/bin/bash

echo "==> Cinnamon Dark Mode inschakelen..."

# Controleer of Cinnamon draait
if [ "$XDG_CURRENT_DESKTOP" != "X-Cinnamon" ]; then
  echo "Waarschuwing: dit script is bedoeld voor Cinnamon, huidige desktop: $XDG_CURRENT_DESKTOP"
fi

# Thema’s instellen op donker
gsettings set org.cinnamon.theme name 'Mint-Y-Dark'
gsettings set org.cinnamon.desktop.interface gtk-theme 'Mint-Y-Dark'
gsettings set org.cinnamon.desktop.wm.preferences theme 'Mint-Y-Dark'
gsettings set org.cinnamon.desktop.interface icon-theme 'Mint-Y-Dark'
gsettings set org.cinnamon.desktop.interface cursor-theme 'Adwaita'

echo "Donkere modus is geactiveerd. Je kunt uitloggen of herstarten voor volledige toepassing."