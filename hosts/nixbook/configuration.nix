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
  ];

  boot.extraModprobeConfig = ''
    options hid_apple fnmode=2
    options hid_apple iso_layout=1
  '';

  specialisation.kernel-latest = lib.mkForce {};
  # fixes temporarly
  /* 
  warning: the following units failed: systemd-sysctl.service
  × systemd-sysctl.service - Apply Kernel Variables
       Loaded: loaded (/etc/systemd/system/systemd-sysctl.service; enabled; preset: ignored)
      Drop-In: /nix/store/lhhc3s6yqbmdbig9ffhrzpfq8ii76n0x-system-units/systemd-sysctl.service.d
               └─overrides.conf
       Active: failed (Result: exit-code) since Mon 2026-04-27 12:15:13 CEST; 340ms ago
     Duration: 5.040s
   Invocation: 7e4b7f175eb741de8ed2e00036350416
         Docs: man:systemd-sysctl.service(8)
               man:sysctl.d(5)
      Process: 60598 ExecStart=/nix/store/084z7x42nynj9znvqp3c38viqkqvkppx-systemd-260.1/lib/systemd/systemd-sysctl (code=exited, status=1/FAILURE)
     Main PID: 60598 (code=exited, status=1/FAILURE)
           IP: 0B in, 0B out
           IO: 0B read, 0B written
     Mem peak: 3M
          CPU: 7ms

  Apr 27 12:15:13 nixbook systemd[1]: Starting Apply Kernel Variables...
  Apr 27 12:15:13 nixbook systemd-sysctl[60598]: Couldn't write '32' to 'vm/mmap_rnd_bits': Invalid argument
  Apr 27 12:15:13 nixbook systemd[1]: systemd-sysctl.service: Main process exited, code=exited, status=1/FAILURE
  Apr 27 12:15:13 nixbook systemd[1]: systemd-sysctl.service: Failed with result 'exit-code'.
  Apr 27 12:15:13 nixbook systemd[1]: Failed to start Apply Kernel Variables.
  Command 'systemd-run -E LOCALE_ARCHIVE -E NIXOS_INSTALL_BOOTLOADER -E NIXOS_NO_CHECK --collect --no-ask-password --pipe --quiet --service-type=exec --unit=nixos-rebuild-switch-to-configuration /nix/store/s83p85v92vj3l7pyiwkxmhzix552m30r-nixos-system-nixbook-26.05.20260422.0726a0e/bin/switch-to-configuration test' returned non-zero exit status 4.
  */
  boot.kernel.sysctl."vm.mmap_rnd_bits" = lib.mkForce 31;

  # boot.kernelParams = [
  #   "brcmfmac.feature_disable=0x82000"
  # ];

  # networking.networkmanager.wifi.scanRandMacAddress = false;
  # networking.networkmanager.wifi.macAddress = "preserve";

  networking.networkmanager.wifi.scanRandMacAddress = false;
  networking.networkmanager.wifi.macAddress = "preserve";

  # boot.loader.limine.enable = lib.mkForce false;
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  boot.loader.limine = {
    enable = true;
    maxGenerations = 15;
  };

  hardware.asahi.extractPeripheralFirmware = true;
  hardware.asahi.peripheralFirmwareDirectory = ../../firmware;

  # sops = {
  #   secrets."wificreds/htlleonding-wpa/user" = {};
  #   secrets."wificreds/htlleonding-wpa/password" = {};
  #
  #   templates."htlleonding-wpa.8021x" = {
  #     content = ''
  #       [Security]
  #       EAP-Method=PEAP
  #       EAP-Identity=${config.sops.placeholder."wificreds/htlleonding-wpa/user"}
  #       EAP-PEAP-Phase2-Method=MSCHAPV2
  #       EAP-PEAP-Phase2-Identity=${config.sops.placeholder."wificreds/htlleonding-wpa/user"}
  #       EAP-PEAP-Phase2-Password=${config.sops.placeholder."wificreds/htlleonding-wpa/password"}
  #
  #       [Settings]
  #       AutoConnect=true
  #     '';
  #     owner = "jakki";
  #     mode = "0400";
  #   };
  # };
  #
  # systemd.tmpfiles.rules = [
  #   "L /var/lib/iwd/htlleonding-wpa.8021x - - - - /run/secrets-rendered/htlleonding-wpa.8021x"
  # ];

  # swap
  swapDevices = [
    {
      device = "/dev/disk/by-uuid/63b04acd-93c6-4c41-bcf9-0be16d7c0e32";
    }
  ];

  boot.resumeDevice = "/dev/disk/by-uuid/63b04acd-93c6-4c41-bcf9-0be16d7c0e32";

  fileSystems = {
    "/".options = ["compress=zstd"];
    "/home".options = ["compress=zstd"];
    "/nix".options = ["compress=zstd" "noatime"];
    "/virt-machines".options = ["compress=zstd"];
    "/gaming".options = ["compress=zstd"];
  };

  services.udev.packages = [
    pkgs.yubikey-personalization
  ];

  # btrfs scubbing
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = ["/"];
  };

  networking.firewall = {
    enable = true;

    allowedTCPPorts = [25565 24454];
    allowedUDPPorts = [25565 24454];
  };

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

  # environment.etc."libinput/local-overrides.quirks".source = "${pkgs.libinput}/share/libinput/50-system-apple.quirks";

  # io
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["*" "-4c4b:4643"];
        settings = {
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
    };
  };

  # steam.enable = true;
  greetd = {
    enable = true;
  };
  tailscale.enable = true;

  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
    dockerSocket.enable = true;
  };

  # virtualisation.vmware.host.enable = true;

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["${vars.user}"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # virtualisation.tpm.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;

  security.polkit.enable = true;
  security.pki.certificateFiles = ["${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"];
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  networking.networkmanager.enable = true;
  networking.hostName = "${host.hostName}";
  # networking.wireless.iwd.enable = true;
  # networking.wireless.iwd.settings = {
  #   IPv6 = {
  #     Enabled = true;
  #   };
  #   Settings = {
  #     AutoConnect = true;
  #   };
  # };
  # networking.networkmanager.wifi.backend = "iwd";

  system.activationScripts = {
    rfkillUnblockWlan = {
      text = ''
        rfkill unblock wlan
      '';
      deps = [];
    };
  };

  programs.zsh.enable = true;

  # gaming
  programs.gamescope.enable = true;
  programs.gamemode.enable = true;

  environment = {
    variables = {
      SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
    };

    systemPackages = let
      jetbrainsIDEs = [
        pkgs.jetbrains.webstorm
        pkgs.jetbrains.idea-oss
        pkgs.jetbrains.idea
        pkgs.jetbrains.datagrip
        pkgs.jetbrains.rust-rover
        pkgs.jetbrains.clion
      ];
    in
      with pkgs;
        [
          firefox
          grim # screenshots
          slurp # screenshots
          wl-clipboard # obv
          mako # notification system
          pavucontrol
          distrobox
          prismlauncher
          thunderbird
          chatterino7
          kdiskmark
          keyd
          lm_sensors
          trashy

          postman

          # # jetbrains
          # # jetbrains-toolbox
          # jetbrains.webstorm
          # jetbrains.idea-ultimate
          # jetbrains.datagrip
          # jetbrains.rust-rover
          #
          # (pkgs.writeShellScriptBin "idea-wayland" ''
          #   ${pkgs.jetbrains.idea-ultimate}/bin/idea-ultimate -Dawt.toolkit.name=WLToolkit
          # '')

          neovim
          vscode-fhs

          gnupg
          pinentry-curses

          # mullvad-vpn
          mullvad

          cacert
          openssl
          dconf
          btop

          librespeed-cli

          gamemode
          xorg.xrdb

          podman-tui
          # docker-compose
          podman-compose
          # qemu-utils
          virtiofsd

          # (heroic.override {
          #   extraPkgs = pkgs: [
          #     pkgs.gamescope
          #     pkgs.gamemode
          #   ];
          # })
          rustdesk-flutter

          # iwgtk
        ]
        ++ (with pkgs-stable; [
          qemu_full # until it unstable is stable again
        ])
        ++ jetbrainsIDEs
        ++ (pkgs.lib.concatMap (
            ide: let
              name = builtins.baseNameOf (builtins.parseDrvName ide.name).name;
            in [
              (pkgs.writeShellScriptBin "${name}-wayland" ''
                ${ide}/bin/${name} -Dawt.toolkit.name=WLToolkit "$@"
              '')
            ]
          )
          jetbrainsIDEs);
  };

  # services.xserver.dpi = 108;

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

  # xdg.portal = {
  #   enable = true;
  #   xdgOpenUsePortal = true;
  #   config = {
  #     common.default = ["gtk"];
  #     hyprland.default = ["gtk" "hyprland"];
  #   };
  #   extraPortals = [
  #     pkgs.xdg-desktop-portal-gtk
  #     pkgs.xdg-desktop-portal-wlr
  #     pkgs.xdg-desktop-portal-hyprland
  #   ];
  # };

  services = {
    openssh = {
      enable = true;
    };

    gnome.gnome-keyring.enable = true;
  };

  home-manager.extraSpecialArgs = {
    inherit
      inputs
      system
      nixpkgs
      vars
      host
      ;
  };

  home-manager.users.${vars.user} = {
    mako.enable = true;
    waybar.enable = true;

    tofi.enable = true;
    ghostty.enable = true;
    tmux.enable = true;

    nixcord.enable = true;

    youtube-music.enable = true;

    useStylix = true;

    zen.enable = true;

    # dconf.settings = {
    #   "org/virt-manager/virt-manager/connections" = {
    #     autoconnect = ["qemu:///system"];
    #     uris = ["qemu:///system"];
    #   };
    # };

    # home.activation = {
    #   extraActivation = ''
    #     ${pkgs.xorg.xrdb}/bin/xrdb /home/${vars.user}/.Xresources
    #   '';
    # };

    # xresources = {
    #   path = "/home/${vars.user}/.Xresources";
    #   extraConfig = ''
    #     Xft.dpi: 163
    #     Xft.autohint: 0
    #     Xft.lcdfilter:  lcddefault
    #     Xft.hintstyle:  hintfull
    #     Xft.hinting: 1
    #     Xft.antialias: 1
    #     Xft.rgba: rgb
    #   '';
    # };

    git.gpgKey = "C8CD2840D9FD4E9B508C628955F07624172E58EB";
  };
}
