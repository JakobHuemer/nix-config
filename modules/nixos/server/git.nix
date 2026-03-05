{
  pkgs,
  config,
  lib,
  vars,
  ...
}: {
  options.gitserver = {
    enable = lib.mkEnableOption "enable git server";
    homeDir = lib.mkOption {
      type = lib.types.str;
      description = "Storage of the git repos";
    };
  };

  config = lib.mkIf config.gitserver.enable {
    users.users.git = {
      isSystemUser = true;
      group = "git";
      home = config.gitserver.homeDir;
      createHome = false; # managed by systemd-tmpfiles below
      shell = "${pkgs.git}/bin/git-shell";
      description = "Git server user";
      openssh.authorizedKeys.keys = [
      ];
    };

    users.groups.git = {};

    systemd.tmpfiles.rules = [
      "d  ${config.gitserver.homeDir}  2775  git   git    -    -"
    ];
  };
}
