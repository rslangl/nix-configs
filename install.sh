#!/usr/bin/env bash

set -euo pipefail

NIX_CONFIGS_REPO_URL=https://github.com/rslangl/nix-configs
SYSTEM_NIX_DIR=/etc/nixos
USERNAME="${USERNAME:-$(whoami)}"
HOME_NIX_DIR="${HOME_NIX_DIR:-$HOME/.config/home-manager}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.local/state/dotfiles}"

# Clone repo
echo "Cloning nix dotfiles to $DOTFILES_DIR..."
if [ -d "$DOTFILES_DIR" ]; then
  echo "Nix dotfiles already present, skipping"
else
  git clone "$NIX_CONFIGS_REPO_URL" "$DOTFILES_DIR"
fi
echo "Done!\n\n"

# Symlink configs
echo "Setting up nix configs..."
if [ -d "$SYSTEM_NIX_DIR" ] && [ ! -L "$SYSTEM_NIX_DIR" ]; then
  echo "Backing up existing /etc/nixos to /etc/nixos.backup"
  sudo mv "$SYSTEM_NIX_DIR" /etc/nixos.backup
fi
echo "Done!\n\n"

# Symlink nix configs dir to /etc/nixos
if [ -L "$SYSTEM_NIX_DIR" ]; then
  echo "/etc/nixos is already a symlink, skipping"
else
  echo "Symlinking $SYSTEM_NIX_DIR to /etc/nixos"
  sudo ln -s "$DOTFILES_DIR" "$SYSTEM_NIX_DIR"
fi
echo "Done!\n\n"

echo "Done! Nix configs installed"
echo "Update:\t`nix flake update`"
echo "Rebuild:\t`sudo nixos-rebuild build --flake /etc/nixos#desktop`"
echo "Test build:\t`./result/bin/switch-to-configuration test`"
echo "Switch build:\t`sudo nixos-rebuild switch --flake /etc/nixos#desktop`"
echo "Cleanup:\t`sudo nix-collect-garbage -d`"

