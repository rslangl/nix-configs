{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    layout = "no";
  };
}
