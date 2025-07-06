{
  description = "Nix, NixOs and Nix Darwin System Flake Configuration with HomeManager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {url = "github:notashelf/nvf";};

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rustowl-flake.url = "github:nix-community/rustowl-flake";
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
    };
  in {
    nixosConfigurations = import ./hosts {
      inherit (nixpkgs) lib;
      inherit inputs nixpkgs nixpkgs-stable nixos-hardware vars;
    };

    darwinConfigurations = import ./darwin {
      inherit (nixpkgs) lib;
      inherit inputs nixpkgs nixpkgs-stable home-manager darwin vars;
    };

    homeConfigurations = import ./nix {
      inherit (nixpkgs) lib;
      inherit inputs nixpkgs nixpkgs-stable home-manager nixgl vars;
    };
  };
}
