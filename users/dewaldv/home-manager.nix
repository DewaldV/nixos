machineSettings:
{ config, lib, pkgs, ... }:

{
  home.stateVersion = "22.11";

  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        indent_style = "space";
        indent_size = 2;
        insert_final_newline = true;
        trim_trailing_whitespace = true;
      };

      "*.md" = { trim_trailing_whitespace = false; };
      "*.go" = { indent_syle = "tab"; };
    };
  };

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 16;
  };

  xdg.desktopEntries.firefoxPersonal = {
    categories = "Network;WebBrowser";
    exec = "firefox --name firefox -P Personal";
    genericName = "Web Browser";
    icon = "firefox";
    name = "Firefox (Personal)";
    startupNotify = true;
    terminal = false;
    type = "Application";
  };

  gtk = {
    enable = true;
    gtk3.extraConfig = { "gtk-application-prefer-dark-theme" = 1; };
    gtk4.extraConfig = { "gtk-application-prefer-dark-theme" = 1; };
  };

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      menu = ''wofi --show=drun --lines=5 --prompt="" --stylesheet=style.css'';
      modifier = "Mod4";
      terminal = "alacritty";
      # startup = [{ command = "mako"; }];

      assigns = {
        "1:web" = [{ app_id = "^firefox$"; }];
        "2:term" = [{ app_id = "^Alacritty$"; }];
        "3:code" = [{ app_id = "^emacs$"; }];
        "4:slack" = [{ app_id = "^Slack$"; }];
        "5:zoom" = [{
          app_id = "";
          title = "Zoom (Meeting)|(- Licensed Account)";
        }];
      };

      window = {
        commands = [
          {
            command = "inhibit_idle fullscreen";
            criteria = { shell = ".*"; };
          }

          {
            command = "floating enable";
            criteria = {
              app_id = "";
              title = "^([Zz]oom.*)|(as_toolbar)";
            };
          }
          {
            command = "floating disable";
            criteria = {
              app_id = "";
              title = "Zoom (Meeting)|(- Licensed Account)";
            };
          }
          {
            command = "move position mouse";
            criteria = {
              app_id = "";
              title = "Chat";
            };
          }
        ];
      };

      bars = [{
        command = "${pkgs.waybar}/bin/waybar";
        statusCommand = null;
      }];

      input = machineSettings.sway.input;

      output = {
        "*" = { bg = "/home/dewaldv/Pictures/wallpaper.png fit"; };
        "eDP-1" = {
          scale = "1.5";
          # scale = "1.0";
          # mode = "--custom 1920x1080";
        };

        "DP-1" = {
          mode = "3440x1440@165Hz";
          adaptive_sync = "off";
        };

        "HDMI-A-1" = {
          mode = "3440x1440@100Hz";
          adaptive_sync = "off";
        };
      };

      keybindings = lib.mkOptionDefault {
        "${modifier}+Escape" = "exec swaylock";
        "${modifier}+Control+e" = "exec ${pkgs.wofi-emoji}/bin/wofi-emoji";

        "${modifier}+greater" = "move workspace to output right";
        "${modifier}+less" = "move workspace to output left";

        "${modifier}+p" = "exec grimshot save output";
        "${modifier}+Shift+p" = "exec grimshot copy output";
        "${modifier}+Ctrl+p" = "exec grimshot copy window";

        "XF86Display" = "output eDP-1 toggle";

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
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        event = "lock";
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
    ];
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        timeout = 330;
        command = ''${pkgs.sway}/bin/swaymsg "output * dpms off"'';
        resumeCommand = ''${pkgs.sway}/bin/swaymsg "output * dpms on"'';
      }
    ];
  };

  services.mako = {
    enable = true;
    actions = true;
    icons = true;
  };

  programs.wofi = {
    enable = true;
    style = ''
      window {
      margin: 0px;
      border: 1px solid #bd93f9;
      background-color: #282a36;
      }

      #input {
      margin: 5px;
      border: none;
      color: #f8f8f2;
      background-color: #44475a;
      }

      #inner-box {
      margin: 5px;
      border: none;
      background-color: #282a36;
      }

      #outer-box {
      margin: 5px;
      border: none;
      background-color: #282a36;
      }

      #scroll {
      margin: 0px;
      border: none;
      }

      #text {
      margin: 5px;
      border: none;
      color: #f8f8f2;
      }

      #entry.activatable #text {
      color: #282a36;
      }

      #entry > * {
      color: #f8f8f2;
      }

      #entry:selected {
      background-color: #44475a;
      }

      #entry:selected #text {
      font-weight: bold;
      }
    '';
  };

  programs.swaylock = {
    settings = {
      show-failed-attempts = true;
      ignore-empty-password = true;
      font = "Roboto";

      color = "1D1D1D";
      indicator-radius = "240";
      indicator-thickness = "20";

      key-hl-color = "880033";

      inside-color = "00000099";
      inside-clear-color = "ffd20400";
      inside-caps-lock-color = "009ddc00";
      inside-ver-color = "d9d8d800";
      inside-wrong-color = "ee2e2400";

      ring-color = "231f20D9";
      ring-clear-color = "231f20D9";
      ring-caps-lock-color = "231f20D9";
      ring-ver-color = "231f20D9";
      ring-wrong-color = "231f20D9";

      line-color = "00000000";
      line-clear-color = "ffd204FF";
      line-caps-lock-color = "009ddcFF";
      line-ver-color = "d9d8d8FF";
      line-wrong-color = "ee2e24FF";

      text-clear-color = "ffd20400";
      text-ver-color = "d9d8d800";
      text-wrong-color = "ee2e2400";

      bs-hl-color = "ee2e24FF";
      caps-lock-key-hl-color = "ffd204FF";
      caps-lock-bs-hl-color = "ee2e24FF";
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
          hwmon-path = "/sys/class/hwmon/hwmon3/temp1_input";
        };
        cpu = { format = " {load}"; };
        memory = { format = " {}%"; };
        battery = {
          bat = machineSettings.sway.battery.bat;
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
          border-radius: 0;
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
          border-right: 2px solid;
          border-left: 0px;
      }

      .modules-right {
          background: @surface0;
          border-left: 10px solid;
          border-right: 0px;
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
