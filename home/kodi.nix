{ pkgs, ... }:
{
  home = {
    username = "kodi";
    homeDirectory = "/home/kodi";
    stateVersion = "25.11";
  };

  imports = [ ./modules ];

  modules = {
    nvim = {
      headless = true;
    };
  };

  programs = {
    kodi = {
      enable = true;
      # package = pkgs.kodi.withPackages (
      #   p: with p; [
      #     jellyfin
      #     # netflix
      #     # youtube
      #     # arteplussept
      #     # sponsorblock
      #     inputstreamhelper
      #   ]
      # );
      # sources = [
      #   {
      #     name = "music";
      #     path = "/mnt/music/";
      #     allowsharing = "true";
      #   }
      # ];
      settings = {
        gamesgeneral.enable = "false";
        lookandfeel = {
          skin = "skin.estuary";
          enablerssfeeds = "false";
        };
        locale = {
          language = "ressource.language.en_gb";
          keyboardlayouts = "English AZERTY";
          activekeyboardlayout = "English AZERTY";
          charset = "UTF-8";
          country = "UK (24h)";
          timezonecountry = "France";
          timezone = "Europe/Paris";
        };
        screensaver = {
          time = "3";
          mode = "screensaver.xbmc.builtin.dim";
        };
        subtitles = {
          languages = "original,English,French";
          downloadfirst = "true";
          tv = "service.subtitles.opensubtitles";
          movie = "service.subtitles.opensubtitles";
        };
        services.webserver = "true";
        smb.minprotocol = "2";
        audiooutput = {
          volumesteps = "20";
          streamnoise = "false";
        };
        powermanagement = {
          displayoff = "20";
          wakeonaccess = "true";
        };
        network.disablehttp2 = "true"; # Required
        loglevel = "1";
        debug = {
          extralogging = "true";
          setextraloglevel = "64,2048,32768";
        };
      };
      addonSettings = {
        "plugin.video.invidious" = {
          auto_instance = "false";
          instance_url = "https://invidious.fdn.fr";
          disable_dash = "false";
        };
      };
    };
  };
}
