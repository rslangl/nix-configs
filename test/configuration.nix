# ./vm-test/configuration.nix
{ config, pkgs, lib, ... }:

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

  fileSystems."/" = {
    device = lib.mkForce "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  home-manager.users.user.fonts.fontconfig.enable = lib.mkForce false;

  #home-manager.users.user.xdg.configFile."fontconfig/conf.d/10-hm-fonts.conf".text = lib.mkForce "<!-- dummy config -->";

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

