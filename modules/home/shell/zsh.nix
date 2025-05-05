{ pkgs, ... }:

{

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;

      autocd = true;

      autosuggestion = {
        enable = true;
        strategy = [ "history" ];
      };

      sessionVariables = {
        EDITOR = "nvim";
        ZSH_EVALCACHE_DISABLE = "false";
        ZSH_EVALCACHE_DIR = "$HOME/.zsh-evalcache";

        # Localizations
        LC_ALL = "en_GB.UTF-8";
        LANG = "en_GB.UTF-8";
        LANGUAGE = "en_GB.UTF-8";

        GITIGNORE_TEMPLATE_FILE = toString ../../../conf/gitignore-template;

        PATH = builtins.concatStringsSep ":" [
          "$HOME/go/bin"
          "$HOME/.local/bin"
          "$HOME/.cargo/bin"
          "$PATH"
        ];

        GIT_ADVICE = 0;

      };

      history = {
        append = true;
        size = 100000;
        save = 100000;

        # extend = true; # save timestamp with command
        share = true; # share between sessions
      };

      plugins = [
        {
          name = "zsh-autopair";
          src = pkgs.fetchFromGitHub {
            owner = "hlissner";
            repo = "zsh-autopair";
            rev = "v1.0";
            hash = "sha256-wd/6x2p5QOSFqWYgQ1BTYBUGNR06Pr2viGjV/JqoG8A=";
          };
        }
        {
          name = "evalcache";
          src = pkgs.fetchFromGitHub {
            owner = "mroth";
            repo = "evalcache";
            rev = "v1.0.2";
            hash = "sha256-qzpnGTrLnq5mNaLlsjSA6VESA88XBdN3Ku/YIgLCb28=";
          };
        }
        {
          name = "zsh-lazyload";
          src = pkgs.fetchFromGitHub {
            owner = "qoomon";
            repo = "zsh-lazyload";
            rev = "v1.0.1";
            hash = "sha256-prV6jUp33HgGayf5PuqyM/17/2hJldxMZZskthtdUxY=";
          };
        }
        {
          name = "sudo";
          src = pkgs.fetchFromGitHub {
            owner = "zap-zsh";
            repo = "sudo";
            rev = "b3e86492d6d48c669902b9fb5699a75894cfcebc";
            hash = "sha256-+yMZO4HRF+dS1xOP/19Fneto8JxdVj5GiX3sXOoRdlM=";
          };
        }
      ];

      initContent = ''

        COMPLETION_WAITING_DOTS="true"
        DISABLE_AUTO_TITLE="true"
        ZSH_AUTOSUGGEST_USE_ASYNC="true"
        CASE_SENSITIVE="false"

        HISTSIZE=10000
        SAVEHIST=10000

        GITHUB_COPILOT_CLI_INITIALIZED=false

        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
        zstyle ':completion:*' menu select

        ZSH_AUTOSUGGEST_STRATEGY=(history completion)
        ZSH_AUTOSUGGEST_USE_ASYNC=true

        # Copilot
        qq() {
            initialize_github_copilot_cli
            eval "?? $@"
        }

        git-q() {
            initialize_github_copilot_cli
            eval "git? $@"
        }

        gh-q() {
            initialize_github_copilot_cli
            eval "gh? $@"
        }

        initialize_github_copilot_cli() {
            if [ "$GITHUB_COPILOT_CLI_INITIALIZED" = false ]; then
                eval "$(github-copilot-cli alias -- "$0")"
                GITHUB_COPILOT_CLI_INITIALIZED=true
            fi
        }

        timezsh() {
            shell=''${1-$SHELL}
            for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
        }

        # transient prompt - - - - 

        zle-line-init() {
          emulate -L zsh

          [[ $CONTEXT == start ]] || return 0

          while true; do
            zle .recursive-edit
            local -i ret=$?
            [[ $ret == 0 && $KEYS == $'\4' ]] || break
            [[ -o ignore_eof ]] || exit 0
          done

          local saved_prompt=$PROMPT
          local saved_rprompt=$RPROMPT

          # Set prompt value from character module
          PROMPT=$(starship module character)
          # PROMPT=$(get-transient-prompt)
          RPROMPT=""
          zle .reset-prompt
          PROMPT=$saved_prompt
          RPROMPT=$saved_rprompt

          if (( ret )); then
            zle .send-break
          else
            zle .accept-line
          fi
          return ret
        }

        get-transient-prompt() {
          echo -en "\e[1;35m$USER $(starship module character)\e[0m"
        }

        zle -N zle-line-init

        # transient prompt - - - -

        # evals

        _evalcache gh copilot alias -- zsh
        _evalcache thefuck --alias -- fk

        # fetches 

        pfetch

        autoload -Uz +X compinit && compinit
      '';

      shellAliases = {
        "??" = "ghcs";
        "e?" = "ghce";

        # obv
        nivm = "nvim";

        ip = "ip --color";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";

        cdd = "cd ~/D";
        fk = "fuck";

        # git
        gs = "git status";
        gss = "git status --short";
        
        ga = "git add";
        gap = "git add --patch";
        gr = "git restore";
        gc = "git commit";
        
        gp = "git push";
        gu = "git pull";
        gm = "git merge";
        
        gl = "git log --color --graph --pretty=format:'%C(red)%h%Creset %C(bold blue)<%an> %C(green)%cr %C(auto)%d %n%Creset%s%n'";
        gw = "git checkout";

        gd = "git diff";
        gds = "git diff --staged";

        gb = "git branch";
        gbd = "git branch -r -d";

        sudes = "sudo -E -s";

        c = "z";
        cat = "bat";
        ls = "eza $1 --color=auto --icons=auto";
        l = "ls -lah";

        makegitignore = "cp $GITIGNORE_TEMPLATE_FILE .gitignore";
        mkgitignore = "makegitignore";
        icat = "kitten icat";
      };

    };

    starship.enable = true;
    zoxide.enable = true;
    fzf.enable = true;
    dircolors.enable = true;

  };

  programs.gh = {
    enable = true;

    extensions = [ pkgs.gh-copilot ];
  };

  home.packages = with pkgs; [
    thefuck
    pfetch-rs
    macchina
    starship
    bat
    fzf
    zoxide
    lsd
    eza
  ];

}
