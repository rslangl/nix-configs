{ config, pkgs, lib, userSettings, ... }:

{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
	      packages = [(pkgs.OVMF.override {
          secureBoot = true;
      	  tpmSupport = true;
      	}).fd];
      };
    };
  };

  users.users.${userSettings.username}.extraGroups = lib.mkAfter [ "kvm" "libvirtd" ];

#   environment.systemPackages = with pkgs; [
#     libvirt
#     virt-manager
#     qemu
#     qemu_kvm
#   ];
}
