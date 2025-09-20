{ lib, ... }:

{
  fileSystems."/" = {
    device = lib.mkForce "/dev/disk/by-label/nixos";
    fsType = lib.mkForce "ext4";
    options = lib.mkForce [ "defaults" ];
  };

  boot.loader.grub.enable = lib.mkForce false;
  boot.loader.systemd-boot.enable = lib.mkForce false;
}

