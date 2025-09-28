#!/usr/bin/env bash

set -euo pipefail

# Global vars
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
IMAGES_DIR="${ROOT_DIR}/test/images"
DRIVES_DIR="${ROOT_DIR}/test/drives"
SNAPSHOTS_DIR="${ROOT_DIR}/test/snapshots"
CLOUD_INITS_DIR="${ROOT_DIR}/test/cloud-init"

# Output message colors
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
WARNING="$(tput setaf 1)"

declare -A images

# Structure: type indicating cloud or bare metal image, local ISO file, URL for download, virtual HD file, seed image for cloud images
images[debian]="type:baremetal|file:debian.iso|url:http://ftp.uio.no/debian-cd/13.1.0/amd64/iso-cd/debian-13.1.0-amd64-netinst.iso|drive:debian.qcow2"
images[nixos]="type:baremetal|file:nixos.iso|url:https://channels.nixos.org/nixos-25.05/latest-nixos-graphical-x86_64-linux.iso|drive:nixos.qcow2"
#images[debian-cloud]="type:cloud|file:debian-cloud.iso|url:https://cloud.debian.org/images/cloud/trixie/20250924-2245/debian-13-nocloud-amd64-20250924-2245.qcow2|seed:debian-seed.iso"

# Default settings
SYSTEM=""
INSTALL=false
SNAPSHOT=false
BOOT="c"

launch_cloud_image() {
  local _iso="$1" # images/*.iso
  local _drive="$2" # drives/*.qcow2
  local _seed="$3" # cloud-init/*/seed.iso
  local _boot="$4" # c|d

  qemu-system-x86_64 \
    -drive file="$_iso",format=qcow2 \
    -drive file="$_seed",format=raw \
    -boot "$_boot" \
    -m 4G \
    -enable-kvm \
    -cpu host \
    -smp 4 \
    -device virtio-net-pci,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::2222-:22 \
    -vga virtio \
    -display none \
    -vnc :1
}

launch_baremetal_image() {
  local _iso="$1" # images/*.iso
  local _drive="$2" # drives/*.qcow2
  local _boot="$3" # c|d
  
  echo "${INFO} Launching QEMU with parameters: cdrom=$_iso, drive file=$_drive, boot=$_boot"

  qemu-system-x86_64 \
    -cdrom "$_iso" \
    -drive file="$_drive",format=qcow2 \
    -boot "$_boot" \
    -m 4G \
    -enable-kvm \
    -cpu host \
    -smp 4 \
    -device virtio-net-pci,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::2222-:22 \
    -vga virtio \
    -display none \
    -vnc :1
}

usage() {
    echo "Usage: $0 -s <system> [-i] [-b <boot>]"
    echo ""
    echo "Options:"
    echo "  -s <system>    Required. System name. One of: ${!images[*]}"
    echo "  -i             Optional. Enable install mode (default: false)"
    echo "  -b <boot>      Optional. Boot method: cdrom or drive (default: drive)"
    echo "  -k             Optional. Create snapshot of the selected system (default: false)"
    echo "  -h             Show this help message"
    echo ""
    exit 1
}

while getopts ":s:ikb:h" opt; do
    case "$opt" in
        s)
            SYSTEM="$OPTARG"
            ;;
        i)
            INSTALL=true
            ;;
        b)
            if [[ "$OPTARG" == "cdrom" ]]; then
              BOOT='d'
            elif [[ "$OPTARG" == "drive" ]]; then
              BOOT='c'
            else
              echo "${ERROR} Unknown boot option: $OPTARG"
              usage
            fi
            ;;
        k)
            SNAPSHOT=true
            ;;
        h)
            usage
            ;;
        :)
            echo "${ERROR} Option -$OPTARG requires an argument." >&2
            usage
            ;;
        \?)
            echo "${ERROR} Invalid option: -$OPTARG" >&2
            usage
            ;;
    esac
