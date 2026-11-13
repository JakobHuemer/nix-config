{
  pkgs,
  system,
  pkgs-stable,
  host,
  ...
}: {
  powerManagement = {
    enable = true;
  };

  # default audio volume
  services.pipewire.wireplumber = {
    enable = true;
    extraConfig = {
      "wireplumber.settings" = {
        # "device.routes.default-sink-volume" = "0.016";
        # "device.routes.default-source-volume" = "0.0086";
        "bluetooth.autoswitch" = true;
      };
    };
  };
}
