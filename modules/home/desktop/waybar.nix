{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    waybar.enable = lib.mkEnableOption "enables waybar";
  };

  config = lib.mkIf config.waybar.enable {

    home.packages = with pkgs; [
      waybar
    ];

    home.file.".config/waybar" = {
      source = ../../../conf/waybar;
      recursive = true;
    };
    # programs.waybar = {
    #   enable = true;
    #
    #   settings = {
    #     mainBar = {
    #       position = "top";
    #       height = 30;
    #
    #       modules-left = ["sway/workspaces"];
    #       modules-center = ["sway/window"];
    #       modules-right = [
    #         "mpd"
    #         "temperature"
    #         "clock"
    #       ];
    #
    #       "sway/workspaces" = {
    #         disable-scroll = true;
    #         all-outputs = true;
    #       };
    #     };
    #   };
    # };
  };
}
