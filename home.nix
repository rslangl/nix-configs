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
          format = "{:%H:%M:%S}";
          tooltip = false;
        };

        "clock#date" = {
          format = "{:%e %b %Y}";
          tooltip-format = "{:%e %B %Y}";
        };

        "cpu" = {
          format = "{usage}% CPU";
          tooltip = false;
        };

        "memory" = {
          format = "{used} / {total} GB";
        };

        "network" = {
          format-ethernet = "{ifname}: {ipaddr}/{cidr} {down}↓ {up}↑";
          format-disconnected = "Disconnected";
          format-alt = "{ifname}: {ipaddr}/{cidr} {down}↓ {up}↑";
          tooltip-format = "{ifname} via {gwaddr}";
        };

        "disk" = {
          format = "Disk: {used} / {total}";
          tooltip = false;
        };
      };
    };

    style = ''
/* -----------------------------------------------------------------------------
 * Keyframes
 * -------------------------------------------------------------------------- */

@keyframes blink-warning {
    70% {
        color: white;
    }

    to {
        color: white;
        background-color: orange;
    }
}

@keyframes blink-critical {
    70% {
      color: white;
    }

    to {
        color: white;
        background-color: red;
    }
}


/* -----------------------------------------------------------------------------
 * Base styles
 * -------------------------------------------------------------------------- */

/* Reset all styles */
* {
    border: none;
    border-radius: 0;
    min-height: 0;
    margin: 0;
    padding: 0;
}

/* The whole bar */
#waybar {
    background: #323232;
    color: white;
    font-family: Cantarell, Noto Sans, sans-serif;
    font-size: 13px;
}

/* Each module */
#battery,
#clock,
#cpu,
#custom-keyboard-layout,
#memory,
#mode,
#network,
#pulseaudio,
#temperature,
#tray {
    padding-left: 10px;
    padding-right: 10px;
}


/* -----------------------------------------------------------------------------
 * Module styles
 * -------------------------------------------------------------------------- */

#battery {
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
}

#battery.warning {
    color: orange;
}

#battery.critical {
    color: red;
}

#battery.warning.discharging {
    animation-name: blink-warning;
    animation-duration: 3s;
}

#battery.critical.discharging {
    animation-name: blink-critical;
    animation-duration: 2s;
}

#clock {
    font-weight: bold;
}

#cpu {
  /* No styles */
}

#cpu.warning {
    color: orange;
}

#cpu.critical {
    color: red;
}

#memory {
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
}

#memory.warning {
    color: orange;
}

#memory.critical {
    color: red;
    animation-name: blink-critical;
    animation-duration: 2s;
}

#mode {
    background: #64727D;
    border-top: 2px solid white;
    /* To compensate for the top border and still have vertical centering */
    padding-bottom: 2px;
}

#network {
    /* No styles */
}

#network.disconnected {
    color: orange;
}

#pulseaudio {
    /* No styles */
}

#pulseaudio.muted {
    /* No styles */
}

#custom-spotify {
    color: rgb(102, 220, 105);
}

#temperature {
    /* No styles */
}

#temperature.critical {
    color: red;
}

#tray {
    /* No styles */
}

#window {
    font-weight: bold;
}

#workspaces button {
    border-top: 2px solid transparent;
    /* To compensate for the top border and still have vertical centering */
    padding-bottom: 2px;
    padding-left: 10px;
    padding-right: 10px;
    color: #888888;
}

#workspaces button.focused {
    border-color: #4c7899;
    color: white;
    background-color: #285577;
}

#workspaces button.urgent {
    border-color: #c9545d;
    color: #c9545d;
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
