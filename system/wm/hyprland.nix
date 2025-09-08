{ inputs, pkgs, lib, ... }:
  let
    pkgs-hyprland = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in
{
  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland = {
        enable = true;
      };
      portalPackages = pkgs-hyprland.xdg-desktop-portal-hyprland;
    };
  };

  services.xserver.excludePackages = [ pkgs.xterm ];

  services.xserver = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      enableHidpi = true;
      theme = "chili";
      package = pkgs.sddm;
    };
  };
}
