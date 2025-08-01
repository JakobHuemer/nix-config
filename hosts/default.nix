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
        ./configuration.nix

        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
}
