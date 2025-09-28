# nix-configs

## Usage

### Install

Two environment variables are expected during install (if defaults are not desired):

* `USERNAME`: User account, to be used to resolve the correct `HOME` path
* `DOTFILES_DIR`: Path to which this source code will be cloned

Install using the script:

```shell
USERNAME="user" DOTFILES_DIR="$HOME/.local/state/dotfiles" \
  curl -sSf https://raw.githubusercontent.com/rslangl/nix-configs/master/install.sh | bash
```

### Update

Update the flake:

```shell
nix flake update
```

### Build and switch

Specify flake to use when rebuilding (name of host specified after the `#`-character, or simply use `$(hostname)`):

```shell
sudo nixos-rebuild switch --flake /etc/nixos/#system
```

To test the configuration before switching:

```shell
sudo nixos-rebuild build --flake /etc/nixos/#system
./result/bin/switch-to-configuration test
```

### Cleanup

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

### Terminal

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

### Hyprland

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
* TODO: audio, volume increase/decrease/mute

## References

* [NixOS configuration reference](https://nixos.org/manual/nixos/stable/#ch-configuration)
* [NixOS packages](https://search.nixos.org/packages)
* [NixOS wiki](https://wiki.nixos.org/wiki/Main_Page)
