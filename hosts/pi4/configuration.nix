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
}: let
  kubeMasterIP = "192.168.0.42";
  kubeMasterHostname = "api.kube";
  kubeMasterAPIServerPort = 6443;
in {
  imports =
    [
      # inputs.nixos-hardware.nixosModules.raspberry-pi-4
      inputs.home-manager.nixosModules.home-manager
    ]
    ++ (import ../../modules/nixos);

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  fileSystems."/srv/cloud01" = {
    device = "/dev/disk/by-label/cloud01";
    fsType = "ext4";
    options = ["x-systemd.automount" "nofail"];
  };

  fileSystems."/srv/cloud01-bac" = {
    device = "/dev/disk/by-label/cloud01-backup";
    fsType = "ext4";
    options = ["x-systemd.automount" "nofail"];
  };

  sops.age.keyFile = "/home/${vars.user}/.config/sops/age/keys.txt";

  virtualisation.docker.enable = false;
  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
  };
  virtualisation.containers.storage.settings = {
    storage = {
      driver = "overlay";
      graphRoot = "/srv/cloud01/podman";
      runRoot = "/run/containers/storage";
    };
  };

  users.extraUsers.${vars.user}.extraGroups = ["podman"];

  # services.caddy = {
  #   enable = true;
  #
  #   virtualHosts."seafile.fistel.dev".extraConfig = ''
  #     reverse_proxy localhost:8088
  #   '';
  # };

  # virtualisation.arion = {
  #   backend = "podman-socket";
  #   projects.seafile = {
  #     serviceName = "seafile";
  #     settings = {
  #       imports = [
  #         (import ../../compose/seafile.nix {
  #           storage = "/srv/cloud01/seafile";
  #           hostname = "seafile.ts.fistel.dev";
  #           port = 8088;
  #         })
  #       ];
  #     };
  #   };
  # };
  # services.seafile = {
  #   # enable = true;
  #   adminEmail = "jakobhuemer2.0@gmail.com";
  #   initialAdminPassword = "changeme";
  #   dataDir = "/srv/cloud01/seafile";
  # };

  # system
  tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "both";

  # Disable X11 and display manager (if present)
  services.xserver.enable = false;

  # networking.nameservers = [ "9.9.9.9" "149.112.112.112" ];

  networking.networkmanager.enable = true;
  networking.hostName = "${host.hostName}";
  networking.extraHosts = "${kubeMasterIP} ${kubeMasterHostname}";

  networking.firewall = {
    allowedTCPPorts = [80 443];
    allowedUDPPorts = [80 443];

    trustedInterfaces = [
      "tailscale0"
    ];
  };

  programs.zsh.enable = true;

  security.sudo.wheelNeedsPassword = true;

  environment = {
    systemPackages = with pkgs; [
      # libraspberrypi
      # raspberrypi-eeprom

      neovim
      gnupg
      pinentry-curses

      cacert
      openssl

      librespeed-cli

      arion
      docker-client
    ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  users.users.${vars.user} = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH5xznaVUeu1mED3C2e60W+fbWeGQdeD9m+wz+GTVo0o jakki@nitro"
    ];
  };

  # for zsh for root
  home-manager.users.root = {pkgs, ...}: {
    imports = import ../../modules/home;

    nixpkgs.config.allowUnfree = true;
    git.gpgKey = "2F948936806377F59BF2D6D60A92AD5C02F180B9";

    programs = {
      home-manager.enable = true;
    };
    home = {
      stateVersion = "25.11";
    };
  };
}
