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

      loadModels = [
        "qwen3-coder:30b"
      ];

      environmentVariables = {
        OLLAMA_FLASH_ATTENTION = "0";
        HIP_VISIBLE_DEVICES = "0";
        OLLAMA_CONTEXT_LENGTH = "16384";
      };
    };

    # environment.systemPackages = [
    #   (pkgs.ollama-rocm.override {
    #     acceleration = "rocm";
    #   })
    # ];

    services.open-webui = {
      enable = true;

      port = 6420;
    };
  };
}
