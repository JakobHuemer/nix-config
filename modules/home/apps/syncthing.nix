{
  pkgs,
  system,
  vars,
  lib,
  config,
  host,
  ...
}: {
  config = lib.mkIf config.services.syncthing.enable {
    services.syncthing = {
      settings = let
        homeFolder =
          if lib.hasInfix "darwin" system
          then "/Users/${vars.user}"
          else "/home/${vars.user}";
      in {
        openDefaultPorts = true;
        extraFlags = ["--no-default-folder"];

        devices = {
          "nixbook".id = "G57PZ76-IT5IMMC-C3KQEN3-EH5X2JE-SKAUU7M-C7CHEWG-U2IVIDO-A3CUXAG";
          "pi4".id = "ZFDPFSJ-VLG6YDV-DH76C72-4NG7WDX-RFRO3Y4-6NTRGTP-NAEDUKW-IAOFEAS";
          "sta01".id = "BV2BYWN-KFLGCYV-THMUZ34-DNYOSJ6-6MQLCQ3-N6LR4HH-2QJDI5S-LR6KJAB";
        };

        folders = {
          "schule" = {
            id = "schule";
            path = "${homeFolder}/schule";
            devices = [
              "nixbook"
              "pi4"
              "sta01"
            ];
          };
        };
      };
    };
  };
}
