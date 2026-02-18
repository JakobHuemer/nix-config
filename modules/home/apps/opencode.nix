{
  pkgs,
  lib,
  config,
  ...
}: {
  options.opencode.enable = lib.mkEnableOption "enable opencode";

  config = lib.mkIf config.opencode.enable {
    programs.opencode = {
      enable = true;

      settings = {
        autoupdate = true;
      };
    };
  };
}
