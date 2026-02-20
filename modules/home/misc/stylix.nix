{
  pkgs,
  inputs,
  config,
  vars,
  lib,
  system,
  ...
}: {
  imports = [
    inputs.stylix.homeModules.stylix
  ];

  options = {
    useStylix = lib.mkEnableOption "enables stylix";
  };

  config = let
    # bgImages = {
    #   nyancat-space-kid-drawn = ../../../assets/img/bg/nyancat-space-kid-drawn.jpg;
    #   nyancat-space-drawn = ../../../assets/img/bg/nyancat-space-drawn.jpg;
    #   windows-10-lock-mc = ../../../assets/img/bg/windows_10_lock_mc.jpg;
    #   planet = ../../../assets/img/bg/planet.jpg;
    #   creeper-fancy = ../../../assets/img/bg/creeper-fancy.jpg;
    #   creeper = ../../../assets/img/bg/creeper.jpg;
    # };
  in
    lib.mkIf config.useStylix {
      stylix = {
        enable = true;

        enableReleaseChecks = false;

        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
        polarity = "dark";

        # disable this in favour of using wpaperd manually
        # image = bgImages.nyancat-space-drawn;

        targets.nixcord.enable = false;

        targets.zen-browser.enable = false;

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

          # emoji = {
          #   package = pkgs.noto-fonts-color-emoji;
          #   name = "Noto Color Emoji";
          # };
          emoji = {
            package = inputs.apple-emoji-linux.packages.${system}.default;
            name = "Apple Color Emoji";
          };
        };

        cursor = {
          name = "Banana";
          package = pkgs.banana-cursor;
          size = 24;
        };
      };
    };
}
