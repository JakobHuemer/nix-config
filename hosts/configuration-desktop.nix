{
  inputs,
  pkgs,
  vars,
  ...
}: {
  # printing
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
      gutenprint
      canon-cups-ufr2
      canon-capt
    ];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    # settings = {
    #   General = {
    #     # Shows battery charge of connected devices on supported
    #     # Bluetooth adapters. Defaults to 'false'.
    #     Experimental = true;
    #     # When enabled other devices can connect faster to us, however
    #     # the tradeoff is increased power consumption. Defaults to
    #     # 'false'.
    #     FastConnectable = true;
    #
    #     Enable = "Source,Sink,Media,Socket";
    #     # https://unix.stackexchange.com/questions/407447/how-to-force-a2dp-sink-when-wireless-bluetooth-headset-is-connected/415928#415928
    #     AutoConnect = true;
    #     # MultiProfile = "multiple";
    #     # Disable = "Headset";
    #   };
    #   Policy = {
    #     # Enable all controllers when they are found. This includes
    #     # adapters present on start as well as adapters that are plugged
    #     # in later on. Defaults to 'true'.
    #     # AutoEnable = true;
    #   };
    # };
  };

  services.pulseaudio.enable = false;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # extraConfig.pipewire."92-low-latency" = {
    #   "context.properties" = {
    #     "default.clock.rate" = 48000;
    #     "default.clock.quantum" = 32;
    #     "default.clock.min-quantum" = 32;
    #     "default.clock.max-quantum" = 32;
    #   };
    # };
    #
    # wireplumber.extraConfig.bluetoothEnhancements = {
    #   "monitor.bluez.properties" = {
    #     "bluez5.enable-sbc-xq" = true;
    #     "bluez5.enable-msbc" = true;
    #     "bluez5.enable-hw-volume" = true;
    #     "bluez5.roles" = [
    #       "hsp_hs"
    #       "hsp_ag"
    #       "hfp_hf"
    #       "hfp_ag"
    #     ];
    #   };
    # };
  };

  services.blueman.enable = true;

  users.users.${vars.user} = {
    extraGroups = [
      "networkmanager"
      "video"
      "storage"
    ];
  };

  fonts.packages = with pkgs; [
    # monospace
    jetbrains-mono

    # normal fonts
    noto-fonts
    montserrat
    # noto-fonts-color-emoji

    corefonts # MS
  ];

  environment = {
    variables = {
      NIXOS_OZONE_WL = 1;
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    };

    systemPackages = with pkgs; [
      gparted
    ];
  };

  home-manager.users.${vars.user} = {pkgs, ...}: {
    libre-office.enable = true;

    nemo.enable = true;
  };
}
