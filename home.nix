{ config, pkgs, lib, ... }:

{
  home.username = "user";
  home.homeDirectory = "/home/user";

  home.stateVersion = "24.11";

  home.keyboard = {
    layout = "no";
  };

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

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      return {
        keys = {
          {
            key = "T",
            mods = "CTRL|SHIFT",
            action = wezterm.action.{SpawnTab = "DefaultDomain" },
          },
          {
            key = "E",
            mods = "CTRL|SHIFT",
            action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" },
          },
          -- NOTE: default close is CTRL+SHIFT+W
          {
            key = "O",
            mods = "CTRL|SHIFT",
            action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" },
          },
        };
        window_padding = {
          left = 0;
          bottom = 0;
          right = 0;
          top = 0;
        };
        window_background_opacity = 0.2;
        color_scheme = "Catppuccin Mocha";
      }
    '';
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
          "hyprland/mode"
        ];

        modules-center = [ 
          "hyprland/window"
        ];

        modules-right = [
          "network"
          "cpu"
          "memory"
          "disk"
          "pulseaudio"
          "clock#date"
          "clock#time"
          "hyprland/powermenu"
        ];

        "clock#time" = {
          interval = 1;
          format = "{:%H:%M:%S}  ";
          tooltip = false;
        };

        "clock#date" = {
          format = "{:%e %b %Y} ";
          tooltip-format = "{:%e %B %Y}";
        };

        "cpu" = {
          format = "CPU: {usage}%  ";
          tooltip = false;
        };

        "memory" = {
          format = "Mem: {used}/{total} GB {icon}  ";
        };

        "network" = {
          interface = "enp7s0";
          format-ethernet = "{ifname}: {ipaddr}/{cidr} {bandwidthDownBits}↓ {bandwidthUpBits}↑";
          format-disconnected = "Disconnected";
          #format-alt = "{ifname}: {ipaddr}/{cidr} {down}↓ {up}↑";
          tooltip-format = "{ifname} via {gwaddr}";
          interval = 1;
        };

        "disk" = {
          format = "Disk: {used} / {total} GB";
          tooltip = false;
        };
        "pulseaudio" = {
          format = "Audio: {volume:2}% ";
          format-muted = "MUTE";
          format-icons = {

          };
          scroll-step = "5";
          on-click = "pamixer -t";
          on-click-right = "pavucontrol";
        };
      };
    };

    style = ''
* {
  font-family: FontAwesome, Roboto, Helvetica, Arial, sans-serif;
  font-size: 13px;
}

window#waybar {
  background-color: #292b2e;
  color: #fdf6e3;
}

#custom-right-arrow-dark,
#custom-left-arrow-dark {
	color: #1a1a1a;
}
#custom-right-arrow-light,
#custom-left-arrow-light {
	color: #292b2e;
	background: #1a1a1a;
}

#workspaces,
#clock.1,
#clock.2,
#clock.3,
#pulseaudio,
#memory,
#cpu,
#disk,
#tray {
	background: #1a1a1a;
}

#workspaces button {
	padding: 0 2px;
	color: #fdf6e3;
}
#workspaces button.focused {
	color: #268bd2;
}
#workspaces button:hover {
	box-shadow: inherit;
	text-shadow: inherit;
}
#workspaces button:hover {
	background: #1a1a1a;
	border: #1a1a1a;
	padding: 0 3px;
}

#pulseaudio {
	color: #268bd2;
}
#memory {
	color: #2aa198;
}
#cpu {
	color: #6c71c4;
}
#disk {
	color: #b58900;
}

#clock,
#pulseaudio,
#memory,
#cpu,
#disk {
	padding: 0 10px;
}
    '';
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

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = {
      "monitor" = ",preferred,auto,auto";
      "$mod" = "SUPER";
      "$term" = "wezterm";
      "$menu" = "rofi -show drun";
      exec-once = [
        "waybar"
        "swww init"
      ];
      bind = [
      # principal keybinds
      "$mod, L, exec, hyprlock"
      "$mod, D, exec, $menu"
      "$mod, Return, exec, $term"
      "$mod, Q, killactive"
      "$mod SHIFT, Q, exit"
      "$mod, V, togglefloating"
      "$mod, Tab, cyclenext"
      "$mod SHIFT, Tab, cyclenext, prev"
      "$mod, Left, focuswindow, left"
      "$mod, Right, focuswindow, right"

      # workspaces
      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"
      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod SHIFT, 4, movetoworkspace, 5"
# TODO: swap window positions

      # screencap
      "$mod SHIFT, S, exec, grimblast copy area"
      "$mod ALT, S, exec, grimblast copy active"
      "$mod CTRL, S, exec, grimblast copy screen"
      ];
      bindm = [
        # move/resize window
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"

        # scroll through existing workspaces
        #"$mod, mouse_down, workspace, e+1"
        #"$mod, mouse_up, workspace, e-1"
      ];
      input = {
        kb_layout = "no";
      };
      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        layout = "dwindle";
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        #coltactive_border = "#33ccffee #00ff99ee 45deg";
        #"col.inactive_border" = "rgba(595959aa)";
        "col.inactive_border" = "00x595959aa";
        #col.inactive_border = "#595959aa";
        resize_on_border = false;
        allow_tearing = false;
      };
      decoration = {
        rounding = 10;
        active_opacity = "1.0";
        #inactive_border = "1.0";
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
          #color = "#1a1a1aee";
        };
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };
      # animations = {
      #   enabled = true;
      #   bezier = easeOutQuint,0.23,1,0.32,1;
      #   bezier = easeInOutCubic,0.65,0.05,0.36,1;
      #   bezier = linear,0,0,1,1;
      #   bezier = almostLinear,0.5,0.5,0.75,1.0
      #   bezier = quick,0.15,0,0.1,1
      #
      #   animation = global, 1, 10, default
      #   animation = border, 1, 5.39, easeOutQuint
      #   animation = windows, 1, 4.79, easeOutQuint
      #   animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
      #   animation = windowsOut, 1, 1.49, linear, popin 87%
      #   animation = fadeIn, 1, 1.73, almostLinear
      #   animation = fadeOut, 1, 1.46, almostLinear
      #   animation = fade, 1, 3.03, quick
      #   animation = layers, 1, 3.81, easeOutQuint
      #   animation = layersIn, 1, 4, easeOutQuint, fade
      #   animation = layersOut, 1, 1.5, linear, fade
      #   animation = fadeLayersIn, 1, 1.79, almostLinear
      #   animation = fadeLayersOut, 1, 1.39, almostLinear
      #   animation = workspaces, 1, 1.94, almostLinear, fade
      #   animation = workspacesIn, 1, 1.21, almostLinear, fade
      #   animation = workspacesOut, 1, 1.94, almostLinear, fade
      # };
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
    }; 
  };

  programs.home-manager.enable = true;
}
