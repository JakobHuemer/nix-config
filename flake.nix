{
  description = "Nix, NixOs and Nix Darwin System Flake Configuration with HomeManager";

  nixConfig = {
    extra-substituters = [
      "https://nixos-apple-silicon.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    apple-silicon = {
      # url = "github:nix-community/nixos-apple-silicon/530aa73aa9a21a078ff861b84767ae1d469715fa";
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wpaperd = {
      url = "github:danyspin97/wpaperd"; # is actually 1.2.2 but cli reports 1.2.1
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1&rev=eb0480ba0d0870ab5d8a876f01c6ab033a4b35f4";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:kaylorben/nixcord/35c173408a25cae1c5af23b9d4fd80a181a395d4";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rustowl-flake = {
      url = "github:nix-community/rustowl-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-emoji-linux = {
      url = "github:samuelngs/apple-emoji-linux";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    youtube-music = {
      url = "github:h-banii/youtube-music-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hytale-launcher = {
      url = "github:JPyke3/hytale-launcher-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tuigreet-notashelf = {
      url = "github:NotAShelf/tuigreet";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    nixos-hardware,
    home-manager,
    darwin,
    nixgl,
    ...
  } @ inputs: let
    vars = {
      user = "jakki";
      locations = "$HOME/.setup";
      terminal = "ghostty";
      editor = "nvim";
      domainName = "fistel.dev";
    };

    customPkgsOverlay = final: prev: {
      custom = nixpkgs.lib.packagesFromDirectoryRecursive {
        inherit (final) callPackage;
        directory = ./pkgs;
      };

      tuigreet = inputs.tuigreet-notashelf.packages.${prev.hostPlatform.system}.tuigreet;
    };
  in {
    nixosConfigurations = import ./hosts {
      inherit (nixpkgs) lib;
      inherit
        inputs
        nixpkgs
        nixpkgs-stable
        nixos-hardware
        vars
        customPkgsOverlay
        ;
    };

    darwinConfigurations = import ./darwin {
      inherit (nixpkgs) lib;
      inherit
        inputs
        nixpkgs
        nixpkgs-stable
        home-manager
        darwin
        vars
        customPkgsOverlay
        ;
    };

    homeConfigurations = import ./nix {
      inherit (nixpkgs) lib;
      inherit
        inputs
        nixpkgs
        nixpkgs-stable
        home-manager
        nixgl
        vars
        customPkgsOverlay
        ;
    };
  };
}
