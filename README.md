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
