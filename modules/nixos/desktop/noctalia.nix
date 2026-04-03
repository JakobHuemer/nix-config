{
  pkgs,
  inputs,
  lib,
  system,
  vars,
  config,
  ...
}: {
  options.noctalia.enable = lib.mkEnableOption "noctalia shell";

  config = lib.mkIf config.noctalia.enable {
    hardware.bluetooth.enable = true;
    services.tuned.enable = true;
    # services.power-profiles-daemon.enable = true;
    services.auto-cpufreq.enable = lib.mkForce false;
    services.upower.enable = true;

    environment.systemPackages = with pkgs; [
      inputs.noctalia.packages.${system}.default
      lm_sensors
    ];

    home-manager.users.${vars.user} = {...}: {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia-shell = {
        enable = true;

        # packages = inputs.noctalia.packages.${system}.default;
      };
    };
  };
}
