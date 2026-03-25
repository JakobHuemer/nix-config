{
  pkgs,
  system,
  pkgs-stable,
  host,
  ...
}: {
  powerManagement = {
    enable = true;
  };

  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "schedutil";
        # governor = "performance";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
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
    # lid close
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "subend-then-hibernate";

    # power button
    HandlePowerKey = "lock";
    HandlePowerKeyLongPress = "poweroff";
  };
}
