{ config, pkgs, lib, ... }:
let
  email = "dewald.viljoen@rvu.co.uk";
  sshPubKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMYV7aiA/Iu1NJWA/i3NB/eazTJafGSqrm7LCPaIzwQ8";
in {
  programs.git = {
    userEmail = lib.mkForce email;
    signing.key = lib.mkForce sshPubKey;
  };

  programs.ssh = {
    matchBlocks = {
      "github.com" = { identityFile = lib.mkForce "~/.ssh/rvu"; };
    };
  };

  home.file.".ssh/rvu".text = sshPubKey;
  home.file.".ssh/allowed_signers".text =
    lib.mkForce ''${email} namespaces="git" ${sshPubKey}'';
}
