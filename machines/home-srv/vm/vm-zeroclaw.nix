{
  config,
  nixos-private,
  pkgs-unstable,
  zeroclaw,
  ...
}:

{
  microvm.vms.vm-zeroclaw = {
    specialArgs = {
      beszelAgentEnvironmentFile = config.age.secrets.beszel-agent-env.path;
      inherit
        nixos-private
        pkgs-unstable
        zeroclaw
        ;
    };
    config = import ../../vm-zeroclaw/microvm.nix;
  };
}
