{
  pkgs,
  inputs,
  vars,
  host,
  ...
}:

{
  imports = [
  ];

  users.users.${vars.user} = {
    home = "/Users/${vars.user}";
    shell = pkgs.zsh;
  };

  environment = {
    variables = {
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
    };
    systemPackages = [
      pkgs.treefmt2
      pkgs.git
      pkgs.gh
      pkgs.nixfmt-rfc-style
      pkgs.nixd
      pkgs.prettierd

      pkgs.docker
      pkgs.thefuck
      pkgs.nodejs_22
      pkgs.macchina
      pkgs.pfetch-rs
      pkgs.nh
      pkgs.nyancat

      pkgs.sops

      # rust
      pkgs.cargo
      pkgs.rustup
      pkgs.rust-analyzer
      # not ready for aarch64-darwin
      # inputs.ghostty.packages.${pkgs.system}.default

      pkgs.podman
      pkgs.podman-tui
    ];
  };

  homebrew = {
    enable = true;
    onActivation = {
      upgrade = false;
      cleanup = "zap";
    };

    casks = [
      "alfred"
      "firefox"
      "alt-tab"
      "ghostty"
      "alacritty"
      "kitty"
      "scroll-reverser"
      "maccy"
    ];

    masApps = {
    };
  };

  home-manager = {
    extraSpecialArgs = {
      inherit
        inputs
        pkgs
        vars
        host
        ;
    };
    backupFileExtension = "nix-backup";
  };

  home-manager.users.${vars.user} = {
    imports = import ../modules/home;

    nixvim.enable = true;
    nixcord.enable = true;
    vscode.enable = true;
    ghostty.enable = true;

    home.stateVersion = "24.11";
  };

  nix = {
    package = pkgs.nix;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    gc = {
      automatic = true;
      options = "delete-older-than 10d";
    };
    optimise.automatic = true;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };

  security.pam.enableSudoTouchIdAuth = true;

  system = {
    #MacOS settings1
    stateVersion = 5;
  };
}
