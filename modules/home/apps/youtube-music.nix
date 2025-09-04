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
          enabled = true;
          blocker = "In player";
        };

        blur-nav-bar.enabled = true;

        bypass-age-restrictions.enabled = true;

        captions-selector.enabled = true;

        crossfade = {
          enabled = true;
        };

        exponential-volume.enabled = true;

        in-app-menu.enabled = false;

        performance-improvement.enabled = true;

        precise-volume = {
          enabled = true;
          steps = 2;
        };

        synced-lyrics = {
          enabled = true;
        };

        unobtrusive-player.enabled = true;

        video-toggle = {
          enabled = true;
          align = "middle";
        };
      };
    };
  };
}
