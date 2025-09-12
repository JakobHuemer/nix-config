{
  description = "Rust development environment with common tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    rust-overlay,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        overlays = [(import rust-overlay)];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        # Latest stable Rust with common components
        rust = pkgs.rust-bin.stable.latest.default.override {
          extensions = [
            "rust-src"
            "rust-analyzer"
            "clippy"
            "rustfmt"
          ];
        };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs;
            [
              # Rust toolchain
              rust

              # Cargo tools
              cargo-bloat # Analyze binary size
              cargo-edit # Add/remove dependencies from CLI
              cargo-outdated # Check for outdated dependencies
              cargo-udeps # Find unused dependencies
              cargo-watch # Auto-rebuild on file changes

              # Additional useful tools
              pkg-config
              openssl

              # Platform-specific dependencies
            ]
            ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
              pkgs.darwin.apple_sdk.frameworks.Security
              pkgs.darwin.apple_sdk.frameworks.SystemConfiguration
            ];

          shellHook = ''
            echo "🦀 Rust Development Environment"
            echo "Rust version: $(rustc --version)"
            echo "Cargo version: $(cargo --version)"
            echo ""
            echo "Available tools:"
            echo "  📊 cargo bloat     - Analyze what takes space in your executable"
            echo "  ✏️  cargo edit      - Add/remove/upgrade dependencies"
            echo "  📅 cargo outdated  - Display outdated dependencies"
            echo "  🧹 cargo udeps     - Find unused dependencies"
            echo "  👀 cargo watch     - Watch for changes and rebuild"
            echo ""
            echo "Example usage:"
            echo "  cargo watch -x 'run --bin myapp'"
            echo "  cargo bloat --release"
            echo "  cargo outdated"
            echo "  cargo udeps --all-targets"
          '';
        };
      }
    );
}
