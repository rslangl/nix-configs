{ pkgs, ... }:

{
  imports = [ ];

  system.stateVersion = "25.05";
  networking.hostName = "desktop";

  users.user.user = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

}
