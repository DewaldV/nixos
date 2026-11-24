{
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

    signing.key = sshPubKey;

    settings = {
      user.email = email;
    };
  };

  programs.ssh = {
    settings = {
      "github.com" = {
        IdentityFile = "~/.ssh/rvu";
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
  home.file.".ssh/allowed_signers".text = ''
    ${email} namespaces="git" ${sshPubKey}
    ${email} namespaces="git" ${sshRSAPubKey}
  '';
}
