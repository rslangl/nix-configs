{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    libvirt
    virt-manager
    qemu
    qemu_kvm
    # uefi-run
    # swtpm
    # bottles

    # Filesystems
    # dosfstools
  ];
}
