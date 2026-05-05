{ ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$modifier" = "SUPER";
      "$terminal" = "foot";
      "$menu" = "fuzzel";

      exec-once = [
        "waybar"
        "mako"
      ];

      input = {
        kb_layout = "gb";
        follow_mouse = 1;
      };

      general = {
        gaps_in = 3;
        gaps_out = 6;
        border_size = 1;
        layout = "dwindle";
      };

      decoration = {
        rounding = 0;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      monitor = [ ",preferred,auto,1" ];

      bind = [
        "$modifier, Return, exec, $terminal"
        "$modifier, D, exec, $menu"
        "$modifier, Q, killactive"
        "$modifier, F, fullscreen"
        "$modifier SHIFT, C, exec, hyprctl reload"
        "$modifier SHIFT, E, exit"

        "$modifier, 1, workspace, 1"
        "$modifier, 2, workspace, 2"
        "$modifier, 3, workspace, 3"
        "$modifier, 4, workspace, 4"
        "$modifier, 5, workspace, 5"
        "$modifier SHIFT, 1, movetoworkspace, 1"
        "$modifier SHIFT, 2, movetoworkspace, 2"
        "$modifier SHIFT, 3, movetoworkspace, 3"
        "$modifier SHIFT, 4, movetoworkspace, 4"
        "$modifier SHIFT, 5, movetoworkspace, 5"

        "$modifier CTRL, right, moveworkspacetomonitor, current r"
        "$modifier CTRL, left, moveworkspacetomonitor, current l"
        "$modifier CTRL, up, moveworkspacetomonitor, current u"
        "$modifier CTRL, down, moveworkspacetomonitor, current d"

        "$modifier, P, exec, grimshot save output"
        "$modifier CTRL, P, exec, grimshot save window"
        "$modifier SHIFT, P, exec, grimshot copy area"
        "$modifier SHIFT CTRL, P, exec, grimshot copy window"
      ];

      bindl = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 1%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];
    };
  };
}
