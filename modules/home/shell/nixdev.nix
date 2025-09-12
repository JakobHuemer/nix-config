{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.nixdev.homeManagerModules.default
  ];

  options.nixdev.enable = lib.mkEnableOption "enable nixdev command";

  config = lib.mkIf config.nixdev.enable {
    programs.nixdev = {
      enable = true;
      flakePaths = {
        rust = ../../../dev-flakes/rust.nix;
        java = ../../../dev-flakes/java.nix;
        swift = ../../../dev-flakes/swift.nix;
      };
    };
  };
}
