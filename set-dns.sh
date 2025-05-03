#!/bin/bash

echo "==> DNS instellen op 9.9.9.9 (Quad9) en 1.1.1.1 (Cloudflare)..."

# Zorg dat systemd-resolved actief is
sudo systemctl enable systemd-resolved --now

# DNS configureren via resolved.conf.d
sudo mkdir -p /etc/systemd/resolved.conf.d
echo "[Resolve]
DNS=9.9.9.9 1.1.1.1
FallbackDNS=8.8.8.8 1.0.0.1
DNSStubListener=yes
" | sudo tee /etc/systemd/resolved.conf.d/dns.conf > /dev/null

# symbolic link for resolv.conf
sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

# Herstart resolver
sudo systemctl restart systemd-resolved

echo "DNS succesvol ingesteld op 9.9.9.9 en 1.1.1.1"