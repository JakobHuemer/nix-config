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
    # home.file.".config/hypr" = {
    #   source = ../../../conf/hypr;
    #   recursive = true;
    # };

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

      systemd.enable = true;

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
            monitor = "HDMI-A-1";
            path = "${../../../assets/img/bg/funny-cat.png}";
            blur_passes = 2;
            contrast = 1;
            brightness = 0.5;
            vibrancy = 0.2;
            vibrancy_darkness = 0.2;
          }
        ];

        label = [
          {
            monitor = "";
            text = "cmd[update:1000] echo \"$(date +'%A, %B %d')\"";
            color = "rgba(242, 243, 244, 0.75)";
            font_size = 22;
            font_family = "JetBrains Mono";
            position = "0, 300";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "";
            text = "cmd[update:1000] echo \"$(date +'%I:%M:%S')\"";
            color = "rgba(242, 243, 244, 0.75)";
            font_size = 95;
            font_family = "JetBrains Mono Extrabold";
            position = "0, 200";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "";
            text = "cmd[update:1000] echo \"$(:/home/justin/Documents/Scripts/whatsong.sh)\"";
            color = "$foreground";
            font_size = 18;
            font_family = "Metropolis Light, Font Awesome 6 Free Solid";
            position = "0, 50";
            halign = "center";
            valign = "bottom";
          }
          {
            monitor = "";
            text = "cmd[update:1000] echo \"$(:/home/justin/Documents/Scripts/whoami.sh)\"";
            color = "$foreground";
            font_size = 14;
            font_family = "JetBrains Mono";
            position = "0, -10";
            halign = "center";
            valign = "top";
          }
          {
            monitor = "";
            text = "cmd[update:1000] echo \"$(:/home/justin/Documents/Scripts/battery.sh)\"";
            color = "$foreground";
            font_size = 24;
            font_family = "JetBrains Mono";
            position = "-90, -10";
            halign = "right";
            valign = "top";
          }
          {
            monitor = "";
            text = "cmd[update:1000] echo \"$(:/home/justin/Documents/Scripts/network-status.sh)\"";
            color = "$foreground";
            font_size = 24;
            font_family = "JetBrains Mono";
            position = "-20, -10";
            halign = "right";
            valign = "top";
          }
        ];

        image = [
          {
            monitor = "";
            path = "/home/justin/Pictures/profile_pictures/justin_square.png";
            size = 100;
            border_size = 2;
            border_color = "$foreground";
            position = "0, -100";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "";
            path = "/home/justin/Pictures/profile_pictures/hypr.png";
            size = 75;
            border_size = 2;
            border_color = "$foreground";
            position = "-50, 50";
            halign = "right";
            valign = "bottom";
          }
        ];
      };
    };
  };
}
