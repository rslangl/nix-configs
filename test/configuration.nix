# ./vm-test/configuration.nix
{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  system.stateVersion = "25.05";

  users.users.vmuser = {
    isNormalUser = true;
    password = "vmuser"; 
    extraGroups = [ "wheel" ];
  };

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    firefox
    kate
    xterm
    git
  ];

  networking.networkmanager.enable = true;

  services.qemuGuest.enable = true;
}

