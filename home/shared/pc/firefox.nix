{
  config,
  lib,
  pkgs,
}:
with lib;
let
  ffcgf = config.programs.custom.firefox;
in
{
  options = {
    services.custom.firefox = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      search = {
        disableUnwanted = mkOption {
          type = types.bool;
          default = true;
        };
        kagi = mkOption {
          type = types.bool;
          default = false;
        };
        developer = mkOption {
          type = types.bool;
          default = false;
        };
      };
      privacy = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };
        strict = mkOption {
          type = types.bool;
          default = false;
        };
      };
      eid = mkOption {
        type = types.bool;
        default = true;
      };
      nightly = mkOption {
        type = types.bool;
        default = false;
      };
      defaultExtensions = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };

  config = mkIf ffcgf.enable {
    programs.firefox = rec {
      enable = true;

      nativeMessagingHosts = optionals ffcgf.eid [ pkgs.web-eid-app ];
      version_ =
        if ffcfg.nightly then inputs.firefox.package.${pkgs.system}.firefox-nightly-bin else pkgs.firefox;
      package =
        if !ffcgf.eid then
          version_
        else
          version_.override {
            pkcs11Modules = [ pkgs.eid-mw ];
            nativeMessagingHosts = [ pkgs.web-eid-app ];
          };

      policies.SecurityDevices.p11-kit-proxy = mkIf ffcgf.eid "${pkgs.p11-kit}/lib/p11-kit-proxy.so";

      profiles.default = {
        settings =
          {
            "signon.autofillForms" = false;
            "intl.locale.requested" = "en-GB,en-US";
          }
          // mkIf ffcgf.privacy.enable {
            "privacy.trackingprotection.enable" = true;
            "privacy.trackingprotection.emailtracking.enable" = true;
            "privacy.trackingprotection.socialtracking.enable" = true;
            "privacy.fingerprintingProtection" = true;
          }
          // mkIf ffcgf.privacy.strict {
            "privacy.sanitize.pending" = ''[{\"id\":\"newtab-container\",\"itemsToClear\":[],\"options\":{}},{\"id\":\"shutdown\",\"itemsToClear\":[\"cache\",\"cookies\",\"offlineApps\",\"history\",\"formdata\",\"downloads\",\"sessions\"],\"options\":{}}]'';
            "privacy.clearOnShutdown.downloads" = true;
            "privacy.clearOnShutdown.formdata" = true;
            "privacy.clearOnShutdown.history" = true;
            "privacy.clearOnShutdown.offlineApps" = true;
            "privacy.clearOnShutdown.sessions" = true;
            "privacy.history.custom" = true;
            "privacy.sanitize.sanitizeOnShutdown" = true;
          }
          // mkIf ffcgf.nightly {
            "sidebar.revamp" = true;
            "sidebar.verticalTabs" = true;
            "browser.download.viewableInternally.typeWasRegistered.jxl" = true;
            "devtools.debugger.features.windowless-service-workers" = true;
            "image.jxl.enabled" = true;
            "privacy.webrtc.globalMuteToggles" = true;
            "browser.ml.chat.enabled" = true;
            "browser.ml.chat.provider" = "https://chat.mistral.ai/chat";
            "browser.ml.chat.shortcuts" = false;
          };

        search = {
          force = true;
          default = if ffcgf.search.kagi then "Kagi" else "DuckDuckGo";
          engines =
            { }
            // mkIf ffcgf.search.disableUnwanted {
              Google.metaData.hidden = true;
              Bing.metaData.hidden = true;
              eBay.metaData.hidden = true;
            }
            // mkIf ffcgf.search.kagi {
              Kagi = {
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
                iconUpdateURL = "https://kagi.com/favicon.ico";
                definedAliases = [
                  "@k"
                  "@kagi"
                ];
              };
            }
            // mkIf ffcgf.search.developer {
              GitHub = {
                name = "GitHub";
                urls = [
                  {
                    template = "https://github.com/search";
                    params = {
                      q = "{searchTerms}";
                    };
                  }
                ];
                iconUpdateURL = "https://github.githubassets.com/favicons/favicon.png";
                definedAliases = [ "@gh" ];
              };
              "Nix Config" = {
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
              "Nix Packages" = {
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
              "Nix Home Manager" = {
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
            };
          extensions =
            with pkgs.nur.repos.rycee.frefox-addons;
            [ darkreader ]
            ++ mkIf ffcgf.privacy.enable [
              clearurls
              gaoptout
              privacy-badger
            ]
            ++ mkIf ffcgf.eid [ belgium-eid ];
        };
      };
    };
  };
}
