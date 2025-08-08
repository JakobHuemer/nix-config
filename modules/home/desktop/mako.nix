{
  pkgs,
  vars,
  config,
  lib,
  ...
}: {
  options = {mako.enable = lib.mkEnableOption "enable mako";};

  config = lib.mkIf config.mako.enable {
    services.mako = {
      enable = true;

      settings = {
        default-timeout = 5000; # ms
      };
    };
  };
}
