#!/bin/sh

NIX_CONFIGS_REPO_URL=https://github.com/rslangl/nix-configs
SYSTEM_NIX_DIR=/etc/nixos
HOME_NIX_DIR=/home/user/.config/home-manager
DOTFILES_DIR=/home/user/.local/state/dotfiles

# # Fetch latest version of nix configs
# nix-shell -p git --command \
#   "git clone https://github.com/rslangl/nix-configs $SCRIPT_DIR"
#
# # Change permissions for particular files
# sudo chown 0:0 $SCRIPT_DIR/configuration.nix
# sudo chown 0:0 $SCRIPT_DIR/flake.nix
#
# # Move system-specific files to /etc/nixos/
# sudo mv $SCRIPT_DIR/flake.nix $GLOBAL_NIX_DIR/
# sudo mv $SCRIPT_DIR/configuration.nix $GLOBAL_NIX_DIR/
#
# # Move user-specific files to $HOME/.config/home-manager/expr
# mv $SCRIPT_DIR/home.nix $USER_NIX_DIR/
#

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
