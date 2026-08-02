{
  nixos-private,
  pkgs-unstable,
  zeroclaw,
  ...
}:

{
  microvm.autostart = [ "vm-zeroclaw" ];

  microvm.vms.vm-zeroclaw = {
    specialArgs = {
      inherit
        nixos-private
        pkgs-unstable
        zeroclaw
        ;
    };
    config = import ../../vm-zeroclaw/microvm.nix;
  };
}
