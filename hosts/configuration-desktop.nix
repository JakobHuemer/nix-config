{
  inputs,
  pkgs,
  vars,
  lib,
  host,
  system,
  ...
}: {
  # log to startup to tty1 to make tuigreet clean
  boot.kernelParams = [
    "console=tty1"
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  specialisation.linux-lts = {
    configuration.boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  };

  hardware.graphics.enable = true;

  systemd.user.services.open-thunderbird = {
    description = "Open Thunderbird (UWSM)";

    serviceConfig = {
      Type = "oneshot";

      # Only run when a UWSM-managed graphical session is active.
      ExecCondition = "${pkgs.uwsm}/bin/uwsm check is-active";

      # Launch as a proper systemd user unit in UWSM's app slice.
      ExecStart = "${pkgs.uwsm}/bin/uwsm app -s a -t service -- ${pkgs.thunderbird}/bin/thunderbird";
    };
  };

  systemd.user.timers.open-thunderbird = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "Mon..Fri 07:55";
      Unit = "open-thunderbird.service";
    };
  };

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

  services.qbittorrent = {
    enable = true;
    webuiPort = 4205;
    # package = pkgs.qbittorrent-enhanced;
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
    # noto-fonts
    montserrat
    # noto-fonts-color-emoji

    corefonts # MS

    atkinson-hyperlegible-next

    nvtopPackages.amd
  ];

  environment = {
    variables = {
      NIXOS_OZONE_WL = 1;
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    };

    systemPackages = with pkgs; [
      gparted
      font-manager

      # zed-editor

      minikube
      # docker-machine-kvm2

      # tailscale ui
      ktailctl

      # browsers
      ungoogled-chromium
      brave
      vivaldi

      networkmanagerapplet

      filezilla

      obsidian

      wlr-layout-ui

      teamspeak6-client

      element-desktop

      claude-code
      codex
      aider-chat

      lmstudio
    ];
  };

  home-manager.users.${vars.user} = {pkgs, ...}: {
    # libre-office.enable = true;

    services.trayscale.enable = true;
    opencode.enable = true;

    nemo.enable = true;
  };
}
