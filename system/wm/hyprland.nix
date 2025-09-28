{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./wayland.nix
    ./pipewire.nix
    ./dbus.nix
  ];

  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      package = inputs.nixpkgs.legacyPackages.${pkgs.system}.hyprland;
      portalPackage = inputs.nixpkgs.legacyPackages.${pkgs.system}.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
    };
  };

  #services.xserver.excludePackages = [ pkgs.xterm ];

  #    services.xserver = {
  #     displayManager.sddm = {
  #       enable = true;
  #       wayland.enable = true;
  #       enableHidpi = true;
  #       theme = "chili";
  #       package = pkgs.sddm;
  #     };
  #   };
}
