{ inputs, config, pkgs, sops, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  # remove when putting on raspberry
  virtualisation.vmware.guest.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      # foot = { bar };
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
      # TODO: use sops
      # "8a065e66-15a0-4bac-81d9-6740553e9b47" = {
      "raspi-nix-vm" = {
        # credentialsFile = config.sops.secrets."cloudflared/raspi-nix-vm".path;
        credentialsFile = config.sops.secrets."cloudflared/raspi-nix-vm".path;
	default = "http://localhost:8080";
	ingress = {
	  "localhost.jstxel.de" = "http://localhost:8080";
	};
      };
    };
  };

  # configuration for my raspberry pi 4 home server

}
