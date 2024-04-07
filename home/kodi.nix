{ pkgs, ... }:
{
  imports = [ ./shared/global ];

  home.username = "kodi";
  home.homeDirectory = "/home/kodi";

  home.stateVersion = "23.11";

  programs = {
    zsh.shellAliases = {
      nb = "sudo nixos-rebuild switch --flake /etc/nixos#media-center";
    };
    kodi = {
      enable = true;
      package = pkgs.kodi.withPackages (
        p: with p; [
          jellyfin
          netflix
          youtube
          arteplussept
          sponsorblock
          inputstreamhelper
        ]
      );
      sources = [
        {
          name = "music";
          path = "/mnt/music/";
          allowsharing = "true";
        }
      ];
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
      };
    };
  };
}
