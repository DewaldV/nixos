{ ... }:

{
  imports = [
    # Profiles
    ../../profiles/machines/vm
    ../../profiles/docker

    # Machine-specific config
    ./configuration.nix
    ./openclaw.nix
  ];
}
