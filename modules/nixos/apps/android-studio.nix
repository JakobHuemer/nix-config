{
  pkgs,
  vars,
  system,
  lib,
  config,
  ...
}: {
  options.android-studio.enable = lib.mkEnableOption "Enable android studio on aarch64";

  config = lib.mkIf config.android-studio.enable {};
}
