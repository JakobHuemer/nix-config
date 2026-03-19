{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}:
{
  imports = [ inputs.nixcord.homeModules.nixcord ];

  options = {
    nixcord.enable = lib.mkEnableOption "enable nixcord";
  };

  config =
    if system == "aarch64-linux" then
      lib.mkIf config.nixcord.enable {
        programs.vesktop = {
          enable = true;

          vencord = {
            useSystem = true;

            settings = {
              useQuickCss = true;
              themeLinks = [
                # TODO: reenable: disabled for now because of discords new ui change
                # "https://raw.githubusercontent.com/refact0r/system24/refs/heads/main/theme/system24.theme.css"

                # "https://raw.githubusercontent.com/moistp1ckle/GitHub_Dark/refs/heads/main/source.css"
                # "https://raw.githubusercontent.com/TheoEwzZer/RoundmoledV2/refs/heads/main/roundmoledV2.theme.css"
                # "https://raw.githubusercontent.com/refact0r/midnight-discord/refs/heads/master/flavors/midnight-catppuccin-mocha.theme.css"
                # "https://raw.githubusercontent.com/booglesmcgee/booglesmcgee.github.io/refs/heads/main/Materialistic-Discord/Materialistic.theme.css"
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

              cloud = {
                settingsSync = true;
              };

              plugins = {
                ChatInputButtonAPI.enabled = true;
                CommandsAPI.enabled = true;
                MemberListDecoratorsAPI.enabled = true;
                MessageAccessoriesAPI.enabled = true;

                AccountPanelServerProfile = {
                  enabled = true;
                  prioritizeServerProfile = true;
                };

                BetterFolders = {
                  enabled = true;
                  sidebar = false;
                  sidebarAnim = false;
                  closeAllFolders = true;
                  closeAllHomeButton = false;
                  closeOthers = true;
                  forceOpen = false;
                  keepIcons = false;
                  showFolderIcon = 1;
                };

                BetterGifAltText.enabled = true;

                ReadAllNotificationsButton.enabled = true;

                NoDevtoolsWarning.enabled = true;

                NoProfileThemes.enabled = true;

                NoF1.enabled = true;

                OnePingPerDM.enabled = true;

                oneko.enabled = true;

                PermissionsViewer.enabled = true;

                RoleColorEverywhere.enabled = true;

                SendTimestamps.enabled = true;

                ShowHiddenChannels.enabled = true;

                SilentTyping = {
                  enabled = true;
                  showIcon = true;
                  contextMenu = true;
                };

                SilentMessageToggle.enabled = true;

                Translate = {
                  enabled = true;
                  autoTranslate = false;
                };

                TypingIndicator = {
                  enabled = true;
                  includeCurrentChannel = true;
                  includeMutedChannels = false;
                };

                TypingTweaks.enabled = true;

                UnlockedAvatarZoom.enabled = true;

                UserVoiceShow.enabled = true;

                ValidUser.enabled = true;

                VoiceChatDoubleClick.enabled = true;

                VolumeBooster.enabled = true;

                ReviewDB = {
                  enabled = true;
                  hideTimestamps = false;
                };

                MessageLatency.enabled = true;

                BiggerStreamPreview.enabled = true;

                CallTimer.enabled = true;

                ClearURLs.enabled = true;

                # TODO: customRPC

                # decor.enable = true;

                Experiments = {
                  enabled = true;
                  toolbarDevMenu = true;
                };

                FakeNitro.enabled = true;

                FixImagesQuality.enabled = true;

                FixYoutubeEmbeds.enabled = true;

                FriendsSince.enabled = true;

                FullSearchContext.enabled = true;

                GameActivityToggle.enabled = true;

                GreetStickerPicker.enabled = true;

                iLoveSpam.enabled = true;

                ImageZoom = {
                  enabled = true;
                  nearestNeighbour = true;

                  zoomSpeed = 0.2;
                };

                MemberCount.enabled = true;

                MessageLogger = {
                  enabled = true;
                  deleteStyle = "overlay";
                  ignoreBots = true;
                };

                NewGuildSettings = {
                  enabled = true;

                  # 0 serverDefault
                  # 1 all
                  # 2 only@Mentions
                  # 3 nothing
                  messages = 1;

                  everyone = true;
                  role = false;
                  events = true;
                };

                NoOnboardingDelay.enabled = true;

                OpenInApp.enabled = true;

                PinDMs = {
                  enabled = true;
                  pinOrder = 1;
                };

                PlatformIndicators.enabled = true;

                ReplaceGoogleSearch = {
                  enabled = true;
                  replacementEngine = "DuckDuckGo";
                };

                # shikiCodeblocks = {
                #   enable = true;
                #   theme = "https://raw.githubusercontent.com/withastro/houston-vscode/d297233be95e3f8fdecc22e4ffa92bb0e7265592/themes/houston.json";
                #   tryHljs = "SECONDARY";
                #
                # };

                ShowHiddenThings.enabled = true;

                VencordToolbox.enabled = true;

                VoiceMessages.enabled = true;
              };
            };
          };
        };
      }
    else
      lib.mkIf config.nixcord.enable {
        programs.nixcord = {
          enable = true;

          userPlugins = {
            # customSounds = "github:ScattrdBlade/customSounds/c1c249d83336c51f3cece476dc36583d52eb81c9";
          };

          quickCss = "";
          config = {
            useQuickCss = true;
            themeLinks = [
              # TODO: reenable: disabled for now because of discords new ui change
              # "https://raw.githubusercontent.com/refact0r/system24/refs/heads/main/theme/system24.theme.css"

              # "https://raw.githubusercontent.com/moistp1ckle/GitHub_Dark/refs/heads/main/source.css"
              # "https://raw.githubusercontent.com/TheoEwzZer/RoundmoledV2/refs/heads/main/roundmoledV2.theme.css"
              # "https://raw.githubusercontent.com/refact0r/midnight-discord/refs/heads/master/flavors/midnight-catppuccin-mocha.theme.css"
              # "https://raw.githubusercontent.com/booglesmcgee/booglesmcgee.github.io/refs/heads/main/Materialistic-Discord/Materialistic.theme.css"
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

                showChatBarButton = true;
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

              # shikiCodeblocks = {
              #   enable = true;
              #   theme = "https://raw.githubusercontent.com/withastro/houston-vscode/d297233be95e3f8fdecc22e4ffa92bb0e7265592/themes/houston.json";
              #   tryHljs = "SECONDARY";
              #
              # };

              showHiddenThings.enable = true;

              vencordToolbox.enable = true;

              voiceMessages.enable = true;
            };
          };
        };
      };
}
