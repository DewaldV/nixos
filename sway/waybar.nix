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
        ];
        layer = "top"; # Waybar at top layer
        position = "top"; # Waybar at the top of your screen
        height = 24; # Waybar Height
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
          "cpu"
          "temperature"
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
          hwmon-path = "/sys/class/hwmon/hwmon1/temp1_input";
        };
        cpu = {
          format = " {load}";
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
          format = "{capacity}% {icon}";
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
      /*
      *
      * Catppuccin Mocha palette
      * Maintainer: rubyowo
      *
      */

      @define-color base   #1e1e2e;
      @define-color mantle #181825;
      @define-color crust  #11111b;

      @define-color text     #cdd6f4;
      @define-color subtext0 #a6adc8;
      @define-color subtext1 #bac2de;

      @define-color surface0 #313244;
      @define-color surface1 #45475a;
      @define-color surface2 #585b70;

      @define-color overlay0 #6c7086;
      @define-color overlay1 #7f849c;
      @define-color overlay2 #9399b2;

      @define-color blue      #89b4fa;
      @define-color lavender  #b4befe;
      @define-color sapphire  #74c7ec;
      @define-color sky       #89dceb;
      @define-color teal      #94e2d5;
      @define-color green     #a6e3a1;
      @define-color yellow    #f9e2af;
      @define-color peach     #fab387;
      @define-color maroon    #eba0ac;
      @define-color red       #f38ba8;
      @define-color mauve     #cba6f7;
      @define-color pink      #f5c2e7;
      @define-color flamingo  #f2cdcd;
      @define-color rosewater #f5e0dc;

      * {
          border: none;
          border-radius: 4px;
          font-family: FontAwesome, Noto Sans, Roboto, Helvetica, Arial, sans-serif;
          font-size: 14px;
          min-height: 0;
      }

      window#waybar {
          background: @base;
      }

      #window {
          background: @surface0;
          color: @lavender;
          padding: 0 10px;
          font-weight: normal;
          font-family: "Hack";
      }

      /* #workspaces { */
      /*     background: @base; */
      /*     padding: 0 5px; */
      /* } */

      #workspaces button {
          padding: 0 10px;
          background: @surface0;
          color: @blue;
          border-top: 2px solid transparent;
      }

      #workspaces button.focused {
          color: @green;
          border-top: 2px solid @green;
      }

      .modules-left {
          background: @surface0;
          border-right: 0px solid;
          border-left: 0px;
      }

      .modules-right {
          background: @surface0;
          border-left: 0px solid;
          border-right: 0px;
          padding-left: 5px;
      }

      #clock, #battery, #cpu, #memory, #network, #pulseaudio, #custom-spotify, #tray {
          background: @surface0;
          padding: 0 3px;
          margin: 0 2px;
      }

      #mode {
          color: @peach;
          background: @surface0;
          border-top: 2px solid @peach;
          padding: 0 3px;
          margin: 0 2px;
      }

      #clock {
          color: @subtext1;
          font-weight: bold;
      }

      #battery {
          color: @peach
      }

      #battery icon {
          color: @yellow;
      }

      #battery.charging {
      }

      #memory {
          color: @green;
      }

      #cpu {
          color: @teal;
      }

      #temperature {
          color: @teal;
      }

      #network {
          color: @sky;
      }

      #network.disconnected {
          border-top: 2px solid @sky;
      }

      #pulseaudio {
          color: @sapphire;
      }

      #pulseaudio.muted {
      }

      #tray {
          background: @surface0
      }
    '';
  };
}