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

  console = {
    font = "Lat2-Terminus16";
    keyMap = "de-latin1";
  };

  fonts.packages = with pkgs; [
    jetbrains-mono

    noto-fonts
    noto-fonts-emoji

    corefonts # MS
    youtube-music
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
      distrobox

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

  home-manager.extraSpecialArgs = {inherit inputs system nixpkgs vars host;};

  home-manager.users.${vars.user} = {
    sway.enable = true;
    tofi.enable = true;
    ghostty.enable = true;
    tmux.enable = true;

    nixcord.enable = true;

    useStylix = true;

    zen.enable = true;

    git.gpgKey = "C68AA68E0D1846F90E1336278D4386EB3398D4A3";
  };

  system = {stateVersion = "25.05";};
}
