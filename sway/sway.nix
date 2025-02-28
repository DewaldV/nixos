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
        "1:web" = [
          { app_id = "^firefox$"; }
          { app_id = "^brave-browser$"; }
        ];
        "2:term" = [ { app_id = "^foot$"; } ];
        "3:code" = [ { app_id = "^emacs$"; } ];
        "4:chat" = [
          { app_id = "^Slack$"; }
          { app_id = "^discord$"; }
        ];
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
}
