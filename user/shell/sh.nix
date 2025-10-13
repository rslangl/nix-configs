{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    zsh
    oh-my-zsh
  ];

  xdg.configFile."npm/npmrc".text = ''
    prefix=$XDG_DATA_HOME/npm
    cache=$XDG_CACHE_HOME/npm
    init-module=$XDG_CONFIG_HOME/npm/config/npm-init.js
    logs-dir=$XDG_STATE_HOME/npm/logs
  '';

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    autocd = true;
    shellAliases = {
      ls = "eza --icons -l -T -a -L=1";
      # la = "ls -la";
      # ll = "ls -l";
      cat = "bat";
      htop = "btm";
      fd = "fd -Lu";
      w3m = "w3m -no-cookie -v";
      wget = "wget --no-cookie -v --hsts-file=$XDG_CACHE_HOME/wget-hsts";
      sbt = "sbt -ivy $XDG_DATA_HOME/ivy2 -sbt-dir $XDG_CONFIG_HOME/sbt";
      mvn = "mvn -gs $XDG_CONFIG_HOME/maven/settings.xml";
      nvidia-settings = "nvidia-settings --config=$XDG_CONFIG_HOME/nvidia/settings";
      keychain = "keychain --absolute --dir $XDG_RUNTIME_DIR/keychain";
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
    envExtra = "
      export RUSTUP_HOME=${config.xdg.dataHome}/rustup\n
      export CARGO_HOME=${config.xdg.dataHome}/cargo\n
      export _JAVA_OPTIONS=-Djava.util.prefs.userRoot=${config.xdg.configHome}/java\n
      export GRADLE_USER_HOME=${config.xdg.dataHome}/gradle\n
      export NPM_CONFIG_USERCONFIG=${config.xdg.configHome}/npm/npmrc\n
      export KUBECONFIG=${config.xdg.configHome}/kube\n
      export KUBECACHEDIR=${config.xdg.cacheHome}/kube\n
      export GOPATH=${config.xdg.dataHome}/go\n
      export GOMODCACHE=${config.xdg.cacheHome}/go/mod\n
      export DOCKER_CONFIG=${config.xdg.configHome}/docker\n
      export ANSIBLE_HOME=${config.xdg.configHome}/ansible\n
      export ANSIBLE_CONFIG=${config.xdg.configHome}/ansible.cfg\n
      export ANSIBLE_GALAXY_CACHE_DIR=${config.xdg.cacheHome}/ansible/galaxy_cache\n
      export VAGRANT_HOME=${config.xdg.dataHome}/vagrant\n
      export VAGRANT_ALIAS_FILE=${config.xdg.dataHome}/vagrant/aliases\n
      export GTK2_RC_FILES=${config.xdg.configHome}/gtk-2.0/gtkrc:${config.xdg.configHome}/gtk-2.0/gtkrc.mine\n
      export XCOMPOSEFILE=${config.xdg.configHome}/X11/xcompose\n
      export XCOMPOSECACHE=${config.xdg.cacheHome}/X11/xcompose
    ";
    # extra commands to be added to .zprofile
    #profileExtra = "[[ \"$(tty)\" == \"/dev/tty1\" ]] && exec Hyprland";
    # extra commands to be added to .zshrc
    initContent = "
      eval \"$(zoxide init zsh)\" > /dev/null 2>&1\n
      eval \"$(keychain --eval github --quiet)\"
    ";
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
