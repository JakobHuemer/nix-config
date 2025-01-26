#
# System config for MacBook Pro M2 Pro
#

{
  inputs,
  pkgs,
  vars,
  host,
  ...
}:

{

  home-manager.users.${vars.user} = {

  };

  environment = {
    systemPackages = [
      pkgs.alacritty
      # pkgs.neovim
      pkgs.colima
      pkgs.nyancat
      pkgs.cloudflared
      pkgs.nodePackages.prettier
      # pkgs.ladybird
      # pkgs.youtube-music
    ];
  };

  homebrew = {

    taps = [
      "th-ch/youtube-music"
    ];

    casks = [
      "free-download-manager"
      "zen-browser"
      "jetbrains-toolbox"
      "youtube-music"
      "surfshark"
      "vmware-fusion"
      "brave-browser"
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
    ];
    masApps = {
    };
  };

  system = {
    # MacOs settings ....
  };
}
