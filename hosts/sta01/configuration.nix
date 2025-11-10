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
  # btrfs scubbing

  imports = [
    inputs.hyprland.nixosModules.default
  ];

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
  tuigreet = {
    enable = true;
    cmd = "Hyprland";
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
        pkgs.jetbrains.idea-ultimate
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
          rustdesk

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
          qemu_full
          virtiofsd

          (heroic.override {
            extraPkgs = pkgs: [
              pkgs.gamescope
              pkgs.gamemode
            ];
          })
        ]
        ++ (with pkgs-stable; [
          whatsie
        ])
        ++ jetbrainsIDEs
        ++ (pkgs.lib.concatMap (
            ide: let
              name = builtins.baseNameOf (builtins.parseDrvName ide.name).name;
            in [
              (pkgs.writeShellScriptBin "${name}-wayland" ''
                ${ide}/bin/${name} -Dawt.toolkit.name=WLToolkit
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

  programs.xwayland.enable = true;
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    xwayland.enable = true;
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
    hyprland.enable = true;
    mako.enable = true;
    waybar.enable = true;

    tofi.enable = true;
    ghostty.enable = true;
    tmux.enable = true;

    nixcord.enable = true;

    youtube-music.enable = true;

    useStylix = true;

    zen.enable = true;

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

  system = {
    stateVersion = "25.05";
  };
}
