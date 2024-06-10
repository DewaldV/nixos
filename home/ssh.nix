{ config, pkgs, ... }:

{
  programs.ssh = {
    compression = true;
    enable = true;

    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        identityFile = "~/.ssh/personal-ed25519";
        identitiesOnly = true;
        extraOptions = {
          IdentityAgent = "~/.1password/agent.sock";
        };
      };
    };
  };

  home.file.".ssh/personal-ed25519".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGifLJfVQ78SU0tpXu1A8W+0BLANiprEnYFtDWTlBlTv";

  home.file.".ssh/allowed_signers".text = "dewald.viljoen@pm.me ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGifLJfVQ78SU0tpXu1A8W+0BLANiprEnYFtDWTlBlTv";
}
