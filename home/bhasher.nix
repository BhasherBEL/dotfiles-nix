{ pkgs, inputs, ... }: {
  imports = [ ./shared/global ./shared/pc ];

  home.username = "bhasher";
  home.homeDirectory = "/home/bhasher";

  home.stateVersion = "23.11";

  services.syncthing.enable = true;

  programs = {
    zsh.shellAliases = {
      nb = "sudo nixos-rebuild switch --flake /home/bhasher/sync/nixos#desktop";
    };

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
          "privacy.sanitize.pending" = ''
            [{\"id\":\"newtab-container\",\"itemsToClear\":[],\"options\":{}},{\"id\":\"shutdown\",\"itemsToClear\":[\"cache\",\"cookies\",\"offlineApps\",\"history\",\"formdata\",\"downloads\",\"sessions\",\"siteSettings\"],\"options\":{}}]'';
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
              urls = [{
                template = "https://github.com/search";
                params = { q = "{searchTerms}"; };
              }];
              iconUpdateURL =
                "https://github.githubassets.com/favicons/favicon.png";
              definedAliases = [ "@gh" ];
            };
            "Nix Packages" = {
              urls = [{
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
              }];
              icon =
                "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
            "Nix Home Manager" = {
              urls = [{
                template = "https://home-manager-options.extranix.com/";
                params = [{
                  name = "query";
                  value = "{searchTerms}";
                }];
              }];
              icon =
                "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@hm" "@nh" ];
            };
          };
        };
        #extensions = with pkgs.nur.rycee.firefox-addons;
        #  [
        #     darkreader
        #     sidebery
        #  ];
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
            name = "Gitlab KAP";
            url = "https://gitlab.com/louvainlinux";
          }
        ];
      };
    };

  };
}
