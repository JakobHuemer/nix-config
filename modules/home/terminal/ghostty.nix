{ lib, pkgs, vars, ...}:

{
  home.file.".config/ghostty/config".source = ../../../conf/ghostty/config;
}
