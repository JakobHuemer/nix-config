{
  lib,
  pkgs,
  pkgs-stable,
  inputs,
  vars,
  system,
  nixpkgs,
  host,
  ...
}: {
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  # fingerprint
  services.fprintd.enable = true;

  fileSystems."/" = {
    options = ["compress=zstd"];
  };

  fileSystems."/home" = {
    options = ["compress=zstd"];
  };

  fileSystems."/shared" = {
    options = ["compress=zstd"];
  };

  fileSystems."/nix" = {
    options = ["compress=zstd" "noatime"];
  };

  fileSystems."/swap" = {
    options = ["noatime"];
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 36 * 1024;
    }
  ];

  boot = {
    kernelParams = [
      "resume_offset=28668091"
    ];

    resumeDevice = "/dev/disk/by-uuid/df894974-92ce-4bcf-97be-2cc41fdfceed";
  };

  # tpm setup
  boot.initrd.systemd.tpm2.enable = true;

  # btrfs scubbing
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = ["/"];
  };

  networking.firewall = {
    enable = true;
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["*" "-4c4b:4643" "-1d50:615e" "-16c0:27db"];
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

  boot.loader.limine = {
    enable = true;
  };

  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
    dockerSocket.enable = true;
  };

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
    login.fprintAuth = false;
    sudo.u2fAuth = true;
    sudo.fprintAuth = true;
  };

  networking.networkmanager.enable = true;
  networking.hostName = "${host.hostName}";

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
        # pkgs.jetbrains.idea-oss
        pkgs.jetbrains.idea
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

          obs-studio
          qt6.qtwayland

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

          affinity-v3

          (pkgs-stable.heroic.override {
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
    opencode.enable = lib.mkForce false;

    mako.enable = true;
    waybar.enable = true;

    tofi.enable = true;
    programs.ghostty.enable = true;
    tmux.enable = true;

    programs.vesktop.enable = true;

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

    home.stateVersion = lib.mkForce "26.05";
  };

  system = {
    stateVersion = lib.mkForce "26.05";
  };
}
