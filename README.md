# debian-desktop

Ensure WiFi is working before continuing

Install Flatpak + Flathub

Install Chrome and Brave via Flatpak

Install LibreOffice Fresh via Flatpak

Enable UFW firewall (deny incoming, allow outgoing)

Enable auto-updates for APT and Flatpak

Add current user to sudo if needed


✅ Step-by-step setup using Debian Cinnamon Live ISO

    Download and boot from the Debian Cinnamon Live ISO

        Get it here: https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/

        Choose: debian-live-12.x.0-amd64-cinnamon.iso

    Use the “Install” option from the live environment

        This installs Debian Cinnamon to your hard disk

    Reboot into your new installed system

    Log in with the user you created during installation

    Open the terminal and run the post-install script:

        Either copy/paste the full script from above

        Or download it directly:

        curl -O https://your-server/setup-debian-cinnamon.sh
        chmod +x setup-debian-cinnamon.sh
        sudo ./setup-debian-cinnamon.sh

    Wait for it to complete (a few minutes)

After that, you’ll have:

    Working WiFi

    Chrome, Brave, LibreOffice (via Flatpak)

    UFW firewall enabled

    Auto updates for APT and Flatpak

    Full sudo rights


