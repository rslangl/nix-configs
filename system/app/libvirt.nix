{
  config,
  pkgs,
  lib,
  userSettings,
  ...
}: {
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  users.users.${userSettings.username}.extraGroups = lib.mkAfter ["kvm" "libvirtd"];
}
