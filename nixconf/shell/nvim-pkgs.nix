{ pkgs }:

(with pkgs; [
  treefmt2
  shfmt
  rust-analyzer
  nixd
  prettierd
  yapf
  nixfmt-rfc-style
  rustfmt

  vscode-langservers-extracted
  vimPlugins.nvim-ts-autotag
])
