{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    zsh
    oh-my-zsh
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    autocd = true;
    shellAliases = {
      ls = "ls --color=auto";
      la = "ls -la";
      ll = "ls -l";
      wget = "wget --no-cookie -v --hsts-file=${xdg.config.cacheHome}/wget-hsts";
      sbt = "sbt -ivy ${xdg.config.dataHome}/ivy2 -sbt-dir ${xdg.config.dataHome}/sbt";
      mvn = "mvn -gs ${xdg.config.configHome}/maven/settings.xml";
      nvidia-settings = "nvidia-settings --config=${xdg.config.configHome}/nvidia/settings";
    };
    dirHashes = {
      dev = "$HOME/dev";
      dev_co = "$HOME/dev/co";
      dev_re = "$HOME/dev/re";
      dev_sw = "$HOME/dev/sw";
      mails = "$HOME/mail";
      vm = "$HOME/vm";
      docs = "$HOME/docs";
      docs_art = "$HOME/docs/art";
      docs_tech = "$HOME/docs/tech";
      docs_sci = "$HOME/docs/sci";
      docs_lang = "$HOME/docs/lang";
      share = "$HOME/share";
      share_cast = "$HOME/share/cast"; # podcasts
      share_seed = "$HOME/share/seed"; # torrents
      share_lect = "$HOME/share/lect"; # lectures
    };
    dotDir = "${config.xdg.configHome}/zsh";
    # extra commands to be added to .zshenv
    envExtra = "export RUSTUP_HOME=${config.xdg.dataHome}/rustup\n
       export CARGO_HOME=${config.xdg.dataHome}/cargo";
    # extra commands to be added to .zprofile
    #profileExtra = "[[ \"$(tty)\" == \"/dev/tty1\" ]] && exec Hyprland";
    # extra commands to be added to .zshrc
    initContent = "eval \"$(zoxide init zsh)\" > /dev/null 2>&1\n
       eval \"$(keychain --absolute --dir $XDG_RUNTIME_DIR/keychain --eval ssh $HOME/.ssh/github --quiet)\"";
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "fzf"
      ];
      theme = "bira";
    };
  };
}
