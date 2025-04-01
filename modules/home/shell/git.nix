{ pkgs, ... }:

{

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

      alias = { "one" = "log --oneline"; };

    };
  };
}
