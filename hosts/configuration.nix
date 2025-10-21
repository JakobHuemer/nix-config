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

  services.udisks2.enable = true;

  # firewall

  myfirewall.mullvad_tailscale.enable = true;
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
      NIXOS_OZONE_WL = 1;
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

        udiskie

        typst
        typstyle
        typst-live
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
      options = "delete-older-than 10d";
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

    useGlobalPkgs = false; # will not me possible with nixpkgs
    useUserPackages = true;
  };

  home-manager.users.${vars.user} = {pkgs, ...}: {
    imports = import ../modules/home;

    nixpkgs.config.allowUnfree = true;

    nixdev.enable = true;

    home.file.".nix-assets" = {
      source = ../assets;
      recursive = true;
    };

    services.udiskie = {
      enable = true;
      settings = {
        automount = true;
        notify = true;
        tray = true;

        program_options = {
          file_manager = "${pkgs.nemo-with-extensions}/bin/nemo";
        };
      };
    };

    programs = {
      home-manager.enable = true;
    };
    home = {
      stateVersion = "25.05";
    };
  };

  system = {
    stateVersion = "25.05";
  };
}
