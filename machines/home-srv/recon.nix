{
  config,
  nixos-private,
  recon,
  ...
}:

{
  imports = [ recon.nixosModules.default ];

  age.secrets.recon-password-hash.file = nixos-private.secrets.recon-password-hash;

  services.recon = {
    enable = true;
    externalUrl = "https://recon.furfaces.net";
    passwordHashFile = config.age.secrets.recon-password-hash.path;
  };
}
