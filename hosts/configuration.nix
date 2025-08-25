{
  pkgs,
  pkgs-stable,
  inputs,
  vars,
  system,
  host,
  ...
}: {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
    ]
    ++ (import ../modules/nixos);

  programs.zsh.enable = true;

  # printing
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
      gutenprint
      canon-cups-ufr2
      canon-capt
    ];
  };

  services.udisks2.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    # settings = {
    #   General = {
    #     Experimental = true;
    #     Enable = "Source,Sink,Media,Socket";
    #   };
    # };
  };

  security.sudo = {
    extraConfig = ''
      Defaults insults
    '';
    # until insults are in sudo-rs, will use sudo instead
    # enable = false;
    # sudo-rs = {
    #   enable = true;
    #   execWheelOnly = true;
    #   wheelNeedsPassword = true;
    # };
  };

  # services.pulseaudio.enable = false;
  # services.pulseaudio.support32Bit = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # extraConfig.pipewire."92-low-latency" = {
    #   "context.properties" = {
    #     "default.clock.rate" = 48000;
    #     "default.clock.quantum" = 32;
    #     "default.clock.min-quantum" = 32;
    #     "default.clock.max-quantum" = 32;
    #   };
    # };

    wireplumber.extraConfig.bluetoothEnhancements = {
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.roles" = ["hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag"];
      };
    };
  };

  services.blueman.enable = true;

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
    extraGroups = ["wheel" "networkmanager" "video" "storage"];
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
        nemo
        rustup
      ]
      ++ [
        inputs.apple-emoji-linux.packages.${system}.default
      ];
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

  home-manager = {
    extraSpecialArgs = {inherit inputs system vars pkgs-stable host;};

    useGlobalPkgs = false; # will not me possible with nixpkgs
    useUserPackages = true;
  };

  home-manager.users.${vars.user} = {pkgs, ...}: {
    imports = import ../modules/home;

    nixpkgs.config.allowUnfree = true;

    services.udiskie.enable = true;

    services.udiskie.settings = {
      automount = true;
      notify = true;
      tray = false;
    };

    programs = {home-manager.enable = true;};
    home = {stateVersion = "25.05";};
  };

  system = {stateVersion = "25.05";};
}
