{ inputs, nixpkgs, nixpkgs-stable, darwin, vars, ... }:

let
  systemConfig = system: {
    inherit system;
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        inputs.rust-overlay.overlays.default
      ];
    };
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  };
  inherit inputs;

in {
  mbp2p = let
    inherit (systemConfig "aarch64-darwin") system pkgs pkgs-stable;
    host = {
      hostName = "mbp2p";
      flakePath = "/Users/${vars.user}/nix";
    };
  in darwin.lib.darwinSystem {
    inherit system;
    specialArgs = { inherit system inputs pkgs pkgs-stable vars host; };
    modules = [
      ./darwin-configuration.nix
      ./mbp2p.nix
      # ....
      inputs.home-manager.darwinModules.home-manager
      # ghostty.packages.aarch64-darwin.default
      # nixcord.homeManagerModules.nixcord
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        nix.enable = true;
      }
    ];
  };

}
