{ pkgs, inputs, vars, nixpkgs, ... }:

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
      pkgs.git
      pkgs.docker
      pkgs.thefuck
      pkgs.nodejs_22
      pkgs.macchina
      pkgs.pfetch-rs
      pkgs.nh
     
      # rust
      pkgs.cargo
      pkgs.rustup
      pkgs.rust-analyzer

      # not ready for aarch64-darwin
      # inputs.ghostty.packages.${pkgs.system}.default
    ];
  };


  homebrew = {
    enable = true;
    onActivation = {
      upgrade = false;
      cleanup = "zap";
    };
  
    brews = [];

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
      # "wireguard" = 1451685025;
    };
  };

  home-manager.backupFileExtension = "nix-backup";

  home-manager.users.${vars.user} = {
    imports = [
      ../modules/home/shell/zsh.nix
      ../modules/home/terminal/ghostty.nix
      ../modules/home/shell/starship.nix
    ];

    home.stateVersion = "24.11";
  };

  nix = {
    package = pkgs.nix;
    gc.automatic = true;
    optimise.automatic = true;
    settings = {
      # auto-optimise-store = true;
      experimental-features = [
        "nix-command" "flakes"
      ];
    };
  };

  security.pam.enableSudoTouchIdAuth = true;

  system = {
    #MacOS settings1
    stateVersion = 5;
  };
}
