{
  pkgs,
  inputs,
  vars,
  system,
  nixpkgs,
  host,
  ...
}: {
  # imports = import ../modules/nixos;

  programs.zsh.enable = true;

  # make gnupg work with pinentry
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    # pinentryFlavor = "curses";
    enableSSHSupport = true;
  };

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

  fonts.packages = with pkgs;
    [
      jetbrains-mono

      noto-fonts
      # noto-fonts-emoji

      corefonts # MS
    ]
    ++ [
      inputs.apple-emoji-linux.packages.${system}.default
    ];

  environment = {
    variables = {
      TERMINAL = "${vars.terminal}";
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
    };

    systemPackages = with pkgs;
      [
        zsh
        pinentry-curses
        ripgrep
        fh
      ]
      ++ [
        inputs.apple-emoji-linux.packages.${system}.default
      ];
  };

  # hardware.pulseaudio.enable = false;
  # services = {
  #   pipewire = {
  #     enable = true;
  #     alsa = {
  #       enable = true;
  #       support32Bit = true;
  #     };
  #   };
  # };

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
    imports = import ../modules/home;

    home = {stateVersion = "25.05";};

    programs = {home-manager.enable = true;};
  };

  system = {stateVersion = "25.05";};
}
