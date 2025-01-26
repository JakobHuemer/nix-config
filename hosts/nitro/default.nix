{ pkgs, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # configuration to make for acer nitro 5 NixStation NixOs

  home-manager.users.${vars.user} = {
    nixcord.enable = true;
    vscode.enable = true;
    ghostty.enable = true;
  };
}
