{
  pkgs,
  config,
  ...
}: let
  configDir =
    if pkgs.stdenv.isDarwin && !config.xdg.enable
    then "Library/Application Support/nushell"
    else "${config.xdg.configHome}/nushell";
in {
  programs = {
    nushell = {
      enable = true;
    };

    # Integration programs - check which ones support nushell
    oh-my-posh.enableNushellIntegration = true;
    zoxide.enableNushellIntegration = true;
    # fzf.enableNushellIntegration = true;  # uncomment if this option exists
  };

  programs.gh = {
    enable = true;
    extensions = [pkgs.gh-copilot];
  };

  home.packages = with pkgs; [
    nushell
    pay-respects
    pfetch-rs
    macchina
    bat
    fzf
    zoxide
    lsd
    eza
  ];
}
