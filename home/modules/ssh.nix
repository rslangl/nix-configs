{ config, ... }:

{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
        User git
        IndentityFile ~/.ssh/github
    '';
  };

  home.file.".ssh/github".source = "../../secrets/github";
  home.file.".ssh/github.oub".source = "../../secrets/github.pub"
}
