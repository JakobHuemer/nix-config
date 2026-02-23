{
  pkgs,
  system,
  vars,
  lib,
  config,
  host,
  ...
}: let
  mkSyncthingFolders = hostName: folders: let
    # helper: check membership in attrset
    hasDevice = devices: devices ? "${hostName}";
    # helper: resolve path for this host
    resolvePath = folder: let
      dev = folder.devices."${hostName}" or {};
    in
      dev.path or folder.defaultPath;
    # helper: list of device names (already IDs)
    deviceList = devices: builtins.attrNames devices;
    # build folder entries, filtered to only those this host participates in
    mkFolderEntry = name: folder: {
      name = name;
      value = {
        id = folder.id;
        path = resolvePath folder;
        devices = deviceList folder.devices;
      };
    };
    folderNames = builtins.attrNames folders;
    relevantNames = builtins.filter (n: hasDevice folders.${n}.devices) folderNames;
    entries = map (n: mkFolderEntry n folders.${n}) relevantNames;
  in
    builtins.listToAttrs entries;
in {
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
          "mbp2p".id = "VSEHSRN-GLJKODA-YSHOY3C-Z42LV32-M4UHIRV-64XHYJQ-EUE3FHV-F5INSAH";
        };

        # folders = {
        #   "schule" = {
        #     id = "schule";
        #     path = "${homeFolder}/schule";
        #     devices = [
        #       "nixbook"
        #       "pi4"
        #       "sta01"
        #       "mbp2p"
        #     ];
        #   };
        #   "vwa" = {
        #     id = "vorwissenschaftliche-arbeit";
        #     path = "${homeFolder}/vwa";
        #     devices = [
        #       "nixbook"
        #       "pi4"
        #       "sta01"
        #       "mbp2p"
        #     ];
        #   };
        # };

        folders = mkSyncthingFolders host.hostName {
          schule = {
            id = "schule";
            defaultPath = "${homeFolder}/schule";

            devices = {
              nixbook = {};
              pi4 = {};
              sta01 = {};
              mbp2p = {};
            };
          };

          vwa = {
            id = "vorwissenschaftliche-arbeit";
            defaultPath = "${homeFolder}/vwa";
            devices = {
              nixbook = {};
              pi4 = {};
              sta01 = {};
              mbp2p = {};
            };
          };
        };
      };
    };
  };
}
