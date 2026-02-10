{
  config,
  pkgs,
  lib,
  nixos-private,
  ...
}:
let
  email = nixos-private.private.keys.rvu.email;
  sshPubKey = nixos-private.private.keys.rvu.ssh.pub;
  sshRSAPubKey = nixos-private.private.keys.rvu.ssh-rsa.pub;
in
{
  programs.git = {

    signing.key = lib.mkForce sshPubKey;

    settings = {
      user.email = lib.mkForce email;
      gpg."ssh" = {
        program = lib.mkForce "/opt/1Password/op-ssh-sign";
      };
    };

    includes = [
      {
        condition = "gitdir:~/Projects/tempcover";
        contents = {
          user = {
            signingKey = sshRSAPubKey;
          };
        };
      }
    ];
  };

  programs.ssh = {
    matchBlocks = {
      "github.com" = {
        identityFile = lib.mkForce "~/.ssh/rvu";
      };
      "ssh.dev.azure.com" = {
        hostname = "ssh.dev.azure.com";
        identitiesOnly = true;
        identityFile = "~/.ssh/rvu-rsa";
        extraOptions = {
          IdentityAgent = "~/.1password/agent.sock";
        };
      };
    };
  };

  home.file.".ssh/rvu".text = sshPubKey;
  home.file.".ssh/rvu-rsa".text = sshRSAPubKey;
  home.file.".ssh/allowed_signers".text = lib.mkForce ''
    ${email} namespaces="git" ${sshPubKey}
    ${email} namespaces="git" ${sshRSAPubKey}
  '';
}
