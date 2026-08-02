{ pkgs, pkgs-unstable, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    github-cli
    pkgs-unstable.codex
    pkgs-unstable.opencode
    pkgs-unstable.zeroclaw
  ];

  users.users.claw = {
    isNormalUser = true;
    createHome = true;
  };

  services.zeroclaw.instances.main = {
    package = pkgs-unstable.zeroclaw;
    settings = {
      gateway = {
        host = "0.0.0.0";
        port = 42617;
        allow_public_bind = true;
      };

      providers.models.openai.codex = {
        model = "gpt-5.4";
        wire_api = "responses";
        requires_openai_auth = true;
      };

      agents.main = {
        model_provider = "openai.codex";
        risk_profile = "supervised";
      };

      risk_profiles.supervised.level = "supervised";
    };
  };

  networking.firewall.allowedTCPPorts = [
    42617 # ZeroClaw gateway
  ];
}
