{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {tuigreet.enable = lib.mkEnableOption "enbale tuigreet";};

  config = lib.mkIf config.tuigreet.enable {
    services.greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };
}
