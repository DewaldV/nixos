{
  config,
  pkgs,
  lib,
  ...
}:
let
  email = "dewald.viljoen@rvu.co.uk";
  sshPubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMYV7aiA/Iu1NJWA/i3NB/eazTJafGSqrm7LCPaIzwQ8";
  sshRSAPubKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCjuu4vEU3rcsKa11Ro5+w+Zrl3flqIQ03ZsfRDD9+FV6rQ2X9NnaAgclYmFSQ3lCJrw7vpiQ76FK2W8tCX6P7m62Qg2PKMFFHqXfmY4G8muJGFgSWB1lCcJpY7naTIkXILs0wjdzKr5VHf8nUsQUrvGKhd+VgXUeLKubgxjKLonk7BjObpedle16ONY8NGQJwL0doWXNDVcQq+gtRrQHw4YW6YwUMy+wGsAD+lKw3wr2/9BcmB9lVS5CO+LXUgjfbsfoox4r/KMkI1CJzzRMnwJUFKToCpTfkC2Grq9XZ89PEJOwYylsDzMFIVXE1cpm5/xcND6PyE5mgFRI+V7DQ3";
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
