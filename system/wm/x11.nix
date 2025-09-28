{pkgs, ...}: {
  imports = [
    ./pipewire.nix
    ./dbus.nix
    ./fonts.nix
  ];

  services.xserver = {
    enable = true;
    layout = "no";
    xkbVariant = "";
    xkbOptions = "caps:escape";
    excludePackages = [pkgs.xterm];
    displayManager = {
      lightdm.enable = true;
      sessionCommands = ''
        xset -dpms
        xset s blank
        xset r rate 350 50
        xset s 300
        ${pkgs.lightlocker}/bin/light-locker --idle-hint &
      '';
    };
    libinput = {
      touchpad.disableWhileTyping = true;
    };
  };
}
