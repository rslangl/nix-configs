{
  inputs,
  config,
  pkgs,
  userSettings,
  ...
}: {
  programs.home-manager.enable = true;

  imports = [
    (./. + "../../../user/wm" + ("/" + userSettings.wm) + ".nix")
    ../../user/shell/sh.nix
    ../../user/shell/cli-apps.nix
    ../../user/app/development/neovim.nix
    ../../user/app/git/git.nix
    ../../user/app/pwmgr/keepass.nix
    ../../user/app/browser/firefox.nix
  ];

  home = {
    stateVersion = "25.05";
    inherit (userSettings) username;
    homeDirectory = "/home/" + userSettings.username;
    packages = with pkgs; [
      # Core
      zsh
      git
      btop
      tree
      ripgrep
      unzip
      fzf
      pkg-config
      openssl

      # Office
      zathura # PDF viewer
      xournalpp # handwriting notetaking app
      libreoffice

      # Media
      mpv # video playback
      sxiv # image viewer
      telegram-desktop
      signal-desktop
      vesktop # custom Discord desktop app
      grimblast # screen capture
      yt-dlp

      # Utils
      keychain # SSH key manager
      zoxide # smarter `cd` app
      file
    ];
    sessionVariables = {
      EDITOR = userSettings.editor;
      TERM = userSettings.term;
      BROWSER = userSettings.browser;
    };
  };

  xdg = {
    enable = true;
    mimeApps.defaultApplications = {
      "text/plain" = ["nvim.desktop"];
      "application/pdf" = ["zathura.desktop"];
      "image/*" = ["sxiv.desktop"];
      "video/*" = ["mpv.desktop"];
    };
    userDirs = {
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
  };
}
