{ pkgs, ... }: {
  programs = {
    firefox = {
      enable = true;
      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = {
          "browser.toolbars.bookmarks.visibility" = "always";
          "app.shield.optoutstudies.enabled" = false;
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
        };
        #extensions = with pkgs.inputs.firefox-addons; [
        #  ublock-origin
        #  bitwarden-password-manager
        #  facebook-container
        #  "français-language-pack"
        #];
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
}
