{
  pkgs,
  lib,
  config,
  ...
}: {
  options.ollama.enable = lib.mkEnableOption "enable ollama";

  config = lib.mkIf config.ollama.enable {
    services.ollama = {
      enable = true;
      package = pkgs.ollama-rocm;
    };
    services.nextjs-ollama-llm-ui = {
      enable = true;

      port = 6420;
    };
  };
}
