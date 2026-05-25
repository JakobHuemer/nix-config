{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.programs.bun.enable {
    programs.bun = {
      settings = {
        install = {
          minimumReleaseAge = 1209600; # 2 weeks
          minimumReleaseAgeExcludes = ["@types/node" "typescript"];

          frozenLockfile = true;
          exact = true;

          security.scanner = "bun-osv-scanner";

          linker = "isolated";
        };
      };
    };
  };
}
