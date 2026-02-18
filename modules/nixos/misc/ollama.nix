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
      package = (pkgs.ollama-rocm.override {
        acceleration = "rocm";
      });

      loadModels = [
        "qwen3-coder:30b"
      ];
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
