{ pkgs, vars, ... }:

{
  programs.nixvim = {
    enable = true;

    opts = {
      relativenumber = true;
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
      showtabline = 2;
      expandtab = true;

      breakindent = true;

      ignorecase = true;
      smartcase = true;

      undofile = true;

      signcolumn = "yes";

      scrolloff = 5;
      colorcolumn = "80";
    };

    colorschemes.catppuccin.enable = true;

    clipboard.providers.wl-copy.enable = true;

    plugins = {
      lualine.enable = true;

      lsp = {
        enable = true;
        servers = {
          rust_analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;

            settings = {
              checkOnSave = true;
              check = {
                command = "clippy";
              };
            };
          };

          lua_ls.enable = true;

          nixd.enable = true;
        };
      };

      nvim-tree = {
        enable = true;

        openOnSetup = false;
        hijackCursor = true;
        syncRootWithCwd = true;
        disableNetrw = true;

        filters.dotfiles = false;

        updateFocusedFile = {
          enable = true;
          updateRoot = false;
        };

        view = {
          width = 30;
          preserveWindowProportions = true;
        };

        renderer = {
          rootFolderLabel = false;
          highlightGit = true;
          indentMarkers.enable = true;

          icons = {
            gitPlacement = "before";
            padding = " ";
            symlinkArrow = " ➛ ";

            glyphs = {
              default = "󰈚";
              folder = {
                default = "";
                empty = "";
                open = "";
                symlink = "";
              };
              git = {
                unmerged = "";
                deleted = "";
                ignored = "";
                staged = "";
                renamed = "";
                unstaged = "";
                untracked = "";
              };
            };
          };
        };
      };

      telescope = {
        enable = true;
      };

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

      todo-comments = {
        enable = true;
      };

      rainbow-delimiters.enable = true;

      indent-blankline = {
        enable = true;

        # require("ibl").setup
        settings = {

          indent.char = "│";

          scope = {
            show_end = true;
            show_start = true;
          };
        };
      };

      conform-nvim = {
        enable = true;
        settings = {
          notify_on_error = true;
          format_on_save = ''
            							function(bufnr)
            								-- Disable with a global or buffer-local variable
            								if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            									return
            								end
            								return { timeout_ms = 500, lsp_format = 'fallback' }
            							end
            						'';

          formatters_by_ft = {
            html = {
              __unkeyed-1 = "prettierd";
              __unkeyed-2 = "prettier";
              stop_after_first = true;
            };
            css = {
              __unkeyed-1 = "prettierd";
              __unkeyed-2 = "prettier";
              stop_after_first = true;
            };
            javascript = {
              __unkeyed-1 = "prettierd";
              __unkeyed-2 = "prettier";
              stop_after_first = true;
            };
            javascriptreact = {
              __unkeyed-1 = "prettierd";
              __unkeyed-2 = "prettier";
              stop_after_first = true;
            };
            typescript = {
              __unkeyed-1 = "prettierd";
              __unkeyed-2 = "prettier";
              stop_after_first = true;
            };
            typescriptreact = {
              __unkeyed-1 = "prettierd";
              __unkeyed-2 = "prettier";
              stop_after_first = true;
            };
            java = [ "google-java-format" ];
            python = [ "black" ];
            lua = [ "stylua" ];
            nix = [ "nixfmt" ];
            markdown = {
              __unkeyed-1 = "prettierd";
              __unkeyed-2 = "prettier";
              stop_after_first = true;
            };
            rust = [ "rustfmt" ];
          };
        };

      };

      treesitter = {
        enable = true;

        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          json
          lua
          html
          nix
          make
          markdown
          toml
          vim
          vimdoc
          yaml
          xml
          regex
          java
          python
          rust
          gleam
          zig
        ];

        settings = {
          indent.enable = true;
          auto_install = true;
          ensure_installed = [
            "git_config"
            "gitattributes"
            "gitcommit"
            "gitignore"
          ];

          highlight = {
            enable = true;
          };
        };
      };

      autoclose = {
        enable = true;
        options.autoIndent = true;
      };

      mini = {
        enable = true;
        modules = {

          comment = {
            mappings = {
              comment = "<leader>/";
              comment_line = "<leader>/";
              comment_visual = "<leader>/";
              textobject = "<leader>/";
            };
          };

          diff = {
            view = {
              style = "sign";
            };
          };

          surround = {
            mappings = {
              add = "gsa";
              delete = "gsd";
              find = "gsf";
              find_left = "gsF";
              highlight = "gsh";
              replace = "gsr";
              update_n_lines = "gsn";
            };
          };

          indentscope = {
            draw = {
              delay = 50;
            };

            options = {
              border = "both";
            };

            symbol = "╎";
          };

          fuzzy = {
            cutoff = 200;
          };

          pairs = {
            modes = {
              insert = true;
              command = false;
              terminal = true;
            };
          };

        };
      };

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
