{
  pkgs,
  pkgs-stable,
  inputs,
  vars,
  host,
  ...
}: let
  nixbin = "/Users/${vars.user}/.nixbin";
in {
  imports = [];

  users.users.${vars.user} = {
    home = "/Users/${vars.user}";
    shell = pkgs.zsh;
  };

  networking = {
    hostName = "${host.hostName}";
    computerName = "${host.hostName}";
  };

  system.activationScripts.extraActivation.text = ''
    echo "settings up system symlinks..."
    echo "cleaning up symlinks first..."

    rm -fr ${nixbin}

    echo "done cleaning up symlinks!"

    echo "setting up directories..."
    mkdir -p ${nixbin}
    mkdir -p ${nixbin}/lib
    mkdir -p ${nixbin}/bin
    echo "setting up links..."

    ln -sf ${pkgs.graphviz}/bin/dot ${nixbin}/bin/dot

    mkdir -p /opt/local/bin/
    ln -sf ${nixbin}/bin/dot /opt/local/bin/dot
    ln -sf ${pkgs.plantuml}/lib/plantuml.jar ${nixbin}/lib/plantuml.jar
    echo "symlink setup done!"
  '';

  services.tailscale = {
    enable = true;
  };

  environment = {
    variables = {
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
      SHELL = "${pkgs.zsh}/bin/zsh";
      CARGO_TARGET_DIR = "/Users/${vars.user}/cargo-target/";

      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
      OPENSSL_DIR = "${pkgs.openssl.dev}";
      # Optional, might help some builds
      OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
      OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
    };

    systemPath = [
      "${nixbin}/bin"
      # add bun .bin/bin
      "/Users/${vars.user}/.bun/bin"
    ];

    systemPackages = [
      # util
      pkgs.ffmpeg
      pkgs.gnupg
      pkgs.git
      pkgs.gh
      pkgs.lazygit
      pkgs.nnn
      pkgs.direnv
      pkgs.nixd
      pkgs.nil
      pkgs.tmux
      pkgs.tmuxifier
      pkgs.fh
      pkgs.openssl
      pkgs.nixfmt-classic
      pkgs.plantuml
      pkgs.tree-sitter
      pkgs.yarn
      pkgs.yarn2nix
      pkgs.meson
      pkgs.awscli2
      pkgs.oh-my-posh
      pkgs.unar

      pkgs.tailscale
      # pkgs.tailscaled

      # neovim reqs
      pkgs.luarocks
      pkgs.lua5_1
      pkgs.julia_19-bin
      pkgs.wget

      pkgs.jdk21_headless
      pkgs.nushell

      # oxide
      pkgs.ripgrep # better grep
      pkgs.ripgrep-all # ripgrep for all files (pdf, zip, etc.)
      pkgs.fd # find alternative
      pkgs.gitui # lazygit rust port larifary
      pkgs.dust # better du
      pkgs.dua # interactive disk usage analyzer
      pkgs.yazi # filemanager with previews
      pkgs.hyperfine # clever benchmark
      pkgs.tokei # count code lines quickly
      pkgs.mprocs # tui to run multiple commands parallel
      pkgs.presenterm # terminal slideshow presentation tool
      pkgs.cargo-aoc
      # pkgs-stable.mullvad

      # pkgs.nh
      pkgs.nyancat

      # programming
      pkgs.docker
      pkgs.nodejs_22
      pkgs.podman
      pkgs.podman-tui
      pkgs.docker-compose
      pkgs.jbang

      pkgs.hugo
      pkgs.go
      pkgs.neovim

      pkgs.quarkus
      pkgs.maven
      pkgs.kubectl

      pkgs.bun
      pkgs.nodePackages.rimraf
      # cmake

      pkgs.cargo
      pkgs.rustup
      (pkgs.rust-bin.stable.latest.default.override {
        extensions = ["rust-src" "llvm-tools"];
      })
      (pkgs.rust-bin.nightly.latest.default.override {
        extensions = ["rust-src" "llvm-tools"];
      })

      pkgs.openssl
      pkgs.openssl.dev
      pkgs.pkg-config

      pkgs.imagemagick
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
    nerd-fonts.fantasque-sans-mono

    jost # nice font which looks incredible condensed
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

    brews = [
      "trash"
    ];

    casks = [
      "utm"
      "netdownloadhelpercoapp"
      "corelocationcli"
      "github"
      "soduto"
      "alfred"
      "firefox"
      "alt-tab"
      "ghostty"
      "alacritty"
      "kitty"
      "scroll-reverser"
      "maccy"
      "mullvad-vpn"
      "surfshark"
      # "teamviewer"
      # "tor-browser"
      # "swift-shift"
      "vlc"

      "visual-studio-code"
      "cursor"

      "bitwarden"
    ];

    masApps = {};
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs pkgs pkgs-stable vars host;};
    backupFileExtension = "nix-backup";
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  home-manager.users.${vars.user} = {
    imports = import ../modules/home;

    # disable nixvim for a temporal lua configuration
    # nixvim.enable = true;
    nixcord.enable = true;
    # vscode.enable = true;
    ghostty.enable = true;
    tmux.enable = true;

    home.stateVersion = "25.05";
  };

  nix = {
    enable = true;
    package = pkgs.nix;
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    gc = {
      automatic = true;
      options = "delete-older-than 30d";
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

  security.pam.services.sudo_local = {
    enable = true;
    touchIdAuth = true;
    reattach = true;
  };

  time.timeZone = "Europe/Vienna";

  power.sleep = {
    computer = 40;
    display = 40;
  };

  launchd.user.agents.UserKeyMapping.serviceConfig = {
    ProgramArguments = [
      "/usr/bin/hidutil"
      "property"
      "--set"
      (let
        # USB HID key codes - https://developer.apple.com/library/archive/technotes/tn2450/_index.html
        leftCtrl = "0x7000000E0"; # USB HID 0xE0
        fnGlobe = "0xFF00000003"; # USB HID (0x0003 + 0xFF00000000 - 0x700000000)
        capsLock = "0x700000039"; # USB HID 0x39
        escape = "0x700000029"; # USB HID 0x29
      in
        "{\"UserKeyMapping\":["
        + "{\"HIDKeyboardModifierMappingDst\":${fnGlobe},\"HIDKeyboardModifierMappingSrc\":${leftCtrl}},"
        + "{\"HIDKeyboardModifierMappingDst\":${leftCtrl},\"HIDKeyboardModifierMappingSrc\":${fnGlobe}},"
        + "{\"HIDKeyboardModifierMappingDst\":${escape},\"HIDKeyboardModifierMappingSrc\":${capsLock}}"
        + "]}")
    ];
    RunAtLoad = true;
  };

  system = {
    #MacOS settings1
    stateVersion = 6;
    primaryUser = "${vars.user}";

    startup.chime = false;

    keyboard = {
      # enableKeyMapping = true;
      # swapLeftCtrlAndFn = true;
      # nonUS.remapTilde = true;
      # remapCapsLockToEscape = true;
    };

    defaults = {
      screensaver = {
        askForPassword = true;
        askForPasswordDelay = 0;
      };

      controlcenter = {
        BatteryShowPercentage = true;
        AirDrop = false;
      };

      loginwindow = {
        LoginwindowText = "λ"; # default \\U03bb (λ)
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
        "com.apple.mouse.scaling" = 0.5;
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
        wvous-br-corner = 4;
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
        location = "/Users/${vars.user}/Desktop/Screenshots/";
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
        _FXSortFoldersFirst = true;
      };

      # CustomSystemPreferences = {
      # "com.apple.mouse" = {
      #   # "doubleClickThreshold" = 0.5;
      #   "linear" = 1;
      #   # "com.apple.mouse.doubleClickThreshold" = 0.5;
      #   "com.apple.mouse.linear" = 1;
      #   # "com.apple.mouse.scaling" = 4;
      # };
      #
      # ".GlobalPreferences" = {
      #   "com.apple.mouse" = {
      #     "doubleClickThreshold" = 0.5;
      #     "linear" = 1;
      #     "com.apple.mouse.doubleClickThreshold" = 0.5;
      #     "com.apple.mouse.linear" = 1;
      #   };
      # };
      #
      # NSGlobalDomain = {
      #   # "com.apple.mouse.doubleClickThreshold" = 0.5;
      #   "com.apple.mouse.linear" = true;
      # };
      #
      # };

      # https://macos-defaults.com/

      CustomUserPreferences = {
        NSGlobalDomain = {
          "com.apple.mouse.linear" = true;
          "CGDisableCursorLocationMagnification" = true;
          ApplePressAndHoldEnabled = false;
        };

        "com.apple.symbolichotkeys" = {
          AppleSymbolicHotKeys = {
            # Disable Ctrl + Space (Previous input source)
            "60" = {
              enabled = false;
              value = {
                parameters = [32 49 1048576];
                type = "standard";
              };
            };

            # Disable Ctrl + Option + Space (Next input source)
            "61" = {
              enabled = false;
              value = {
                parameters = [32 49 1572864];
                type = "standard";
              };
            };

            "64" = {
              enabled = false;
              value = {
                parameters = [32 49 1048576];
                type = "standard";
              };
            };

            # Disable Cmd + Option + Space (Spotlight Finder Search)
            "65" = {
              enabled = false;
              value = {
                parameters = [32 49 1179648];
                type = "standard";
              };
            };
          };
        };
      };
    };
  };
}
