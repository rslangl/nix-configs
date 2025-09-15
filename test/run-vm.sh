#!/usr/bin/env bash
set -euo pipefail

IMAGE="./result/nixos.qcow2"

if [ ! -f "$IMAGE" ]; then
  echo "❌ Image not found at $IMAGE. Run nix build first."
  exit 1
fi

qemu-system-x86_64 \
  -enable-kvm \
  -m 4096 \
  -smp 4 \
  -device virtio-vga \
  -nic user,model=virtio \
  -drive file="$IMAGE",format=qcow2,if=virtio \
  -display default,show-cursor=on

