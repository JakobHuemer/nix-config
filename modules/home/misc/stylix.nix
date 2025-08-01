{
  pkgs,
  inputs,
  config,
  vars,
  lib,
  ...
}: {
  imports = [
    inputs.stylix.homeModules.stylix
  ];

  options = {
    useStylix = lib.mkEnableOption "enables stylix";
  };

  config = lib.mkIf config.useStylix {
    stylix = {
      enable = true;

      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      polarity = "dark";

      image = ../../../assets/img/bg/planet.jpg;

      targets.nixcord.enable = false;

      fonts = {
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };

        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };

        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrains Mono";
        };

        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
      };
    };
  };
}
