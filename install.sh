#!/bin/sh

GLOBAL_NIX_DIR=/etc/nixos
USER_NIX_DIR=$HOME/.config/home-manager
SCRIPT_DIR=$HOME/dev/sw/nix-configs

# Fetch latest version of nix configs
nix-shell -p git --command \
  "git clone https://github.com/rslangl/nix-configs $SCRIPT_DIR"

# Change permissions for particular files
sudo chown 0:0 $SCRIPT_DIR/configuration.nix
sudo chown 0:0 $SCRIPT_DIR/flake.nix

# Move system-specific files to /etc/nixos/
sudo mv $SCRIPT_DIR/flake.nix $GLOBAL_NIX_DIR/
sudo mv $SCRIPT_DIR/configuration.nix $GLOBAL_NIX_DIR/

# Move user-specific files to $HOME/.config/home-manager/expr
mv $SCRIPT_DIR/home.nix $USER_NIX_DIR/

# Rebuild system
sudo nixos-rebuild switch --flake $GLOBAL_NIX_DIR#mechromancer
