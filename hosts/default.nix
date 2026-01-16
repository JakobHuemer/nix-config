{
  inputs,
  nixpkgs,
  nixpkgs-stable,
  vars,
  ...
}: let
  lib = nixpkgs.lib;
  lib-stable = nixpkgs-stable.lib;
in {
  # NixOs Laptop Desktop

  sta01 = let
    system = "x86_64-linux";
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  in
    lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit
          inputs
          system
          pkgs-stable
          vars
          ;
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

  nixbook = let
    system = "aarch64-linux";
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  in
    lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit
          inputs
          system
          pkgs-stable
          vars
          ;
        host = {
          hostName = "nixbook";
          flakePath = "/etc/nixos/nix-config";
        };
      };

      modules = [
        ./configuration.nix
        ./configuration-desktop.nix
        ./configuration-laptop.nix
        ./nixbook
	"${inputs.nixos-apple-silicon}/apple-silicon-support"
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
        inherit
          inputs
          system
          pkgs-stable
          vars
          ;
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
