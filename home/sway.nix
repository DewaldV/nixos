{ config, lib, pkgs, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      menu = "fuzzel";
      modifier = "Mod4";
      terminal = "alacritty";

      assigns = {
        "1:web" = [{ app_id = "^firefox$"; }];
        "2:term" = [{ app_id = "^Alacritty$"; }];
        "3:code" = [{ app_id = "^emacs$"; }];
        "4:slack" = [{ app_id = "^Slack$"; }];
        "5:zoom" = [{ app_id = "^Zoom$"; }];
      };

      window = {
        commands = [
          {
            command = "inhibit_idle fullscreen";
            criteria = { shell = ".*"; };
          }
          {
            command =
              "border pixel 0, floating enable, fullscreen disable, move absolute position 0 0";
            criteria = { app_id = "flameshot"; };
          }
          {
            command = "floating enable";
            criteria = { app_id = "Zoom"; };
          }
          {
            command = "move position mouse";
            criteria = {
              app_id = "Zoom";
              title = "zoom";
            };
          }
          {
            command = "floating disable";
            criteria = {
              app_id = "Zoom";
              title = "Zoom (Meeting|- (Licensed|Free) Account)";
            };
          }
          {
            command = "floating disable, move right, resize set width 20";
            criteria = {
              app_id = "Zoom";
              title = "Meeting Chat";
            };
          }
        ];
      };

      bars = [{
        command = "${pkgs.waybar}/bin/waybar";
        statusCommand = null;
      }];

      input = { "*" = { xkb_layout = "gb"; }; };

      output = {
        "*" = { bg = "/home/dewaldv/Pictures/wallpaper.png fill"; };
        "eDP-1" = {
          scale = "1.5";
          pos = "760 1440";
          # scale = "1.0";
          # mode = "--custom 1920x1080";
        };

        "DP-1" = {
          mode = "3440x1440@165Hz";
          adaptive_sync = "off";
        };

        "HDMI-A-1" = {
          mode = "3440x1440@100Hz";
          pos = "0 0";
          adaptive_sync = "off";
        };
      };

      keybindings = lib.mkOptionDefault {
        "${modifier}+Escape" = "exec swaylock";

        "${modifier}+Ctrl+up" = "move workspace to output up";
        "${modifier}+Ctrl+down" = "move workspace to output down";
        "${modifier}+Ctrl+left" = "move workspace to output left";
        "${modifier}+Ctrl+right" = "move workspace to output right";

        "${modifier}+p" = "exec grimshot save output";
        "${modifier}+Shift+p" = "exec grimshot copy output";
        "${modifier}+Ctrl+p" = "exec grimshot copy window";

        "--locked XF86Display" = "output eDP-1 toggle";

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
        command = "swaylock -f";
      }
      {
        event = "lock";
        command = "swaylock -f";
      }
    ];
    timeouts = [
      {
        timeout = 300;
        command = "swaylock -f";
      }
      {
        timeout = 330;
        command = ''swaymsg "output * dpms off"'';
        resumeCommand = ''swaymsg "output * dpms on"'';
      }
    ];
  };

  services.mako = {
    enable = true;
    actions = true;
    icons = true;
    defaultTimeout = 5000;
    font = "Noto Sans 10";
    borderRadius = 4;
    # catppuccin/mako: https://github.com/catppuccin/mako/blob/main/src/mocha
    backgroundColor = "#1e1e2e";
    textColor = "#cdd6f4";
    borderColor = "#89b4fa";
    progressColor = "over #313244";
    extraConfig = ''
      [urgency=high]
      border-color=#fab387
    '';
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      # catppuccin/fuzzel: https://github.com/catppuccin/fuzzel/blob/main/themes/mocha.ini
      colors = {
        background = "1e1e2edd";
        text = "cdd6f4ff";
        match = "f38ba8ff";
        selection = "585b70ff";
        selection-match = "f38ba8ff";
        selection-text = "cdd6f4ff";
        border = "b4befeff";
      };
    };
  };

  programs.swaylock = {
    package = pkgs.swaylock-effects;
    settings = {
      show-failed-attempts = true;
      font = "Noto Sans, Light";
      font-size = 32;
      clock = true;
      timestr = "%H:%M";
      datestr = "%a %d %b %Y";
      indicator = true;

      # catppuccin/swaylock: https://github.com/catppuccin/swaylock/blob/main/themes/mocha.conf
      color = "1e1e2e";
      bs-hl-color = "f5e0dc";
      caps-lock-bs-hl-color = "f5e0dc";
      caps-lock-key-hl-color = "a6e3a1";
      inside-color = "00000000";
      inside-clear-color = "00000000";
      inside-caps-lock-color = "00000000";
      inside-ver-color = "00000000";
      inside-wrong-color = "00000000";
      key-hl-color = "a6e3a1";
      layout-bg-color = "00000000";
      layout-border-color = "00000000";
      layout-text-color = "cdd6f4";
      line-color = "00000000";
      line-clear-color = "00000000";
      line-caps-lock-color = "00000000";
      line-ver-color = "00000000";
      line-wrong-color = "00000000";
      ring-color = "b4befe";
      ring-clear-color = "f5e0dc";
      ring-caps-lock-color = "fab387";
      ring-ver-color = "89b4fa";
      ring-wrong-color = "eba0ac";
      separator-color = "00000000";
      text-color = "cdd6f4";
      text-clear-color = "f5e0dc";
      text-caps-lock-color = "fab387";
      text-ver-color = "89b4fa";
      text-wrong-color = "eba0ac";
    };
  };

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
        "sway/mode" = { format = ''<span style="italic">{}</span>''; };
        tray = {
          # "icon-size" = 21;
          spacing = 10;
        };
        clock = { format = "{:%a %d %b %H:%M}"; };
        temperature = {
          format = " {temperatureC}°C";
          hwmon-path = "/sys/class/hwmon/hwmon1/temp1_input";
        };
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
