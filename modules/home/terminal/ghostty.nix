{ lib, config, pkgs, vars, ... }:

{

  options = { ghostty.enable = lib.mkEnableOption "enable ghostty"; };

  config = lib.mkIf config.ghostty.enable {

    home.file.".config/ghostty/config".source = ../../../conf/ghostty/config;
  };
}
