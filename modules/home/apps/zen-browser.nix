{
  pkgs,
  vars,
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  options = {zen.enable = lib.mkEnableOption "enables zen-browser";};

  config = lib.mkIf config.zen.enable {
    programs.zen-browser = {
      enable = true;
    };
  };
}
