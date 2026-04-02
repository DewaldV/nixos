{ ... }:

{
  nixpkgs.config.allowUnfree = true;
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

  # https://daiderd.com/nix-darwin/manual/index.html#opt-system.stateVersion
  system.stateVersion = 6;

  programs.zsh.enable = true;
}
