{
  description = "Flake config for based heretics";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    systemSettings = {
      system = "x86_64-linux";
      hostname = "mechromancer";
      profile = "personal";
      timezone = "Europe/Oslo";
      locale = "en_US.UTF-8";
      bootMode = "uefi";
      bootMountPath = "/boot";
    };

    userSettings = {
      username = "rslangl";
      email = "fjellape1447@protonmail.com";
      dotfilesDir = "/home/user/.local/state/dotfiles";
      wm = "hyprland";
      browser = "firefox";
      term = "wezterm";
      font = "Intel One Mono";
      fontPkg = pkgs.intel-one-mono;
      editor = "neovim";
    };

    inherit (systemSettings) system;

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    inherit (inputs.nixpkgs) lib;
  in {
    nixosConfigurations = {
      system = lib.nixosSystem {
        inherit (systemSettings) system;
        modules = [
          (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit pkgs userSettings systemSettings inputs;
              };
              users.${userSettings.username} = import (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix");
            };
          }
        ];
        specialArgs = {
          inherit userSettings systemSettings inputs;
        };
      };
    };
  };
}
