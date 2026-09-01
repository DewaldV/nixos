{
  config,
  pkgs,
  ...
}:

let
  caddyWithOvh = pkgs.caddy.withPlugins {
    plugins = [ "github.com/caddy-dns/ovh@v1.1.0" ];
    hash = "sha256-f3alHFzSVez4sCrcSYCX3QTiK0OwaI4LtWTsZ18QCBI=";
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
