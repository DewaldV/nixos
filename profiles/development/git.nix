{
  config,
  pkgs,
  nixos-private,
  ...
}:
{

  programs.git = {
    enable = true;

    signing = {
      key = nixos-private.private.keys.personal.ssh.pub;
      signByDefault = true;
    };

    settings = {
      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        lg1 = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
        lg2 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all";
        pr = "pull --rebase --prune";
        at = "for-each-ref --sort=taggerdate --format '%(align:20,left)%(taggerdate:format:%Y-%m-%d  %H:%M)%(end)%(align:18,left)%(tag)%(end)%(align:25,left)%(taggername)%(end)%(subject)' refs/tags";
      };

      user = {
        name = "DewaldV";
        email = "dewald.viljoen@pm.me";
      };

      color.ui = "auto";
      core.autocrlf = "input";

      gpg.format = "ssh";
      gpg."ssh" = {
        program = "op-ssh-sign";
        allowedSignersFile = "/home/dewaldv/.ssh/allowed_signers";
      };
      init.defaultBranch = "main";
      pull.rebase = true;

      url."ssh://git@github.com".insteadOf = "https://github.com";
    };
  };
}
