{ config, pkgs, lib, systemSettings, userSettings, ... }:

{
  imports = [
    #../../system/hardware-configuration.nix
    #../../system/hardware/systemd.nix # systemd config
    #../../system/hardware/kernel.nix # Kernel config
    #../../system/hardware/power.nix # Power management
    #../../system/hardware/time.nix # Network time sync
    #../../system/app/libvirt.nix
    #../../system/app/docker.nix
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
    defaultUserShell = pkgs.zsh;
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

  fonts.fontDir.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  system.stateVersion = "25.05";

  home-manager.users.${userSettings.username} = import ./home.nix;
}
