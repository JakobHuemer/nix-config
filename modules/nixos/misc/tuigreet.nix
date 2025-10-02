{
  pkgs,
  config,
  lib,
  ...
}: {
  options.tuigreet = {
    enable = lib.mkEnableOption "enbale tuigreet";
    cmd = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.tuigreet.enable {
    services.greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${config.tuigreet.cmd}";
        user = "greeter";
      };
    };
  };
}
