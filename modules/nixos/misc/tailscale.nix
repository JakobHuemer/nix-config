{
  lib,
  config,
  host,
  vars,
  ...
}: {
  options.tailscale = {
    enable = lib.mkEnableOption "enable Tailscale";

    hostname = lib.mkOption {
      default = host.hostName;
      type = lib.types.string;
      description = "The name under which this device wil be shown as";
    };
  };

  config = lib.mkIf config.tailscale.enable {
    services.tailscale = {
      enable = true;

      extraSetFlags = [
        "--ssh"
        "--operator=${vars.user}"
      ];

      useRoutingFeatures = lib.mkDefault "client";
    };

    # networking.firewall.checkReversePath = "loose";
  };
}
