{
  pkgs,
  pkgs-stable,
  lib,
  config,
  vars,
  system,
  inputs,
  ...
}: {
  options = {
    hyprland.enable = lib.mkEnableOption "enables hyprland";
  };

  config = lib.mkIf config.hyprland.enable {
    programs.xwayland.enable = true;

    xdg.portal.extraPortals = [
      inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland
    ];

    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;

      package = inputs.hyprland.packages.${system}.hyprland;
      portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
    };

    security.pam.services.hyprlock = {};

    # for wluma
    services.upower.enable = true;

    home-manager.users.${vars.user} = {
      home.packages = with pkgs; [
        waybar
        wl-clipboard
        ghostty
        dmenu-wayland
        alacritty
        kitty
        foot
        dconf
        jq # for getting focused display

        # hyprpaper
        hypridle

        # notification daemon
        libnotify

        # media key utilities
        brightnessctl
        playerctl
      ];

      services.hyprpolkitagent = {
        enable = true;
      };

      services.wpaperd = {
        enable = true;
        package = pkgs.custom.wpaperd;

        settings = let
          base = {
            path = ../../../assets/img/bg/nyancat-space-drawn.jpg;
            mode = "center";
          };
        in {
          "any" =
            base
            // {
              offset = 1.0;
            };

          "DP-1" =
            base
            // {
              path = ../../../assets/img/keyboard-layout.png;
            };

          "eDP-1" =
            base
            // {
              path = ../../../assets/img/bg/moon-and-earth-from-orion.jpg;
              # duration = "2m";
              # sorting = "random";

              # assign to group 1 so all goup 1 share the same random wallpaper
              # group = 1;
            };
        };
      };

      services.hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "pidof hyprlock || hyprlock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
            ignore_dbus_inhibit = false;
            ignore_systemd_inhibit = false;
          };

          listener = [
            # {
            #   timeout = 300;
            #   on-timeout = "loginctl lock-session";
            # }
            # {
            #   timeout = 300;
            #   on-timeout = "hyprctl dispatch dpms off";
            #   on-resume = "hyprctl dispatch dpms on";
            # }
          ];
        };
      };

      # ambient light sensor -> screen brightness
      services.wluma.enable = true;
      services.wluma.package = inputs.wluma.defaultPackage.${system};

      wayland.windowManager.hyprland = {
        enable = true;

        configType = "lua";

        package = null;
        portalPackage = null;

        xwayland.enable = true;

        systemd.enable = false;

        extraLuaFiles = {
          main = ../../../conf/hypr/hyprland.lua;

          hyprland_config = {
            content = ../../../conf/hypr/hyprland_config.lua;
            autoLoad = false;
          };

          toggle_touchpad = {
            content = ../../../conf/hypr/toggle_touchpad.lua;
            autoLoad = false;
          };
        };
      };

      programs.hyprlock = {
        enable = true;

        settings = {
          general = {
            hide_cursor = false;
            ignore_empty_input = true;
            no_fade_in = true;
            no_fade_out = true;
            grace = 0;
            disable_loading_bar = true;
            fractional_scaling = 1;
          };

          input-field = pkgs.lib.mkForce [
            {
              monitor = "";
              size = "250, 60";
              outline_thickness = 2;
              dots_size = 0.2;
              dots_spacing = 0.35;
              dots_center = true;
              outer_color = "rgba(0, 0, 0, 0)";
              inner_color = "rgba(0, 0, 0, 0.2)";
              font_color = "$foreground";
              fade_on_empty = false;
              rounding = -1;
              check_color = "rgb(204, 136, 34)";
              placeholder_text = "<i><span foreground=\"##cdd6f4\">Input Password...</span></i>";
              hide_input = false;
              position = "0, -200";
              halign = "center";
              valign = "center";
            }
          ];

          background = pkgs.lib.mkForce [
            {
              monitor = "DP-1";
              path = "${../../../assets/img/bg/funny-cat.png}";
              blur_passes = 2;
              contrast = 1;
              brightness = 0.5;
              vibrancy = 0.2;
              vibrancy_darkness = 0.2;
            }
            {
              monitor = "DP-2";
              path = "${../../../assets/img/bg/funny-cat.png}";
              blur_passes = 2;
              contrast = 1;
              brightness = 0.5;
              vibrancy = 0.2;
              vibrancy_darkness = 0.2;
            }
            {
              monitor = "eDP-1";
              path = "${../../../assets/img/bg/funny-cat.png}";
              blur_passes = 2;
              contrast = 1;
              brightness = 0.5;
              vibrancy = 0.2;
              vibrancy_darkness = 0.2;
            }
          ];

          label = [
          ];
        };
      };
    };
  };
}
