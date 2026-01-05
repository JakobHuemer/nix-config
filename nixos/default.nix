{
  inputs,
  lib,
  genSpecialArgs,
  vars,
  ...
}: {
  sta01 = lib.nixosSystem {
    specialArgs = {
      inherit (genSpecialArgs "x86_64-linux");
      host = {
        hostName = "sta01";
        flakePath = "/etc/nixos/nix-config";
      };
    };

    modules = [
      ./sta01
      ./configuration.nix
      ./configuration-desktop.nix
    ];
  };

  pi4 = lib.nixosSystem {
    specialArgs = {
      inherit (genSpecialArgs "aarch64-linux");
      host = {
        hostName = "pi4";
        flakePath = "/etc/nixos/nix-config";
      };
    };
    modules = [
      ./pi4
      ./configuration.nix
    ];
  };
}
