{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.youtube-music.homeManagerModules.default
  ];

  options.youtube-music.enable = lib.mkEnableOption "enable youtube music";

  config = lib.mkIf config.youtube-music.enable {
    programs.youtube-music = {
      enable = true;

      options = {
        tray = true;
      };
    };
  };
}
