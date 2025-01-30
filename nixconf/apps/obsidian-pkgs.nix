{ pkgs }:

(with pkgs; [
  hugo
  plantuml
  graphviz
  temurin-bin-23
  python313Packages.pyodbc
])
