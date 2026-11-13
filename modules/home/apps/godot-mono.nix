{
  pkgs,
  config,
  lib,
  ...
}: {
  options.programs.godot-mono.enable = lib.mkEnableOption "godot mono";

  config = lib.mkIf config.programs.godot-mono.enable {
    home.packages = with pkgs; [
      dotnet-sdk_11
      (godot-mono.overrideAttrs {
        dotnet-sdk = pkgs.dotnetCorePackages.sdk_10_0-source;
      })
      netcoredbg
      godot-mcp

      (buildDotnetGlobalTool {
        pname = "easydotnet";
        version = "3.4.26";
        executables = ["dotnet-easydotnet"];
        nugetHash = "sha256-Sn4zzJ4nWkkp5o/aJ9HV8m+JW4DWx09/MsNEbWU1qYU=";
        dotnet-runtime = pkgs.dotnetCorePackages.sdk_11_0;
      })
    ];

    home.file.".local/share/godot/export_templates".source = "${pkgs.godotPackages_4_7.export-templates-mono-bin}/share/godot/export_templates";
  };
}
