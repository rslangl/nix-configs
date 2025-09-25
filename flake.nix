{
  description = "Flake config for based heretics";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hyprland = {
    #   url = "github:hyprwm/Hyprland";
    # #  url =  "github:nixos/nixpkgs/nixos-unstable";
    #  inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };
    hyprland-plugins = {
      #type = "git";
      #url = "https://code.hyprland.org/hyprwm/hyprland-plugins.git";
      url = "github:hyprwm/hyprland-plugins";
      ##rev = "b8d6d369618078b2dbb043480ca65fe3521f273b";
      inputs.hyprland.follows = "nixpkgs";
    };
    hyprlock = {
      type = "git";
      url = "https://code.hyprland.org/hyprwm/hyprlock.git";
      #rev = "04cfdc4e5bb0e53036e70cc20922ab346ce165cd";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #nixos-generators.url = "github:nix-community/nixos-generators";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
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
        username = "user";
        email = "mailman@kek.net";
        dotfilesDir = "/home/user/.local/state/dotfiles";
        wm = "hyprland";
        browser = "firefox";
        term = "wezterm";
        font = "Intel One Mono";
        fontPkg = pkgs.intel-one-mono;
        editor = "neovim";
      };

      system = systemSettings.system;

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      #   overlays = [
      #     hyprland.overlays.default
      #   ];
      };

      lib = inputs.nixpkgs.lib;
    in
  {
    nixosConfigurations = {
      system = lib.nixosSystem {
        system = systemSettings.system;
        modules = [
          (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit userSettings systemSettings inputs;
              };
              users.${userSettings.username} = import (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix");
            };
          }
            #./test/test-overlay.nix
        ];
        specialArgs = {
          inherit userSettings systemSettings inputs;
        };
      };

    };
  };
}

