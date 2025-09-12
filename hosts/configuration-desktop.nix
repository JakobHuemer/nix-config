{
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

  services.udisks2.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    # settings = {
    #   General = {
    #     Experimental = true;
    #     Enable = "Source,Sink,Media,Socket";
    #   };
    # };
  };

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

    wireplumber.extraConfig.bluetoothEnhancements = {
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.roles" = [
          "hsp_hs"
          "hsp_ag"
          "hfp_hf"
          "hfp_ag"
        ];
      };
    };
  };

  services.blueman.enable = true;

  users.users.${vars.user} = {
    extraGroups = [
      "networkmanager"
      "video"
      "storage"
    ];
  };

  fonts.packages =
    with pkgs; [
      jetbrains-mono

      noto-fonts
      # noto-fonts-emoji

      corefonts # MS
    ]
    # ++ [
    #   inputs.apple-emoji-linux.packages.${system}.default
    # ]
    ;

  home-manager.users.${vars.user} = {pkgs, ...}: {
    services.udiskie.enable = true;

    libre-office.enable = true;

    services.udiskie.settings = {
      automount = true;
      notify = true;
      tray = false;
    };
  };
}
