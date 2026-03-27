{
  pkgs,
  inputs,
  lib,
  system,
  vars,
  config,
  ...
}: {
  options.noctalia.enable = lib.mkEnableOption "noctalia shell";

  config = lib.mkIf config.noctalia.enable {
    hardware.bluetooth.enable = true;
    # services.tuned.enable = true;
    services.upower.enable = true;

    environment.systemPackages = with pkgs; [
      inputs.noctalia.packages.${system}.default
      gpu-screen-recorder
    ];

    home-manager.users.${vars.user} = {...}: {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia-shell = {
        enable = true;

        package = let
          noctaliaFile =
            builtins.fromJSON
            (builtins.readFile ../../../conf/noctalia.json);
        in
          inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
            inherit pkgs; # THIS PART IS VERY IMPORTAINT, I FORGOT IT IN THE VIDEO!!!

            settings = noctaliaFile.settings;

            # plugins = noctaliaFile.plugins;
          };
      };
    };
  };
}
