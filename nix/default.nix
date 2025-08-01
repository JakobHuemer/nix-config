{
  inputs,
  nixpkgs,
  home-manager,
  nixgl,
  vars,
  ...
}: let
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
in {
}
