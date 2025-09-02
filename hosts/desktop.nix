{ config, pkgs, ... }:

{
  imports = [
    ./hardware/desktop.nix
  ];

  networking.hostName = "desktop";

  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    vim git
  ];

  system.stateVersion = "25.05";
}

