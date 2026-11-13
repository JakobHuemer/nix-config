{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.boot.loader.limine.enable {
    environment.systemPackages = with pkgs; [
      sbctl
    ];

    boot.loader.limine = {
      secureBoot = {
        enable = true;
      };

      style = {
        interface = {
          resolution = "2560x1440";
          helpHidden = true;

          branding = null;
        };

        wallpapers = lib.mkForce [
          ../../../assets/img/mc_scenerySunset.jpg
        ];
        wallpaperStyle = lib.mkForce "centered";

        graphicalTerminal = {
          palette = lib.mkForce "1e1e2e;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4";
          background = lib.mkForce null;
          brightBackground = lib.mkForce null;
        };
      };
    };
  };
}
