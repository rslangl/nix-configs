{ config, pkgs, lib, ... }:

{
  home.username = "user";
  home.homeDirectory = "/home/user";

  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    neovim
    fzf
    oh-my-zsh
    ripgrep
    pay-respects  # command-not-found tool
    signal-desktop
    btop
    tree
    keychain
    zoxide
    mpv
    zathura # PDF reader
    grimblast # screencap
    imagemagick
    ffmpeg
    ffmpegthumbnailer
    swww
    python3
    adwaita-icon-theme
    solarc-gtk-theme
    

    #(btop.override { settings = { color_theme = "gruvbox_dark_v2"; vim_keys = true; }; } )
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    #(nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/user/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.git = {
    enable = true;
    userName = "rslangl";
  };

  # home.pointerCursor = {
  #   gtk.enable = true;
  #   package = pkgs.bibata-cursors;
  #   name = "Bibata-Modern-Classic";
  #   size = 16;
  # };

  gtk = {
    enable = true;

    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    theme = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita";
    };

    # TODO:: Terminal font: JetBrains Mono
  };

  xdg.mimeApps.defaultApplications = {
    "text/plain" = [ "nvim.desktop" ];
    "application/pdf" = [ "zathura.desktop" ];
    "image/*" = [ "sxiv.desktop" ];
    "video/png" = [ "mpv.desktop" ];
    "video/jpg" = [ "mpv.desktop" ];
    "video/*" = [ "mpv.desktop" ];
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    autocd = true;
    shellAliases = {
      ls="ls --color=auto";
      la="ls -la";
      ll="ls -l";
      wget="wget --hsts-file=$XDG_CACHE_HOME/wget-hsts";
      sbt="sbt -ivy $XDG_DATA_HOME/ivy2 -sbt-dir $XDG_DATA_HOME/sbt";
      mvn="mvn -gs $XDG_CONFIG_HOME/maven/settings.xml";
      nvidia-settings="nvidia-settings --config=$XDG_CONFIG_HOME/nvidia/settings";
    };
    dirHashes = {
      dev = "$HOME/dev";
      dl = "$HOME/tmp";
    };
    dotDir = ".config/zsh";
    # extra commands to be added to .zshenv
    envExtra = 
      "export RUSTUP_HOME=${config.xdg.dataHome}/rustup\n
       export CARGO_HOME=${config.xdg.dataHome}/cargo";
    # extra commands to be added to .zprofile
    profileExtra = "[[ \"$(tty)\" == \"/dev/tty1\" ]] && exec Hyprland";
    # extra commands to be added to .zshrc
    initExtra =
      "eval \"$(zoxide init zsh)\" > /dev/null 2>&1\n
       eval \"$(keychain --absolute --dir $XDG_RUNTIME_DIR/keychain --eval --agents ssh ~/.ssh/github --quiet)\"";
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

  programs.waybar = {
    enable = true;
    settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;

          modules-left = [ 
            "hyprland/workspaces" 
          ];

          modules-center = [ 
            "clock" 
          ];

          modules-right = [
            "pulseaudio"
            "network" 
            "cpu" 
            "memory" 
            "tray"
            "group/time"
          ];
        };
    };
    style = 
      "* {
        padding: 0;
        border-radius: 0;
        min-height: 0;
        margin: 0;
        border: none;
        text-shadow: none;
        transition: none;
        box-shadow: none;
      }

      window#waybar {
        background: #3c3835;
        color: #fff4d2;
        padding-right: 9px;
        padding-left: 5px;
        margin: 0;
      }";
  };

  programs.hyprlock = {
    enable = true;
  };

  services.hypridle = {
    enable = true;
    settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };

        listener = [
        {
          timeout = 900;
          on-timeout = "hyprlock";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        ];
    };
  };

  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    bind = [
      "$mod, L, exec, hyprlock" # lock screen
      "$mod, D, exec, rofi -show drun"		# launch app-launcher
      "$mod, Return, exec, wezterm"		# launch terminal
      "$mod, Q, killactive"			# kill active window
      "$mod, M, exit"				# exit Hyprland
      "$mod, V, togglefloating"			# toggle floating
      "$mod SHIFT, S, exec, grimblast copy area"
      "$mod ALT, S, exec, grimblast copy active"
      "$mod CTRL, S, exec, grimblast copy screen"
    ] ++ (
      # workspaces
      # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
      builtins.concatLists (builtins.genList (i:
        let ws = i + 1;
	in [
	    "$mod, code:1${toString i}, workspace, ${toString ws}"
	    "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
	  ]
	)
	9)
    );
  };

  programs.home-manager.enable = true;
}
