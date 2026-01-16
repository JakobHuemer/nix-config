{ pkgs, system, pkgs-stable, host, ... }:
{
  powerManagement.enable = true;

  # cpu performance scaling
  services.tlp = {
    enable = true;

    settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 70;

       # #Optional helps save long term battery health
       # START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
       # STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
    };
  };

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

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "subend-then-hibernate";
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=20min
  '';
}
