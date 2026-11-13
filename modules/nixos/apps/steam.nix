{
  pkgs,
  config,
  lib,
  ...
}: {
  options.custom.steam.enable = lib.mkEnableOption "enable steam";

  config = let
    cfg = config.custom.steam;
  in
    lib.mkIf cfg.enable {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      };

      environment.systemPackages = with pkgs; [
        gamemode
      ];

      programs.gamescope.enable = true;
      programs.gamemode.enable = true;
    };
}
