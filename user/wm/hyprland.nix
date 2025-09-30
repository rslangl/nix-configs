{
  inputs,
  config,
  lib,
  pkgs,
  userSettings,
  systemSettings,
  ...
}: {
  imports = [
    ../app/terminal/wezterm.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    alacritty
    kitty
    hypridle
    hyprlock
    hyprpaper
    qt6.qtwayland
    # xdg-utils
    # xdg-desktop-portal
    # xdg-desktop-portal-gtk
    # xdg-desktop-portal-hyprland
    # #nwg-dock-hyprland
    wl-clipboard
    rofi # TODO: consider moving to a launcher module
  ];

  gtk = {
    enable = true;

    # NOTE: taken from the wiki
    #
    # theme = {
    #   package = pkgs.flat-remix-gtk;
    #   name = "Flat-Remix-GTK-Grey-Darkest";
    # };
    #
    # iconTheme = {
    #   package = pkgs.adwaita-icon-theme;
    #   name = "Adwaita";
    # };

    cursorTheme = {
      package = pkgs.adwaita-icon-theme; # pkgs.quintom-cursor-theme
      name = "Adwaita";
      size = 16;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.nixpkgs.legacyPackages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    systemd.enable = true;
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
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod, left, movewindow, l"
        "$mod, right, movewindow, r"
        "$mod, up, movewindow, u"
        "$mod, down, movewindow, d"
        "$mod SHIFT, H, resizeactive, -20 0"
        "$mod SHIFT, J, resizeactive, 0 20"
        "$mod SHIFT, K, resizeactive, 0 -20"
        "$mod SHIFT, L, resizeactive, 20 0"

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
        "col.inactive_border" = "00x595959aa";
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
}
