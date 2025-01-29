{
  pkgs,
  inputs,
  vars,
  system,
  nixpkgs,
  host,
  ...
}:

{
  # imports = import ../modules/nixos;

  programs.zsh.enable = true;

  users.users.${vars.user} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  time.timeZone = "Europe/Vienna";
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_MONETARY = "de_AT.UTF-8";
    };
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
    };

    systemPackages =
      (import ../nixconf/shell/nvim-pkgs.nix { inherit pkgs; })
      ++ (import ../nixconf/pckgs-all.nix { inherit pkgs; })
      ++ (with pkgs; [
        nodejs

      ]);
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
  };

  nix = {
    settings = {
      auto-optimise-store = true;
    };

    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

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

  home-manager.extraSpecialArgs = {
    inherit
      inputs
      system
      nixpkgs
      vars
      host
      ;
  };

  home-manager.users.${vars.user} = {
    imports = import ../modules/home;

    nixvim.enable = true;

    home = {
      stateVersion = "24.11";
    };

    programs = {
      home-manager.enable = true;
    };

    # other homemanager stuff for NixOs

  };

  system = {
    stateVersion = "24.11";
  };

}
