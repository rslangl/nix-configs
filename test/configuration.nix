# ./vm-test/configuration.nix
{ config, pkgs, ... }:

{
  imports = [
    #./hardware-configuration.nix
    ../profiles/personal/configuration.nix
  ];

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.grub.enable = lib.mkForce false;
  boot.extraModprobeConfig = lib.mkForce "";  # NOTE: may use either mkOverride or mkForce to override from real configuration.nix
  boot.loader.generic-extlinux-compatible.enable = lib.mkForce false;
  boot.isContainer = true;

  # users.users.vmuser = {
  #   isNormalUser = true;
  #   password = "vmuser"; 
  #   extraGroups = [ "wheel" ];
  # };
  #
  # services.xserver.enable = true;
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # environment.systemPackages = with pkgs; [
  #   firefox
  #   kate
  #   xterm
  #   git
  # ];

  networking.networkmanager.enable = true;

  services.qemuGuest.enable = true;
}

