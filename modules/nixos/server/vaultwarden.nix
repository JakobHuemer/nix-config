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
      backupDir = "/var/lib/vaultwarden/backup";
    };
  };
}
