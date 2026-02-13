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

  # # cpu performance scaling
  # services.tlp = {
  #   enable = true;
  #
  #   settings = {
  #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #
  #     # Use frequency limits, not performance percentages
  #     CPU_SCALING_MIN_FREQ_ON_AC = 900000; # 900 MHz in kHz
  #     CPU_SCALING_MAX_FREQ_ON_AC = 3500000; # 3.5 GHz in kHz (or whatever your max is)
  #     CPU_SCALING_MIN_FREQ_ON_BAT = 900000; # 900 MHz in kHz
  #     CPU_SCALING_MAX_FREQ_ON_BAT = 2000000; # 2 GHz in kHz - your desired middle ground
  #
  #     # #Optional helps save long term battery health
  #     # START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
  #     # STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
  #   };
  # };

  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";

        scaling_min_freq = 900000;
        scaling_max_freq = 2000000;
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

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=20min
  '';
}
