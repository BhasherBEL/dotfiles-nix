{ pkgs, ... }:
{
  imports = [
    ./shared/global
    ./shared/pc
    #inputs.nixvim.homeManagerModules.nixvim
  ];

  home = {
    username = "bhasher";
    homeDirectory = "/home/bhasher";
    stateVersion = "23.11";
  };

  services.syncthing.enable = true;

  programs = {
    git = {
      enable = true;
      diff-so-fancy.enable = true;
      extraConfig = {
        user = {
          name = "Brieuc Dubois";
          email = "git@bhasher.com";
        };
        # TODO
        commit.gpgSign = false;
        init.defaultBranch = "master";
        gpg.program = "gpg";
        color = {
          ui = "auto";
          diff = "auto";
          status = "auto";
          branch = "auto";
        };
        help.autocorrect = 30;
        alias = {
          graph = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(bold blue)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
          s = "status";
          d = "diff";
          c = "commit";
        };
        push.default = "simple";
        pull.rebase = "true";
      };
    };
    ssh = {
      enable = true;
      matchBlocks = {
        "shp 192.168.1.221" = {
          hostname = "192.168.1.221";
          user = "shp";
          identitiesOnly = true;
          identityFile = "/run/secrets/ssh/snodes";
        };
        "kodi media-center" = {
          user = "kodi";
          hostname = "10.0.0.10";
          identitiesOnly = true;
          identityFile = "/run/secrets/ssh/snodes";
        };
        "truenas snas 192.168.1.201" = {
          user = "bhasher";
          hostname = "192.168.1.201";
          identitiesOnly = true;
          identityFile = "/run/secrets/ssh/snodes";
        };
        "vps bdubois.io" = {
          user = "debian";
          hostname = "bdubois.io";
          identitiesOnly = true;
          identityFile = "/run/secrets/ssh/ovh_vps";
        };
        "llnux" = {
          user = "docker";
          hostname = "10.0.0.1";
          port = 1234;
          identitiesOnly = true;
          identityFile = "/run/secrets/ssh/llnux";
        };
        "llnux-vpn" = {
          user = "docker";
          hostname = "192.168.30.2";
          port = 22;
          identitiesOnly = true;
          identityFile = "/run/secrets/ssh/llnux";
        };
        "llnux-ingi" = {
          user = "root";
          hostname = "kot-li-nux.info.ucl.ac.be";
          identitiesOnly = true;
          identityFile = "/run/secrets/ssh/llnux_ingi";
          proxyCommand = "ssh -q -W %h:%p ingi";
        };
        "ingi" = {
          user = "bridubois";
          hostname = "studssh.info.ucl.ac.be";
          identitiesOnly = true;
          identityFile = "/run/secrets/ssh/ingi";
        };
        "github.com" = {
          user = "shp";
          identitiesOnly = true;
          identityFile = "/run/secrets/ssh/gitkey";
        };
        "forge.uclouvain.be" = {
          user = "git";
          identitiesOnly = true;
          identityFile = "/run/secrets/ssh/gitkey";
        };
        "gitlab.com" = {
          user = "git";
          identitiesOnly = true;
          identityFile = "/run/secrets/ssh/gitlab";
        };
        "git.bhasher.com" = {
          user = "git";
          port = 2222;
          hostname = "192.168.1.221";
          identitiesOnly = true;
          identityFile = "/run/secrets/ssh/gitea";
        };
        "aur.archlinux.org" = {
          user = "aur";
          identitiesOnly = true;
          identityFile = "/run/secrets/ssh/aur";
        };
        "languagelab ll languagelab.sipr.ucl.ac.be" = {
          user = "bridubois";
          hostname = "130.104.12.159";
          identitiesOnly = true;
          identityFile = "/run/secrets/ssh/languagelab";
        };
      };
    };
    firefox = {
      enable = true;
      profiles.default = {
        settings = {
          "intl.locale.requested" = "en-GB,en-US";
          "privacy.clearOnShutdown.downloads" = true;
          "privacy.clearOnShutdown.formdata" = true;
          "privacy.clearOnShutdown.history" = true;
          "privacy.clearOnShutdown.offlineApps" = true;
          "privacy.clearOnShutdown.sessions" = true;
          "privacy.history.custom" = true;
          "privacy.sanitize.pending" = ''[{\"id\":\"newtab-container\",\"itemsToClear\":[],\"options\":{}},{\"id\":\"shutdown\",\"itemsToClear\":[\"cache\",\"cookies\",\"offlineApps\",\"history\",\"formdata\",\"downloads\",\"sessions\"],\"options\":{}}]'';
          "privacy.sanitize.sanitizeOnShutdown" = true;
          "signon.autofillForms" = false;
        };
        search = {
          force = true;
          default = "Kagi";
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
            "Meteo" = {
              urls = [ { template = "https://www.meteo.be/fr/{searchTerms}"; } ];
              iconUpdateURL = "https://www.meteo.be/favicon-192x192.png";
              definedAliases = [ "@meteo" ];
            };
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
          };
        };
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          darkreader
          sidebery
          #wappalyzer  # UNFREE
          cookie-quick-manager
          clearurls
          gaoptout
          privacy-badger
          aw-watcher-web
          #keepa  # UNFREE
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
            name = "OpenStreetMap";
            url = "https://www.openstreetmap.org";
          }
          {
            name = "Weather";
            bookmarks = [
              {
                name = "Meteo Louvain-la-Neuve";
                url = "https://www.meteo.be/fr/ottignies-louvain-la-neuve";
              }
              {
                name = "Meteo Bruxelles";
                url = "https://www.meteo.be/fr/bruxelles";
              }
              {
                name = "Pluie Louvain-la-Neuve";
                url = "https://www.accuweather.com/en/be/louvain-la-neuve/959043/minute-weather-forecast/959043";
              }
              {
                name = "Pluie Bruxelles";
                url = "https://www.accuweather.com/en/be/watermael-boitsfort/27577/weather-forecast/27577";
              }
            ];
          }
          {
            name = "Meteo Louvain-la-Neuve";
            url = "https://www.meteo.be/fr/ottignies-louvain-la-neuve";
          }
          {
            name = "Meteo Bruxelles";
            url = "https://www.meteo.be/fr/bruxelles";
          }
          {
            name = "Kagi";
            url = "https://kagi.com";
          }
          {
            name = "CUPS";
            url = "http://localhost:631/";
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
          {
            name = "UCLouvain";
            bookmarks = [
              {
                name = "INGInious";
                url = "https://inginious.info.ucl.ac.be/mycourses";
              }
              {
                name = "Moodle";
                url = "https://moodle.uclouvain.be";
              }
            ];
          }
        ];
      };
    };
  };
}
