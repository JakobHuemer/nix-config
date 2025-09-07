{
  config,
  lib,
  pkgs,
  ...
}: {
  options.doh.enable = lib.mkEnableOption "enable dns over https";

  config = let
    hasIPv6 = false;
    StateDirectory = "dnscrypt-proxy";
    # forwarding_rules = pkgs.writeText "forwarding-rules.txt" ''
    #   ts.net 100.100.100.100
    # '';
  in
    lib.mkIf config.doh.enable {
      networking.resolvconf.useLocalResolver = true;

      services.dnscrypt-proxy2 = {
        enable = true;
        settings = {
          sources.public-resolvers = {
            urls = [
              "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
              "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
            ];
            minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3"; # See https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
            cache_file = "/var/lib/${StateDirectory}/public-resolvers.md";
          };

          # Use servers reachable over IPv6 -- Do not enable if you don't have IPv6 connectivity
          ipv6_servers = hasIPv6;
          block_ipv6 = ! (hasIPv6);

          require_dnssec = true;
          require_nolog = false;
          require_nofilter = true;

          # forwarding_rules = forwarding_rules;

          # If you want, choose a specific set of servers that come from your sources.
          # Here it's from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
          # If you don't specify any, dnscrypt-proxy will automatically rank servers
          # that match your criteria and choose the best one.
          # server_names = [ ... ];
        };
      };

      systemd.services.dnscrypt-proxy2.serviceConfig.StateDirectory = StateDirectory;
    };
}
