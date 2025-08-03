{
  pkgs,
  config,
  lib,
  vars,
  host,
  inputs,
  ...
}: {
  options = {sway.enable = lib.mkEnableOption "enabled sway";};

  config = lib.mkIf config.sway.enable {
    wayland.windowManager.sway = {
      enable = true;
      config = {
        terminal = "ghostty";
        startup = [];
        focus = {
          followMouse = true;
          mouseWarping = true;
        };
        modifier = "Mod1";
        # menu = "dmenu-wl_run -i";
        menu =
          "tofi-drun --output \"$(swaymsg -t get_outputs | jq -r '.[] "
          + "| select(.focused).name')\" | xargs swaymsg exec --";

        defaultWorkspace = "1";

        keybindings = let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
          lib.mkOptionDefault {"${modifier}+q" = "kill";};

        output = {
          # "Virtual-1" = {
          #   resolution = "2560x1600";
          #   scale = "1.8";
          #   scale_filter = "smart";
          # };
          "HDMI-A-1" = {
            position = "-300 -1440";
            resolution = "2560x1440";
            scale = "1";
            scale_filter = "smart";
            adaptive_sync = "off";
            allow_tearing = "yes";
          };
          "eDP-1" = {
            position = "0 0";
            resolution = "1920x1080";
            scale = "1";
            scale_filter = "smart";
            adaptive_sync = "off";
            allow_tearing = "yes";
          };
        };

        input = {
          "type:keyboard" = {
            xkb_layout = "de";
            xkb_variant = "nodeadkeys";
            xkb_options = "caps:escape";
            repeat_delay = "200";
            repeat_rate = "32";
          };

          "type:pointer" = {
            accel_profile = "flat";
            pointer_accel = "-0.4";
          };

          "type:touchpad" = {
            natural_scroll = "enabled";
            dwt = "enabled";
            tap = "enabled";
            scroll_factor = "0.2";
            drag_lock = "disabled";
          };
        };
        bars = [
          {
            command = "waybar";
          }
        ];
      };

      extraConfig = "";
    };

    home.packages = with pkgs; [
      ghostty
      dmenu-wayland
      alacritty
      kitty
      foot
      dconf
      jq # for getting focused display
      waybar
    ];

    home.pointerCursor = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
      x11 = {
        enable = true;
        defaultCursor = "Adwaita";
      };
    };
  };
}
