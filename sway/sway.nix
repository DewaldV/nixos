{
  config,
  lib,
  pkgs,
  ...
}:

{
  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;

    config = rec {
      menu = "fuzzel";
      modifier = "Mod4";
      terminal = "foot";

      assigns = {
        "1:web" = [ { app_id = "^firefox$"; } ];
        "2:term" = [ { app_id = "^foot$"; } ];
        "3:code" = [ { app_id = "^emacs$"; } ];
        "4:slack" = [ { app_id = "^Slack$"; } ];
        "5:zoom" = [ { app_id = "^Zoom$"; } ];
      };

      window = {
        commands = [
          {
            command = "inhibit_idle fullscreen";
            criteria = {
              shell = ".*";
            };
          }
          {
            command = "border pixel 0, floating enable, fullscreen disable, move absolute position 0 0";
            criteria = {
              app_id = "flameshot";
            };
          }
          {
            command = "floating enable";
            criteria = {
              app_id = "Zoom";
            };
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

      bars = [
        {
          command = "${pkgs.waybar}/bin/waybar";
          statusCommand = null;
        }
      ];

      input = {
        "*" = {
          xkb_layout = "gb";
        };
      };

      output = {
        "*" = {
          bg = "${config.xdg.userDirs.pictures}/wallpaper.png fill";
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

        "${modifier}+Shift+s" = "output eDP-1 scale 1.0";
        "${modifier}+Shift+d" = "output eDP-1 scale 1.25";

        "XF86MonBrightnessDown" = "exec light -U 10";
        "XF86MonBrightnessUp" = "exec light -A 10";

        "--locked XF86AudioRaiseVolume" = "exec 'wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 1%+'";
        "--locked XF86AudioLowerVolume" = "exec 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-'";
        "--locked XF86AudioMute" = "exec 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'";
        "--locked XF86AudioMicMute" = "exec 'wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle'";
      };
    };
  };

  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock-effects}/bin/swaylock -f";
      }
      {
        event = "lock";
        command = "${pkgs.swaylock-effects}/bin/swaylock -f";
      }
    ];
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock-effects}/bin/swaylock -f";
      }
      {
        timeout = 310;
        command = ''${pkgs.sway}/bin/swaymsg "output * dpms off"'';
        resumeCommand = ''${pkgs.sway}/bin/swaymsg "output * dpms on"'';
      }
      {
        timeout = 600;
        command = "${pkgs.systemd}/bin/systemctl suspend";
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
}
