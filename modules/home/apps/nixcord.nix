{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{

  imports = [
    inputs.nixcord.homeManagerModules.nixcord
  ];

  options = {
    nixcord.enable = lib.mkEnableOption "enable nixcord";
  };

  config = lib.mkIf config.nixcord.enable {

    programs.nixcord = {
      enable = true;
      quickCss = "";
      config = {
        useQuickCss = true;
        themeLinks = [
          # "https://raw.githubusercontent.com/moistp1ckle/GitHub_Dark/refs/heads/main/source.css"
          # "https://raw.githubusercontent.com/TheoEwzZer/RoundmoledV2/refs/heads/main/roundmoledV2.theme.css"
          # "https://raw.githubusercontent.com/refact0r/midnight-discord/refs/heads/master/flavors/midnight-catppuccin-mocha.theme.css"
          # "https://raw.githubusercontent.com/booglesmcgee/booglesmcgee.github.io/refs/heads/main/Materialistic-Discord/Materialistic.theme.css"
          "https://raw.githubusercontent.com/refact0r/system24/refs/heads/main/theme/system24.theme.css"
          # "https://raw.githubusercontent.com/PL7963/Discord-Mica/refs/heads/main/discord-mica.theme.css"
          # "https://raw.githubusercontent.com/TheCommieAxolotl/BetterDiscord-Stuff/refs/heads/main/Ultra/Ultra.theme.css"
          # "https://raw.githubusercontent.com/LuckFire/amoled-cord/refs/heads/main/clients/amoled-cord.theme.css"
          # "https://raw.githubusercontent.com/discord-extensions/modern-indicators/refs/heads/main/clients/modern-indicators.theme.css"
          # "https://raw.githubusercontent.com/SlippingGittys-Discord-Themes/Espresso-Discord-Theme/refs/heads/main/discordEspresso.theme.css"
          # "https://raw.githubusercontent.com/catppuccin/discord/refs/heads/main/themes/mocha.theme.css"
        ];

        transparent = true;
        disableMinSize = true;
        frameless = true;

        plugins = {
          chatInputButtonAPI.enable = true;
          commandsAPI.enable = true;
          memberListDecoratorsAPI.enable = true;
          messageAccessoriesAPI.enable = true;

          accountPanelServerProfile = {
            enable = true;
            prioritizeServerProfile = true;
          };

          betterFolders = {
            enable = true;
            sidebar = false;
            sidebarAnim = false;
            closeAllFolders = true;
            closeAllHomeButton = false;
            closeOthers = true;
            forceOpen = false;
            keepIcons = false;
            showFolderIcon = "always";
          };

          betterGifAltText.enable = true;

          readAllNotificationsButton.enable = true;

          noDevtoolsWarning.enable = true;

          noProfileThemes.enable = true;

          noF1.enable = true;

          nsfwGateBypass.enable = true;

          onePingPerDM.enable = true;

          oneko.enable = true;

          permissionsViewer = {
            enable = true;
            defaultPermissionsDropdownState = false;
          };

          roleColorEverywhere.enable = true;

          sendTimestamps.enable = true;

          showHiddenChannels.enable = true;

          silentTyping = {
            enable = true;
            showIcon = true;
            contextMenu = true;
          };

          silentMessageToggle.enable = true;

          translate = {
            enable = true;
            autoTranslate = false;
          };

          typingIndicator = {
            enable = true;
            includeCurrentChannel = true;
            includeMutedChannels = false;

          };

          typingTweaks.enable = true;

          unlockedAvatarZoom.enable = true;

          userVoiceShow.enable = true;

          validUser.enable = true;

          voiceChatDoubleClick.enable = true;

          volumeBooster.enable = true;

          reviewDB = {
            enable = true;
            hideTimestamps = false;
          };

          messageLatency.enable = true;

          biggerStreamPreview.enable = true;

          callTimer.enable = true;

          clearURLs.enable = true;

          # TODO: customRPC

          # decor.enable = true;

          experiments = {
            enable = true;
            toolbarDevMenu = true;
          };

          fakeNitro = {
            enable = true;

          };

          fixImagesQuality.enable = true;

          fixYoutubeEmbeds.enable = true;

          friendsSince.enable = true;

          fullSearchContext.enable = true;

          gameActivityToggle.enable = true;

          greetStickerPicker.enable = true;

          iLoveSpam.enable = true;

          imageZoom = {
            enable = true;
            nearestNeighbour = true;

            zoomSpeed = 0.2;
          };

          memberCount.enable = true;

          messageLogger = {
            enable = true;
            deleteStyle = "overlay";
            ignoreBots = true;
          };

          moreCommands.enable = true;

          moreUserTags = {
            enable = true;

            # TODO: edit texts for different people etc.
          };

          newGuildSettings = {
            enable = true;

            # 0 serverDefault
            # 1 all
            # 2 only@Mentions
            # 3 nothing
            messages = "only@Mentions";

            everyone = true;
            role = false;
            events = true;
          };

          noOnboardingDelay.enable = true;

          openInApp.enable = true;

          pinDMs = {
            enable = true;
            pinOrder = "custom";
          };

          platformIndicators.enable = true;

          replaceGoogleSearch = {
            enable = true;
            customEngineName = "DuckDuckGo";

            customEngineURL = "https://duckduckgo.com/";
          };

          shikiCodeblocks = {
            enable = true;
            theme = "https://raw.githubusercontent.com/withastro/houston-vscode/d297233be95e3f8fdecc22e4ffa92bb0e7265592/themes/houston.json";
            tryHljs = "SECONDARY";

          };

          showHiddenThings.enable = true;

          vencordToolbox.enable = true;

          voiceMessages.enable = true;

        };
      };
    };

    home.activation = {
      createNixcordApp = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
              $DRY_RUN_CMD mkdir -p $HOME/Applications
              
              # Create the NixCord.app bundle
              $DRY_RUN_CMD mkdir -p "$HOME/Applications/NixCord.app/Contents/MacOS"
              
              # Create Info.plist
              $DRY_RUN_CMD cat > "$HOME/Applications/NixCord.app/Contents/Info.plist" << 'EOF'
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>CFBundleExecutable</key>
            <string>discord</string>
            <key>CFBundleIdentifier</key>
            <string>com.discord.Discord</string>
            <key>CFBundleName</key>
            <string>Discord</string>
            <key>CFBundlePackageType</key>
            <string>APPL</string>
            <key>CFBundleShortVersionString</key>
            <string>1.0</string>
            <key>LSApplicationCategoryType</key>
            <string>public.app-category.social-networking</string>
            <key>LSMinimumSystemVersion</key>
            <string>10.10.0</string>
        </dict>
        </plist>
        EOF

              # Create the executable script
              $DRY_RUN_CMD cat > "$HOME/Applications/NixCord.app/Contents/MacOS/discord" << 'EOF'
        #!/bin/sh
        PATH="${config.home.profileDirectory}/bin:$PATH"
        exec discord "$@"
        EOF
              
              # Make the script executable
              $DRY_RUN_CMD chmod +x "$HOME/Applications/NixCord.app/Contents/MacOS/discord"
      '';
    };
  };
}
