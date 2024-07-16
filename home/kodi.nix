{ pkgs, ... }:
{
  imports = [ ./shared/global ];

  home.username = "kodi";
  home.homeDirectory = "/home/kodi";

  home.stateVersion = "23.11";

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
        push = {
          default = "simple";
          autoSetupRemote = true;
        };
        pull.rebase = "true";
      };
    };
    ssh = {
      enable = true;
      matchBlocks = {
        "github.com" = {
          user = "git";
          identitiesOnly = true;
          identityFile = "/run/secrets/ssh/gitkey";
        };
      };
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
