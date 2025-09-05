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
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    inputs.home-manager.nixosModules.home-manager
  ] ++ (import ../../modules/nixos);

  # system
  tailscale.enable = true;

  # Disable X11 and display manager (if present)
  services.xserver.enable = false;

  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocales = ["en_GB.UTF-8/UTF-8" "de_DE.UTF-8/UTF-8" "de_AT.UTF-8/UTF-8"];

  i18n.extraLocaleSettings = {
    LC_ALL = "en_GB.UTF-8";
  };


  networking.nameservers = [ "9.9.9.9" "149.112.112.112" ];

  networking.networkmanager = {
    enable = true;


    ensureProfiles = {
      profiles = {
	# Wired connection profile
	"wired-connection-1" = {
	  connection = {
	    id = "Wired connection 1";
	    uuid = "70ca4781-c4f9-37f2-b617-231a097a94b5";
	    type = "ethernet";
	    autoconnect-priority = "-999";
	    interface-name = "end0";
	  };
	  ethernet = {
	  };
	  ipv4 = {
	    method = "manual";
	    address1 = "192.168.0.42/24,192.168.0.11";
	    dns = "9.9.9.9;149.112.112.112;";
	  };
	  ipv6 = {
	    addr-gen-mode = "default";
	    method = "auto";
	  };
	  proxy = {
	  };
	};
	
	# WiFi connection profile
	"wlan-kremsmuenster" = {
	  connection = {
	    id = "Wlan Kremsmuenster";
	    uuid = "336de64d-9f4d-46f7-b6cf-4c487009d0c6";
	    type = "wifi";
	    interface-name = "wlan0";
	  };
	  wifi = {
	    mode = "infrastructure";
	    ssid = "Wlan Kremsmuenster";
	  };
	  wifi-security = {
	    auth-alg = "open";
	    key-mgmt = "wpa-psk";
	    psk = "notmypassword"; # put actual password in secretely
	  };
	  ipv4 = {
	    method = "manual";
	    address1 = "192.168.0.43/24,192.168.0.11";
	    dns = "9.9.9.9;149.112.112.112;";
	  };
	  ipv6 = {
	    addr-gen-mode = "default";
	    method = "auto";
	  };
	  proxy = {
	  };
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
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH5xznaVUeu1mED3C2e60W+fbWeGQdeD9m+wz+GTVo0o jakki@nitro"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  home-manager = {
    extraSpecialArgs = {inherit inputs system vars pkgs-stable host;};

    useGlobalPkgs = false;
    useUserPackages = true;
  };

  home-manager.users.${vars.user} = {pkgs, ...}: {
    imports = import ../../modules/home;

    nixpkgs.config.allowUnfree = true;

    tmux.enable = true;

    home = {stateVersion = "25.05";};
    programs = {home-manager.enable = true;};
  };

  system = {stateVersion = "25.05";};
}
