{ inputs, nixpkgs, home-manager, nixgl, vars, ... }:

let
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
in {
  nitro = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {
      inherit inputs nixgl vars;
      host = {
        hostName = "nitro";
        flakePath = "/nixos/etc/nix-config";
      };
    };
    modules = [
      ./home-configuration.nix
      ./nitro.nix
      {
        home = {
          username = "${vars.user}";
          homeDirectory = "/home/${vars.user}";
          packages = [ pkgs.home-manager ];
          stateVersion = "24.11";
        };
      }
    ];
  };
}
