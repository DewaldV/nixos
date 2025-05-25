{ config, pkgs, ... }:

{
  programs.mangohud = {
    enable = true;

    settings = {
      toggle_hud = "Shift_R+F12";

      fps = true;
      frametime = true;
      frame_timing = true;
      throttling_status = true;
      vulkan_driver = true;

      text_outline = true;

      cpu_stats = true;
      cpu_temp = true;
      cpu_power = true;

      gpu_stats = true;
      gpu_temp = true;
      gpu_power = true;
      gpu_voltage = true;
    };
  };
}
