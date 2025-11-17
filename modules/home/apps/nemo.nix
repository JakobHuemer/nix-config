{
  pkgs,
  config,
  lib,
  vars,
  ...
}: {
  options.nemo.enable = lib.mkEnableOption "enable nemo";

  config = lib.mkIf config.nemo.enable {
    xdg.desktopEntries.nemo = {
      name = "Nemo";
      exec = "${pkgs.nemo-with-extensions}/bin/nemo";
    };
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = ["nemo.desktop"];
        "application/x-gnome-saved-search" = ["nemo.desktop"];
      };
    };

    dconf = {
      settings = {
        "org/cinnamon/desktop/applications/terminal" = {
          exec = "${vars.terminal}";
        };
      };
    };
  };
}
