{
  lib,
  ...
}:

{
  wayland.windowManager.hyprland.settings.input.kb_layout = lib.mkForce "us";

  wayland.windowManager.hyprland.settings.monitor = lib.mkForce [
    "DP-1,3440x1440@165,auto,1,bitdepth,10,cm,hdr,sdrbrightness,1.20,sdrsaturation,1.20"
    ",preferred,auto,1"
  ];
}
