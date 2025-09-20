#!/usr/bin/env bash

set -euo pipefail

IMAGE_PATH="$1"
NBD_DEVICE="/dev/nbd0"

# Partition sizes in MiB (adjust as needed)
BOOT_SIZE=512       # usually exists
ROOT_SIZE=10240     # usually exists
HOME_SIZE=5120      # 5 GB
VAR_SIZE=2048       # 2 GB

cleanup() {
  echo "Cleaning up..."
  sudo qemu-nbd --disconnect "$NBD_DEVICE" || true
  sudo rmmod nbd || true
}
trap cleanup EXIT

echo "Loading nbd module..."
sudo modprobe nbd max_part=8

echo "Connecting $IMAGE_PATH to $NBD_DEVICE..."
sudo qemu-nbd --connect="$NBD_DEVICE" "$IMAGE_PATH"

echo "Checking existing partitions..."
PARTS=$(sudo parted "$NBD_DEVICE" print | grep "^ " | awk '{print $1, $4, $5}')

echo "Current partitions:"
echo "$PARTS"

# Helper to check if a partition label exists
partition_exists() {
  local label=$1
  blkid | grep -q "LABEL=\"$label\""
}

# Create /home and /var partitions if missing
sudo parted "$NBD_DEVICE" unit MiB print > /tmp/parts.txt
LAST_END=$(grep '^ ' /tmp/parts.txt | tail -1 | awk '{print $3}' | tr -d 'MiB')

echo "Last partition ends at: $LAST_END MiB"

# Calculate start/end points for new partitions
HOME_START=$(( LAST_END ))
HOME_END=$(( HOME_START + HOME_SIZE ))

VAR_START=$(( HOME_END ))
VAR_END=$(( VAR_START + VAR_SIZE ))

if partition_exists "home"; then
  echo "/home partition already exists, skipping creation."
else
  echo "Creating /home partition from ${HOME_START}MiB to ${HOME_END}MiB..."
  sudo parted -a optimal "$NBD_DEVICE" mkpart primary ext4 "${HOME_START}MiB" "${HOME_END}MiB"
fi

if partition_exists "var"; then
  echo "/var partition already exists, skipping creation."
else
  echo "Creating /var partition from ${VAR_START}MiB to ${VAR_END}MiB..."
  sudo parted -a optimal "$NBD_DEVICE" mkpart primary ext4 "${VAR_START}MiB" "${VAR_END}MiB"
fi

# Wait for kernel to re-read partition table
echo "Reloading partition table..."
sudo partprobe "$NBD_DEVICE"

# Format partitions if they don't have correct labels
format_partition() {
  local part_num=$1
  local label=$2
  local dev="${NBD_DEVICE}p${part_num}"

  if blkid "$dev" | grep -q "LABEL=\"$label\""; then
    echo "Partition $dev already formatted with label $label, skipping mkfs."
  else
    echo "Formatting $dev as ext4 with label $label..."
    sudo mkfs.ext4 -L "$label" "$dev"
  fi
}

# Find partition numbers for home and var by searching partition labels
get_partition_number_by_label() {
  local label=$1
  blkid -L "$label" | sed -e 's|/dev/nbd0p||'
}

# If new partitions were created, figure out their numbers
echo "Finding partition numbers for /home and /var..."

sleep 2  # wait a bit for system to see partitions

# If /home partition label exists, get number, else assume last partition
HOME_PART_NUM=$(blkid -L home || echo "")
if [[ -z "$HOME_PART_NUM" ]]; then
  # Find last partition number for /home (assuming sequential)
  TOTAL_PARTS=$(sudo parted "$NBD_DEVICE" print | grep '^ ' | wc -l)
  HOME_PART_NUM=$TOTAL_PARTS
fi

VAR_PART_NUM=$((HOME_PART_NUM + 1))

# Format partitions
format_partition "$HOME_PART_NUM" "home"
format_partition "$VAR_PART_NUM" "var"

# Disconnect image
echo "Disconnecting $NBD_DEVICE before launching QEMU..."
sudo qemu-nbd --disconnect "$NBD_DEVICE"

# Launch QEMU (adjust as needed)
echo "Launching QEMU with $IMAGE_PATH..."
qemu-system-x86_64 \
  -drive file="$IMAGE_PATH",format=qcow2 \
  -m 4G \
  -enable-kvm \
  -cpu host \
  -smp 4 \
  -device virtio-net,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp:2222-:22 \
  -vga qxl \
  -display gtk

# cleanup() will run here thanks to trap

