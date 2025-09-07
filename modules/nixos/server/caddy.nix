{
  pkgs,
  config,
  lib,
  ...
}: {
  options.caddy.enable = lib.mkEnableOption "enable caddy";

  config = lib.mkIf config.caddy.enable {
    networking.firewall.allowedTCPPorts = [80 443];

    services.caddy = {
      enable = true;
      globalConfig = ''
      '';

      virtualHosts.":80, :443" = {
        extraConfig = ''
          respond "Hello, World!"
        '';
      };
    };
  };
}
