{
  lib,
  pkgs,
  pkgs-unstable,
  nixos-private,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    git
    github-cli
    pkgs-unstable.codex
    pkgs-unstable.opencode
    pkgs-unstable.zeroclaw
  ];

  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";

  users.users = {
    root.openssh.authorizedKeys.keys = [
      nixos-private.private.keys.personal.ssh.pub
    ];
  };

  services.zeroclaw.instances.main = {
    package = pkgs-unstable.zeroclaw;
    settings = {
      gateway = {
        host = "0.0.0.0";
        port = 42617;
        allow_public_bind = true;
        allow_remote_admin = true;
      };

      runtime.shell = "${pkgs.bash}/bin/sh";

      providers.models.openai.default = {
        model = "gpt-5.6-terra";
        wire_api = "responses";
        requires_openai_auth = true;
      };

      agents.main = {
        model_provider = "openai.default";
        risk_profile = "supervised";
        runtime_profile = "default";
      };

      risk_profiles.supervised.level = "supervised";
      runtime_profiles.default = { };
    };
  };

  networking.firewall.allowedTCPPorts = [
    42617 # ZeroClaw gateway
  ];
}
