{
  pkgs,
  system,
  vars,
  lib,
  config,
  host,
  ...
}: let
  allwaysSyncDevices = [
    "server"
  ];

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
        devices = (deviceList folder.devices) ++ allwaysSyncDevices;
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
          "server".id = "P4NMIXM-PAKBF6V-WESAV34-4D5MGEV-HUKDFZ4-6GXLYJV-Q6F4HDS-NMJMUQZ";
          "nixbook".id = "G57PZ76-IT5IMMC-C3KQEN3-EH5X2JE-SKAUU7M-C7CHEWG-U2IVIDO-A3CUXAG";
          "sta01".id = "BV2BYWN-KFLGCYV-THMUZ34-DNYOSJ6-6MQLCQ3-N6LR4HH-2QJDI5S-LR6KJAB";
          "mbp2p".id = "VSEHSRN-GLJKODA-YSHOY3C-Z42LV32-M4UHIRV-64XHYJQ-EUE3FHV-F5INSAH";
          "frame1301".id = "G3PBSFL-ADLXPJU-OVSCVVT-3RFK4N4-JIEEXXP-LCS6TDB-RNHULPL-3ZLNPAA";
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
              sta01 = {};
              mbp2p = {};
              frame1301 = {
                path = "${homeFolder}/school";
              };
            };
          };

          ssh-keys = {
            id = "ssh-keys";
            defaultPath = "${homeFolder}/.ssh";

            ignorePatterns = [
              "known_hosts"
              "known_hosts.old"
            ];

            devices = {
              nixbook = {};
              sta01 = {};
              frame1301 = {};
            };
          };

          vwa = {
            id = "vorwissenschaftliche-arbeit";
            defaultPath = "${homeFolder}/vwa";
            devices = {
              nixbook = {};
              sta01 = {};
              mbp2p = {};
              frame1301 = {};
            };
          };
        };
      };
    };
  };
}
