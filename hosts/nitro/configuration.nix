{
  pkgs,
  inputs,
  vars,
  system,
  nixpkgs,
  host,
  ...
}: {
  # system

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # make gnupg work with pinentry
  # services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    # pinentryFlavor = "curses";
    pinentryPackage = pkgs.pinentry-gtk2;
    enableSSHSupport = true;
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

  users.users.${vars.user} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel" "networkmanager" "video"];
  };

  time.timeZone = "Europe/Vienna";
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {LC_MONETARY = "de_AT.UTF-8";};
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "de-latin1";
  };

  fonts.packages = with pkgs; [
    jetbrains-mono

    noto-fonts
    noto-fonts-emoji

    corefonts # MS
  ];

  environment = {
    variables = {
      TERMINAL = "${vars.terminal}";
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
      SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
    };

    systemPackages = with pkgs; [
      firefox
      grim # screenshots
      slurp # screenshots
      wl-clipboard # obv
      mako # notification system
      pavucontrol

      neovim

      gnupg
      pinentry-curses

      mullvad-vpn
      mullvad

      cacert
      openssl
    ];
  };

  hardware.pulseaudio.enable = false;
  services = {
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

  nix = {
    settings = {auto-optimise-store = true;};

    nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "delete-older-than 10d";
    };
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };

  nixpkgs.config.allowUnfree = true;

  home-manager.extraSpecialArgs = {inherit inputs system nixpkgs vars host;};

  home-manager.users.${vars.user} = {
    imports = import ../../modules/home;

    sway.enable = true;
    tofi.enable = true;
    ghostty.enable = true;
    tmux.enable = true;

    useStylix = true;

    zen.enable = true;

    git.gpgKey = "C68AA68E0D1846F90E1336278D4386EB3398D4A3";

    # nixvim.enable = true;

    home = {stateVersion = "25.05";};

    programs = {home-manager.enable = true;};

    # other homemanager stuff for NixOs
  };

  system = {stateVersion = "25.05";};
}
