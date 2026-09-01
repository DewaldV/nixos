{ ... }:

{
  security.sudo.extraRules = [
    {
      users = [ "dewaldv" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
