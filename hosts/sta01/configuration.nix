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

  ollama.enable = true;

  specialisation.gnome-xorg = {
    configuration = {
      # Enable X server + GNOME desktop on Xorg
      services.xserver.enable = true;
      services.xserver.displayManager.gdm.enable = true;
      services.xserver.desktopManager.gnome.enable = true;

      # Disable greetd so it doesn't conflict with GDM
      greetd.enable = lib.mkForce false;
      services.greetd.enable = lib.mkForce false;

      # Disable Hyprland to avoid portal/session conflicts
      hyprland.enable = lib.mkForce false;
      programs.hyprland.enable = lib.mkForce false;

      # Override Wayland env vars so apps use X11 natively
      environment.variables = {
        NIXOS_OZONE_WL = lib.mkForce "0";
        ELECTRON_OZONE_PLATFORM_HINT = lib.mkForce "x11";
      };
    };
  };

  specialisation.amd-gpu-passthrough = {
    configuration = {
      boot.extraModprobeConfig = ''
        softdep amdgpu pre: vfio-pci
      '';

      boot.initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"

        "amdgpu"
      ];

      boot.kernelParams = [
        "vfio-pci.ids=1002:ab30,1002:747e" # amd 7800 XT
      ];
    };
  };

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

            # for desktop keyboard and window managers
            leftmeta = "leftalt";
            leftalt = "leftmeta";
          };
        };
      };
    };
  };

  steam.enable = true;
  greetd = {
    enable = true;
  };
  tailscale.enable = true;

  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  boot.loader.limine = {
    enable = true;
  };

  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  virtualisation.vmware.host.enable = true;

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["${vars.user}"];
  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  services.udev.packages = [
    pkgs.yubikey-personalization
  ];

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
          xrdb

          podman-tui
          # docker-compose
          podman-compose
          # qemu-utils
          virtiofsd

          (heroic.override {
            extraPkgs = pkgs: [
              pkgs.gamescope
              pkgs.gamemode
            ];
          })
        ]
        ++ (with pkgs-stable; [
          qemu_full # until it unstable is stable again
          rustdesk
        ])
        ++ [
          inputs.hytale-launcher.packages.${system}.default
        ]
        ++ jetbrainsIDEs
        ++ (pkgs.lib.concatMap (
            ide: let
              name = baseNameOf (builtins.parseDrvName ide.name).name;
            in [
              (pkgs.writeShellScriptBin "${name}-wayland" ''
                ${ide}/bin/${name} -Dawt.toolkit.name=WLToolkit "$@"
              '')
            ]
          )
          jetbrainsIDEs);
  };

  services.xserver.dpi = 108;

  # fonts.fontconfig = {
  #   hinting = {
  #     enable = true;
  #     autohint = false;
  #     style = "full";
  #   };
  #   subpixel = {
  #     lcdfilter = "default";
  #     rgba = "rgb";
  #   };
  #   antialias = true;
  # };

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

    # mullvad-vpn = {
    #   enable = true;
    #   package = pkgs.mullvad;
    # };
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

  systemd = {
    services.xrdp = {
      serviceConfig = {
        ExecStart = lib.mkForce "${pkgs.xrdp}/bin/xrdp --nodaemon --config /home/${vars.user}/.Xresources";
        # https://github.com/NixOS/nixpkgs/blob/nixos-23.11/nixos/modules/services/networking/xrdp.nix#L158
        # seems the integer port results in ipv6 only
      };
    };
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

    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };

    # home.activation = {
    #   extraActivation = ''
    #     ${pkgs.xorg.xrdb}/bin/xrdb /home/${vars.user}/.Xresources
    #   '';
    # };

    xresources = {
      path = "/home/${vars.user}/.Xresources";
      extraConfig = ''
        Xft.dpi: 163
        Xft.autohint: 0
        Xft.lcdfilter:  lcddefault
        Xft.hintstyle:  hintfull
        Xft.hinting: 1
        Xft.antialias: 1
        Xft.rgba: rgb
      '';
    };

    git.gpgKey = "DBFA8DCA389649DB6BEE8A009B4F31A8AFE90BEB";
  };
}
