{ ... }: {
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
          "privacy.clearOnShutdown.downloads" = false;
          "privacy.clearOnShutdown.formdata" = false;
          "privacy.clearOnShutdown.history" = false;
          "privacy.clearOnShutdown.offlineApps" = true;
          "privacy.clearOnShutdown.sessions" = false;
          "privacy.history.custom" = true;
          "privacy.sanitize.pending" = ''
            [{"id":"shutdown","itemsToClear":["cache","cookies","offlineApps"],"options":{}}]'';
          "privacy.sanitize.sanitizeOnShutdown" = true;
          "signon.autofillForms" = false;
        };
        search = {
          force = true;
          default = "DuckDuckGo";
        };
        #extensions = with pkgs.inputs.firefox-addons; [
        #  darkreader
        #  sidebery
        #  terms-of-service-didnt-read
        #];
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
        ];
      };
    };

  };
}
