{
  lib,
  pkgs,
  pkgs-stable,
  inputs,
  vars,
  system,
  nixpkgs,
  host,
  config,
  ...
}: {
  imports = [
    inputs.hyprland.nixosModules.default
    inputs.steam-asahi.nixosModules.default
  ];

  boot.extraModprobeConfig = ''
    options hid_apple fnmode=2
    options hid_apple iso_layout=1
  '';

  hardware.asahi.enable = true;

  services.logind.settings.Login = {
    # lid close
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "subend-then-hibernate";

    # power button
    HandlePowerKey = "lock";
    HandlePowerKeyLongPress = "poweroff";
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

  boot.kernelParams = [
    #   "brcmfmac.feature_disable=0x82000"

    # steam asahi
    "zswap.enabled=1"
    "zswap.compressor=zstd"
    "zswap.zpool=zsmalloc"
    "zswap.max_pool_percent=20"
  ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
    "vm.page-cluster" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.max_map_count" = 1048576;
  };

  # makes charging stop at 80 percent and will switch to AC.
  # Automatically, if battery reaches 75 it will charge again.
  systemd.tmpfiles.rules = [
    "w /sys/class/power_supply/macsmc-battery/charge_control_end_threshold - - - - 80"
  ];

  networking.networkmanager.wifi.scanRandMacAddress = false;
  networking.networkmanager.wifi.macAddress = "preserve";

  boot.loader.efi.canTouchEfiVariables = false;

  boot.loader.limine = {
    maxGenerations = 5;
  };

  hardware.asahi.extractPeripheralFirmware = true;
  hardware.asahi.peripheralFirmwareDirectory = ../../firmware;

  services.pipewire.wireplumber.extraConfig."99-asahi-mic" = {
    "monitor.alsa.rules" = [
      {
        matches = [{"device.name" = "alsa_card.platform-audio.2.auto";}];
        actions.update-props."session.dont-restore-off-profile" = true;
      }
    ];
  };

  # swap
  swapDevices = [
    {
      device = "/dev/disk/by-uuid/63b04acd-93c6-4c41-bcf9-0be16d7c0e32";
    }
    {
      device = "/var/lib/swapfile";
      size = 12 * 1024;
    }
  ];

  fileSystems = {
    "/".options = ["compress=zstd"];
    "/home".options = ["compress=zstd"];
    "/nix".options = ["compress=zstd" "noatime"];
    "/virt-machines".options = ["compress=zstd"];
    "/gaming".options = ["compress=zstd"];
  };

  programs.steam-asahi = {
    enable = true;
    memoryMiB = 12288;
  };

  services.udev.packages = [
    pkgs.yubikey-personalization
  ];

  # this makes
  environment.etc."libinput/local-overrides.quirks".text = ''
    [keyd virtual keyboard]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal

    [Apple MTP multi-touch]
    MatchUdevType=touchpad
    MatchName=Apple MTP multi-touch
    AttrKeyboardIntegration=internal
  '';

  services.keyd = {
    enable = true;
    keyboards.default.settings = lib.mkForce {
      main = {
        # important
        capslock = "esc";

        # this swaps fn and ctrl on the horrible macos keyboard.
        # pressing fn (physical lctrl) enables a "control" layer
        # where i then can set the media behaviours for f keys.
        # pressing controll (physical fn) enables some other "control"
        # layer that doesn't seem to trigger media behvaiour on
        # the f keys. this perfectly resembles expected behvaiour
        # as if fn and control were physically swapped
        leftcontrol = "overload(fn, fn)";
        fn = "leftcontrol";
      };

      # here i am actually setting the media behaviour when the
      # swapped fn (physical controll) is placed
      control = {
        # fn + FXX to media
        f1 = "brightnessdown";
        f2 = "brightnessup";
        f7 = "previoussong";
        f8 = "playpause";
        f9 = "nextsong";
        f10 = "mute";
        f11 = "volumedown";
        f12 = "volumeup";
      };
    };
  };

  # steam.enable = true;
  android-studio.enable = true;

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["${vars.user}"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.libvirtd.qemu.swtpm.enable = true;

  system.activationScripts = {
    rfkillUnblockWlan = {
      text = ''
        rfkill unblock wlan
      '';
      deps = [];
    };
  };

  programs.gamescope.enable = true;
  programs.gamemode.enable = true;

  environment = {
    sessionVariables = {
      MOZ_GMP_PATH = ["${pkgs.widevine-cdm-lacros}/gmp-widevinecdm/system-installed"];
    };

    extraInit = ''
      ln -sfn ${pkgs.widevine-cdm}/WidevineCdm \
        /home/${vars.user}/.config/BraveSoftware/Brave-Browser/WidevineCdm/current
    '';

    systemPackages = with pkgs; [
      timewall
      awww

      prismlauncher

      # mullvad-vpn
      legendary-gl
    ];
  };

  fonts.fontconfig = {
    hinting = {
      enable = true;
      autohint = false;
      style = "full";
    };
    subpixel = {
      lcdfilter = "default";
      rgba = "rgb";
    };
    antialias = true;
  };

  home-manager.users.${vars.user} = {
    imports = [
      inputs.win11-nixos-apple-silicon.homeModules.default
    ];

    programs.win11-nixos-apple-silicon = {
      enable = true;

      memory = 1024 * 16;

      virtio-iso-path = "/home/jakki/Downloads/virtio-win-0.1.302.iso";
      win11-iso-path = "/home/jakki/Downloads/win11.iso";

      diskSize = 1024 * 100;
    };

    home.file.".config/fex-emu/Config.json" = {
      enable = true;
      text = ''
        {
          "Config": {
            "RootFS": "Fedora_44.ero"
          }
        }
      '';
    };

    git.gpgKey = "C8CD2840D9FD4E9B508C628955F07624172E58EB";

    home.stateVersion = "25.11";
  };

  system.stateVersion = "25.11";
}
