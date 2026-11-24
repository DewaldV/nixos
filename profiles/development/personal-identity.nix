{
  lib,
  nixos-private,
  ...
}:

let
  identity = nixos-private.private.keys.personal;
in
{
  programs.git = {
    signing.key = lib.mkDefault identity.ssh.pub;
    settings.user = {
      name = lib.mkDefault "DewaldV";
      email = lib.mkDefault identity.email;
    };
  };

  programs.ssh.settings."github.com".IdentityFile = lib.mkDefault "~/.ssh/personal-ed25519";

  home.file.".ssh/personal-ed25519".text = identity.ssh.pub;
  home.file.".ssh/allowed_signers".text = lib.mkDefault "${identity.email} ${identity.ssh.pub}";
}
