{
  pkgs,
  config,
  lib,
  ...
}: {
  options.greetd = {
    enable = lib.mkEnableOption "enbale tuigreet";
  };

  config = lib.mkIf config.greetd.enable {
    services.greetd = {
      enable = true;
      settings = {
        vt = "next";

        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember-session --cmd uwsm start default";
          user = "greeter";
        };
      };
    };
  };
}
