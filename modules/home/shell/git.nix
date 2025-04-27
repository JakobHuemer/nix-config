{ pkgs, ... }:

{

  home.packages = with pkgs; [
    diff-so-fancy
  ];

  programs.git = {
    enable = true;
    userName = "JakobHuemer";
    userEmail = "j.huemer-fistelberger@htblaleonding.onmicrosoft.com";
    signing = {
      key = "D617865DCD802230ED4AFC3B02A04F8328440D81";
      signByDefault = true;
    };

    extraConfig = {

      filter = {
        lfs.clean = "git-lfs clean -- %f";
        lfs.smudge = "git-lfs smudge -- %f";
        lfs.process = "git-lfs filter-process";
        lfs.required = true;
      };

      init.defaultBranch = "main";

      alias = { 
        one = "log --oneline";
        ignore = "!gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ | tee .gitignore ;}; gi";
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
    };
  };
}
