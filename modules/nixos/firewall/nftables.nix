{
  pkgs,
  config,
  lib,
  ...
}: {
  options.nftables.enable = lib.mkEnableOption "enable nftables firewall";

  config = lib.mkIf config.nftables.enable {
    networking.nftables = {
      enable = true;
    };

    networking.firewall = {
      enable = true;
    };
  };
}
