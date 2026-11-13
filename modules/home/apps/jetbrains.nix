{
  pkgs,
  lib,
  config,
  ...
}: {
  options.custom.jetbrains = {
    enable = lib.mkEnableOption "jetbrains apps";

    apps = lib.mkOption {
      default = with pkgs; [
        jetbrains.webstorm
        jetbrains.idea
        jetbrains.datagrip
      ];

      description = "List of all jetbrains apps to be installed";
      type = lib.types.listOf lib.types.package;
    };
  };

  config = let
    cfg = config.custom.jetbrains;
  in
    lib.mkIf cfg.enable {
      home.packages =
        cfg.apps
        ++ (pkgs.lib.concatMap (ide: let
            name = baseNameOf (builtins.parseDrvName ide.name).name;
          in [
            (pkgs.writeShellScriptBin "${name}-wl" ''
              ${ide}/bin/${name} -Dawt.toolkit.name=WLToolkit "$@"
            '')
          ])
          cfg.apps);
    };
}
