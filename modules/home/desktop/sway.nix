{ pkgs, config, lib, vars, host, inputs, ... }:

{

  options = { sway.enable = lib.mkEnableOption "enabled sway"; };

  config = lib.mkIf config.sway.enable {
    wayland.windowManager.sway = {
      enable = true;
      config = rec {
      	terminal = "foot";
	startup = [
	  { command = "firefox"; }
	];
	focus = {
          followMouse = true;
	  mouseWarping = true;
	};
	modifier = "Mod1";
	menu = "dmenu-wl_run -i";

	keybindings = let
	  modifier = config.wayland.windowManager.sway.config.modifier;
	in lib.mkOptionDefault {
          "${modifier}+Shift+q" = "kill";
	};

	output = {
          "Virtual-1" = {
            resolution = "2560x1600";
	    scale = "1.8";
            scale_filter = "smart";
	  };
	};

	input = {
          "type:keyboard" = {
            xkb_layout = "de";
            xkb_variant = "nodeadkeys";
            xkb_options = "lv3:ralt_switch";
	  };
	};
      };

      extraConfig = ''
      '';
    };

    home.packages = [
      pkgs.ghostty
      pkgs.dmenu-wayland
      pkgs.alacritty
      pkgs.kitty
      pkgs.foot
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
