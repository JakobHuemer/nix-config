{
  inputs,
  config,
  pkgs,
  sops,
  vars,
  ...
}: {
  networking = {
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          {
            address = "192.168.8.42";
            prefixLength = 24;
          }
        ];
      };

      # wlan0 = {
      #   ipv4.addresses = [
      #     {
      #       address = "192.168.8.43";
      #       prefixLength = 24;
      #     }
      #   ];
      # };
    };
  };

  # networking.networkmanager.enable = true;

  services.openssh = {
    enable = true;
    ports = [22];
    allowSFTP = true;

    settings = {
      PasswordAuthentication = true;
    };
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICULebDDxaeO8wiff+ZAUaD2kzChyoKWW/2KDWt5AbJL jakki@mbp2p"
  ];

  # environment.systemPackages = with pkgs; [
  #   git
  #   wget
  #   curl
  #   parted
  #   util-linux
  #   coreutils
  #   networkmanager
  # ];
  #
  # nix = {
  #   settings.experimental-features = ["nix-command" "flakes"];
  #   extraOptions = "experimental-features = nix-command flakes";
  # };

  # system = {
  #   stateVersion = "25.05";
  # };
}
