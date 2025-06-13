{ pkgs, lib, config, ... }:

{
  programs.tmux = {
    enable = true;

    tmuxp.enable = true;
  };

}
