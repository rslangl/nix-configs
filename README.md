# nix-configs

## Usage 

**Rebuild**

Specify flake to use when rebuilding (name of host specified after the `#`-character, or simply use `$(hostname)`):
```shell
sudo nixos-rebuild switch --flake /etc/nixos/#neuromancer
```

To test the configuration before switching:
```shell
sudo nixos-rebuild build --flake /etc/nixos/#neuromancer
./result/bin/switch-to-configuration test
```

**Home-Manager**

Currently not rebuilding home-manager with every `nixos-rebuilt`:
```shell
home-manager switch
```

**Cleanup

View generations:
```shell
nix profile list
nix-env --list-generations
```

Clean old builds:
```shell
sudo nix-collect-garbage -d
```

## Keybinds

**Terminal**
* `CTRL+SHIFT+O`: Split horizontal
* `CTRL+SHIFT+E`: Split vertical
* `CTRL+SHIFT+T`: New tab
* `CTRL+TAB`: Cycle tabs
* `CTRL+SHIFT+TAB`: Reverse cycle tabs
* `CTRL+SHIFT+W`: Close current tab
* `ALT+h`: Focus left pane
* `ALT+j`: Focus pane below
* `ALT+k`: Focus pane above
* `ALT+l`: Focus right pane

**Hyprland**
* `SUPER+d`: Launch rofi
* `SUPER+q`: Kill window
* `SUPER+TAB`: Cycle window
* `SUPER+SHIFT+TAB`: Reverse cycle windows
* `SUPER+LeftArrow`: Swap with window to the left
* `SUPER+RightArrow`: Swap with window to the right
* `SUPER+UpArrow`: Swap with window above
* `SUPER+DownArrow`: Swap with window below
* `SUPER+SHIFT+S`: Launch grimblast to copy area
* `SUPER+ALT+S`: Launch grimblast to copy active
* `SUPER+CTRL+S`: Launch grimblast to copy screen
* `SUPER+1`: Switch to workspace 1 (up to 5)
* `SUPER+SHIFT+1`: Move active window to workspace 1 (up to 5)
* `ALT+SHIFT+h`: Resize terminal pane left
* `ALT+SHIFT+j`: Resize terminal pane down
* `ALT+SHIFT+k`: Resize terminal pane up
* `ALT+SHIFT+l`: Resize terminal pane right
* `SUPER+SHIFT+h`: Resize window left
* `SUPER+SHIFT+j`: Resize window down
* `SUPER+SHIFT+k`: Resize window up
* `SUPER+SHIFT+l`: Resize window right
* <u>TODO</u>: audio, volume increase/decrease/mute

## TODO

Patching similar to LibrePhoneix' approach, but I want initialization/bootstrapping logic based on user input that does not require manually editing the flake

Secrets management with `sops`, and stateless or ephemeral root FS with `impermanence`, preserving only whitelisted state (like `/nix`, logs, config, home, etc.), specified under `environment.persistence`.

Sops-nix:
* Declarative and fully integrated with NixOS and flakes
* Uses encrypted files (Age or GPG) directly in your config repo
* Secrets are decrypted at activation time, not stored in plain text or the Nix store
* Bonus: works with both system and Home Manager modules
* Great for multi-host, multi-person setups 

agenix:
* Uses SSH or Age encryption for secrets; similar declarative approach
* Includes a NixOS module for seamless integration

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager";
    sops-nix.url = "github:mic92/sops-nix";
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, impermanence, ... }:
    let system = "x86_64-linux"; uname = "your-username";
    in {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          system = system;
          modules = [
            ./hosts/desktop.nix
            sops-nix.nixosModules.sops
            impermanence + "/nixos.nix"
            home-manager.nixosModules.home-manager
            { home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${uname} = {
                imports = [ ./home/base.nix ./home/desktop.nix ];
                extraSpecialArgs = { inherit uname; };
              };
            }
          ];
        };
      };
    };
}
# hosts/desktop.nix
{
  imports = [
    ./hardware/desktop.nix
    ./hardware/*
  ];

  environment.persistence."/nix/persist" = {
    directories = [ "/etc/nixos" "/var/log" "/var/lib" ];
    files = [ "/etc/machine-id" ];
  };

  # Other system settings...

  system.stateVersion = "24.05";
}
```
