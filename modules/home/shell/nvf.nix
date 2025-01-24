{ pkgs, vars, ... }:

{
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
          # autoindent = true;
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
              scope.enabled = true;
              scope.show_start = true;
              scope.show_end = true;
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

          nix.enable = true;
          nix.format.package = pkgs.nixfmt-rfc-style;
          nix.format.type = "nixfmt";

          rust.enable = true;
          ts.enable = true;
        };

      };
    };
  };
}
