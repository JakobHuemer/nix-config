{ inputs, pkgs, nixgl, vars, ... }:

{
  nixGL = {
    defaultWrapper = "nvidia";
    installScripts = "nvidia";

    prime = {
      installScript = "nvidia";
    };

    vulkan.enable = true;
  };

  home = {
    packages = [
      (import nixgl { inherit pkgs; }).nixVulkanIntel
      pkgs.hello
      pkgs.tmux
      pkgs.kitty
      pkgs.alacritty


      # nvidia
      # pkgs.nvidia-docker
      # pkgs.nvidia-settings
      # pkgs.vulkan-tools
      # pkgs.glxinfo
    ];

    sessionVariables = {
      NIXOS_OZONE_WL = "1";

      # nvidia
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBARY_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";
    };


    activation = {
      linkDesktopApplications = {
        after = [ "writeBoundary" "createXdgUserDirectories" ];
        before = [];
        data = "/usr/bin/update-desktop-database";
      };
    };

    # nvidia

  };

  xdg = {
    enable = true;
    systemDirs.data = [ "/home/${vars.user}/.nix-profile/share" ];
  }; # add nixpks to XDG_DATA_DIRS

  nix = {
    settings = {
      auto-optimise-store = true;
    };

    package = pkgs.nixVersions.stable;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes 
      keep-outputs          = true
      keep-derivations      = true
    '';
  };

  nixpkgs.config = {
    allowUnfree = true;
    nvidia.acceptLicense = true;
  };

}
