{ lib, ... }:

{
  #config = {
    fileSystems."/" = lib.mkForce {
      device = "/dev/disk/by-label/nixos";
      autoResize = true;
      fsType = "ext4";
      options = [ "rw" "relatime" ];
    };

    fileSystems."/boot" = lib.mkForce {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    };

    fileSystems."/home" = lib.mkForce {
      device = "/dev/disk/by-label/home";
      fsType = "ext4";
    };

    fileSystems."/var" = lib.mkForce {
      device = "/dev/disk/by-label/var";
      fsType = "ext4";
    };

    boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

    boot.initrd.availableKernelModules = lib.mkForce [
      "xhci_pci"
      "ahci"
      "virtio_pci"
      "virtio_blk"
      "virtio_scsi"
      "sd_mod"
      "sr_mod"
      "ext4"
    ];
  #};
}

