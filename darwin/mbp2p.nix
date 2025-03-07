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
      # pkgs.neovim
      pkgs.colima
      pkgs.nyancat
      pkgs.cloudflared
      pkgs.nodePackages.prettier
      # pkgs.ladybird
      # pkgs.youtube-music
      pkgs.quarkus
      pkgs.maven
      pkgs.kubectl

      pkgs.asciidoctor-with-extensions
      pkgs.testdisk

      pkgs.texlivePackages.xelatex-dev
      pkgs.pandoc
      pkgs.librsvg
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
      "vmware-fusion"
      "brave-browser"
      "vivaldi"
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

      "google-drive"

      "geogebra"
      "signal@beta"
      "steam"

      "libreoffice"
      "obsidian"
      "discord@canary"
      "discord@ptb"

      "dbeaver-community"
      "gitkraken"
      "chromium"

      "android-platform-tools"

      "adobe-creative-cloud"
    ];
    masApps = {
    };
  };

  system = {
    # MacOs settings ....
  };
}
