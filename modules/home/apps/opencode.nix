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
    home.file.".config/opencode/skills/caveman/SKILL.md" = let
      src = pkgs.fetchFromGitHub {
        owner = "JuliusBrussee";
        repo = "caveman";
        rev = "main";
        hash = "sha256-EAlKoqJuTMib+gcLscMtpS8Zzq/D/LmIRoG3g/XKThc=";
      };
    in {
      enable = true;
      source = src + "/skills/caveman/SKILL.md";
    };

    programs.opencode = {
      enable = true;

      package = inputs.opencode.packages.${system}.opencode;

      tui.theme = "catppuccin";

      settings = {
        autoupdate = true;

        plugin = [
          "opencode-gemini-auth@latest"
        ];

        provider = {
          ollama = {
            name = "Ollama (sta01)";
            npm = "@ai-sdk/openai-compatible";
            options = {
              baseURL = "http://sta01.h.fistel.dev:11434/v1";
            };

            models = {
              "gemma4-26b-16GB-VRAM" = {
                name = "Gemma 4 26b 16GB VRAM";
                limit = {
                  context = 65536;
                  output = 8192;
                };
              };

              "gemma4:e4b" = {
                name = "Gemma 4 e4B";
                limit = {
                  context = 131072;
                  output = 16384;
                };
              };
            };
          };
        };
      };
    };
  };
}
