wget https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.0.0-amd64-netinst.iso

sudo dd if=debian-13.0.0-amd64-netinst.iso of=/
dev/sdX bs=4M status=progress conv=fsync