{
  pkgs,
  lib,
  systemSettings,
  userSettings,
  self,
  ...
}: {
  imports = [
    ../../system/hardware-configuration.nix
    ../../system/hardware/systemd.nix
    ../../system/hardware/kernel.nix
    ../../system/security/sudo.nix
    ../../system/security/firewall.nix
    ../../system/security/automount.nix
    #../../system/security/sshd.nix
    (./. + "../../../system/wm" + ("/" + userSettings.wm) + ".nix")
    ../../system/app/libvirt.nix
    ../../system/app/docker.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.trusted-users = ["@wheel"];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = systemSettings.bootMountPath;
      grub.enable = false;
    };
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
    extraGroups = ["wheel" "networkmanager" "video" "audio" "dialout" "input" "adbusers"];
    uid = 1000;
  };

  environment = {
    variables = rec {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";

      XDG_BIN_HOME = "$HOME/.local/bin";
      PATH = [
        "${XDG_BIN_HOME}"
      ];
    };

    systemPackages = with pkgs; [
      vim
      wget
      curl
      git
      zsh
      cryptsetup
      home-manager
      wpa_supplicant
      dconf
      tuigreet
    ];

    shells = with pkgs; [zsh];
  };

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

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "tuigreet --cmd Hyprland";
        user = "user";
      };
    };
  };

  system.stateVersion = "25.05";
}
