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
        sopsFile = ../../../secrets/cloudflare-creds.yaml;
      };
      sops.secrets."acme/fistel.dev/cf_dns_api_token" = {
        restartUnits = restartUnits ++ ["cloudflare-dyndns"];
        sopsFile = ../../../secrets/cloudflare-creds.yaml;
      };
      sops.secrets."acme/fistel.dev/cf_zone_api_token" = {
        inherit restartUnits;
        sopsFile = ../../../secrets/cloudflare-creds.yaml;
      };

      sops.templates."cloudflare-creds" = {
        content = ''
          CF_API_EMAIL=${config.sops.placeholder."acme/fistel.dev/cf_email"}
          CF_DNS_API_TOKEN=${config.sops.placeholder."acme/fistel.dev/cf_dns_api_token"}
          CF_ZONE_API_TOKEN=${config.sops.placeholder."acme/fistel.dev/cf_zone_api_token"}
        '';
      };

      sops.templates."cloudflare-dyndns" = {
        content = ''
          ${config.sops.placeholder."acme/fistel.dev/cf_dns_api_token"}
        '';
      };

      services.cloudflare-dyndns = {
        enable = true;
        apiTokenFile = config.sops.templates."cloudflare-dyndns".path;

        domains = [
          "fistel.dev"
          "*.fistel.dev"
        ];

        proxied = false;
        ipv4 = true;
        ipv6 = false;
      };

      systemd.services."acme-order-renew-example.com" = {
        after = ["cloudflare-dyndns.service"];
        wants = ["cloudflare-dyndns.service"];
      };

      systemd.services."acme-example.com" = {
        after = ["cloudflare-dyndns.service"];
        wants = ["cloudflare-dyndns.service"];
      };

      security.acme = {
        acceptTerms = true;
        defaults.email = "jakobhuemer2.0+acme@gmail.com";

        certs."fistel.dev" = {
          dnsProvider = "cloudflare";
          # webroot = "/var/lib/acme/acme-challenge/";

          domain = "fistel.dev";

          extraLegoFlags = [
            "--dns.resolvers=1.1.1.1:53"
            "--dns.resolvers=8.8.8.8:53"
          ];

          environmentFile = config.sops.templates."cloudflare-creds".path;

          extraDomainNames = map (str: "${str}.${vars.domainName}") [
            "*"
            "*.ts"
          ];
        };
      };
    };
}
