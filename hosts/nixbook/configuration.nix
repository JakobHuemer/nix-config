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
    options hid_apple iso_layout=0
  '';

  hardware.asahi.extractPeripheralFirmware = true;
  hardware.asahi.peripheralFirmwareDirectory = ../../firmware;

  hardware.graphics.enable = true;

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

  # io
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["*"];
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

  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.limine = {
    enable = true;
    maxGenerations = 15;
  };

  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # virtualisation.vmware.host.enable = true;

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["${vars.user}"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  security.polkit.enable = true;
  security.pki.certificateFiles = ["${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"];
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  networking.networkmanager.enable = true;
  networking.hostName = "${host.hostName}";

  programs.zsh.enable = true;

  programs.light.enable = true;

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
        pkgs.jetbrains.datagrip
        pkgs.jetbrains.rust-rover
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
          vdhcoapp
          trashy

          opencode

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

          blender

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

          # video download helper
          vdhcoapp

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

  hyprland.enable = true;

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

    # git.gpgKey = "DBFA8DCA389649DB6BEE8A009B4F31A8AFE90BEB";
  };
}
