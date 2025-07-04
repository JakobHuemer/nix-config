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
    taps = ["th-ch/youtube-music"];

    casks = [
      "yed"
      "anydesk"
      "easy-move+resize"
      "bluestacks"
      "prismlauncher"
      "minecraft"
      "mysqlworkbench"
      "heroic"
      "figma"
      "free-download-manager"
      "zen"
      "jetbrains-toolbox"
      "youtube-music"
      # "vmware-fusion"
      "brave-browser"
      "vivaldi"
      "teamviewer"
      "wireshark-app"

      # ms apps
      "microsoft-powerpoint"
      "microsoft-word"
      "microsoft-excel"
      "microsoft-teams"

      "whatsapp"
      "thunderbird"
      "numi"
      "keyboard-cleaner"
      "virtualbox"
      "postman"
      "insomnia"
      "yaak"
      "bruno"

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
    masApps = {};
  };

  system = {
    # MacOs settings ....
  };
}
