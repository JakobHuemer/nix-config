{
  pkgs,
  lib,
  config,
  pkgs-stable,
  inputs,
  system,
  ...
}: {
  custom.steam.enable = true;

  networking.firewall = {
    # allowedTCPPorts = [25565 24454];
    # allowedUDPPorts = [25565 24454];
  };

  environment.systemPackages = [
    pkgs.prismlauncher

    (pkgs-stable.heroic.override {
      extraPkgs = pkgs: [
        pkgs.gamescope
        pkgs.gamemode
      ];
    })

    inputs.hytale-launcher.packages.${system}.default
  ];
}
