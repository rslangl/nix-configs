{ config, pkgs, userSettings, ... }:

{
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;

  programs.home-manager.enable = true;

  imports = [
    # TODO: 
  ];

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    # Core
    zsh
    git
    firefox
    btop
    tree
    ripgrep
    unzip
    fzf

    # Office
    zathura           # PDF viewer
    xournalpp         # handwriting notetaking app
    libreoffice

    # Media
    mpv               # video playback
    sxiv              # image viewer
    telegram-desktop
    signal-desktop
    vesktop           # custom Discord desktop app
    grimblast         # screen capture
    yt-dlp

    # Utils
    keychain          # SSH key manager
    zoxide            # smarter `cd` app
  ];

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

  home.sessionVariables = {
    EDITOR = userSettings.editor;
    TERM = userSettings.term;
    BROWSER = userSettings.browser;
  };
}
