{ config, pkgs, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
  };
  # home.pointerCursor = {
  #   gtk.enable = true;
  #   package = pkgs.adwaita-icon-theme;
  #   name = "Adwaita";
  #   size = 16;
  # };
  #
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  xdg.enable = true;
  xdg.mimeApps.defaultApplications = {
    "text/plain" = ["nvim.desktop"];
    "application/pdf" = ["zathura.desktop"];
    "image/*" = ["sxiv.desktop"];
    "video/*" = ["mpv.desktop"];
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}";
    documents = "${config.home.homeDirectory}/docs";
    download = "${config.home.homeDirectory}/tmp";
    music = "${config.home.homeDirectory}/self/music";
    pictures = "${config.home.homeDirectory}/self/pics";
    publicShare = "${config.home.homeDirectory}/share";
    templates = "${config.home.homeDirectory}";
    videos = "${config.home.homeDirectory}/self/vids";
  };

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    # cursorTheme = {
    #   package = pkgs.adwaita-icon-theme;
    #   name = "Adwaita";
    #   size = 16;
    # };
    # iconTheme = {
    #   package = pkgs.adwaita-icon-theme;
    #   name = "Adwaita";
    # };
    # theme = {
    #   package = pkgs.gnome-themes-extra;
    #   name = "Adwaita";
    # };

  };

  imports = [
    ./modules/term.nix
    ./modules/shell.nix
    ./modules/de.nix
    ./modules/git.nix
    ./modules/ssh.nix
    ./modules/browser.nix
  ];

  home.stateVersion = "25.05";
}
