
{ config, pkgs, ... }:

{
  networking.hostName = "desktop";

  users.users.your-username = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    vim git
  ];

  system.stateVersion = "25.05";
}
