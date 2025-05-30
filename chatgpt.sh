#!/bin/bash

# === Configuratie ===
APP_NAME="chatgpt"
GITHUB_REPO="lencx/ChatGPT"
DEB_ARCH="amd64"

# === Functie om de nieuwste release op te halen ===
get_latest_release() {
  curl -s "https://api.github.com/repos/$GITHUB_REPO/releases/latest" | \
    grep "browser_download_url.*${DEB_ARCH}.deb" | \
    cut -d '"' -f 4
}

# === Script start ===
echo "⏳ ChatGPT Desktop voor Debian installeren..."

DOWNLOAD_URL=$(get_latest_release)

if [ -z "$DOWNLOAD_URL" ]; then
  echo "❌ Kan de downloadlink niet ophalen. Controleer internetverbinding of repo."
  exit 1
fi

FILENAME=$(basename "$DOWNLOAD_URL")

echo "🔽 Downloaden: $FILENAME"
wget -q --show-progress "$DOWNLOAD_URL"

if [ ! -f "$FILENAME" ]; then
  echo "❌ Download mislukt."
  exit 1
fi

echo "📦 Installeren..."
sudo apt install ./"$FILENAME" -y

if [ $? -eq 0 ]; then
  echo "✅ Installatie voltooid! Start de app via je menu of met 'chatgpt' in de terminal."
else
  echo "⚠️ Installatie mislukt. Probeer eventueel met 'sudo dpkg -i $FILENAME' gevolgd door 'sudo apt -f install'"
fi

# === Opruimen ===
rm "$FILENAME"