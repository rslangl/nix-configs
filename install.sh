#!/usr/bin/env bash

set -euo pipefail

# Output message colors
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"

# Default variables
NIX_CONFIGS_REPO_URL=https://github.com/rslangl/nix-configs
SYSTEM_NIX_DIR=/etc/nixos
USERNAME="${USERNAME:-$(whoami)}"
HOME_NIX_DIR="${HOME_NIX_DIR:-$HOME/.config/home-manager}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.local/state/dotfiles}"
HARDWARE_CONFIG_FILE="${DOTFILES_DIR}/system/hardware-configuration.nix"

# Clone repo
echo "${INFO} Cloning nix dotfiles to $DOTFILES_DIR..."
if [ -d "$DOTFILES_DIR" ]; then
  read -rp "${NOTE} Nix dotfiles already present, overwrite? [N/y]" dotfilesdirOverwrite
    case "$dotfilesdirOverwrite" in
      [yY][eE][sS]|[Y])
        echo "${INFO} Removing existing directory"
        rm -rf "${DOTFILES_DIR}"
        git clone "$NIX_CONFIGS_REPO_URL" "$DOTFILES_DIR"
        ;;
      *)
        echo "${INFO} Aborting"
        exit 1
        ;;
  esac
else
  git clone "$NIX_CONFIGS_REPO_URL" "$DOTFILES_DIR"
fi

# Ensure hardware config is present
echo "${INFO} Checking for presence of hardware configuration..."
if [ -f "$HARDWARE_CONFIG_FILE" ]; then
  read -rp "${INFO} Config found, overwrite? [N/y]" hardwareconfOverwrite
  case "$hardwareconfOverwrite" in
    [yY][eE][sS]|[Y])
      echo "${INFO} Force generating hardware configuratiuon"
      nixos-generate-config --show-hardware-config > "$HARDWARE_CONFIG_FILE"
      ;;
    *)
      echo "${INFO} Aborting"
      exit 1
      ;;
  esac
else
  echo "Not found, generating..."
  nixos-generate-config --show-hardware-config > "$HARDWARE_CONFIG_FILE"
  if [ -f "$HARDWARE_CONFIG_FILE" ]; then
    echo "${OK} Hardware configuration generated successfully"
  fi
fi

# Symlink nix configs dir to /etc/nixos
if [ -L "$SYSTEM_NIX_DIR/profiles" || -L "$SYSTEM_NIX_DIR/system" || -L "$SYSTEM_NIX_DIR/user" ]; then
  read -rp "${INFO} /etc/nixos is already a symlink, ovewrite? [N/y]" systemdirOverwrite
  case "$systemdirOverwrite" in
    [yY][eE][sS]|[Y])
      rm -rf "${SYSTEM_NIX_DIR:?}/*"
      ;;
    *)
      echo "${INFO} Aborting"
      exit 1
      ;;
  esac
else
  ln -s "${DOTFILES_DIR}/profiles" "${SYSTEM_NIX_DIR}/profiles"
  ln -s "${DOTFILES_DIR}/system" "${SYSTEM_NIX_DIR}/system"
  ln -s "${DOTFILES_DIR}/user" "${SYSTEM_NIX_DIR}/user"
fi

