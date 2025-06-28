{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {vscode.enable = lib.mkEnableOption "enable vscode";};

  config = lib.mkIf config.vscode.enable {
    programs.vscode = {
      enable = true;

      userSettings = {
        files.autosave = "off";

        editor = {
          cursorBlinking = "solid";
          inlineSuggest.enabled = true;
          cursorStyle = "block";
          formatOnPaste = true;
          defaultFormatter = "esbenp.prettier-vscode";
          formatOnSave = true;
          unicodeHighlight.ambiguousCharacters = true;
          fontFamily = "'JetBrainsMono Nerd Font', monospace";
          fontVariations = false;
        };

        explorer = {
          confirmDelete = true;
          confirmDragAndDrop = false;
        };

        workbench = {
          sideBar.location = "right";
          iconTheme = "catppuccin-mocha";
        };

        prettier = {
          bracketSameLine = true;
          trailingComma = "all";
        };

        "[rust]".editor.defaultFormatter = "rust-lang.rust-analyzer";
        "[python]".editor.defaultFormatter = "ms-python.python";
        "[nix]".editor.tabSize = 4;
        "[markdown]".editor.formatOnSave = false;
        "[asciidoctor]".editor.formatOnSave = false;
      };

      keybindings = [
        {
          key = "cmd+[Backslash]";
          command = "editor.action.commentLine";
          when = "editorTextFocus && !editorReadonly";
        }
        {
          key = "shift+cmd+[Backslash]";
          command = "editor.action.blockComment";
          when = "editorTextFocus && editorReadonly";
        }
        {
          key = "ctrl+shift+cm+o";
          command = "github.copilot.toggleCopilot";
        }
      ];

      extensions = with pkgs; [
        vscode-extensions.rust-lang.rust-analyzer
        vscode-extensions.enkia.tokyo-night
        vscode-extensions.github.copilot
        vscode-extensions.vincaslt.highlight-matching-tag
        vscode-extensions.formulahendry.auto-rename-tag
        vscode-extensions.oderwat.indent-rainbow
        vscode-extensions.mechatroner.rainbow-csv
        vscode-extensions.k--kato.intellij-idea-keybindings
        vscode-extensions.christian-kohler.path-intellisense
        vscode-extensions.esbenp.prettier-vscode
        vscode-extensions.vue.vscode-typescript-vue-plugin
        vscode-extensions.vue.volar
        vscode-extensions.asciidoctor.asciidoctor-vscode
        vscode-extensions.ziglang.vscode-zig
        vscode-extensions.yoavbls.pretty-ts-errors
        vscode-extensions.waderyan.gitblame
        vscode-extensions.vscodevim.vim
        vscode-extensions.vscjava.vscode-maven
        vscode-extensions.vscjava.vscode-gradle
        vscode-extensions.denoland.vscode-deno
        vscode-extensions.tamasfe.even-better-toml
        # vscode-extensions.equinusocio.vsc-material-theme-icons
        vscode-extensions.catppuccin.catppuccin-vsc-icons
        vscode-extensions.ms-python.python

        vscode-extensions.github.copilot
        vscode-extensions.github.copilot-chat
      ];
    };
  };
}
