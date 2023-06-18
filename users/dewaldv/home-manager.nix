{ config, lib, pkgs, ... }:

{
  home.stateVersion = "22.11";

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 16;
  };

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      menu = ''wofi --show=drun --lines=5 --prompt=""'';
      modifier = "Mod4";
      terminal = "alacritty";
      startup = [
        # Launch Firefox on start
        { command = "firefox"; }
      ];

      assigns = {
        "1:web" = [{ app_id = "^firefox$"; }];
        "2:term" = [{ app_id = "^Alacritty$"; }];
        "3:code" = [{ app_id = "^emacs$"; }];
        "4:slack" = [{ app_id = "^Slack$"; }];
        "7:zoom" = [{ app_id = "^zoom$"; }];
      };

      bars = [{
        command = "${pkgs.waybar}/bin/waybar";
        statusCommand = null;
      }];

      input = {
        "*" = {
          xkb_layout = "gb";
          xkb_options = "ctrl:nocaps";
        };
      };

      output = { "eDP-1" = { scale = "2.0"; }; };

      keybindings = lib.mkOptionDefault {
        "${modifier}+k" = "output eDP-1 toggle";
        "${modifier}+l" = "exec swaylock";

        "${modifier}+greater" = "move workspace to output right";
        "${modifier}+less" = "move workspace to output left";

        "XF86MonBrightnessDown" = "exec light -U 10";
        "XF86MonBrightnessUp" = "exec light -A 10";

        "XF86AudioRaiseVolume" =
          "exec 'wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 1%+'";
        "XF86AudioLowerVolume" =
          "exec 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-'";
        "XF86AudioMute" = "exec 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'";
        "XF86AudioMicMute" =
          "exec 'wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle'";
      };
    };
  };

  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock";
      }
      {
        event = "lock";
        command = "lock";
      }
    ];
    timeouts = [{
      timeout = 180;
      command = "${pkgs.swaylock}/bin/swaylock -fF";
    }];
  };
  # programs.swaylock.enable = true;

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        fonts = [ "FontAwesome" "Noto Sans" ];
        layer = "top"; # Waybar at top layer
        position = "top"; # Waybar at the top of your screen
        height = 24; # Waybar Height
        # "width": 1366, // Waybar width
        # Choose the order of the modules
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "sway/window" ];
        modules-right =
          [ "pulseaudio" "network" "cpu" "memory" "battery" "tray" "clock" ];
        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = false;
          format = "{icon}";
          format-icons = {
            "1:web" = "";
            "2:term" = "";
            "3:code" = "";
            "4:slack" = "";
            "5:music" = "";
            "7:zoom" = "Z";
            "urgent" = "";
            "focused" = "";
            "default" = "";
          };
        };
        "sway/mode" = { format = ''<span style="italic">{}</span>''; };
        tray = {
          # "icon-size" = 21;
          spacing = 10;
        };
        clock = { format-alt = "{:%Y-%m-%d}"; };
        cpu = { format = " {load}"; };
        memory = { format = " {}%"; };
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
          format-icons = [ "" "" "" "" "" ];
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
            default = [ "" "" ];
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
      * {
          border: none;
          border-radius: 0;
          font-family: FontAwesome, Noto Sans, Roboto, Helvetica, Arial, sans-serif;
          font-size: 14px;
          min-height: 0;
      }

      window#waybar {
          background: transparent;
          color: white;
      }

      #window {
          font-weight: normal;
          font-family: "Hack";
      }
      /*
      #workspaces {
          padding: 0 5px;
      }
      */

      #workspaces button {
          padding: 0 5px;
          background: transparent;
          color: white;
          border-top: 2px solid transparent;
      }

      #workspaces button.focused {
          color: #c9545d;
          border-top: 2px solid #c9545d;
      }

      #mode {
          background: #64727D;
          border-bottom: 3px solid white;
      }

      #clock, #battery, #cpu, #memory, #network, #pulseaudio, #custom-spotify, #tray, #mode {
          padding: 0 3px;
          margin: 0 2px;
      }

      #clock {
          font-weight: bold;
      }

      #battery {
      }

      #battery icon {
          color: red;
      }

      #battery.charging {
      }

      @keyframes blink {
          to {
              background-color: #ffffff;
              color: black;
          }
      }

      #battery.warning:not(.charging) {
          color: white;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      #cpu {
      }

      #memory {
      }

      #network {
      }

      #network.disconnected {
          background: #f53c3c;
      }

      #pulseaudio {
      }

      #pulseaudio.muted {
      }

      #custom-spotify {
          color: rgb(102, 220, 105);
      }

      #tray {
      }
    '';
  };
}
