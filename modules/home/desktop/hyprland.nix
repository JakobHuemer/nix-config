{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {hyprland.enable = lib.mkEnableOption "enables hyprland";};

  config = lib.mkIf config.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      xwayland.enable = true;

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
