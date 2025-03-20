{
  config,
  lib,
  pkgs,
  inputs,
  osConfig,
  ...
}:
let
  ffcfg = config.modules.firefox;
in
{
  options = {
    modules.firefox = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      strictPrivacy = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      kagiSearch = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      nightly = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      bookmarks = lib.mkOption {
        type = lib.types.listOf lib.types.attrs;
        default = { };
      };
    };
  };

  config = lib.mkIf ffcfg.enable {
    programs.firefox = {
      enable = true;

      nativeMessagingHosts = [ pkgs.web-eid-app ];
      package =
        if ffcfg.nightly then
          inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin.override {
            pkcs11Modules = [ pkgs.eid-mw ];
            nativeMessagingHosts = [ pkgs.web-eid-app ];
            extraPolicies.SecurityDevices.p11-kit-proxy = "${pkgs.p11-kit}/lib/p11-kit-proxy.so";
          }
        else
          pkgs.firefox.override {
            pkcs11Modules = [ pkgs.eid-mw ];
            nativeMessagingHosts = [ pkgs.web-eid-app ];
            extraPolicies.SecurityDevices.p11-kit-proxy = "${pkgs.p11-kit}/lib/p11-kit-proxy.so";
          };

      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
          EmailTracking = true;
        };
        Cookies = {
          Locked = true;
          Behavior = "reject-foreign";
          BehaviorPrivateBrowsing = "reject-foreign";
        };
        DisablePocket = true;
        DisableAccounts = true;
        # AllowedDomainsForApps = [ ]; # May prevent google login
        AppAutoUpdate = false;
        AutofillAddressEnabled = !ffcfg.strictPrivacy;
        AutofillCreditCardEnabled = false;
        BackgroundAppUpdate = false;
        CaptivePortal = true;
        SantizeOnShutdown = ffcfg.strictPrivacy;
        OfferToSaveLogins = !ffcfg.strictPrivacy;
        OfferToSaveLoginsDefault = false;
        UserMessaging = {
          WhatsNew = false;
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          UrlbarInterventions = false;
          SkipOnboarding = true;
          MoreFromMozilla = false;
          FirefoxLabs = true;
          Locked = true;
        };
        DefaultDownloadDirectory = "\${home}/Downloads";
        DisableAppUpdate = true;
        DisableDefaultBrowserAgent = true;
        DisableFirefoxAccounts = ffcfg.strictPrivacy;
        DisableFormHistory = ffcfg.strictPrivacy;
        DisableProfileRefresh = true;
        DisableSetDesktopBackground = true;
        DisableSystemAddonUpdate = true;
        DisplayBookmarksToolbar = "newtab";
        DisplayMenuBar = "never";
        DNSOverHTTPS = {
          Enabled = false;
          Locked = true;
        };
        EncryptedMediaExtensions.Enabled = false;
        EnterprisePoliciesEnabled = true;
        ExtensionUpdate = false;
        FirefoxHome = {
          Search = true;
          TopSites = true;
          SponsoredTopSites = false;
          Highlights = false;
          Pocket = false;
          SponsoredPocket = false;
          Snippets = false;
          Locked = true;
        };
        FirefoxSuggest = {
          WebSuggestions = false;
          SponsoredSuggestions = false;
          ImpoveSuggest = false;
          Locked = true;
        };
        # GoToIntranetSiteForSingleWordEntryInAddressBar = true;
        HardwareAcceleration = true;
        Homepage = {
          StartPage = "homepage";
          Locked = true;
        };
        HttpsOnlyMode = "force_enabled";
        ManualAppUpdateOnly = true;
        MicrosoftEntraSSO = false;
        NetworkPrediction = true;
        NoDefaultBookmarks = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        PasswordManagerEnabled = !ffcfg.strictPrivacy;
        PDFjs = {
          Enable = true;
          EnablePermissions = false;
        };
        PictureInPicture = {
          Enable = true;
          Locked = true;
        };
        PopupBlocking = {
          Default = true;
          Locked = true;
        };
        PostQuantumKeyAgreementEnabled = true;
        PrintingEnabled = true;
        PrivateBrowsingModeAvailability = 0;
        PromptForDownloadLocation = false;
        Proxy = {
          Mode = "none";
          Locked = true;
        };
        SearchEngines = {
          Add = [
            {
              Name = "Kagi";
              URLTemplate = "https://kagi.com/search?q={searchTerms}";
              Method = "GET";
              IconURL = "https://kagi.com/favicon.ico";
              Alias = "@kagi";
              Description = "Kagi private search engine";
              SuggestURLTemplate = "https://kagi.com/api/autosuggest?q={searchTerms}";
            }
          ];
          Default = if ffcfg.kagiSearch then "Kagi" else "ddg";
          PreventInstalls = true;
          Remove = [
            "Google"
            "Bing"
            "eBay"
          ];
        };
        SearchSuggestEnabled = !ffcfg.strictPrivacy;
        SecurityDevices.Add.p11-kit-proxy = "${pkgs.p11-kit}/lib/p11-kit-proxy.so";
        ShowHomeButton = false;
        SSLVersionMin = "tls1.2";
        StartDownloadsInTempDirectory = true;
        TranslateEnabled = true;
        WindowsSSO = false;
        Preferences = {
          browser.translations.automaticallyPopup = false;
        };
      };

      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings =
          {
            "browser.contentblocking.category" = "custom";
            "browser.discovery.enabled" = false;
            "browser.download.useDownloadDir" = false;
            "browser.newtabpage.activity-stream.feeds.topsites" = false;
            "browser.newtabpage.activity-stream.showSearch" = false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
            "datareporting.healthreport.uploadEnabled" = false;
            "doh-rollout.disable-heuristics" = true;
            "dom.security.https_only_mode" = true;
            "dom.security.https_only_mode_ever_enabled" = true;
            "extensions.formautofill.creditCards.enabled" = false;
            "media.eme.enabled" = true;
            "network.cookie.cookieBehavior" = 1;
            "network.trr.mode" = 5;
            "privacy.donottrackheader.enabled" = true;
            "privacy.globalprivacycontrol.enabled" = true;
            "privacy.globalprivacycontrol.was_ever_enabled" = true;
            "signon.autofillForms" = false;
            "signon.firefoxRelay.feature" = "disabled";
            "signon.generation.enabled" = false;
            "signon.management.page.breach-alerts.enabled" = false;
            "signon.rememberSignons" = false;
            "intl.locale.requested" = "en-GB,en-US";
            "privacy.trackingprotection.enable" = true;
            "privacy.trackingprotection.emailtracking.enable" = true;
            "privacy.trackingprotection.socialtracking.enable" = true;
            "privacy.fingerprintingProtection" = true;
          }
          // lib.mkIf ffcfg.strictPrivacy {
            "privacy.sanitize.pending" =
              ''[{\"id\":\"newtab-container\",\"itemsToClear\":[],\"options\":{}},{\"id\":\"shutdown\",\"itemsToClear\":[\"cache\",\"cookies\",\"offlineApps\",\"history\",\"formdata\",\"downloads\",\"sessions\"],\"options\":{}}]'';
            "privacy.clearOnShutdown.downloads" = true;
            "privacy.clearOnShutdown.formdata" = true;
            "privacy.clearOnShutdown.history" = true;
            "privacy.clearOnShutdown.offlineApps" = true;
            "privacy.clearOnShutdown.sessions" = true;
            "privacy.history.custom" = true;
            "privacy.sanitize.sanitizeOnShutdown" = true;
          }
          // lib.mkIf ffcfg.nightly {
            "sidebar.revamp" = true;
            "sidebar.verticalTabs" = true;
            "browser.download.viewableInternally.typeWasRegistered.jxl" = true;
            "devtools.debugger.features.windowless-service-workers" = true;
            "image.jxl.enabled" = true;
            "privacy.webrtc.globalMuteToggles" = true;
            "browser.ml.chat.enabled" = true;
            "browser.ml.chat.provider" = "https://ai.bhasher.com";
            "browser.ml.chat.shortcuts" = false;
          };

        search = {
          force = true;
          default = if ffcfg.kagiSearch then "Kagi" else "ddg";
          privateDefault = "ddg";
          engines = lib.mkMerge [
            ({
              google.metaData.hidden = true;
              bing.metaData.hidden = true;
              ebay.metaData.hidden = true;
              github = {
                name = "GitHub";
                urls = [
                  {
                    template = "https://github.com/search";
                    params = {
                      q = "{searchTerms}";
                    };
                  }
                ];
                icon = "https://github.githubassets.com/favicons/favicon.png";
                definedAliases = [ "@gh" ];
              };
              nixConfig = {
                name = "Nix Config";
                urls = [
                  {
                    template = "https://search.nixos.org/options";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@nc" ];
              };
              nixPackages = {
                name = "Nix Packages";
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };
              nixHomeManager = {
                name = "Nix Home Manager";
                urls = [
                  {
                    template = "https://home-manager-options.extranix.com/";
                    params = [
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [
                  "@hm"
                  "@nh"
                ];
              };
            })
            (lib.mkIf ffcfg.kagiSearch {
              kagi = {
                name = "Kagi";
                urls = [
                  {
                    template = "https://kagi.com/search";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "https://kagi.com/favicon.ico";
                definedAliases = [
                  "@k"
                  "@kagi"
                ];
              };
            })
          ];
        };
        extensions.packages =
          with pkgs.nur.repos.rycee.firefox-addons;
          [
            darkreader
            belgium-eid
            sidebery
            gaoptout
            cookie-quick-manager
            ublock-origin
            bitwarden
            istilldontcareaboutcookies
            french-language-pack
            castkodi
            twitch-auto-points
          ]
          ++ lib.optionals ffcfg.strictPrivacy [
            clearurls
            privacy-badger
            facebook-container
          ]
          ++ lib.optionals ffcfg.nightly [ aw-watcher-web ]
          ++ lib.optionals osConfig.modules.classes.master-thesis.enable [
            zotero-connector
          ];
        bookmarks = {
          force = true;
          settings = ffcfg.bookmarks;
        };
      };
    };

    xdg.mimeApps.defaultApplications = {
      "text/html" = [ "firefox.desktop" ];
      "text/xml" = [ "firefox.desktop" ];
      "text/json" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "application/pdf" = [ "firefox.desktop" ];
    };
  };
}
