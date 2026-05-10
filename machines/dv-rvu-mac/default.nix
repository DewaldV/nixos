{ ... }:

{
  imports = [ ../../profiles/nix/darwin.nix ];

  # https://daiderd.com/nix-darwin/manual/index.html#opt-system.stateVersion
  system.stateVersion = 6;

  programs.zsh.enable = true;
}
