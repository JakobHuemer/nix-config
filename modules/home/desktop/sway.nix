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
    wayland.windowManager.sway = let
      current_monitor = "$(swaymsg -t get_outputs | jq -r '.[] | select(.focused).name')";
    in {
      enable = true;
      config = {
        terminal = "ghostty";
        startup = [];
        focus = {
          followMouse = true;
          mouseWarping = true;
        };
        modifier = "Mod1";
        menu = "dmenu-wl_run -i --monitor \"${current_monitor}\"";
        # menu =
        #   "tofi-drun --output \"$(swaymsg -t get_outputs | jq -r '.[] "
        #   + "| select(.focused).name')\" | xargs swaymsg exec --";
        workspaceAutoBackAndForth = true; # pres $mod + <n> to got there and again to go to previous
        workspaceOutputAssign = [
          {
            output = "HDMI-A-1";
            workspace = "1";
          }
          {
            output = "eDP-1";
            workspace = "2";
          }
        ];

        gaps = {
          smartBorders = "no_gaps";
          smartGaps = true;
        };

        defaultWorkspace = "1";

        keybindings = let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
          lib.mkOptionDefault {"${modifier}+q" = "kill";};

        output = {
          "HDMI-A-1" = {
            position = "0 0";
            resolution = "2560x1440";
            scale = "1";
            scale_filter = "smart";
            adaptive_sync = "off";
            allow_tearing = "yes";
          };
          "eDP-1" = {
            position = "300 1440";
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
