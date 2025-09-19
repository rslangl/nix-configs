#!/usr/bin/env bash

set -euo pipefail

IMAGE="$1"

if [ ! -f "$IMAGE" ]; then
  echo "❌ Image not found at $IMAGE."
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

