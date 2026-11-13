{
  pkgs,
  inputs,
  config,
  vars,
  host,
  lib,
  system,
  ...
}: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  options.custom.stylix = {
    enable = lib.mkEnableOption "stylix";
  };

  config = let
    cfg = config.custom.stylix;
  in
    lib.mkIf cfg.enable ({
        # assertions = [
        #   {
        #     assertion = !(config.home-manager.users.${vars.user}.custom.stylix.enable or false);
        #     message = "stylix nixos module and home-manager module can't both be used at once";
        #   }
        # ];
      }
      // (import ../../../settings/stylix.nix {
        inherit pkgs inputs system;
      }));
}
