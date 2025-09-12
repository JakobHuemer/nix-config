{
  description = "Java Quarkus Dev Shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.temurin-21
            pkgs.maven
            pkgs.quarkus
          ];

          shellHook = ''
            export JAVA_HOME=${pkgs.temurin-21}
            export PATH=$JAVA_HOME/bin:$PATH
          '';
        };
      }
    );
}
