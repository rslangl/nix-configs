#!/usr/bin/env bash
set -euo pipefail

# TODO: use associative array for resources

DEBIAN_CLOUD_ISO_URL="https://cloud.debian.org/images/cloud/trixie/20250924-2245/debian-13-nocloud-amd64-20250924-2245.qcow2"
DEBIAN_CLOUD_ISO="debian13_nocloud.qcow2"
DEBIAN_CLOUD_SEED_ISO="debian13_nocloud_seed.iso"

DEBIAN_ISO_URL="http://ftp.uio.no/debian-cd/13.1.0/amd64/iso-cd/debian-13.1.0-amd64-netinst.iso"DEBIAN_ISO="debian13.iso"
DEBIAN_ISO="debian13.iso"
DEBIAN_DRIVE_FILE="debian.qcow2"

NIXOS_ISO_URL="https://channels.nixos.org/nixos-25.05/latest-nixos-graphical-x86_64-linux.iso"
NIXOS_ISO="nixos.iso"
NIXOS_DRIVE_FILE="nixos.qcow2"

if [[ ! -f "$DEBIAN_ISO" ]]; then
  echo "Downloading Debian ISO..."
  curl -Lo "$DEBIAN_ISO" "$DEBIAN_ISO_URL"
fi

if [[ ! -f "$DEBIAN_CLOUD_ISO" ]]; then
  echo "Downloading Debian cloud ISO..."
  curl -Lo "$DEBIAN_CLOUD_ISO" "$DEBIAN_CLOUD_ISO_URL"
fi

if [[ ! -f "$NIXOS_ISO" ]]; then
  echo "Downloading NixOS ISO..."
  curl -Lo "$NIXOS_ISO" "$NIXOS_ISO_URL"
fi

if [[ ! -f "$DEBIAN_DRIVE_FILE" ]]; then
  echo "Creating Debian drive file..."
  qemu-img create -f qcow2 "$DEBIAN_DRIVE_FILE" 20G
fi

if [[ ! -f "$NIXOS_DRIVE_FILE" ]]; then
  echo "Creating NixOS drive file..."
  qemu-img create -f qcow2 "$NIXOS_DRIVE_FILE" 20G
fi

# TODO: check args

SYSTEM="$1"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H-%M-%SZ")

# TODO: wrap calls to functions for specific conditions:
# build drive file require both ISO and drive file, `boot c`
# boot from drive file require only drive file, `boot d`
# booting from cloud image require a seed image to be created first

case "$SYSTEM" in
  debian)
    echo "Making snapshot prior to launching..."
    qemu-img create -f qcow2 -b "$DEBIAN_DRIVE_FILE" -F qcow2 "debian_snapshot_${TIMESTAMP}.qcow2"
    echo "Launching Debian.."
    qemu-system-x86_64 \
      -cdrom "$DEBIAN_ISO" \
      -drive file="$DEBIAN_DRIVE_FILE",format=qcow2 \
      -boot c \
      -m 4G \
      -enable-kvm \
      -cpu host \
      -smp 4 \
      -device virtio-net-pci,netdev=net0 \
      -netdev user,id=net0,hostfwd=tcp::2222-:22 \
      -vga virtio \
      -display none \
      -vnc :1
  ;;
  debiancloud)
    echo "Launching Debian cloud..."
    qemu-system-x86_64 \
      -drive file="$DEBIAN_CLOUD_ISO",format=qcow2 \
      -drive file="$DEBIAN_CLOUD_SEED_ISO",format=raw \
      -boot d \
      -m 4G \
      -enable-kvm \
      -cpu host \
      -smp 4 \
      -device virtio-net-pci,netdev=net0 \
      -netdev user,id=net0,hostfwd=tcp::2222-:22 \
      -vga virtio \
      -display none \
      -vnc :1
  ;;
  nixos)
    echo "Launching NixOS.."
    qemu-system-x86_64 \
      -cdrom "$NIXOS_ISO" \
      -drive file="$NIXOS_DRIVE_FILE",format=qcow2 \
      -boot d \
      -m 4G \
      -enable-kvm \
      -cpu host \
      -smp 4 \
      -device virtio-net-pci,netdev=net0 \
      -netdev user,id=net0,hostfwd=tcp::2222-:22 \
      -vga virtio \
      -display none \
      -vnc :1
  ;;
  *)
    echo "No such system: $SYSTEM"
    exit 1
  ;;
esac

