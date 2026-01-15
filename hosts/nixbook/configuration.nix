# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ system, host, vars, config, lib, pkgs, pkgs-stable, inputs, ... }:

{

  imports = [
      inputs.home-manager-stable.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
    ]
    ++ (import ../../modules/nixos);

  fileSystems = {
	"/".options = ["compress=zstd"];
	"/home".options = ["compress=zstd"];
	"/nix".options = ["compress=zstd" "noatime"];
	"/virt-machines".options = ["compress=zstd"];
	"/gaming".options = ["compress=zstd"];
  };

  i18n = {
    defaultLocale = "en_GB.UTF-8";

    extraLocales = [
      "en_GB.UTF-8/UTF-8"
      "en_DE.UTF-8/UTF-8"
      "en_AT.UTF-8/UTF-8"
    ];

    extraLocaleSettings = {
      LC_MONETARY = "de_AT.UTF-8";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "de-latin1";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  # hardware.asahi.extractPeripheralFirmware = true;
  hardware.asahi.peripheralFirmwareDirectory = ../../firmware;

  # networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # networking.hostName = "nixbook";

  networking.wireless.iwd = {
  	enable = true;
	settings.General.EnableNetworkConfiguration = true;
  };

  nix = {
  	# enable = true;
  	settings = {
		extra-substituters = [
			"https://nixos-apple-silicon.cachix.org"
		];
		extra-trusted-public-keys = [
			"nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
		];
	};
	extraOptions = ''
		experimental-features = nix-command flakes
		keep-outputs 	      = true
		keep-derivations      = true
	'';

	# registry.nixpkgs.flake = inputs.nixpkgs;
	
  };

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;


  environment = {
    variables = {
      TERMINAL = "${vars.terminal}";
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";

      SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
    };

    systemPackages = with pkgs; [
      zsh
      pinentry-all
      fh
      net-tools
      dig
      sops
      age
      vlc
      lsof
      gparted
      font-manager

      ungoogled-chromium
      brave
      vivaldi
      firefox

      neovim
      git
      gnupg
      pinentry-curses

      cacert
      openssl
      dconf
      btop

      opencode

      pavucontrol
    ];
  };

  hyprland.enable = true;

  services.openssh.enable = true;

  services.gnome.gnome-keyring.enable = true;

  services.blueman.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = ["*"];
      settings.main = {
        capslock = "esc";
      };
    };
  };

  tailscale.enable = true;

  services.udev.packages = [
    pkgs.yubikey-personalization
  ];

  security.polkit.enable = true;
  # security.pk1.certificateFiles = ["${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"];
  # security.pam.services = {
  #   login.uf2Auth = true;
  #   sudo.uf2Auth = true;
  # };

  # services.pulseaudio.enable = true;

  # security.rkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  users.users.${vars.user} = {
    extraGroups = [ "wheel" "networkmanager" "video" "storage" ];
    isNormalUser = true;
  };

  
  home-manager.extraSpecialArgs = {
    inherit inputs system vars pkgs-stable host;
  };

  home-manager = {
    useGlobalPkgs = false;
    useUserPackages = true;
    backupFileExtension = "hm-bk";
  };

  home-manager.users.${vars.user} = {pkgs, ...}: {
    imports = import ../../modules/home;

    nixpkgs.config.allowUnfree = true;

    # zsh.enable = true;

    home.file.".nix-assets" = {
      source = ../../assets;
      recursive = true;
    };

    services.trayscale.enable = true;
    nemo.enable = true;

    waybar.enable = true;
    mako.enable = true;
    tofi.enable = true;
    ghostty.enable = true;
    tmux.enable = true;

    useStylix = true;

    programs.home-manager.enable = true;

    home.stateVersion = "25.11";
  };

  system.stateVersion = "25.11"; # Did you read the comment?

}

