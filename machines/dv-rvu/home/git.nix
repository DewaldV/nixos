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
    settings = {
      "github.com" = {
        IdentityFile = lib.mkForce "~/.ssh/rvu";
      };
      "ssh.dev.azure.com" = {
        HostName = "ssh.dev.azure.com";
        IdentitiesOnly = true;
        IdentityFile = "~/.ssh/rvu-rsa";
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
