{
  lib,
  pkgs,
  pkgs-stable,
  inputs,
  vars,
  system,
  host,
  config,
  ...
}: {
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  ollama.enable = true;

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  environment = {
    systemPackages = with pkgs;
      (with pkgs-stable; [
        rustdesk
      ])
      ++ [
        inputs.hytale-launcher.packages.${system}.default
      ];
  };

  home-manager.users.${vars.user} = {
    git.gpgKey = "DBFA8DCA389649DB6BEE8A009B4F31A8AFE90BEB";

    home.stateVersion = "25.11";
  };

  system.stateVersion = "25.11";
}