done

if [[ -z "${SYSTEM:-}" ]]; then
    echo "${ERROR} System (-s) is required."
    usage
fi

if [[ -z "${images[$SYSTEM]+_}" ]]; then
    echo "${ERROR} Unknown system '$SYSTEM'. Must be one of: ${!images[*]}"
    usage
fi

if [[ -n "${SNAPSHOT:-}" ]]; then
  if [[ ! -f "${DRIVES_DIR}/${SYSTEM}.qcow2" ]]; then
    echo "${ERROR} No drive file to run snapshot from: $SYSTEM, in directory $DRIVES_DIR"
    usage
  fi
  echo "${INFO} Creating snapshot of existing image"
  TIMESTAMP=$(date -u +"%Y-%m-%dT%H-%M-%SZ")
  qemu-img create -f qcow2 -b "${DRIVES_DIR}/${SYSTEM}.qcow2" -F qcow2 "${SNAPSHOTS_DIR}/${SYSTEM}_snapshot_${TIMESTAMP}.qcow2"
fi

LAUNCH_TYPE=""
ISO_FILE=""
SEED_FILE=""
DRIVE_FILE=""

# Iterate all images and ensure the necessary resources are available
for image in "${!images[@]}"; do
  entry="${images[$image]}"

  echo "${INFO} Processing image: $image"

  LAUNCH_TYPE=$(echo "$entry" | grep -oP 'type:\K[^|]+')
  file=$(echo "$entry" | grep -oP 'file:\K[^|]+')
  url=$(echo "$entry" | grep -oP 'url:\K[^|]+')
  drive=$(echo "$entry" | grep -oP 'drive:\K[^|]+')

  if [ ! -f "${DRIVES_DIR}/${drive}" ]; then
    echo "${NOTE} Drive file $drive for system $SYSTEM does not exist, creating..."
    qemu-img create -f qcow2 "$DRIVES_DIR/$drive" 64G
    echo "${OK} Drive file created successfully"
  fi

  if [ ! -f "${IMAGES_DIR}/${file}" ]; then
    echo "${NOTE} ISO file $file for system $SYSTEM does not exist, downloading..."
    curl -Lo "$IMAGES_DIR/$file" "$url"
    echo "${OK} ISO file downloaded successfully"
  fi

  if [[ "$LAUNCH_TYPE" == "cloud" ]]; then
    seed=$(echo "$entry" | grep -oP 'seed:\K[^|]+')
    SEED_FILE="${CLOUD_INITS_DIR}/${image}/seed.iso"

    # Create seed image if does not exist
    if [ ! -f "$SEED_FILE" ]; then
      echo "${NOTE} Seed file for cloud system $SYSTEM does not exist, creating..."
      genisoimage -output "$SEED_FILE" -volid cidata -joliet -rock "${CLOUD_INITS_DIR}/${SYSTEM}/user-data" "${CLOUD_INITS_DIR}/${SYSTEM}/meta-data"
      echo "${OK} Seed file created successfully"
    fi
  fi

done

# Launch with QEMU depending on image type
if [ "$LAUNCH_TYPE" == "baremetal" ]; then
  echo "${INFO} Launching bare metal image: $SYSTEM"
  launch_baremetal_image "${IMAGES_DIR}/${SYSTEM}.iso" "${DRIVES_DIR}/$SYSTEM.qcow2" "$BOOT"
elif [[ "$LAUNCH_TYPE" == "cloud" ]]; then
  echo "${INFO} Launching cloud image: $SYSTEM"
  launch_cloud_image "${IMAGES_DIR}/${SYSTEM}.iso" "${DRIVES_DIR}/$SYSTEM.qcow2" "${CLOUD_INITS_DIR}/${SYSTEM}/seed.iso" "$BOOT"
else
  echo "${ERROR} Launch type not recognized: $LAUNCH_TYPE"
  usage
fi

