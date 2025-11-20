{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  # Ollama LLM service with ROCm acceleration
  services.ollama = {
    enable = true;
    package = pkgs-unstable.ollama-rocm;
    acceleration = "rocm";
  };
}
