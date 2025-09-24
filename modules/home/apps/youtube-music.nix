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

        language = "en";

        removeUpgradeButton = true;

        resumeOnStart = false;

        # TODO: Add a nice theme
        themes = [];
      };

      plugins = {
        adblocker = {
          enable = true;
          blocker = "In player";
        };

        blur-nav-bar.enable = true;

        bypass-age-restrictions.enable = true;

        captions-selector.enable = true;

        crossfade = {
          enable = true;
        };

        exponential-volume.enable = true;

        in-app-menu.enable = false;

        performance-improvement.enable = true;

        precise-volume = {
          enable = true;
          steps = 2;
        };

        synced-lyrics = {
          enable = true;
        };

        unobtrusive-player.enable = true;

        video-toggle = {
          enable = true;
          align = "middle";
        };
      };
    };
  };
}
