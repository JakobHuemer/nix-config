{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    # ../../modules/desktop/hyprland.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;



  # configuration to make for acer nitro 5 NixStation NixOs

}
