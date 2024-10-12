{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        fonts = [
          "FontAwesome"
          "Noto Sans"
          "Hack"
        ];
        layer = "top"; # Waybar at top layer
        position = "top"; # Waybar at the top of your screen
        height = 36; # Waybar Height
        # "width": 1366, // Waybar width
        # Choose the order of the modules
        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];
        modules-center = [ "sway/window" ];
        modules-right = [
          "pulseaudio"
          "network"
          "temperature"
          "cpu"
          "memory"
          "battery"
          "tray"
          "clock"
        ];
        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = false;
          format = "{icon}";
          format-icons = {
            "1:web" = "";
            "2:term" = "";
            "3:code" = "";
            "4:slack" = "";
            "5:zoom" = "Z";
            "urgent" = "";
            "focused" = "";
            "default" = "";
          };
        };
        "sway/mode" = {
          format = ''<span style="italic">{}</span>'';
        };
        tray = {
          # "icon-size" = 21;
          spacing = 10;
        };
        clock = {
          format = "{:%a %d %b %H:%M}";
        };
        temperature = {
          format = " {temperatureC}°C";
          hwmon-path = "/sys/class/hwmon/hwmon5/temp1_input";
        };
        cpu = {
          format = "{icon} {load}";
          format-icons = [
            "<span color='#69ff94'>▁</span>"
            "<span color='#2aa9ff'>▂</span>"
            "<span color='#f8f8f2'>▃</span>"
            "<span color='#f8f8f2'>▄</span>"
            "<span color='#ffffa5'>▅</span>"
            "<span color='#ffffa5'>▆</span>"
            "<span color='#ff9977'>▇</span>"
            "<span color='#dd532e'>█</span>"
          ];
        };
        memory = {
          format = " {}%";
        };
        battery = {
          bat = "BAT0";
          states = {
            good = 95;
            warning = 25;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          # "format-good" = ""; // An empty format will hide the module
          # "format-full" = "";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
        network = {
          # "interface": "wlp2s0", // (Optional) To force the use of this interface
          format-wifi = " {essid} ({signalStrength}%)";
          format-ethernet = " {ifname}: {ipaddr}/{cidr}";
          format-disconnected = "⚠ Disconnected";
        };
        pulseaudio = {
          # "scroll-step": 1,
          format = "{icon} {volume}%";
          format-bluetooth = "{icon}  {volume}% ";
          format-muted = "";
          format-icons = {
            headphones = "";
            handsfree = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
            ];
          };
          on-click = "pavucontrol";
        };
        # "custom/spotify": {
        #     "format": " {}",
        #     "max-length": 40,
        #     "interval": 30, // Remove this if your script is endless and write in loop
        #     "exec": "$HOME/.config/waybar/mediaplayer.sh 2> /dev/null", // Script in resources folder
        #     "exec-if": "pgrep spotify"
        # }
      };
    };

    style = ''
      @define-color base   #1a1a1a;
      @define-color text   #d1d1d1;

      * {
        border: none;
        font-family: Noto Sans, FontAwesome;
        font-size: 16px;
        min-height: 0;
        color: @text;
      }

      window#waybar {
        background: @base;
      }

      #window {
        padding: 0 10px;
        font-weight: normal;
      }

      #workspaces button {
        padding: 0 10px;
        border-top: 2px solid transparent;
      }

      #workspaces button.focused {
        border-top: 2px solid;
      }

      .modules-left {
        border-right: 0px solid;
        border-left: 0px;
      }

      .modules-right {
        border-left: 0px solid;
        border-right: 0px;
        padding-left: 5px;
      }

      #clock, #battery, #cpu, #memory, #network, #pulseaudio, #custom-spotify, #tray {
        padding: 0 3px;
        margin: 0 2px;
      }

      #cpu, #temperature, #memory, #battery {
        font-family: Hack;
        border-left: 0px solid;
        border-radius: 0;
        margin-top: 4px;
        margin-bottom: 4px;
        padding-left: 4px;
      }

      #mode {
        border-top: 2px solid;
        padding: 0 3px;
        margin: 0 2px;
      }

      #clock {
        font-weight: bold;
      }

      #battery {
      }

      #battery icon {
      }

      #battery.charging {
      }

      #memory {
      }

      #cpu {
      }

      #temperature {
      }

      #network {
      }

      #network.disconnected {
        border-top: 2px solid;
      }

      #pulseaudio {
      }

      #pulseaudio.muted {
      }

      #tray {
      }
    '';
  };
}
