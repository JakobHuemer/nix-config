{
  lib,
  config,
  pkgs,
  vars,
  ...
}: {
  options.custom.virtualisation = {
    enable = lib.mkEnableOption "my virtualisation config";
  };

  config = let
    cfg = config.custom.virtualisation;
  in
    lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        qemu_full
      ];

      programs.virt-manager.enable = true;
      users.groups.libvirtd.members = ["${vars.user}"];
      virtualisation.spiceUSBRedirection.enable = true;

      virtualisation.libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
        };
      };

      home-manager.users.${vars.user} = {
        dconf.settings = {
          "org/virt-manager/virt-manager/connections" = {
            autoconnect = ["qemu:///system"];
            uris = ["qemu:///system"];
          };
        };
      };
    };
}
