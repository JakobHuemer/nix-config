{
  inputs,
  config,
  pkgs,
  sops,
  vars,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # remove when putting on raspberry
  virtualisation = {
    vmware.guest.enable = true;
    docker.enable = true;
    oci-containers = {
      backend = "docker";
      containers = {
        # foot = { bar };
      };
    };
  };

  networking.dhcpcd = {
    persistent = true;

    extraConfig = ''
      nixpi4
    '';
  };

  services.openssh = {
    enable = true;
    ports = [ 4204 ];
    allowSFTP = true;

    settings = {
      PasswordAuthentication = true;
      UseDns = null;
      PermitRootLogin = "prohibit-password";
    };

    authorizedKeysFiles = [ "/ssh/authorized_keys" ];

    extraConfig = ''
      Match User jakki,root
        PasswordAuthentication no
    '';
  };

  environment.systemPackages = [
    pkgs.cloudflared
  ];

  users.extraGroups.docker.members = [ "${vars.user}" ];

  sops.defaultSopsFile = ../../secrets/secrets.yaml;

  sops.age.keyFile = "/home/${vars.user}/.config/sops/age/keys.txt";

  sops.secrets."cloudflared/raspi-nix-vm" = {
    owner = config.services.cloudflared.user;
    group = config.services.cloudflared.group;
  };

  sops.secrets."cloudflared/cert" = {
    owner = config.services.cloudflared.user;
    group = config.services.cloudflared.group;
  };

  services.cloudflared = {
    enable = true;
    tunnels = {
      "raspi-nix-vm" = {
        credentialsFile = config.sops.secrets."cloudflared/raspi-nix-vm".path;
        default = "http://localhost:8080";
        ingress = {
          "localhost.jstxel.de" = "http://localhost:8080";
        };
      };
    };
  };

}
