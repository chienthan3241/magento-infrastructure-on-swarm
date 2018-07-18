#!/bin/bash

if [ "x$(id -u)" != "x0" ]; then
    echo "ERROR: Must run as root.  Bailing out."
    exit 1
fi

echo "==> Decrypt /data, passphrase required"
cryptsetup open --allow-discards /dev/mapper/vg0-data vg0-data-decrypted

echo "--> Mount /data"
mount /dev/mapper/vg0-data-decrypted /data

echo "==> Decrypt swap 0, passphrase required"
cryptsetup open --allow-discards /dev/mapper/vg0-swap0 vg0-swap0-decrypted
echo "==> Decrypt swap 1, passphrase required"
cryptsetup open --allow-discards /dev/mapper/vg0-swap1 vg0-swap1-decrypted

echo "--> Swapping on swap"
swapon -d -p0 /dev/mapper/vg0-swap0-decrypted
swapon -d -p0 /dev/mapper/vg0-swap1-decrypted

echo "==> Starting docker"
systemctl start docker

