{
  pkgs,
  config,
  ...
}: {
  programs = {
    nushell = {
      enable = true;
    };

    # Integration programs - check which ones support nushell
    oh-my-posh.enableNushellIntegration = true;
    zoxide.enableNushellIntegration = true;
    # fzf.enableNushellIntegration = true;  # uncomment if this option exists
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
