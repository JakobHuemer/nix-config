{
  lib,
  pkgs,
  pkgs-stable,
  inputs,
  vars,
  system,
  nixpkgs,
  host,
  ...
}: {
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.fprintd.enable = true;

  fileSystems = {
    "/" = {options = ["compress=zstd"];};
    "/home" = {options = ["compress=zstd"];};
    "/shared" = {options = ["compress=zstd"];};
    "/nix" = {options = ["compress=zstd" "noatime"];};
    "/swap" = {options = ["noatime"];};
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 36 * 1024;
    }
  ];

  boot = {
    kernelParams = [
      "resume_offset=28668091"
    ];

    resumeDevice = "/dev/disk/by-uuid/df894974-92ce-4bcf-97be-2cc41fdfceed";
  };

  systemd.tmpfiles.rules = [
    "w /sys/devices/system/cpu/intel_pstate/hwp_dynamic_boost - - - - 1"
  ];

  # tpm setup
  boot.initrd.systemd.tpm2.enable = true;

  android-studio.enable = true;

  home-manager.users.${vars.user} = {
    # opencode.enable = lib.mkForce false;

    git.gpgKey = "DBFA8DCA389649DB6BEE8A009B4F31A8AFE90BEB";

    home.stateVersion = "26.11";
  };

  system = {
    stateVersion = "26.11";
  };
}
