{
  system,
  vars,
  pkgs,
  lib,
  config,
  ...
}: {
  options.custom.espanso = {
    enable = lib.mkEnableOption "espanso";
  };

  config = let
    cfg = config.custom.espanso;
  in
    lib.mkIf cfg.enable {
      services.espanso = {
        enable = true;
        package = pkgs.espanso-wayland;
      };

      environment.systemPackages = with pkgs; [
        wlrctl
      ];

      home-manager.users.${vars.user} = {
        xdg.configFile."espanso/config/default.yaml".source = (pkgs.formats.yaml {}).generate "default.yaml" {
          keyboard_layout = {
            layout = "de";
            variant = "nodeadkeys";
            optoins = "grp:win_space_toggle";
          };
        };

        xdg.configFile."espanso/match/base.yaml".source = (pkgs.formats.yaml {}).generate "base.yaml" {
          matches = [
            {
              trigger = ":espanso";
              replace = "Hi there!";
            }
            {
              trigger = "dont";
              replace = "don't";
              right_word = true;
            }
            {
              trigger = "doesnt";
              replace = "doesn't";
              right_word = true;
            }
            {
              trigger = "youre";
              replace = "you're";
              right_workd = true;
            }
            {
              trigger = "youll";
              replace = "you'll";
              right_word = true;
            }
            {
              trigger = "commt";
              replace = "commit";
              word = true;
            }
          ];
        };
      };
    };
}
