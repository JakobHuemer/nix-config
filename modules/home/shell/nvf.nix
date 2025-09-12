{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.nvf.homeManagerModules.nvf];

  options = {
    nvf.enable = lib.mkEnableOption "enable nvf";
  };

  config = lib.mkIf config.nvf.enable {
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          theme = {
            enable = true;
            name = "catppuccin";
            style = "mocha";
          };

          scrollOffset = 4;
          # autopairs.nvim-autopairs.enable = true;

          filetree.nvimTree = {
            enable = true;

            openOnSetup = false;

            mappings = {
              refresh = "<leader>r";
              focus = "<leader>e";
              toggle = "<leader>t";
            };

            setupOpts = {
              filters.dotfiles = false;
              hijack_cursor = true;
              sync_root_with_cwd = true;
              disable_netrw = true;

              update_focused_file = {
                enable = true;
                update_root = false;
              };

              view = {
                width = 30;
                preserve_window_proportions = true;
              };

              renderer = {
                root_folder_label = false;
                highlight_git = true;
                indent_markers = {
                  enable = true;
                };
                icons = {
                  glyphs = {
                    default = "󰈚";
                    folder = {
                      default = "";
                      empty = "";
                      empty_open = "";
                      open = "";
                      symlink = "";
                    };
                    git = {
                      unmerged = "";
                    };
                  };
                };
              };
            };
          };

          statusline.lualine.enable = true;
          telescope.enable = true;
          autocomplete.nvim-cmp.enable = true;

          mini = {
            indentscope.enable = true;
            fuzzy.enable = true;
            pairs.enable = true;
          };

          options = {
            autoindent = true;
            tabstop = 2;
            shiftwidth = 2;
          };

          # TODO: remap to something without leader key
          comments.comment-nvim.mappings = {
            toggleCurrentBlock = "<leader>/";
            toggleCurrentLine = "<leader>/";
          };

          notes.todo-comments = {
            enable = true;
          };

          visuals = {
            rainbow-delimiters.enable = true;

            indent-blankline = {
              enable = true;
              setupOpts = {
                # scope.highlight = "{smart_indent_cap}";
                # scope.highlight = [
                #   "{highlight}"
                #   "{smart_indent_cap}"
                # ];

                scope = {
                  enabled = true;
                  show_start = true;
                  show_end = true;
                };
              };
            };
          };

          ui = {
            colorizer.enable = true;
            illuminate.enable = true;

            noice = {
              enable = true;
            };

            smartcolumn = {
              enable = true;
              setupOpts = {
                colorcolumn = ["120"];
              };
            };
          };

          treesitter = {
            enable = true;
            highlight.enable = true;
            indent.enable = true;
            autotagHtml = true;
          };

          lsp.formatOnSave = true;

          languages = {
            enableLSP = true;
            enableTreesitter = true;
            enableFormat = true;

            gleam.enable = true;
            zig.enable = true;
            html.enable = true;
            markdown.enable = true;
            python.enable = true;
            clang.enable = true;

            nix = {
              enable = true;
              format.package = pkgs.nixfmt-rfc-style;
              format.type = "nixfmt";
              lsp.enable = true;
              lsp.package = pkgs.nixd;
              extraDiagnostics.enable = true;
            };

            rust.enable = true;
            ts.enable = true;
          };
        };
      };
    };
  };
}
