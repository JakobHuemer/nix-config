{
  config,
  lib,
  ...
}: {
  options.myfirewall.mullvad_tailscale.enable = lib.mkEnableOption "enable mullvad tailsacle firewall entry";

  # makes mullvad consider tailscale traffic LAN traffic
  config = lib.mkIf config.myfirewall.mullvad_tailscale.enable {
    networking.nftables.tables = {
      mullvad_tailscale = {
        family = "inet";
        content = ''
          chain output {
            type route hook output priority 0; policy accept;
            ip daddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
          }

          chain input {
            type filter hook input priority -100; policy accept;
            ip saddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
          }
        '';
      };
    };
  };
}
