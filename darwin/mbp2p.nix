# System config for MacBook Pro M2 Pro
#
{
  pkgs,
  pkgs-stable,
  vars,
  inputs,
  system,
  ...
}: {
  home-manager.users.${vars.user} = {
    git.gpgKey = "D617865DCD802230ED4AFC3B02A04F8328440D81";
  };

  nix = {
    linux-builder = {
      enable = true;
      supportedFeatures = [
        "kvm"
        "benchmark"
        "big-parallel"
        "nixos-test"
      ];
      maxJobs = 4;
      package = pkgs.darwin.linux-builder;
      ephemeral = true;
      config = {
        nix.settings.sandbox = false;
      };
    };
    settings.trusted-users = ["@admin"];
  };

  launchd.daemons.linux-builder = {
    serviceConfig = {
      StandardOutPath = "/var/log/darwin-builder.log";
      StandardErrorPath = "/var/log/darwin-builder.log";
    };
  };

  environment = {
    systemPackages = [
      pkgs.colima
      pkgs.cloudflared

      pkgs-stable.php
      pkgs-stable.php84Packages.composer
      pkgs-stable.laravel

      pkgs.testdisk
      pkgs.act

      inputs.rustowl-flake.packages.${system}.rustowl
    ];
  };

  homebrew = {
    taps = [
      "th-ch/youtube-music"
      "pakerwreah/calendr"
    ];

    casks = [
      # Calendar & productivity
      "calendr"
      "numi"
      "obsidian"
      "yaak"

      # Communication
      "discord@canary"
      "discord@ptb"
      "signal@beta"
      "whatsapp"
      "microsoft-teams"
      "thunderbird"

      # Microsoft apps
      "microsoft-powerpoint"
      "microsoft-word"
      "microsoft-excel"

      # Design & creative
      "figma"
      "adobe-creative-cloud"

      # Development tools
      "jetbrains-toolbox"
      "postman"
      "insomnia"
      "bruno"
      "gitkraken"
      "mysqlworkbench"

      # Browsers
      "brave-browser"
      "vivaldi"
      "chromium"

      # Gaming
      "prismlauncher"
      "minecraft"
      "heroic"
      "steam"
      "itch"
      "bluestacks"

      # Remote access
      "anydesk"
      "teamviewer"

      # Virtualization
      "virtualbox"
      # "vmware-fusion"

      # Utilities
      "easy-move+resize"
      "keyboard-cleaner"
      "free-download-manager"
      "google-drive"
      "wireshark-app"
      "zen"
      "yed"

      # Office
      "libreoffice"

      # Music
      "youtube-music"

      "maxon"
    ];

    masApps = {};
  };

  system = {
    # MacOs settings ....
  };
}
