{
  inputs,
  nixpkgs,
  vars,
  ...
}: let
  lib = nixpkgs.lib;
in {
  # NixOs Laptop Desktop

  nitro = let
    system = "x86_64-linux";
  in
    lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs system nixpkgs vars;
        host = {
          hostName = "nitro";
          flakePath = "/nixos/etc/nix-config";
        };
      };

      modules = [
        ./nitro
        # ./configuration.nix

        inputs.sops-nix.nixosModules.sops

        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };

  pi4 = let
    system = "aarch64-linux";
    nixpkgs = nixpkgs.legacyPackages.${system};
  in
    lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs system nixpkgs vars;
        host = {
          hostName = "pi4";
          flakePath = "/nixos/etc/nix-config";
        };
      };
      modules = [
        ./pi4
        # ./configuration.nix

        inputs.sops-nix.nixosModules.sops

        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };

  macnix = let
    system = "aarch64-linux";
  in
    lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs system nixpkgs vars;
        host = {
          hostName = "macnix";
          flakePath = "/nixos/etc/nix-config";
        };
      };

      modules = [
        ./macnix
        # ./configuration.nix

        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
}
