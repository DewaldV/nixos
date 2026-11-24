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
          "Hack Nerd Font"
          "Hack"
        ];
        layer = "top";
        position = "top";
        height = 36;
        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];
        modules-center = [ ];
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
            "1:web" = "";
            "2:term" = "";
            "3:code" = "";
            "4:chat" = "";
            "5:zoom" = "";
            "urgent" = "";
            "focused" = "";
            "default" = "";
          };
        };
        "sway/mode" = {
          format = ''<span style="italic">{}</span>'';
        };
        tray.spacing = 10;
        clock = {
          format = "{:%a %d %b %H:%M}";
        };
        temperature = {
          format = " {temperatureC}°C";
          hwmon-path = lib.mkDefault "/sys/class/hwmon/hwmon5/temp1_input";
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
          format = "󰍛 {}%";
        };
        battery = {
          bat = lib.mkDefault "BAT0";
          states = {
            good = 95;
            warning = 25;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁽"
            "󰁿"
            "󰂁"
            "󰁹"
          ];
        };
        network = {
          format-wifi = "  {essid} ({signalStrength}%)";
          format-ethernet = "󰈁 {ifname}: {ipaddr}/{cidr}";
          format-disconnected = "󰈂 Disconnected";
        };
        pulseaudio = {
          format = "{icon}  {volume}%";
          format-bluetooth = "{icon}   {volume}%";
          format-muted = " ";
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
          on-click = "pwvucontrol";
        };
      };
    };

    style = ''
      @define-color base   #1a1a1a;
      @define-color text   #d1d1d1;

      * {
        border: none;
        border-radius: 0;
        font-family: "Hack Nerd Font", "Hack";
        font-size: 16px;
        min-height: 0;
        color: @text;
      }

      window#waybar {
        background: @base;
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

      #clock,
      #battery,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #temperature,
      #tray {
        padding: 0 3px;
        margin: 0 2px;
      }

      #battery,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #temperature {
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
    '';
  };
}
