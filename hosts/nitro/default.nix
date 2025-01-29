{
  pkgs,
  inputs,
  vars,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages = [
    pkgs.firefox
    pkgs.nemo

    # Audio / Video
    pkgs.alsa-utils
    pkgs.pipewire
    pkgs.pulseaudio
    pkgs.vlc
    pkgs.mpv
    pkgs.linux-firmware
    pkgs.pavucontrol
    pkgs.ghostty
    pkgs.kitty
    pkgs.alacritty
  ];

  # configuration to make for acer nitro 5 NixStation NixOs

  programs.hyprland = {
    enable = true;

    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

  };

  home-manager.users.${vars.user} = {
    # nixcord.enable = true;
    hyprland.enable = true;
    vscode.enable = true;
    ghostty.enable = true;

    wayland.windowManager.hyprland.settings = {
      "$mod" = "ALT";
      "$terminal" = "ghostty";
      bind =
        [
          "$mod, A, exec, $terminal"
          "$mod, M, exit,"
          "$mod, Q, killactive,"
          "$mod, W, togglefloating,"
          "$mod, F, exec, firefox"
        ]
        ++ (builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          ) 9
        ));
    };
  };
}
