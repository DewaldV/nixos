{
  config,
  pkgs,
  ...
}:

let
  caddyWithOvh = pkgs.caddy.withPlugins {
    plugins = [ "github.com/caddy-dns/ovh@v1.1.0" ];
    hash = "sha256-VbOupg6fDzk2CRknLmdgP+BpgBMDJ/kUr0V46smIM8U=";
  };
in
{
  services.caddy = {
    enable = true;
    package = caddyWithOvh;
    openFirewall = true;
    globalConfig = ''
      email dv@dewaldv.com
      acme_dns
      import ${config.age.secrets.home-srv-ovh-dns.path}
    '';
  };

  # caddy user needs to read the agenix-decrypted secret at runtime
  age.secrets.home-srv-ovh-dns.owner = "caddy";
}
