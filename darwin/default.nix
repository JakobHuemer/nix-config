{
  inputs,
  nixpkgs,
  darwin,
  home-manager,
  nixvim,
  vars,
  ...
}:

let
  systemConfig = system: {
    system = system;
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  };
in
{
  mbp2p =
    let
      inherit (systemConfig "aarch64-darwin") system pkgs;
    in
    darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit
          inputs
          system
          pkgs
          vars
          ;
      };
      modules = [
        ./darwin-configuration.nix
        ./mbp2p.nix
        # ....
        nixvim.nixDarwinModules.nixvim
        home-manager.darwinModules.home-manager
        # ghostty.packages.aarch64-darwin.default
        # nixcord.homeManagerModules.nixcord
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

        }
      ];
    };
}
