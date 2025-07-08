{
  description = "Flake config for based heretics";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
    let
      system = "x86_64-linux";
    in
  {
    
    # The 'default' config is intended for workstations with DE's
    nixosConfigurations.mechromancer = nixpkgs.lib.nixosSystem {
      #extraSpecialArgs = {inherit inputs system;};
      specialArgs = {inherit inputs system;};
      modules = [
        ./configuration.nix
          # ensures home-manager is enabled for all users on the system
          home-manager.nixosModules.home-manager {
              # use global packages configured via system-level nixpkgs rather
              # than a private pkgs instance
              home-manager.useGlobalPkgs = true;
              # install packages to /etc/profiles/ rather than $HOME/.nix-profile
              home-manager.useUserPackages = true;
              #home-manager.users.user = import $HOME/.config/home-manager/home.nix;
            }
      ];
    };

  };
}

