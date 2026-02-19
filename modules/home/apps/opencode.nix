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
              "qwen3-coder:30b" = {
                name = "qwen3-coder:30b";
                limit = {
                  context = 256000;
                  output = 256000;
                };
              };
              "gpt-oss:20b" = {
                name = "gpt-oss:20b";
                limit = {
                  context = 128000;
                  output = 128000;
                };
              };
              "glm-4.7-flash:latest" = {
                name = "glm-4.7-flash:latest";
                limit = {
                  context = 189000;
                  output = 198000;
                };
              };
            };
          };
        };
      };
    };
  };
}
