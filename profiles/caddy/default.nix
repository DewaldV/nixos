{
  config,
  pkgs,
  ...
}:

let
  caddyWithOvh = pkgs.caddy.withPlugins {
    plugins = [ "github.com/caddy-dns/ovh@v1.1.0" ];
    hash = "sha256-VJgAmT1q1wcqt7o7HrK2+ONfZrfI/QW2v3d6ZSMh718=";
  };
in
{
  services.caddy = {
    enable = true;
    package = caddyWithOvh;
    globalConfig = ''
      email dv@dewaldv.com
      acme_dns
      import ${config.age.secrets.home-srv-ovh-dns.path}
    '';
  };

  # caddy user needs to read the agenix-decrypted secret at runtime
  age.secrets.home-srv-ovh-dns.owner = "caddy";
}
