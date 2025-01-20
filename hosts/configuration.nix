{ lib, config, pkgs, nixpkgs, inputs, vars, ... }:

let
  terminal = pkgs.${vars.terminal};
in 
{
  imports = [
    ../modules/shell/zsh.nix
  ];

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };

      grub = {
        efiSupport = true;
        device = "nodev";
      };
    };
  };


  users.users.${vars.user} = {
    isNormalUser = true;
    groups = [ "wheel" "networkmanager" ];
  };

  tune.timeZone = "Europe/Vienna";
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
      nix-tree  # browse nix store
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
    ];
  };

  hardware.pulseaudio.enable = false;
  services = {
    pipewire = {
      enable = true;
      alas = {
        enable = true;
        support32Bit = true;
      };
    };
  };

  system = {
    stateVersuin = "24.11"
  };

  home-manager.users.${vars.user} = {
    home = {
      stateVersion = "24.11";
    };

    programs = {
      home-manager.enable = true;
    };

    # other homemanager stuff for NixOs


  };


}
