{ config, lib, pkgs, hyprland, vars, host, ... }:

let
  colors = "TODO: here colors path";
in  
with lib;
with host;
{
  options = {
    hyprland = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    }:
  }:

  config mkIf (config.hyprland.enable) {
    # hyprland config etc to get hyprland running...
    # TODO: hyprland here

    programs.hyprland = {
      enable = true;
      package = hyprland.packages.${pkgs.system}.hyprland;
    }:

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${config.programs.hyprland.package}/bin/Hyprland";
          user = "${vars.user}";
        };
      };
      vt = 7;
    }:
  };
}
