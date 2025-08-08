{
  lib,
  pkgs,
  inputs,
  vars,
  system,
  nixpkgs,
  host,
  config,
  ...
}: {
  # system

  steam.enable = true;
  tuigreet.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelModules = ["nouveau"];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
    ];
  };
  # services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    open = true;

    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      sync.enable = true;
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:5:0:0";
    };
  };

  specialisation = {
    on-the-go.configuration = {
      system.nixos.tags = ["on-the-go"];
      hardware.nvidia = {
        prime = {
          sync.enable = lib.mkForce false;
          offload.enable = lib.mkForce true;
          offload.enableOffloadCmd = lib.mkdForce true;
        };
      };
    };
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
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
  networking.hostName = "nitro";

  programs.zsh.enable = true;

  programs.light.enable = true;

  environment = {
    variables = {
      SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
    };

    systemPackages = with pkgs; [
      firefox
      grim # screenshots
      slurp # screenshots
      wl-clipboard # obv
      mako # notification system
      pavucontrol
      distrobox
      prismlauncher
      thunderbird

      neovim
      vscode

      gnupg
      pinentry-curses

      mullvad-vpn
      mullvad

      cacert
      openssl
    ];
  };

  services = {
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };

    openssh = {enable = true;};

    gnome.gnome-keyring.enable = true;

    mullvad-vpn.enable = true;
  };

  home-manager.extraSpecialArgs = {inherit inputs system nixpkgs vars host;};

  home-manager.users.${vars.user} = {
    sway.enable = true;
    mako.enable = true;
    waybar.enable = true;

    tofi.enable = true;
    ghostty.enable = true;
    tmux.enable = true;

    nixcord.enable = true;

    youtube-music.enable = true;

    useStylix = true;

    zen.enable = true;

    git.gpgKey = "C68AA68E0D1846F90E1336278D4386EB3398D4A3";
  };

  system = {stateVersion = "25.05";};
}
