{ pkgs, lib, systemSettings, userSettings, self, ... }:
let
  wmConfig = "${self}/system/wm/" + userSettings.wm + ".nix";
in
{

  imports = [
    ../../system/hardware-configuration.nix
    ../../system/hardware/systemd.nix
    ../../system/hardware/kernel.nix
    ../../system/security/firewall.nix
    ../../system/security/automount.nix
    #../../system/security/sshd.nix
    (./. + "../../../system/wm" + ("/" + userSettings.wm) + ".nix")
    ../../system/app/libvirt.nix
    ../../system/app/docker.nix
  #   "${self}/system/hardware-configuration.nix"
  #   "${self}/system/hardware/systemd.nix"
  #   "${self}/system/hardware/kernel.nix"
  #   "${wmConfig}"
  #   "${self}/system/app/libvirt.nix"
  #   "${self}/system/app/docker.nix"
  ];

  nix.settings.trusted-users = [ "@wheel" ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.efi.efiSysMountPoint = systemSettings.bootMountPath;
    loader.grub.enable = false;
    extraModprobeConfig = "options kvm_intel nested=1";
  };

  networking = {
    hostName = systemSettings.hostname;
    networkmanager.enable = true;
  };

  time.timeZone = systemSettings.timezone;
  i18n.defaultLocale = systemSettings.locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = systemSettings.locale;
    LC_IDENTIFICATION = systemSettings.locale;
    LC_MEASUREMENT = systemSettings.locale;
    LC_MONETARY = systemSettings.locale;
    LC_NAME = systemSettings.locale;
    LC_NUMERIC = systemSettings.locale;
    LC_PAPER = systemSettings.locale;
    LC_TELEPHONE = systemSettings.locale;
    LC_TIME = systemSettings.locale;
  };

  console.keyMap = "no";

  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = "user";
    extraGroups = lib.mkDefault [ "wheel" "networkmanager" "video" "audio" "dialout" ];
    uid = 1000;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    zsh
    cryptsetup
    home-manager
    wpa_supplicant
    dconf
  ];

  environment.shells = with pkgs; [ zsh ];
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  fonts.fontDir.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  system.stateVersion = "25.05";
}
