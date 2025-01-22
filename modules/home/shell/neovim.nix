{ pkgs, vars, ... }:


{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter
      elixir-tools-nvim
      nvchad-ui
      nvchad
      catppuccin-nvim
    ];
  };
}
