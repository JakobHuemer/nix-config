{
  pkgs,
  ...
}:

{

  programs.git = {
    enable = true;
    userName = "JakobHuemer";
    userEmail = "j.huemer-fistelberger@htblaleonding.onmicrosoft.com";

    extraConfig =
      let
        ghPath = "${pkgs.gh}/bin/gh";
      in
      {

        filter = {
          lfs.clean = "git-lfs clean -- %f";
          lfs.smudge = "git-lfs smudge -- %f";
          lfs.process = "git-lfs filter-process";
          lfs.required = true;
        };

        init.defaultBranch = "main";

      };
  };
}
