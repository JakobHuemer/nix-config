{
  inputs,
  nixpkgs,
  nixpkgs-stable,
  vars,
  ...
}: let
  lib = nixpkgs.lib;
in {
  # NixOs Laptop Desktop

  nitro = let
    system = "x86_64-linux";
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  in
    lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs system pkgs-stable vars;
        host = {
          hostName = "nitro";
          flakePath = "/etc/nixos/nix-config";
        };
      };

      modules = [
        ./nitro
        ./configuration.nix
        ./configuration-desktop.nix
      ];
    };

  pi4 = let
    system = "aarch64-linux";
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
      config.allowUnsupportedSystem = true;
    };
  in
    lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs system pkgs-stable vars;
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
