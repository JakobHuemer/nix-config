{ inputs, nixojgs, home-manager, nixvim, hyprland, vars, ... }:

let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit sstem;
    config.allowUnfree = true;
  };


  lib = nixpkgs.lib;
in 
{
  # NixOs Laptop Desktop
  nixtop = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs system nixpkgs hyprland vars;
      host = {
        hostName = "NixTop";
        # config about monitors...
      };
    };

    modules = [
      ./nitro
      ./configuration.nix
    ];

    
  };
}
