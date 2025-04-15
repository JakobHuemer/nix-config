# System config for MacBook Pro M2 Pro
#

{ pkgs, pkgs-stable, vars, ... }:

{

  home-manager.users.${vars.user} = {

  };

  environment = {
    systemPackages = [
      pkgs.colima
      pkgs.cloudflared

      pkgs-stable.php
      pkgs-stable.php84Packages.composer
      pkgs-stable.laravel

      pkgs.testdisk
      

    ];
  };

  homebrew = {

    taps = [ "th-ch/youtube-music" ];

    casks = [
      "prismlauncher"
      "mysqlworkbench"
      "heroic"
      "figma"
      "free-download-manager"
      "zen-browser"
      "jetbrains-toolbox"
      "youtube-music"
      "surfshark"
      # "vmware-fusion"
      "brave-browser"
      "vivaldi"
      "teamviewer"

      # ms apps
      # "microsoft-powerpoint"
      "microsoft-word"
      # "microsoft-excel"
      "microsoft-teams"

      "whatsapp"
      "thunderbird"
      "numi"
      "keyboard-cleaner"
      "virtualbox"
      "postman"
      "insomnia"

      "google-drive"

      # "geogebra"
      "signal@beta"
      "steam"

      "libreoffice"
      "obsidian"

      "discord@canary"
      "discord@ptb"

      # "dbeaver-community"
      "gitkraken"
      "chromium"

      # "android-platform-tools"

      "adobe-creative-cloud"

      "itch"
    ];
    masApps = { };
  };

  system = {
    # MacOs settings ....
  };
}
