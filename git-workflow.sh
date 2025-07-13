#!/bin/sh

GLOBAL_NIX_DIR=/etc/nixos
USER_NIX_DIR=$HOME/.config/home-manager
SCRIPT_DIR=$HOME/dev/sw/nix-configs

diff $GLOBAL_NIX_DIR/flake.nix flake.nix >flake.diff
diff $GLOBAL_NIX_DIR/configuration.nix configuration.nix >config.diff

# TODO: patch command
