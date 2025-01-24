{
  lib,
  config,
  pkgs,
  nixpkgs,
  home-manager,
  inputs,
  vars,
  ...
}:

{
  imports = [
    ../modules/shell/git.nix
  ];

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

    systemPackages = with pkgs; [
      ghostty
      zsh
      git
      nodejs
      nix-tree # browse nix store
      tmux
      wget

      # Audio / Video
      alsa-utils
      pipewire
      pulseaudio
      vlc
      mpv
      linux-firmware
      pavucontrol

      # Apps
      firefox

      # Filemanagement
      nemo
      unrar
      rsync
      zip
      unrar

      treefmt2
      sops
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
  };

  nix = {
    settings = {
      auto-optimise-store = true;
    };
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

  home-manager.users.${vars.user} = {
    imports = [
      ../modules/home/shell/git.nix
      ../modules/home/shell/zsh.nix
      ../modules/home/shell/neovim.nix
      # home-manager modules import
    ];

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
