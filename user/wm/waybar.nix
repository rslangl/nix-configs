{
  ...
}: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 35;
        spacing = 2;

        modules-left = [
          "hyprland/powermenu"
          "network"
          "cpu"
          "memory"
          "disk"
        ];

        modules-center = [
          "hyprland/window"
          "hyprland/workspaces"
          "hyprland/mode"
        ];

        modules-right = [
          "pulseaudio"
          "clock#date"
          "clock#time"
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
          format-icons = {};
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
}
