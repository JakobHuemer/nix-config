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

  sops.defaultSopsFile = ../../secrets/pi4.yaml;
  sops.age.keyFile = "/home/${vars.user}/.config/sops/age/keys.txt";

  #   owner = "root";
  #   group = "wheel";
  #   mode = "0400";
  # };


  # nftables.enable = true;
  # caddy.enable = true;
  #
  # immich.enable = true;
  # vaultwarden.enable = true;

  acme."fistel.dev".enable = true;

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
    allowedTCPPorts = [ 80 443 6443 ];
    allowedUDPPorts = [ 80 443 6443 ];

    trustedInterfaces = [
      "tailscale0"
    ];
  };

  programs.zsh.enable = true;

  security.sudo.wheelNeedsPassword = true;

  # services.kubernetes = {
  #   roles = ["master" "node"];
  #   masterAddress = kubeMasterHostname;
  #   apiserverAddress = "https://${kubeMasterHostname}:${toString kubeMasterAPIServerPort}";
  #   # easyCerts = true;
  #
  #   apiserver = {
  #     securePort = kubeMasterAPIServerPort;
  #     advertiseAddress = kubeMasterIP;
  #   };
  #
  #   addons.dns.enable = true;
  #
  #   # kubelet.extraOpts = "--fail-swap-on=false";
  # };
  #
  # systemd.services.etcd = {
  #   environment = {
  #     ETCD_UNSUPPORTED_ARCH = "arm64";
  #   };
  # };

  services.k3s = {
    enable = true;
    role = "server";  # or "agent" for worker nodes
    extraFlags = toString [
      # optional: disable traefik if you want to use something else
      # "--disable=traefik"
    ];

    manifests.traefik-config.content = {
      apiVersion = "helm.cattle.io/v1";
      kind = "HelmChartConfig";
      metadata = {
        name = "traefik";
        namespace = "kube-system";
      };
      spec.valuesContent = ''
        tlsStore:
          default:
            defaultCertificate:
              secretName: tls-secret
      '';
    };
  };

  systemd.services.k3s-tls-secret = {
    requires = [ "k3s.service" "acme-fistel.dev.service" ];
    after = [ "k3s.service" "acme-fistel.dev.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      
      LoadCredential = [
        "tls.crt:/var/lib/acme/fistel.dev/fullchain.pem"
        "tls.key:/var/lib/acme/fistel.dev/key.pem"
      ];
    };
    script = ''
      ${pkgs.k3s}/bin/k3s kubectl create secret tls tls-secret \
        --cert=/var/lib/acme/fistel.dev/fullchain.pem \
        --key=/var/lib/acme/fistel.dev/key.pem \
        -n kube-system \
        --dry-run=client -o yaml | ${pkgs.k3s}/bin/k3s kubectl apply -f -
    '';
  };

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

      # kubernetes
      kompose
      kubectl
      kubernetes
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

    programs = {
      home-manager.enable = true;
    };
    home = {
      stateVersion = "25.11";
    };
  };

  home-manager.users.${vars.user} = {pkgs, ...}: {
    # tmux.enable = true;

    git.gpgKey = "2F948936806377F59BF2D6D60A92AD5C02F180B9";
  };
}
