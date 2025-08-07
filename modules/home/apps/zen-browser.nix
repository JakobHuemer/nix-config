{
  pkgs,
  vars,
  inputs,
  lib,
  config,
  system,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  options = {zen.enable = lib.mkEnableOption "enables zen-browser";};

  config = lib.mkIf config.zen.enable {
    programs.zen-browser = {
      enable = true;

      #   profiles."default" = {
      #     id = 0;
      #     isDefault = true;
      #   };
      #
      #   policies = {
      #     AutofillCreditCardEnabled = false;
      #     DisableAppUpdate = true;
      #     DisableFeedbackCommands = true;
      #     DisableFirefoxStudies = true;
      #     DisablePocket = true;
      #     DisableTelemetry = true;
      #     DontCheckDefaultBrowser = true;
      #     NoDefaultBookmarks = true;
      #     OfferToSaveLogins = false;
      #     EnableTrackingProtection = {
      #       Value = true;
      #       Locked = true;
      #       Cryptomining = true;
      #       Fingerprinting = true;
      #     };
      #   };
    };
    # home.packages = [
    #   # (
    #   inputs.zen-browser.packages."${system}".default
    #   # )
    # ];
  };
}
