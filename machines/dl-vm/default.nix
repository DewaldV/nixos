{ ... }:

{
  imports = [
    # Profiles
    ../../profiles/machines/vm

    # Machine-specific config
    ./configuration.nix
    ./transmission.nix
    ./vpn.nix
  ];
}
