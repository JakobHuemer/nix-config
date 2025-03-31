
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

  networking = {
    hostName = "${host.hostName}";
    computerName = "${host.hostName}";
  };

  # system.activationScripts.extraActivation.text =
  #   let
  #     nixbin = "/Users/${vars.user}/.nixbin";
  #   in
  #   ''
  #     echo "settings up nodejs symlinkgs..."
  #     mkdir -p ${nixbin}
  #     mkdir -p ${nixbin}/lib
  #     mkdir -p ${nixbin}/bin
  #     ln -sf ${pkgs.nodejs}/bin/node ${nixbin}/node
  #     ln -sf ${pkgs.nodejs}/bin/npm ${nixbin}/npm
  #     ln -sf ${pkgs.graphviz}/bin/dot ${nixbin}/dot
  #     ln -sf ${pkgs.graphviz}/bin/dot /opt/local/bin/dot
  #     ln -sf ${pkgs.python313}/bin/python3 ${nixbin}/python3
  #     ln -sf ${pkgs.temurin-bin-23}/bin/java ${nixbin}/java
  #     ln -sf ${pkgs.plantuml}/lib/plantuml.jar ${nixbin}/lib/plantuml.jar
  #     ln -sf ${pkgs.postgresql_jdbc}/share/java/postgresql-jdbc.jar ${nixbin}/lib/postgresql-jdbc.jar
  #     ln -sf ${pkgs.pandoc}/bin/pandoc ${nixbin}/bin/pandoc
  #   '';

  environment = {
    variables = {
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
    };

    systemPackages = with pkgs; [
        
      # util
      gnupg
      git
      gh
      lazygit
      nnn

      # pkgs.nh
      # pkgs.nyancat

      # programming
      docker
      # pkgs.nodejs_22
      podman
      podman-tui
     
      # cmake

      # rust
      # pkgs.cargo
      # pkgs.rustup
      # pkgs.rustc
      imagemagick
    ];
  };

  fonts.packages = with pkgs; [
    atkinson-hyperlegible
    atkinson-monolegible

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    noto-fonts-extra

    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono

  ];

  homebrew = {
    enable = true;
    onActivation = {
      upgrade = false;
      cleanup = "zap";
    };

    taps = [
      # "pablopunk/brew"
    ];

    casks = [
      "github"
      "alfred"
      "firefox"
      "alt-tab"
      "ghostty"
      "alacritty"
      "kitty"
      "scroll-reverser"
      "maccy"
      # "teamviewer"
      # "tor-browser"
      # "swift-shift"
      "vlc"
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
    # vscode.enable = true;
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

  # no longer has any effect
  # security.pam.enableSudoTouchIdAuth = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  time.timeZone = "Europe/Vienna";
  system = {
    #MacOS settings1
    stateVersion = 5;


    startup.chime = false;

    keyboard = {
      enableKeyMapping = true;
      swapLeftCtrlAndFn = true;
      nonUS.remapTilde = true;
      remapCapsLockToEscape = true;
    };


    defaults = {

      controlcenter = {
        BatteryShowPercentage = true;
        AirDrop = false;
      };

      loginwindow = {
        LoginwindowText = "Welcome Jakki!"; # default \\U03bb (λ)
        SHOWFULLNAME = true;
      };

      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        KeyRepeat = 2;
        # KeyRepeatDelay = 0.25;
        InitialKeyRepeat = 15;
        # KeyRepeatEnabled = 1;
        # KeyRepeatInterval = 0.03333333299999999; 
       
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;

        "com.apple.keyboard.fnState" = true;
        "com.apple.sound.beep.feedback" = 1;
      };

      ".GlobalPreferences" = {
        "com.apple.mouse.scaling" = -1.0;
        "com.apple.sound.beep.sound" = ../assets/sounds/Pop.aiff;
      };

      trackpad = {
        Clicking = true;
        FirstClickThreshold = 0;
        SecondClickThreshold = 0;
      };

      dock = {
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.0;
        largesize = 16;
        tilesize = 16;
        show-recents = false;
        persistent-apps = [];
        persistent-others = [];

        # hot corner
        wvous-bl-corner = 1; 
        wvous-br-corner = 2;
        wvous-tr-corner = 1;
        wvous-tl-corner = 1;

      };

      menuExtraClock = {
        ShowSeconds = true;
        ShowAMPM = true;
        Show24Hour = false;
        ShowDate = 0;
        ShowDayOfWeek = false;
       
      };

      screencapture = {
        location = "/Users/${vars.user}/Desktop/Screencapture";
      };


      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        ShowPathbar = true;
        ShowStatusBar = true;
        QuitMenuItem = true;
        NewWindowTarget = "Home";

        FXPreferredViewStyle = "clmv";
        FXEnableExtensionChangeWarning = false;


      };
    };
  };
}
