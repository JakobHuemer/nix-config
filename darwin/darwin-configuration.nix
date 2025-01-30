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

  system.activationScripts.extraActivation.text =
    let
      nixbin = "/Users/${vars.user}/.nixbin";
    in
    ''
      echo "settings up nodejs symlinkgs..."
      mkdir -p ${nixbin}
      mkdir -p ${nixbin}/lib
      ln -sf ${pkgs.nodejs}/bin/node ${nixbin}/node
      ln -sf ${pkgs.nodejs}/bin/npm ${nixbin}/npm
      ln -sf ${pkgs.graphviz}/bin/dot ${nixbin}/dot
      ln -sf ${pkgs.temurin-bin-23}/bin/java ${nixbin}/java
      ln -sf ${pkgs.plantuml}/lib/plantuml.jar ${nixbin}/lib/plantuml.jar
    '';

  environment = {
    variables = {
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
    };
    systemPackages =
      (import ../nixconf/shell/nvim-pkgs.nix { inherit pkgs; })
      ++ (import ../nixconf/pckgs-all.nix { inherit pkgs; })
      ++ (import ../nixconf/apps/obsidian-pkgs.nix { inherit pkgs; })
      ++ [
        pkgs.git
        pkgs.gh

        pkgs.docker
        pkgs.nodejs_22
        pkgs.nh
        pkgs.nyancat

        # rust
        pkgs.cargo
        pkgs.rustup
        # not ready for aarch64-darwin
        # inputs.ghostty.packages.${pkgs.system}.default

        pkgs.podman
        pkgs.podman-tui

        pkgs.tor
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
      "teamviewer"
      "tor-browser"
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
