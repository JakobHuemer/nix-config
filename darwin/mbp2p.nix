#
# System config for MacBook Pro M2 Pro
#

{
  pkgs,
  vars,
  ...
}:

{

  home-manager.users.${vars.user} = {

  };

  environment = {
    systemPackages = [
      pkgs.colima

      pkgs.cloudflared
      
      pkgs.quarkus
      pkgs.maven
      pkgs.kubectl

      pkgs.testdisk
    ];
  };

  homebrew = {

    taps = [
      "th-ch/youtube-music"
    ];

    casks = [
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

      # ms apps
      # "microsoft-powerpoint"
      # "microsoft-word"
      # "microsoft-excel"
      # "microsoft-teams"

      "whatsapp"
      "thunderbird"
      "numi"
      "keyboard-cleaner"
      "virtualbox"
      "postman"

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
    ];
    masApps = {
    };
  };

  system = {
    # MacOs settings ....
  };
}
