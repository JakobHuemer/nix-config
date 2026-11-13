{
  inputs,
  nixpkgs,
  nixpkgs-stable,
  vars,
  customPkgsOverlay,
  self,
  ...
}: let
  lib = nixpkgs.lib;
  lib-stable = nixpkgs-stable.lib;

  hostAttrs = {
    flakePath = "/etc/nixos/nix-config";
    isNixos = true;
  };

  overlays = [
    customPkgsOverlay
    (import ../overlays/qt6ct.nix)
    inputs.opencode.overlays.default
    inputs.papertimed.overlays.default
    inputs.timewall.overlays.default
    inputs.affinity-nix.overlays.default
  ];
in {
  # NixOs Laptop Desktop

  frame1301 = let
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
          self
          inputs
          system
          pkgs-stable
          vars
          ;
        host =
          hostAttrs
          // {
            hostName = "frame1301";
          };
      };

      modules = [
        ./frame1301
        ./configuration.nix
        ./gaming.nix
        ./configuration-desktop.nix
        ./configuration-laptop.nix
        inputs.nixos-hardware.nixosModules.framework-intel-core-ultra-series3
        {
          nixpkgs.overlays = overlays;
          nixpkgs.config.allowUnfree = true;
        }
      ];
    };

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
          self
          inputs
          system
          pkgs-stable
          vars
          ;
        host =
          hostAttrs
          // {
            hostName = "sta01";
          };
      };

      modules = [
        ./sta01
        ./gaming.nix
        ./configuration.nix
        ./configuration-desktop.nix
        {
          nixpkgs.overlays = overlays;
          nixpkgs.config.allowUnfree = true;
        }
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
          self
          inputs
          system
          pkgs-stable
          vars
          ;
        host =
          hostAttrs
          // {
            hostName = "nixbook";
          };
      };

      modules = [
        ./configuration.nix
        ./configuration-desktop.nix
        ./configuration-laptop.nix
        ./nixbook
        inputs.apple-silicon.nixosModules.apple-silicon-support
        {
          nixpkgs.overlays =
            overlays
            ++ [
              inputs.nixos-aarch64-widevine.overlays.default
            ];
          nixpkgs.config.allowUnfree = true;
        }
      ];
    };
}
