{
  pkgs,
  config,
  lib,
  vars,
  ...
}: {
  options.immich.enable = lib.mkEnableOption "enable immich server";

  config = let
    port = 2283;
  in
    lib.mkIf config.immich.enable {
      services.immich = {
        enable = true;
        inherit port;
        host = "127.0.0.1";
      };

      services.caddy = lib.mkIf config.services.caddy.enable {
        virtualHosts."immich.${vars.domainName}" = {
          extraConfig = ''
            tls /var/lib/acme/fistel.dev/fullchain.pem /var/lib/acme/fistel.dev/key.pem
            reverse_proxy 127.0.0.1:${toString port}
          '';

          serverAliases = ["photos.fistel.dev"];
        };
      };

      users.users.immich.extraGroups = [
        "video"
        "render"
      ];
    };
}
