#
# System config for MacBook Pro M2 Pro
# 

{ inputs, pkgs, vars, ... }: 

{
  imports = [
  ];

  home-manager.users.${vars.user} = {
    imports = [
      ../modules/home/apps/dev/vscode.nix
      ../modules/home/apps/nixcord.nix
      inputs.nixcord.homeManagerModules.nixcord
    ];
  };


  environment = {
    systemPackages = [
      pkgs.alacritty
      pkgs.neovim
      pkgs.colima
      pkgs.nyancat
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
