{ pkgs, lib, config, vars, host, inputs, ... }:

{

  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  options = { nixvim.enable = lib.mkEnableOption "enables nixvim"; };

  config = lib.mkIf config.nixvim.enable {

    programs.nixvim = {

      enable = true;
      globals.mapleader = " ";

      clipboard = { register = "unnamedplus"; };

      opts = {
        relativenumber = true;
        number = true;

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

        cmp = {
          enable = true;
          autoEnableSources = true;
          settings = {
            sources = [
              { name = "nvim_lsp"; }
              { name = "path"; }
              { name = "buffer"; }
              { name = "luasnip"; }
            ];

            mapping = {
              "<C-Space>" = "cmp.mapping.complete()";
              "<C-d>" = "cmp.mapping.scroll_docs(-4)";
              "<C-e>" = "cmp.mapping.close()";
              "<C-f>" = "cmp.mapping.scroll_docs(4)";
              "<CR>" = "cmp.mapping.confirm({ select = true })";
              "<S-Tab>" =
                "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
              "<Tab>" =
                "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            };

            completion.autocomplete =
              [ "require('cmp.types').cmp.TriggerEvent.TextChanged" ];
          };
        };

        lsp = {
          enable = true;
          inlayHints = true;

          servers = {
            lua_ls = { enable = true; };

            html = { enable = true; };

            nixd = {
              enable = true;

              settings = let
                # flake = "(builtins.getFlake (\"git+file://\" + toString ./. ))";
                flake = ''(builtins.getFlake "${host.flakePath}")'';
              in {
                formatting = { command = [ "nixfmt" ]; };

                nixpkgs = { expr = "import ${flake}.inputs.nixpkgs"; };

                options = {
                  "nixos".expr = "${flake}.nixosConfigurations.nitro.options";
                  "home_manager".expr =
                    "${flake}.homeConfigurations.nitro.options";
                  "nix_darwin".expr =
                    "${flake}.darwinConfigurations.mbp2p.options";
                  "darwin".expr = "${flake}.darwinConfigurations.mbp2p.options";
                };
              };
            };

            rust_analyzer = {
              enable = true;
              installCargo = true;
              installRustc = true;
            };
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

        auto-save = {
          enable = true;
          settings.enabled = true;
          settings.write_all_buffers = true;
        };
        web-devicons.enable = true;

        todo-comments = { enable = true; };

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

        # emmet = {
        #   leader = "<C-Z>";
        #   mode = "inv";
        #   settings = {
        #     html = {
        #       default_attributes = {
        #         option = {
        #           value = null;
        #         };
        #         textarea = {
        #           cols = 10;
        #           id = null;
        #           name = null;
        #           rows = 10;
        #         };
        #       };
        #       snippets = {
        #         "html:5" = ''
        #           <!DOCTYPE html>
        #           <html lang=\"$\{lang}\">
        #           <head>
        #           \t<meta charset=\"$\{charset}\">
        #           \t<title></title>
        #           \t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
        #           </head>
        #           <body>\n\t$\{child}|\n</body>
        #           </html>
        #         '';
        #       };
        #     };
        #     variables = {
        #       lang = "ja";
        #     };
        #   };
        # };

        ts-autotag = {
          enable = true;
          settings = {
            opts = {
              enable_close = true;
              enable_close_on_slash = true;
              enable_rename = true;
            };
            per_filetype = { html = { enable_close = true; }; };
          };
        };

        treesitter = {
          enable = true;

          grammarPackages =
            with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
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
            ensure_installed =
              [ "git_config" "gitattributes" "gitcommit" "gitignore" ];

            highlight = { enable = true; };
          };
        };

        autosource = { enable = true; };

        autoclose = {
          enable = true;

          settings = {

            keys = {
              "(" = {
                escape = false;
                close = true;
                pair = "()";
              };
              "[" = {
                escape = false;
                close = true;
                pair = "[]";
              };
              "{" = {
                escape = false;
                close = true;
                pair = "{}";
              };

              ">" = {
                escape = true;
                close = false;
                pair = "<>";
              };
              ")" = {
                escape = true;
                close = false;
                pair = "()";
              };
              "]" = {
                escape = true;
                close = false;
                pair = "[]";
              };
              "}" = {
                escape = true;
                close = false;
                pair = "{}";
              };

              "\"" = {
                escape = true;
                close = true;
                pair = ''""'';
              };
              "'" = {
                escape = true;
                close = true;
                pair = "''";
              };
              "`" = {
                escape = true;
                close = true;
                pair = "``";
              };
            };

            options = {
              pair_spaces = true;
              auto_indent = true;
              touch_regex = "[%w(%[{]";
            };
          };
        };

        indent-o-matic = {
          enable = true;

          settings = {
            max_lines = 2048;
            skip_multiline = false;
            standard_widths = [ 2 4 8 ];
          };
        };

        conform-nvim = {
          enable = true;

          settings = {

            notify_on_error = true;

            formatters_by_ft = {
              bash = [ "shfmt" ];
              "_" = [ "prettierd" ];
            };

            format_on_save = # Lua
              ''
                function(bufnr)
                  local ignore_filetypes = {  }
                  
                  if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
                    return
                  end

                  if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                  end
                  
                  local bufname = vim.api.nvim_buf_get_name(bufnr)
                  if bufname:match("/node_modules/") then
                    return
                  end
                  
                  return { timeout_ms = 500, lsp_format = "fallback" }
                end
              '';
          };
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

            diff = { view = { style = "sign"; }; };

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
              draw = { delay = 50; };

              options = { border = "both"; };

              symbol = "╎";
            };

            fuzzy = { cutoff = 200; };

          };
        };

        #
        #
        # plugins end - - - - -
      };

      keymaps = [{
        mode = "n";
        key = "<leader>e";
        action = ":NvimTreeOpen<CR>";
        options = {
          silent = true;
          desc = "Open NvimTree file explorer";
        };
      }];
    };
  };
}
