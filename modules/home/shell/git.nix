{
  config,
  pkgs,
  lib,
  ...
}: {
  options.git = {
    gpgKey = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "GPG key ID used to sign git commits";
    };
    signByDefault = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to sign git commits by default";
    };
  };

  config = {
    home.packages = with pkgs; [diff-so-fancy];

    programs.git = {
      enable = true;

      signing = lib.mkIf (config.git.gpgKey != null) {
        key = config.git.gpgKey;
        signByDefault = config.git.signByDefault;
      };

      settings = {
        user.name = "JakobHuemer";
        user.email = "j.huemer-fistelberger@htblaleonding.onmicrosoft.com";

        rerere.enabled = true;
        commit.verbose = true;

        filter = {
          lfs.clean = "git-lfs clean -- %f";
          lfs.smudge = "git-lfs smudge -- %f";
          lfs.process = "git-lfs filter-process";
          lfs.required = true;
        };

        init.defaultBranch = "main";

        alias = {
          one = "log --oneline";
          ignore =
            "!gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@"
            + " | tee .gitignore ;}; gi";

          # pushf = "push --force-with-lease"; # this is dangerous with autocorrect
          pfwl = "push --force-with-lease";

          cam = "commit -am";
          ca = "commit -a";

          fixup = "commit --fixup=HEAD --edit";

          logpretty =
            "log --color --graph --pretty=format:'%C(red)%h%Creset"
            + " %C(bold blue)<%an>%Creset [%C(yellow)%G?%Creset]"
            + " %C(green)%cr%C(auto)%d %n%Creset%s%n'";
        };

        url = {
          "git@github.com".insteadOf = "gh";
          "https://github.com/".insteadOf = "ghttp";
        };

        core = {
          compressions = 9;
          whitespace = "error";
          preloadindex = true;
        };

        advice = {
          addEmptyPathspec = false;
          pushNonEmptyForward = false;
          statusHints = false;
        };

        diff = {
          renames = "copies";
        };

        pager = {
          diff = "diff-so-fancy | $PAGER";
          branch = false;
          tag = false;
        };

        "diff-so-fancy" = {
          markEmptyLines = false;
        };

        interactive = {
          diffFilter = "diff-so-fancy --patch";
        };

        push = {
          autoSetupRemote = true;
          default = "current";
          followTags = true;
        };

        pull = {
          default = "current";
          rebase = true;
        };

        rebase = {
          autoStash = true;
          missingCommitsCheck = "warn";
        };

        fetch = {
          prune = true;
        };

        log = {
          abbrevCommit = true;
          graphColors = "blue,yellow,cyan,magenta,green,red";
        };

        branch = {
          sort = "-committerdate";
        };

        tag = {
          sort = "-taggerdate";
        };

        color = {
          decorate = {
            HEAD = "red";
            branch = "blue";
            tag = "yellow";
            remoteBranch = "magenta";
          };

          branch = {
            current = "magenta";
            local = "default";
            remote = "yellow";
            upstream = "green";
            plain = "blue";
          };
        };

        maintenance = {
          auto = false;
          strategy = "incremental";
        };
      };
    };
  };
}
