{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {tofi.enable = lib.mkEnableOption "enable tofi";};

  config = lib.mkIf config.tofi.enable {
    programs.tofi = {
      enable = true;
      settings = {
        /*
        width = 100%
        height = 100%
        border-width = 0
        outline-width = 0
        padding-left = 35%
        padding-top = 25%
        result-spacing = 25
        num-results = 8
        font = JetBrainsMono NF Regular
        background-color = #000A
        prompt-text = "  "
        */

        width = "100%";
        height = "100%";
        border-width = 0;
        outline-width = 0;
        padding-left = "35%";
        padding-top = "25%";
        result-spacing = 25;
        num-results = 8;
        font = lib.mkForce "JetBrainsMono NF Regular";
        font-size = lib.mkForce 30;
        text-color = lib.mkForce "#D0D0E0FF";
        background-color = lib.mkForce "#101020DD";
        input-background = lib.mkForce "#0000";
        placeholder-color = lib.mkForce "#D0D0F0FF";
        prompt-color = lib.mkForce "#D0D0F0FF";
        prompt-background = lib.mkForce "#0000";
        selection-background = lib.mkForce "#0000";
        selection-color = lib.mkForce "#D0D0F0FF";
        default-result-background = lib.mkForce "#0000";
      };
    };
  };
}
