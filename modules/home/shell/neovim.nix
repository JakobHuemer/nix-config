{
  lib,
  config,
  pkgs,
  pkgs-stable,
  vars,
  ...
}: {
  # options = {neovim.enable = lib.mkEnableOption "enable neovim";};
  #
  # config = lib.mkIf config.neovim.enable {
  # temp. disable while using the lua config
  # programs.neovim = {
  #   enable = true;
  #   defaultEditor = true;
  #   plugins = with pkgs.vimPlugins; [
  #     nvim-treesitter
  #     elixir-tools-nvim
  #     nvchad-ui
  #     nvchad
  #     catppuccin-nvim
  #   ];
  # };

  home.packages = with pkgs; [
    neovim

    treefmt
    shfmt
    nixd
    prettierd
    yapf
    nixfmt
    rustfmt
    alejandra
    stylua
    tinymist

    vscode-langservers-extracted
    vimPlugins.nvim-ts-autotag

    # deps for lua installation
    # probably can be removed when migrating to nix
    gcc
    tree-sitter
    nodejs
    lua
    unzip
    cargo
    python314
    rust-analyzer
    luajitPackages.luarocks
    plantuml # for diagram.nvim
    llvmPackages_20.clang-tools
  ];
  # };
}
