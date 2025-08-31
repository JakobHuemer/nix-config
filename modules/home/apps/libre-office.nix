{
  pkgs,
  lib,
  config,
  ...
}: {
  options.libre-office.enable = lib.mkEnableOption "enable libre office";

  config = lib.mkIf config.libre-office.enable {
    home.packages = with pkgs; [
      libreoffice-qt
      hunspell
      hunspellDicts.en_GB-large
      hunspellDicts.de_AT
      hunspellDicts.de_DE
    ];
  };
}
