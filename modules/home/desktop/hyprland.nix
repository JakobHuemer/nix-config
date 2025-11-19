{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    hyprland.enable = lib.mkEnableOption "enables hyprland";
  };

  config = lib.mkIf config.hyprland.enable {
    home.file.".config/hypr" = {
      source = ../../../conf/hypr;
      recursive = true;
    };

    home.packages = with pkgs; [
      # hyprland
      waybar
      wl-clipboard
      ghostty
      dmenu-wayland
      alacritty
      kitty
      foot
      dconf
      jq # for getting focused display
    ];

    # home.pointerCursor = {
    #   name = "Adwaita";
    #   package = pkgs.adwaita-icon-theme;
    #   size = 24;
    #   x11 = {
    #     enable = true;
    #     defaultCursor = "Adwaita";
    #   };
    # };

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;

      extraConfig = builtins.readFile ../../../conf/hypr/hyprland.conf;

      # settings = {
      #   "$mod" = "SUPER";
      #   bind =
      #     [
      #       "$mod, F, exec, firefox"
      #     ]
      #     ++ (builtins.concatLists (
      #       builtins.genList (
      #         i:
      #         let
      #           ws = i + 1;
      #         in
      #         [
      #           "$mod, code:1${toString i}, workspace, ${toString ws}"
      #           "$mod SHIFT, code:1${toString i}, movetoworkspace ${toString ws}"
      #         ]
      #       ) 9
      #     ));
      # };
    };
  };
}
