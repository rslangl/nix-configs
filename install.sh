#!/usr/bin/env bash

set -euo pipefail

# Output message colors
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"

# Default variables
NIX_CONFIGS_REPO_URL="https://github.com/rslangl/nix-configs"
SYSTEM_CONF_DIR=/etc/nixos
USERNAME="${USERNAME:-$(whoami)}"
HOME_MANAGER_CONF_DIR="${HOME_NIX_DIR:-$HOME/.config/home-manager}"
NIX_CONF_FILE="${HOME}/.config/nix/nix.conf"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.local/state/dotfiles}"
NVIM_DIR="${HOME}/.config/nvim"
NVIM_REPO_URL="https://github.com/rslangl/nvim"
HARDWARE_CONFIG_FILE="${DOTFILES_DIR}/system/hardware-configuration.nix"

confirm() {
  read -rp "$1 [y/N] " answer
  [[ "$answer" == [Yy]* ]]
}

ensure_dir_exists() {
  mkdir -p "$(dirname "$1")"
}

if [[ -d "$DOTFILES_DIR" ]]; then
  echo "INFO: Dotfiles directory already exists at $DOTFILES_DIR"

  existing_remote=$(git -C "$DOTFILES_DIR" config --get remote.origin.url || echo "")

  if [[ "$existing_remote" != "$DOTFILES_REPO" ]]; then
    echo "WARN: Existing dotfiles repo remote does not match expected:"
    echo "  Found: $existing_remote"
    echo "  Expected: $DOTFILES_REPO"

    if confirm "Do you want to delete and re-clone the dotfiles?"; then
      rm -rf "$DOTFILES_DIR"
      git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    else
      echo "ERROR: Aborting install due to mismatched dotfiles repo"
      exit 1
    fi
  else
    echo "INFO: Dotfiles repo matches. Pulling latest..."
    git -C "$DOTFILES_DIR" pull --rebase
  fi
fi

# Ensure nix.conf has flakes and nix-command features enabled
ensure_dir_exists "$NIX_CONF_FILE"
expected_line="experimental-features = nix-command flakes"

if [[ -f "$NIX_CONF_FILE" ]]; then
  if grep -q "$expected_line" "$NIX_CONF_FILE"; then
    echo "INFO: nix.conf already enables flakes"
  else
    echo "WARN: nix.conf exists but flakes/nix-command are not enabled"

    if confirm "Do you want to append flake support to nix.conf?"; then
      echo "$expected_line" >> "$NIX_CONF_FILE"
      echo "INFO: Appended flake support to nix.conf"
    else
      echo "WARN: Skipping nix.conf update — flakes may not work"
    fi
  fi
else
  echo "INFO: Creating nix.conf with flake support..."
  echo "$expected_line" > "$NIX_CONF_FILE"
fi

# Clone neovim config
if [[ -d "$NEOVIM_DIR" ]]; then
  echo "INFO: Neovim config already exists at $NEOVIM_DIR"

  if confirm "Do you want to replace your existing Neovim config?"; then
    rm -rf "$NEOVIM_DIR"
    git clone "$NEOVIM_REPO" "$NEOVIM_DIR"
    echo "INFO: Cloned Neovim config to $NEOVIM_DIR"
  else
    echo "WARN: Skipping Neovim setup"
  fi
else
  echo "INFO: Cloning Neovim config into $NEOVIM_DIR..."
  git clone "$NEOVIM_REPO" "$NEOVIM_DIR"
fi

cd "${DOTFILES_DIR}"
echo "INFO: Building Nix configuration..."
sudo nixos-rebuild switch --flake .#system
