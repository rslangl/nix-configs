{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      #inputs.home-manager.nixosModules.home-manager
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Enable nested virtualisation
  boot.extraModprobeConfig = "options kvm_intel nested=1";

  networking.hostName = "mechromancer";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Oslo";

  i18n.defaultLocale = "en_US.UTF-8";

  hardware = {
    graphics.enable = true;
    nvidia.modesetting.enable = true;
  };

  services.xserver.enable = false;

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

  console.keyMap = "no";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.pulseaudio.enable = false;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  nixpkgs.config.allowUnfree = true;

  users.defaultUserShell = pkgs.zsh;

  users.users.user = {
    isNormalUser = true;
    description = "user";
    useDefaultShell = true;
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "libvirtd" ];
  #   packages = with pkgs; [
  #     home-manager
  #   ];
  };

  # TODO: remove to check if the home-manager import up top actually manages this at all
  #home-manager = {
  # extraSpecialArgs = {inherit inputs;};
  # users = {
  #   "user" = import ./home.nix;
  # };
  #};

  #services.getty.autologinUser = "user";

  programs.zsh = {
   enable = true;
  };

  programs.firefox.enable = true;

  #programs.hyprland = {
    #enable = true;
    #nvidiaPatches = true;
    #xwayland.enable = true;
  #};

  environment.sessionVariables = {
    # if cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

# List packages installed in system profile. To search, run:
# $ nix search wget
  environment.systemPackages = with pkgs; [
    # Utilities
    curl
    git
    wget
    fd
    wl-clipboard

    # Virtualization
    docker

    # Desktop
    hyprland
    hyprlock
    kitty
    wezterm 
    waybar
    libnotify
    nwg-dock-hyprland
    rofi-wayland
    dunst
    zsh
    pyprland

    # System utilities
    gvfs
    dconf

    # Applications
    firefox
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.dejavu-sans-mono
    nerd-fonts.jetbrains-mono
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  #system.stateVersion = "24.11";
}
