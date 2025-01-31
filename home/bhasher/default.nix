{
  config,
  lib,
  osConfig,
  ...
}:
{
  imports = [ ../modules ];

  home = {
    username = "bhasher";
    homeDirectory = "/home/bhasher";
    stateVersion = "23.11";
    file = {
      "${config.home.homeDirectory}/.face.png" = {
        source = ./assets/face.png;
      };
      "${config.xdg.configHome}/assets" = {
        source = ./assets;
        recursive = true;
      };
    };

    # TODO: Move theming to a dedicated module
    sessionVariables = {
      GTK_THEME = lib.mkDefault "Adwaita:dark";
    };

    # Conflict with stylix
    #pointerCursor = {
    #  gtk.enable = true;
    #  package = pkgs.bibata-cursors;
    #  name = "Bibata-Modern-Classic";
    #  size = 16;
    #};
  };

  gtk = {
    enable = true;
  };

  modules = {
    metaPc = {
      enable = true;
      monitors =
        if osConfig.networking.hostName == "desktop" then
          [
            #"DVI-D-1,preferred,-1080x-650,1,transform,1"
            #"HDMI-A-1,preferred,auto,1"
            #"DVI-D-1,preferred,auto-left,1"
            #"DP-1,preferred,auto-left,1"
            "DP-1,preferred,0x0,1"
            "HDMI-A-1,preferred,1920x0,1"
            "DVI-D-1,preferred,-1680x0,1"
          ]
        else if osConfig.networking.hostName == "laptop" then
          [
            "eDP-1,preferred,auto,1"
          ]
        else
          [ ];
    };

    joplin-desktop.enable = true;
    syncthing.enable = true;
    tmux.enable = true;
    firefox = {
      enable = true;
      strictPrivacy = true;
      kagiSearch = true;
      nightly = false;
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
            {
              name = "NixVim";
              url = "https://nix-community.github.io/nixvim/NeovimOptions/index.html";
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
          name = "Mistral";
          url = "https://console.mistral.ai/";
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
            {
              name = "Meteo Helsinki";
              url = "https://en.ilmatieteenlaitos.fi/local-weather";
            }
            {
              name = "Pluie Helsinki";
              url = "https://www.accuweather.com/en/fi/helsinki/133328/minute-weather-forecast/133328";
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
          name = "ActivityWatch";
          url = "http://localhost:5600";
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
            {
              name = "Maubot";
              url = "https://maubot.bhasher.com/_matrix/maubot";
            }
            {
              name = "Recipes";
              url = "https://recipes.bhasher.com";
            }
            {
              name = "Baikal";
              url = "https://baikal.bxl.bhasher.com";
            }
            {
              name = "Paperless";
              url = "https://paperless.bhasher.com";
            }
            {
              name = "PhotoStructure";
              url = "https://photos.bhasher.com";
            }
            {
              name = "OpenWebUI";
              url = "https://ai.bhasher.com";
            }
            {
              name = "Ollama";
              url = "https://ollama.bhasher.com";
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
            {
              name = "Recipes";
              url = "https://recipes.louvainlinux.org";
            }
          ];
        }
        {
          name = "LanguageLab";
          bookmarks = [
            {
              name = "Production";
              url = "https://languagelab.be";
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
        {
          name = "Aalto";
          bookmarks = [
            {
              name = "MyCourses";
              url = "https://mycourses.aalto.fi/";
            }
            {
              name = "Aalto";
              url = "https://aalto.fi";
            }
            {
              name = "Kanttiinit";
              url = "https://kanttiinit.fi";
            }
          ];
        }
      ];
    };
  };
}
