{ pkgs, vars, ... }:

{
  programs.git = {
    enable = true;

    config =
      let
        ghPath = "${pkgs.gh}/bin/gh";
      in
      {
        credential = {
          "https://github.com".helper = "!${ghPath} auth git-credential";
          "https://gist.github.com".helper = "!${ghPath} auth git-credential";
        };

        filter = {
          lfs.clean = "git-lfs clean -- %f";
          lfs.smudge = "git-lfs smudge -- %f";
          lfs.process = "git-lfs filter-process";
          lfs.required = true;
        };

        user.email = "j.huemer-fistelberger@htblaleonding.onmicrosoft.com";
        user.name = "JakobHuemer";

        init.defaultBranch = "main";

        # "credential.'https://github.com.helper'" = "!${ghPath} auth git-credential";
        # "credential.'https://gist.github.com.helper'" = "!${ghPath} auth git-credential";
        # "filter.lfs.clean" = "git-lfs clean -- %f";
        # "filter.lfs.smudge" = "git-lfs smudge -- %f";
        # "filter.lfs.process" = "git-lfs filter-process";
        # "filter.lfs.required" = "true";

        # "init.defaultBranch" = "main";
        signing = {
          key = "A32894C5";
          signByDefault = true;
        };
      };
  };
}
