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
      inputs.nixos-hardware.nixosModules.raspberry-pi-4
      inputs.home-manager.nixosModules.home-manager
    ]
    ++ (import ../../modules/nixos);

  sops.defaultSopsFile = ../../secrets/pi4.yaml;
  sops.age.keyFile = "/etc/sops/age/key.txt";

  sops.secrets."wifi_password_home" = {};

  # system
  tailscale.enable = true;

  # Disable X11 and display manager (if present)
  services.xserver.enable = false;

  # networking.nameservers = [ "9.9.9.9" "149.112.112.112" ];

  networking = {
    useDHCP = false;

    defaultGateway = "192.168.0.11";
    nameservers = ["9.9.9.9" "149.112.112.112"];

    interfaces.eth0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.0.42";
          prefixLength = 24;
        }
      ];
    };

    interfaces.wlan0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.0.43";
          prefixLength = 24;
        }
      ];
    };

    wireless = {
      enable = true;
      interfaces = ["wlan0"]; # Manage only wlan0
      networks = {
        "Wlan Kremsmuenster" = {
          psk = "ichbinkremsmuensterer";
        };
      };
    };
  };

  services.automatic-timezoned.enable = true;

  hardware = {
    raspberry-pi."4".apply-overlays-dtmerge.enable = true;
    deviceTree = {
      enable = true;
      filter = "*rpi-4-*.dtb";
    };
  };

  console.enable = false;

  networking.hostName = "${host.hostName}";

  programs.zsh.enable = true;

  security.sudo.wheelNeedsPassword = true;

  environment = {
    systemPackages = with pkgs; [
      libraspberrypi
      raspberrypi-eeprom

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
    ports = [4204];
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

    programs = {home-manager.enable = true;};
    home = {stateVersion = "25.05";};
  };

  home-manager.users.${vars.user} = {pkgs, ...}: {
    tmux.enable = true;

    git.gpgKey = "0E86AFCB4CF89B380E9101CB8C765C652BCEE672";
  };
}
