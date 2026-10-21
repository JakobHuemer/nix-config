{
  pkgs,
  lib,
  config,
  system,
  inputs,
  ...
}: {
  options.opencode.enable = lib.mkEnableOption "enable opencode";

  config = lib.mkIf config.opencode.enable {
    home.file.".config/opencode/AGENTS.md".source = ../../../conf/opencode/AGENTS.md;

    programs.opencode = {
      enable = true;

      package = inputs.opencode.packages.${system}.opencode;

      settings = {
        autoupdate = true;

        providers.anthropic = {
          settings = {
            baseURL = "http://127.0.0.1:3456/v1";
            apiKey = "dummy";
          };
        };

        plugin = [
          # "@khalilgharbaoui/opencode-claude-code-plugin"
          "@anthonyhaussman/opencode-agy-auth"
          # "opencode-with-claude"
        ];
      };
    };
  };
}
