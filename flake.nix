{
  description = "Flake config for based heretics";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland/v0.44.1?submodules=true";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      type = "git";
      url = "https://code.hyprland.org/hyprwm/hyprland-plugins.git";
      rev = "4d7f0b5d8b952f31f7d2e29af22ab0a55ca5c219";
      inputs.hyprland.follows = "hyprland";
    };
    hyprlock = {
      type = "git";
      url = "https://code.hyprland.org/hyprwm/hyprlock.git";
      rev = "73b0fc26c0e2f6f82f9d9f5b02e660a958902763";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
        browser = "firefox";
        term = "wezterm";
        font = "Intel One Mono";
        fontPkg = pkgs.intel-one-mono;
        editor = "neovim";
      };

      profileDir = ./profiles/${systemSettings.profile};

      system = systemSettings.system;

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      lib = inputs.nixpkgs.lib;
    in
  {
    nixosConfigurations = {
      system = lib.nixosSystem {
        system = systemSettings.system;
        modules = [
          "${profileDir}/configuration.nix"
          inputs.home-manager.nixosModules.home-manager 
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${userSettings.username} = import "${profileDir}/home.nix";
          }
        ];
        specialArgs = {
          inherit userSettings systemSettings inputs;
        };
      };
    };
  };
}

