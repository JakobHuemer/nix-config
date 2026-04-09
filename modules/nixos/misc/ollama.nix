{
  pkgs,
  lib,
  config,
  vars,
  host,
  ...
}: {
  options.ollama.enable = lib.mkEnableOption "enable ollama";

  config = lib.mkIf config.ollama.enable {
    services.ollama = {
      enable = true;
      package = pkgs.ollama-rocm;

      host = "0.0.0.0";
      port = 11434;

      loadModels = [
        "qwen3-coder:30b"
        "VladimirGav/gemma4-26b-16GB-VRAM"
        "gemma4:e4b"
      ];

      environmentVariables = {
        # OLLAMA_FLASH_ATTENTION = "0";
        # HIP_VISIBLE_DEVICES = "0";
        OLLAMA_CONTEXT_LENGTH = "131072"; # 128K
        HSA_OVERRIDE_GFX_VERSION =
          if host.hostName == "sta01"
          then "11.0.1"
          else null;
      };
    };

    # environment.systemPackages = [
    #   (pkgs.ollama-rocm.override {
    #     acceleration = "rocm";
    #   })
    # ];

    # services.open-webui = {
    #   enable = true;
    #
    #   package = pkgs-stable.open-webui;
    #
    #   host = "0.0.0.0";
    #   port = 6420;
    # };
  };
}
