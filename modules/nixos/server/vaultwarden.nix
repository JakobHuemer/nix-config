{
  pkgs,
  config,
  lib,
  vars,
  ...
}: {
  options.vaultwarden.enable = lib.mkEnableOption "enable vaultwarden";

  config = lib.mkIf config.vaultwarden.enable {
    services.vaultwarden = {
      enable = true;
      backupDir = "/var/lib/backup-vaultwarden";

      config = {
        DOMAIN = "https://bitwarden.${vars.domainName}";
        SINGUPS_ALLOWED = true;

        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;

        # SMTP_HOST = "127.0.0.1";
        # SMTP_PORT = 25;
        # SMTP_SSL = false;
      };
    };

    services.caddy = lib.mkIf config.services.caddy.enable {
      virtualHosts."bitwarden.${vars.domainName}" = {
        extraConfig = ''
          tls /var/lib/acme/fistel.dev/fullchain.pem /var/lib/acme/fistel.dev/key.pem

          encode zstd gzip

          reverse_proxy :${toString config.services.vaultwarden.config.ROCKET_PORT} {
              header_up X-Real-IP {remote_host}
          }
        '';
      };
    };
  };
}
