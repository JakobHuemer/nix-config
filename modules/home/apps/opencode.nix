{
  pkgs,
  lib,
  config,
  ...
}: {
  options.opencode.enable = lib.mkEnableOption "enable opencode";

  config = lib.mkIf config.opencode.enable {
    programs.opencode = {
      enable = true;

      settings = {
        autoupdate = true;

        provider = {
          ollama = {
            name = "Ollama (sta01)";
            npm = "@ai-sdk/openai-compatible";
            options = {
              baseURL = "http://sta01.h.fistel.dev:11434/v1";
            };

            models = {
              "qwen3-coder:30b".name = "qwen3-coder:30b";
            };
          };
        };
      };
    };
  };
}
