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
  imports =
    [
      # inputs.nixos-hardware.nixosModules.raspberry-pi-4
      inputs.home-manager.nixosModules.home-manager
    ]
    ++ (import ../../modules/nixos);

  boot.loader.grub.enable = false;

  sops.defaultSopsFile = ../../secrets/pi4.yaml;
  sops.age.keyFile = "/home/${vars.user}/.config/sops/age/keys.txt";

  # sops.secrets."wifi_password_home" = {
  #   owner = "root";
  #   group = "wheel";
  #   mode = "0400";
  # };

  # sops.templates."wifi-env.conf" = {
  #   content = ''
  #     psk_home=${config.sops.placeholder.wifi_password_home}
  #   '';
  #   owner = "root";
  # };

  # nftables.enable = true;
  # caddy.enable = true;
  #
  # immich.enable = true;
  # vaultwarden.enable = true;

  # acme."fistel.dev".enable = true;

  # system
  tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "both";

  # Disable X11 and display manager (if present)
  services.xserver.enable = false;

  # networking.nameservers = [ "9.9.9.9" "149.112.112.112" ];

  networking.networkmanager.enable = true;
  networking.hostName = "${host.hostName}";

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
