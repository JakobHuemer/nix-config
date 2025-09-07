{
  pkgs,
  config,
  lib,
  vars,
  ...
}: {
  options.acme."fistel.dev".enable = lib.mkEnableOption "enable fistel.dev acme";

  config = let
    restartUnits = ["acme-fistel.dev.service"];
  in
    lib.mkIf config.acme."fistel.dev".enable {
      sops.secrets."acme/fistel.dev/cf_email" = {
        inherit restartUnits;
      };
      sops.secrets."acme/fistel.dev/cf_dns_api_token" = {
        inherit restartUnits;
      };
      sops.secrets."acme/fistel.dev/cf_zone_api_token" = {
        inherit restartUnits;
      };

      sops.templates."cloudflare-creds" = {
        content = ''
          CF_API_EMAIL=${config.sops.placeholder."acme/fistel.dev/cf_email"}
          CF_DNS_API_TOKEN=${config.sops.placeholder."acme/fistel.dev/cf_dns_api_token"}
          CF_ZONE_API_TOKEN=${config.sops.placeholder."acme/fistel.dev/cf_zone_api_token"}
        '';
      };

      security.acme = {
        acceptTerms = true;
        defaults.email = "jakobhuemer2.0+acme@gmail.com";

        certs."${vars.domainName}" = {
          dnsProvider = "cloudflare";

          group = "caddy";
          reloadServices = ["caddy"];

          extraLegoFlags = [
            "--dns.resolvers=1.1.1.1:53"
            "--dns.resolvers=8.8.8.8:53"
          ];

          environmentFile = config.sops.templates."cloudflare-creds".path;

          extraDomainNames = ["photos.${vars.domainName}" "immich.${vars.domainName}"];
        };
      };
    };
}
