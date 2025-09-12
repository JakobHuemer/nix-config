{
  description = "Swift development flake with flake-utils";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      devShells.default = pkgs.mkShell {
        name = "swift-dev-shell";

        buildInputs = [
          pkgs.swift
          pkgs.swiftPackages.swift-format
          pkgs.swiftlint
          pkgs.cmake
          pkgs.gnumake
          pkgs.pkg-config
          pkgs.libxml2
          pkgs.bashInteractive
        ];

        shellHook = ''
          echo "🚀 Swift Dev Shell Ready for ${system}!"
        '';
      };
    });
}
