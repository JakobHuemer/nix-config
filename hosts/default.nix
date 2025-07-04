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
  in
    lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs system nixpkgs vars;
        host = {
          hostName = "nitro";
          flakePath = "/etc/nixos/nix-config";
        };
      };

      modules = [
        ./nitro
        # ./configuration.nix

        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };

  nixpi4 = let
    system = "aarch64-linux";
    nixpkgs = nixpkgs-stable;
  in
    lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs system nixpkgs vars;
        host = {
          hostName = "nixpi4";
          flakePath = "/etc/nixos/nix-config";
        };
      };
      modules = [
        ./nixpi4
        "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        # ./configuration.nix

        # inputs.sops-nix.nixosModules.sops

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
