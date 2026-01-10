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
      inputs.sops-nix.nixosModules.sops
    ]
    ++ (import ../modules/nixos);

  services.automatic-timezoned.enable = true;

  # sops.gnupg.home = "/var/lib/sops";

  programs.zsh.enable = true;

  # services.devmon.enable = true;
  # services.gvfs.enable = true;
  services.udisks2.enable = true;

  # firewall

  # networking.firewall.backend = "nftables";
  # myfirewall.mullvad_tailscale.enable = true;

  doh.enable = true;

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

  # make gnupg work with pinentry
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-all;
  };

  users.users.root = {
    shell = pkgs.zsh;
  };

  users.users.${vars.user} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel"];
  };

  i18n = {
    defaultLocale = "en_GB.UTF-8";

    extraLocales = [
      "en_GB.UTF-8/UTF-8"
      "de_DE.UTF-8/UTF-8"
      "de_AT.UTF-8/UTF-8"
    ];

    extraLocaleSettings = {
      LC_MONETARY = "de_AT.UTF-8";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "de-latin1";
  };

  environment = {
    variables = {
      TERMINAL = "${vars.terminal}";
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
    };

    systemPackages =
      with pkgs; [
        zsh
        # pinentry-tty
        pinentry-all
        ripgrep
        fh
        nemo-with-extensions
        bitwarden-cli
        net-tools
        dig
        wireshark
        sops
        age
        tcpdump
        (flameshot.override {enableWlrSupport = true;})
        vlc
        qbittorrent-enhanced
        kubectl

        udiskie

        lsof
        file

        typst
        typstyle
        typst-live

        github-copilot-cli

        codeberg-cli

        ripgrep # better grep
        ripgrep-all # ripgrep for all files (pdf, zip, etc.)
        fd # find alternative
        # pkgs.gitui # lazygit rust port larifary # fails to build on darwin
        dust # better du
        dua # interactive disk usage analyzer
        yazi # filemanager with previews
        hyperfine # clever benchmark
        tokei # count code lines quickly
        mprocs # tui to run multiple commands parallel
        presenterm # terminal slideshow presentation tool
      ]
      # ++ [
      #   inputs.apple-emoji-linux.packages.${system}.default
      # ]
      ;
  };

  nix = {
    settings = {
      auto-optimise-store = true;
    };

    nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 10d";
    };
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
      extra-platforms       = aarch64-linux arm-linux
    '';
  };

  nixpkgs.config.allowUnfree = true;

  home-manager = {
    extraSpecialArgs = {
      inherit
        inputs
        system
        vars
        pkgs-stable
        host
        ;
    };

    backupFileExtension = "hm-bkp";

    useGlobalPkgs = false; # will not me possible with nixpkgs
    useUserPackages = true;
  };

  home-manager.users.${vars.user} = {pkgs, ...}: {
    imports = import ../modules/home;

    nixpkgs.config.allowUnfree = true;

    home.file.".nix-assets" = {
      source = ../assets;
      recursive = true;
    };

    services.udiskie = {
      enable = true;
      package = pkgs.udiskie;

      settings = {
        automount = true;
        notify = true;
        # tray = true;

        program_options = {
          file_manager = "${pkgs.nemo-with-extensions}/bin/nemo";
        };

        icon_names.media = ["media-optical"];
      };
    };

    programs = {
      home-manager.enable = true;
    };
    home = {
      stateVersion = "25.11";
    };
  };

  system = {
    stateVersion = "25.11";
  };
}
