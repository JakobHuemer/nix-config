{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {tmux.enable = lib.mkEnableOption "enables tmux";};

  config = lib.mkIf config.tmux.enable {
    programs.tmux = {
      enable = true;

      prefix = "C-Space";
      mouse = true;

      resizeAmount = 5;

      # shell = "${pkgs.zsh}/bin/zsh";
      shell = "$SHELL";

      terminal = "tmux-256color";

      plugins = with pkgs; [
        # tmuxPlugins.cpu
        tmuxPlugins.sensible
        tmuxPlugins.resurrect
        tmuxPlugins.continuum
        {
          plugin = tmuxPlugins.cpu;
          extraConfig = ''
            #theme
            set -g status-position top

            set -gF window-status-format "#[bg=#{@ctp_surface1},fg=#{@ctp_fg}] ##I ##T "
            set -gF window-status-current-format "#[bg=#{@ctp_mauve},fg=#{@ctp_crust}] ##I ##T "

            set -g @cpu_low_bg_color "#[bg=#{@thm_green}]" # background color when cpu is low
            set -g @cpu_medium_bg_color "#[bg=#{@thm_yellow}]" # background color when cpu is medium
            set -g @cpu_high_bg_color "#[bg=#{@thm_red}]" # background color when cpu is high

            set -g status-left ""
            set -g status-right '#{weather} '
            set -ag status-right '#[bg=default] #[fg=#{@thm_crust}]#{cpu_bg_color} CPU #{cpu_icon} #{cpu_percentage} '
            set -ag status-right '#[bg=default] #[bg=#{@thm_flamingo}] MEM #{ram_percentage} '

            set -g @catppuccin_window_status_style "slanted"
          '';
        }
        {
          plugin = tmuxPlugins.yank;
          extraConfig = ''
            setw -g mode-keys vi
            bind-key v copy-mode

            # Start selection with 'V' (like linewise visual mode in nvim)
            bind-key -T copy-mode-vi v send -X begin-selection
            bind-key -T copy-mode-vi V send -X select-line

            # Yank selection with 'y' (like yank in nvim)
            bind-key -T copy-mode-vi y send -X copy-selection-and-cancel

            # Move to word with 'w'
            bind-key -T copy-mode-vi w send -X next-word

            # Move back a word with 'b'
            bind-key -T copy-mode-vi b send -X previous-word

            # Move to end of word with 'e'
            bind-key -T copy-mode-vi e send -X next-word-end

            # Move to beginning/end of line with '0' and '$'
            bind-key -T copy-mode-vi 0 send -X start-of-line
            bind-key -T copy-mode-vi '$' send -X end-of-line

            # Move up/down by page with Ctrl-d / Ctrl-u
            bind-key -T copy-mode-vi C-d send -X halfpage-down
            bind-key -T copy-mode-vi C-u send -X halfpage-up

            # Search forward/backward with '/' and '?'
            bind-key -T copy-mode-vi / send -X search-forward
            bind-key -T copy-mode-vi ? send -X search-backward

            # Repeat search with 'n' and reverse with 'N'
            bind-key -T copy-mode-vi n send -X search-again
            bind-key -T copy-mode-vi N send -X search-reverse

            # Cancel copy mode with 'Escape'
            bind -T copy-mode-vi Escape send-keys -X cancel
          '';
        }
        {
          plugin = tmuxPlugins.catppuccin;
          extraConfig = ''

          '';
        }
        {
          plugin = tmuxPlugins.tmux-sessionx;
          extraConfig = ''
            set -g @sessionx-bin "C-i"
          '';
        }
        {
          plugin = tmuxPlugins.mkTmuxPlugin {
            pluginName = "tmuxifier";
            version = "tmuxifier-unstable";
            src = pkgs.fetchFromGitHub {
              owner = "jimeh";
              repo = "tmuxifier";
              rev = "HEAD";
              sha256 = "sha256-qF4a6+34xqBVKxtOyP2ze9qIvuRIEf1j2oXbd+h3TiM=";
            };

            rtpFilePath = "tmuxifier.tmux";
          };
        }
        {
          plugin = tmuxPlugins.mkTmuxPlugin {
            pluginName = "tmux-weather-gps";
            version = "tmux-weather-gps-unstable";
            src = pkgs.fetchFromGitHub {
              owner = "jakobhuemer";
              repo = "tmux-weather-gps";
              rev = "HEAD";
              sha256 = "sha256-EwKeGLGQrwJU9J816g6PHrRgvCWsToAJwoeVR45NdxU=";
            };

            rtpFilePath = "tmux-weather.tmux";
          };
          extraConfig = ''
            set-option -g @tmux-weather-interval 5
            set-option -g @tmux-weather-gps "true"
          '';
        }
        {
          plugin = tmuxPlugins.mkTmuxPlugin {
            pluginName = "tmux.nvim";
            version = "unstable-2025-07-02";
            src = pkgs.fetchFromGitHub {
              owner = "aserowy";
              repo = "tmux.nvim";
              rev = "HEAD";
              sha256 = "sha256-/XIjqQr9loWVTXZDaZx2bSQgco46z7yam50dCnM5p1U=";
            };

            rtpFilePath = "tmux.nvim.tmux";
          };

          extraConfig = ''
            # navigation
            set -g @tmux-nvim-navigation true
            set -g @tmux-nvim-navigation-cycle false
            set -g @tmux-nvim-navigation-keybinding-left 'C-h'
            set -g @tmux-nvim-navigation-keybinding-down 'C-j'
            set -g @tmux-nvim-navigation-keybinding-up 'C-k'
            set -g @tmux-nvim-navigation-keybinding-right 'C-l'

            # resize
            set -g @tmux-nvim-resize true
            set -g @tmux-nvim-resize-step-x 5
            set -g @tmux-nvim-resize-step-y 5
            set -g @tmux-nvim-resize-keybinding-left 'M-h'
            set -g @tmux-nvim-resize-keybinding-down 'M-j'
            set -g @tmux-nvim-resize-keybinding-up 'M-k'
            set -g @tmux-nvim-resize-keybinding-right 'M-l'
          '';
        }
      ];

      extraConfig = ''
        unbind r
        bind r source-file ~/.config/tmux/tmux.conf

        set -gu default-command

        # start session numbering at 1
        set -g base-index 1
        setw -g pane-base-index 1

        # pressing ESC in NeoVim happen without delay (https://github.com/neovim/neovim/wiki/FAQ#esc-in-tmux-or-gnu-screen-is-delayed)
        set -sg escape-time 10

        # auto renumber windows on closing one
        set -g renumber-windows on

        # #theme
        # set -g status-position top
        #
        # set -gF window-status-format "#[bg=#{@ctp_surface1},fg=#{@ctp_fg}] ##I ##T "
        # set -gF window-status-current-format "#[bg=#{@ctp_mauve},fg=#{@ctp_crust}] ##I ##T "
        #
        # set -g @cpu_low_bg_color "#[bg=#{@thm_green}]" # background color when cpu is low
        # set -g @cpu_medium_bg_color "#[bg=#{@thm_yellow}]" # background color when cpu is medium
        # set -g @cpu_high_bg_color "#[bg=#{@thm_red}]" # background color when cpu is high
        #
        # set -g status-left ""
        # set -g status-right '#{weather} '
        # set -ag status-right '#[bg=default] #[fg=#{@thm_crust}]#{cpu_bg_color} CPU #{cpu_icon} #{cpu_percentage} '
        # set -ag status-right '#[bg=default] #[bg=#{@thm_flamingo}] MEM #{ram_percentage} '
        #
        # set -g @catppuccin_window_status_style "slanted"
      '';
    };

    home.packages = with pkgs; [
      tmuxifier
    ];
  };
}
