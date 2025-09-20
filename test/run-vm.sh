#!/usr/bin/env bash
set -euo pipefail

# Root and test directories
ROOT_DIR="$(dirname "$(realpath "$0")")"
TEST_DIR="$ROOT_DIR/test"
IMG_NAME="nixos-25.05-x86_64-linux.qcow2"
IMG_PATH="$TEST_DIR/$IMG_NAME"
SEED_ISO="$TEST_DIR/seed.iso"
USER_DATA="$TEST_DIR/user-data.yaml"
META_DATA="$TEST_DIR/meta-data"

# Your repo and setup script inside VM
GITHUB_REPO="https://github.com/youruser/yourrepo.git"
SETUP_SCRIPT_PATH="install.sh"  # relative path inside yourrepo

# NixOS cloud image URL
NIXOS_CLOUD_IMAGE_URL="https://releases.nixos.org/nixos/25.05/nixos-25.05-x86_64-linux.qcow2"

mkdir -p "$TEST_DIR"

echo "Checking if image exists at $IMG_PATH..."
if [[ ! -f "$IMG_PATH" ]]; then
  echo "Image not found. Downloading NixOS cloud image..."
  curl -L -o "$IMG_PATH" "$NIXOS_CLOUD_IMAGE_URL"
else
  echo "Image already exists."
fi

echo "Generating cloud-init user-data file..."
cat > "$USER_DATA" <<EOF
#cloud-config
runcmd:
  - [ sh, -c, "git clone $GITHUB_REPO /root/setup || (cd /root/setup && git pull)" ]
  - [ sh, -c, "chmod +x /root/setup/$SETUP_SCRIPT_PATH && /root/setup/$SETUP_SCRIPT_PATH" ]
EOF

# Empty meta-data file required for cloud-init seed ISO
touch "$META_DATA"

# Function to create seed.iso using Docker with cloud-localds
create_seed_iso_with_docker() {
  echo "Creating seed ISO using Docker container..."
  docker run --rm -v "$TEST_DIR":/workdir ubuntu:22.04 bash -c "
    apt update -qq && apt install -y -qq cloud-image-utils && \
    cloud-localds /workdir/seed.iso /workdir/user-data.yaml
  "
}

# Function to create seed.iso using genisoimage fallback
create_seed_iso_with_genisoimage() {
  echo "Docker not available or failed. Creating seed ISO using genisoimage..."
  nix-shell -p cdrtools --run "genisoimage -output '$SEED_ISO' -volid cidata -joliet -rock '$USER_DATA' '$META_DATA'"
}

echo "Creating seed ISO for cloud-init..."

if command -v docker >/dev/null 2>&1; then
  if create_seed_iso_with_docker; then
    echo "Seed ISO created with Docker."
  else
    echo "Docker failed to create seed ISO. Falling back to genisoimage."
    create_seed_iso_with_genisoimage
  fi
else
  echo "Docker not found. Using genisoimage to create seed ISO."
  create_seed_iso_with_genisoimage
fi

echo "Launching QEMU..."

qemu-system-x86_64 \
  -drive file="$IMG_PATH",format=raw \
  -drive file="$SEED_ISO",format=raw,if=virtio \
  -m 4G \
  -enable-kvm \
  -cpu host \
  -smp 4 \
  -device virtio-net,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
  -vga qxl \
  -display gtk

echo "VM exited."

