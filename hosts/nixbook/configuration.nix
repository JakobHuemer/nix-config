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

  hardware.asahi.extractPeripheralFirmware = true;
  hardware.asahi.peripheralFirmwareDirectory = ../../firmware;

  fileSystems = {
        "/".options = ["compress=zstd"];
        "/home".options = ["compress=zstd"];
        "/nix".options = ["compress=zstd" "noatime"];
        "/virt-machines".options = ["compress=zstd"];
        "/gaming".options = ["compress=zstd"];
  };

  # disable 32bit
  # services.pulseaudio.support32Bit = false;
  # services.pipewire.alsa.support32Bit = false;

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

	    leftcontrol = "fn";
	    fn = "leftcontrol";
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
        ]
        ++ (with pkgs-stable; [
          qemu_full # until it unstable is stable again
          rustdesk
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

    # nixcord.enable = true;

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
