{ pkgs }:

(with pkgs; [

  unrar
  rsync
  zip
  wget
  gnupg

  zsh
  git
  gh
  tmux

  nix-tree
  sops
  nvchecker

  # languages
  go
  python313
  python313Packages.pip
  fontforge
  python313Packages.pyodbc
  python312Packages.fontforge

  docker-compose
])
