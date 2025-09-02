{ config, ... }:

{
  programs.git = {
    enable = true;
    username = "rslangl";
    userEmail = "fjellape1447@protonmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
