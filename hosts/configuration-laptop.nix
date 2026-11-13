{
  pkgs,
  system,
  pkgs-stable,
  lib,
  host,
  config,
  ...
}: let
  doSuspend = config.boot.resumeDevice != null;
in {
  powerManagement = {
    enable = true;
  };

  boot.zswap = {
    enable = true;
    compressor = "lz4";
  };
  boot.kernel.sysctl."vm.swappiness" = 100;

  # default audio volume
  services.pipewire.wireplumber = {
    enable = true;
    extraConfig = {
      "wireplumber.settings" = {
        # "device.routes.default-sink-volume" = "0.016";
        # "device.routes.default-source-volume" = "0.0086";
        "bluetooth.autoswitch" = true;
      };
    };
  };

  services.power-profiles-daemon.enable = true;
  services.logind.settings.Login.HandlePowerKey = "lock";
  services.logind.settings.Login.IdleActionSec = "10m";

  services.logind.settings.Login.HandleLidSwitch = lib.mkIf doSuspend "suspend-then-hibernate";
  services.logind.settings.Login.HandlePowerKeyLongPress = lib.mkIf doSuspend "hibernate";
  services.logind.settings.Login.IdleAction = lib.mkIf doSuspend "suspend-then-hibernate";

  systemd.sleep.settings.Sleep = lib.mkIf doSuspend {
    HibernateDelaySec = "20m";
  };
}
