{
  lib,
  config,
  pkgs,
  vars,
  ...
}:

{

  options = {
    neovim.enable = lib.mkEnableOption "enable neovim";
  };

  config = lib.mkIf config.neovim.enable {
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
  };
}
