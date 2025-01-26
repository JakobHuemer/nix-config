{ pkgs, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages = [
    pkgs.firefox

    # Audio / Video
    pkgs.alsa-utils
    pkgs.pipewire
    pkgs.pulseaudio
    pkgs.vlc
    pkgs.mpv
    pkgs.linux-firmware
    pkgs.pavucontrol
  ];

  # configuration to make for acer nitro 5 NixStation NixOs

  home-manager.users.${vars.user} = {
    # nixcord.enable = true;
    vscode.enable = true;
    ghostty.enable = true;
  };
}
