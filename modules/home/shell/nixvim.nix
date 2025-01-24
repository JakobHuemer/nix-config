{ pkgs, vars, ... }:

{
  programs.nixvim = {
    enable = true;

    colorschemes.catppuccin.enable = true;

    clipboard.providers.wl-copy.enable = true;

    opts = {
      relativenumber = true;
      # clipboard = "unnamedplus5";
      tabstop = 2;
      # softtabsop = 2;
      showtabline = 2;

      # smartindent = true;
      # shiftwidth = 2;
      scrolloff = 5;

    };

    plugins = {
      lualine.enable = true;

      lsp = {
        enable = true;
        servers = {
          rust_analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };

          lua_ls.enable = true;

          nixd.enable = true;
        };
      };

      nvim-tree.enable = true;

      auto-save = {
        enable = true;
        settings.enabled = true;
        settings.write_all_buffers = true;
      };

      cmp = {
        autoEnableSources = true;
        settings.sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
        ];

        settings.mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-e>" = "cmp.mapping.close()";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        };
      };

      web-devicons.enable = true;

    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>E";
        action = ":NvimTreeOpen";
        options = {
          silent = true;
          desc = "Open NvimTree file explorer";
        };
      }
    ];
  };
}
