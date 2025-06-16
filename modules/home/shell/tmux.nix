{ lib, config, ... }:

{

  options = { tmux.enable = lib.mkEnableOption "enables tmux"; };

  config = lib.mkIf config.tmux.enable {

    programs.tmux = {
      enable = true;

      tmuxp.enable = true;
    };
  };
}
