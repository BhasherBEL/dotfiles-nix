{ pkgs, inputs, ... }:
{
  imports = [
    ./shared/global
    ./shared/pc
    #inputs.nixvim.homeManagerModules.nixvim
  ];

  home.username = "bhasher";
  home.homeDirectory = "/home/bhasher";

  home.stateVersion = "23.11";

  services.syncthing.enable = true;

  programs = {
    firefox = {
      enable = true;
      profiles.default = {
        settings = {
          "browser.search.defaultenginename" = "DuckDuckGo";
          "browser.search.order.1" = "DuckDuckGo";
          "intl.locale.requested" = "en-GB,en-US";
          "privacy.clearOnShutdown.downloads" = true;
          "privacy.clearOnShutdown.formdata" = true;
          "privacy.clearOnShutdown.history" = true;
          "privacy.clearOnShutdown.offlineApps" = true;
          "privacy.clearOnShutdown.sessions" = true;
          "privacy.clearOnShutdown.siteSettings" = true;
          "privacy.history.custom" = true;
          "privacy.sanitize.pending" = ''[{\"id\":\"newtab-container\",\"itemsToClear\":[],\"options\":{}},{\"id\":\"shutdown\",\"itemsToClear\":[\"cache\",\"cookies\",\"offlineApps\",\"history\",\"formdata\",\"downloads\",\"sessions\",\"siteSettings\"],\"options\":{}}]'';
          "privacy.sanitize.sanitizeOnShutdown" = true;
          "signon.autofillForms" = false;
        };
        search = {
          force = true;
          default = "DuckDuckGo";
          engines = {
            Google.metaData.hidden = true;
            Bing.metaData.hidden = true;
            eBay.metaData.hidden = true;
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
        };
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          darkreader
          sidebery
          #wappalyzer
          cookie-quick-manager
        ];
        bookmarks = [
          {
            name = "Nix sites";
            toolbar = true;
            bookmarks = [
              {
                name = "HM Search";
                url = "https://home-manager-options.extranix.com/";
              }
              {
                name = "NixOS Search";
                url = "https://search.nixos.org/packages";
              }
            ];
          }
          {
            name = "syncthing";
            url = "https://127.0.0.1:8384";
          }
          {
            name = "Github";
            url = "https://github.com/BhasherBEL";
          }
          {
            name = "NUR";
            url = "https://nur.nix-community.org";
          }
          {
            name = "Discourse NixOS";
            url = "https://discourse.nixos.org";
          }
          {
            name = "DeepL";
            url = "https://deepl.com/translator#en/fr/";
          }
          {
            name = "Homelab";
            bookmarks = [
              {
                name = "Hub";
                url = "https://hub.bhasher.com";
              }
              {
                name = "Grafana";
                url = "https://grafana.bhasher.com";
              }
              {
                name = "Jellyfin";
                url = "https://jellyfin.bhasher.com";
              }
              {
                name = "Radarr";
                url = "https://radarr.bhasher.com";
              }
              {
                name = "Sonarr";
                url = "https://sonarr.bhasher.com";
              }
              {
                name = "Lidarr";
                url = "https://lidarr.bhasher.com";
              }
              {
                name = "Bazarr";
                url = "https://bazarr.bhasher.com";
              }
              {
                name = "Transmission";
                url = "https://transmission.bhasher.com";
              }
              {
                name = "Accounts";
                url = "https://accounts.bhasher.com";
              }
              {
                name = "Vaultwarden";
                url = "https://vault.bhasher.com";
              }
              {
                name = "Element";
                url = "https://element.bhasher.com";
              }
              {
                name = "Gitea";
                url = "https://git.bhasher.com";
              }
              {
                name = "Syncthing";
                url = "https://syncthing.bhasher.com";
              }
              {
                name = "Board";
                url = "https://board.bhasher.com";
              }
              {
                name = "Home Assistant";
                url = "https://hass.bhasher.com";
              }
              {
                name = "Invoiceplace";
                url = "https://invoice.bhasher.com";
              }
            ];
          }
          {
            name = "Louvain-li-Nux";
            bookmarks = [
              {
                name = "Hub";
                url = "https://hub.louvainlinux.org";
              }
              {
                name = "Portainer";
                url = "https://portainer.louvainlinux.org";
              }
              {
                name = "Compta";
                url = "https://compta.louvainlinux.org";
              }
              {
                name = "Board";
                url = "https://board.louvainlinux.org";
              }
              {
                name = "Gitlab";
                url = "https://gitlab.com/louvainlinux";
              }
              {
                name = "Nextcloud";
                url = "https://cloud.louvainlinux.org";
              }
              {
                name = "Vaultwarden";
                url = "https://vault.louvainlinux.org";
              }
              {
                name = "Uptime";
                url = "https://uptime.louvainlinux.org";
              }
              {
                name = "Accounts";
                url = "https://accounts.louvainlinux.org";
              }
              {
                name = "Grafana";
                url = "https://grafana.louvainlinux.org";
              }
              {
                name = "Router";
                url = "http://10.0.0.1:8443";
              }
              {
                name = "Wiki";
                url = "https://wiki.louvainlinux.org";
              }
              {
                name = "Piwigo";
                url = "https://piwigo.kapucl.be";
              }
            ];
          }
          {
            name = "LanguageLab";
            bookmarks = [
              {
                name = "Release SIPR";
                url = "http://languagelab.sipr.ucl.ac.be/";
              }
              {
                name = "Gitlab";
                url = "https://forge.uclouvain.be/sbibauw/languagelab";
              }
            ];
          }
        ];
      };
    };
  };
}
