{
  pkgs,
  vars,
  config,
  lib,
  ...
}: {
  options = {
    mako.enable = lib.mkEnableOption "enable mako";
  };

  config = lib.mkIf config.mako.enable {
    services.mako = {
      enable = true;

      settings = {
        default-timeout = 5000; # ms
        icons = true;
        "icon-path" =
          "${config.gtk.iconTheme.package}"
          + "/share/icons/${config.gtk.iconTheme.name}";
      };
    };

    systemd.user.sessionVariables.GDK_PIXBUF_MODULE_FILE = "${pkgs.librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache";
  };
}
