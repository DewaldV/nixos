{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  services.ollama = {
    enable = true;
    package = pkgs-unstable.ollama-rocm;
    acceleration = "rocm";
  };
}
