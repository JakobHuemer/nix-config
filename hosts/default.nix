{
  inputs,
  nixpkgs,
  home-manager,
  nixvim,
  hyprland,
  sops-nix,
  vars,
  ...
}:

let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in
{
  # NixOs Laptop Desktop
  nitro = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit
        inputs
        system
        nixpkgs
        hyprland
        vars
        ;
      host = {
        hostName = "NixTop";
        # config about monitors...
      };
    };

    modules = [
      ./nitro
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];

  };

  pi4 = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit
        inputs
        system
        nixpkgs
        vars
        ;
      host = {
        hostName = "pi4";
        # config about monitors...
      };
    };

    modules = [
      ./pi4
      ./configuration.nix

      sops-nix.nixosModules.sops

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];

  };
}
