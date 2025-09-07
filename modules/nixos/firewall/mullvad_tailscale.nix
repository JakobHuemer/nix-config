{
  config,
  lib,
  ...
}: {
  options.myfirewall.mullvad_tailscale.enable = lib.mkEnableOption "enable mullvad tailsacle firewall entry";

  # makes mullvad consider tailscale traffic LAN traffic
  config = lib.mkIf config.myfirewall.mullvad_tailscale.enable {
    networking.nftables = {
      enable = true;
      tables = {
        mullvad_tailscale = {
          family = "inet";
          content = ''
            chain exclude-outgoing {
              type route hook output priority 0; policy accept;
              ip daddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
              ip daddr 100.100.100.100 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
            }

            chain allow-incoming {
              type filter hook input priority -100; policy accept;
              iifname "tailscale0" ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
            }

            chain exclude-dns {
              type filter hook output priority -10; policy accept;
              ip daddr 100.100.100.100 udp dport 53 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
              ip daddr 100.100.100.100 tcp dport 53 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
            }
          '';
        };
      };
    };
  };
}
