{
  lib,
  pkgs,
  pkgs-stable,
  inputs,
  vars,
  system,
  host,
  config,
  self,
  ...
}: {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
      inputs.nix-index-database.nixosModules.default
    ]
    ++ (import ../modules/nixos);

  # important

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;
  boot.supportedFilesystems = ["nfs"];

  time.timeZone = "Europe/Vienna";

  system.configurationRevision = self.rev or self.dirtyRev;

  # makes dynamically linked libs work but still not trash the system
  programs.nix-ld.enable = true;

  specialisation = lib.mkIf (!(config.hardware.asahi.enable or false)) {
    kernel-latest.configuration = {
      boot.kernelPackages = pkgs.linuxPackages_latest;
    };
  };

  sops.defaultSopsFile = ../secrets/general.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/${vars.user}/.config/sops/age/keys.txt";

  services.geoclue2.appConfig.timewall = {
    isAllowed = true;
    isSystem = false;
  };

  # btrfs scubbing
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = ["/"];
  };

  networking.firewall = {
    enable = true;

    allowedTCPPorts = [25565 24454];
    allowedUDPPorts = [25565 24454];
  };

  greetd = {
    enable = true;
  };

  tailscale.enable = true;

  boot.loader.limine = {
    enable = true;
  };

  networking.networkmanager.enable = true;
  networking.hostName = "${host.hostName}";

  programs.zsh.enable = true;

  sops.secrets.consul_http_token = {
    owner = vars.user;
    mode = "0400";
  };

  sops.secrets.nomad_token = {
    owner = vars.user;
    mode = "0400";
  };
  #
  # services.devmon.enable = true;
  # services.gvfs.enable = true;
  services.udisks2.enable = true;

  # firewall

  # networking.firewall.backend = "nftables";
  # myfirewall.mullvad_tailscale.enable = true;

  networking = {
    nameservers = [
      /*
      "100.109.186.71" "192.168.0.31"
      */
      "9.9.9.9"
      "1.1.1.1"
    ];
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = "none";

    # resolvconf.extraOptions = [
    #   "timeout:1"
    # ];
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

  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;

  console = {
    font = "Lat2-Terminus16";
    keyMap = "de-latin1";
  };

  programs.npm = {
    enable = true;
    npmrc = ''
      prefix = ''${HOME}/.npm
    '';
  };

  environment = {
    variables = {
      SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
      TERMINAL = "${vars.terminal}";
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
    };

    systemPackages =
      with pkgs; [
        # keep-sorted start
        (flameshot.override {enableWlrSupport = true;})
        (lib.hiPrio kubectl)
        age
        bitwarden-cli
        btop
        cacert
        comma
        consul
        dconf
        dig
        dua # interactive disk usage analyzer
        # pkgs.gitui # lazygit rust port larifary # fails to build on darwin
        dust # better du
        fd # find alternative
        fh
        file
        forgejo-cli
        gh
        github-copilot-cli
        gnome-keyring
        gnupg
        graphite-cli
        hyperfine # clever benchmark
        inotify-tools
        jjui
        jujutsu
        keep-sorted
        lazydocker
        lazyjj
        lsof
        mprocs # tui to run multiple commands parallel
        mullvad
        nemo-with-extensions
        net-tools
        node-gyp
        nomad
        openssl
        pi-coding-agent
        # pinentry-tty
        pinentry-all
        pkgs-stable.presenterm # terminal slideshow presentation tool
        podman-compose
        qbittorrent-enhanced
        ripgrep
        ripgrep # better grep
        ripgrep-all # ripgrep for all files (pdf, zip, etc.)
        sops
        tcpdump
        tokei # count code lines quickly
        typst
        typst-live
        typstyle
        udiskie
        virtiofsd
        vlc
        wireshark
        yazi # filemanager with previews
        zsh
        # keep-sorted end
      ]
      # ++ [
      #   inputs.apple-emoji-linux.packages.${system}.default
      # ]
      ;
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      trusted-users = ["root" "@wheel"];
    };

    nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 10d";
    };
    registry.nixpkgs.flake = inputs.nixpkgs;
    registry.stable = {
      from = {
        id = "stable";
        type = "indirect";
      };
      flake = inputs.nixpkgs-stable;
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
      extra-platforms       = aarch64-linux arm-linux
    '';

    # extraConfig = ''
    #   netrc-file = /etc/nix/netrc
    # '';
  };

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

    useGlobalPkgs = true;
    useUserPackages = true;
  };

  home-manager.users.${vars.user} = {pkgs, ...}: {
    imports =
      import ../modules/home
      ++ [
        inputs.papertimed.homeModules.default
        inputs.timewall.homeManagerModules.default
        inputs.lan-mouse.homeManagerModules.default
      ];

    home.file.".nix-assets" = {
      source = ../assets;
      recursive = true;
    };

    zsh.consul_http_token_path = config.sops.secrets.consul_http_token.path;
    zsh.nomad_token_path = config.sops.secrets.nomad_token.path;

    services.syncthing.enable = true;

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
      worktrunk.enable = true;
      bun.enable = true; # managed by shell module
    };

    xresources = {
      path = "/home/${vars.user}/.Xresources";
      extraConfig = ''
        Xft.dpi: 163
        Xft.autohint: 0
        Xft.lcdfilter:  lcddefault
        Xft.hintstyle:  hintfull
        Xft.hinting: 1
        Xft.antialias: 1
        Xft.rgba: rgb
      '';
    };
  };
}
