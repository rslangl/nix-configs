{
  description = "Test NixOS VM image";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  inputs.nixos-generators.url = "github:nix-community/nixos-generators";

  outputs = { self, nixpkgs, nixos-generators, ... }:
    let
      system = "x86_64-linux";
    in {
      packages.${system}.vmImage = nixos-generators.nixosGenerate {
        inherit system;
        format = "qcow2";
        modules = [ ./test/configuration.nix ];
      };
    };
}

