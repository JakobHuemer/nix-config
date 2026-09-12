{
  lib,
  config,
  pkgs,
  vars,
  ...
}: {
  config = lib.mkIf config.programs.ghostty.enable {
    # home.file.".config/ghostty/config".source = ../../../conf/ghostty/config;

    programs.ghostty = {
      enableZshIntegration = true;

      settings = {
        font-family = ["JetBrainsMonoNL Nerd Font Mono" "Apple Color Emoji"];
        font-feature = "-liga";
        cursor-style = "block";

        cursor-style-blink = false;
        mouse-hide-while-typing = true;

        background-blur-radius = 30;
        background-opacity = 0.95;

        command = "zsh";

        window-padding-x = 5;
        window-padding-y = 5;
        window-padding-balance = true;
        window-padding-color = "extend";

        window-theme = "ghostty";

        window-height = 24;
        window-width = 90;

        window-inherit-working-directory = "true";

        quick-terminal-position = "center";
        quick-terminal-animation-duration = 0;
        gtk-quick-terminal-layer = "top";
        quick-terminal-screen = "mouse";
        quick-terminal-autohide = true;
        quick-terminal-keyboard-interactivity = "exclusive";

        shell-integration = "zsh";
        shell-integration-features = "sudo,cursor,ssh-env,ssh-terminfo";

        # macos-titlebar-style = hidden
        macos-option-as-alt = "left";

        link-url = true;

        auto-update = "download";

        # catppuccin-mocha theme
        # explicitly define official catppuccin mocha colors
        # because ghosttys theme uses iTerm2 colors which
        # are different

        palette = [
          "0=#45475a"
          "1=#f38ba8"
          "2=#a6e3a1"
          "3=#f9e2af"
          "4=#89b4fa"
          "5=#f5c2e7"
          "6=#94e2d5"
          "7=#a6adc8"
          "8=#585b70"
          "9=#f38ba8"
          "10=#a6e3a1"
          "11=#f9e2af"
          "12=#89b4fa"
          "13=#f5c2e7"
          "14=#94e2d5"
          "15=#bac2de"
        ];

        background = "1e1e2e";
        foreground = "cdd6f4";
        cursor-color = "f5e0dc";
        selection-background = "353749";
        selection-foreground = "cdd6f4";

        # make ghostty not group on linux
        gtk-single-instance = false;

        # keybinds

        keybind = [
          "global:super+shift+enter=toggle_quick_terminal"
        ];
      };
    };
  };
}
