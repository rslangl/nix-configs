{ ... }:

{
  imports = [
    ./pipewire.nix
    ./dbus.nix
    ./fonts.nix
  ];

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
      options = "caps:escape";
    };
  };
}
