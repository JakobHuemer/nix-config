{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.boot.loader.limine.enable {
    boot.loader.limine.style = {
      interface = {
        resolution = "2560x1440";
        helpHidden = true;

        branding = null;
      };

      wallpapers = [
        ../../../assets/img/mc_scenerySunset.jpg
      ];
      wallpaperStyle = "centered";

      graphicalTerminal = {
        palette = "1e1e2e;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4";
        background = "1e1e2e";
        foreground = "cdd6f4";
      };
    };
  };
}
