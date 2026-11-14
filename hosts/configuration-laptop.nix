{
  pkgs,
  system,
  pkgs-stable,
  lib,
  vars,
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

  systemd.user.services."battery-low" = {
    script = ''
      out=`${pkgs.acpi}/bin/acpi -b`
      battery_level=`echo "''${out}" | ${pkgs.gnugrep}/bin/grep -P -o "[0-9]+(?=%)"`
      if [[ ''${battery_level} -lt 16 && "''${out}" == *"Discharging"* ]]; then
        ${pkgs.libnotify}/bin/notify-send -u critical \
          -i battery-caution \
          -a "Battery" \
          -t 0 \
          -h string:x-canonical-private-synchronous:battery \
          "Battery low (''${battery_level}%)" \
          "Connect a charger"
        fi
    '';
    serviceConfig = {
      Type = "oneshot";
    };
    startAt = "*:0/1";
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

  environment = {
    systemPackages = with pkgs; [
      lm_sensors
    ];
  };
}
