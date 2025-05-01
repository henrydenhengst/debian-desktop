#!/bin/bash

echo "=== Debian Cinnamon Setup - Hardware Check ==="

# Check RAM
total_mem=$(grep MemTotal /proc/meminfo | awk '{print $2}')
if [ "$total_mem" -lt 4000000 ]; then
    echo "❌ Onvoldoende RAM: $(($total_mem / 1024)) MB (minimaal 4000 MB aanbevolen)"
else
    echo "✅ RAM OK: $(($total_mem / 1024)) MB"
fi

# Check disk space (root partition)
free_space=$(df / | tail -1 | awk '{print $4}')
if [ "$free_space" -lt 10000000 ]; then
    echo "❌ Onvoldoende schijfruimte: $(($free_space / 1024)) MB vrij (minimaal 10 GB aanbevolen)"
else
    echo "✅ Schijfruimte OK: $(($free_space / 1024)) MB vrij"
fi

# Check if root device is on an SSD
root_dev=$(df / | tail -1 | awk '{print $1}' | sed 's/[0-9]*$//')
rotational_file="/sys/block/$(basename $root_dev)/queue/rotational"
if [ -f "$rotational_file" ] && [ "$(cat $rotational_file)" -eq 0 ]; then
    echo "✅ SSD gedetecteerd voor root-partitie ($root_dev)"
else
    echo "❌ Geen SSD gedetecteerd voor root-partitie ($root_dev) – SSD aanbevolen"
fi

# Check CPU architecture
arch=$(uname -m)
if [[ "$arch" != "x86_64" ]]; then
    echo "❌ Geen 64-bit CPU gedetecteerd ($arch vereist x86_64)"
else
    echo "✅ 64-bit CPU OK: $arch"
fi

# Check for network interface
if ip link | grep -q "state UP"; then
    echo "✅ Netwerkinterface actief"
else
    echo "❌ Geen actieve netwerkinterface gevonden"
fi

# Check WiFi availability
if iw dev 2>/dev/null | grep -q Interface; then
    echo "✅ WiFi-adapter aanwezig"
else
    echo "❌ Geen WiFi-adapter gevonden"
fi

echo "=== Hardwarecheck voltooid ==="