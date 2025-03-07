{ pkgs }:

(with pkgs; [
  clang
  hugo
  plantuml
  graphviz
  temurin-bin-23

  texliveGUST
  texlivePackages.dvisvgm
  haskellPackages.hsc2hs
])
