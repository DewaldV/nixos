{ pkgs, ... }:

{
  nix.settings = {
    trusted-users = [
      "root"
      "@admin"
    ];

    experimental-features = [
      "nix-command"
      "flakes"
    ];

    netrc-file = "/etc/nix/netrc";
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    nixfmt
    nvd
  ];
}
