{ lib, config, ... }:
let
  sshcfg = config.modules.ssh;
in
{
  options = {
    modules.ssh.enable = lib.mkEnableOption "Enable ssh";
  };

  config = lib.mkIf sshcfg.enable {
    programs.ssh = {
      enable = true;
      matchBlocks = {
        "shp 192.168.0.201" = {
          hostname = "192.168.0.201";
          user = "shp";
          identitiesOnly = true;
          identityFile = "/run/secrets/ssh/snodes";
        };
        "spi 192.168.3.16" = {
          hostname = "192.168.3.16";
          user = "spi";
          identitiesOnly = true;
          identityFile = "/run/secrets/ssh/snodes";
        };
        "kodi media-center" = {
          user = "kodi";
          hostname = "192.168.0.200";
          identitiesOnly = true;
          identityFile = "/run/secrets/ssh/snodes";
        };
        "truenas snas 192.168.1.201" = {
          user = "bhasher";
          hostname = "192.168.1.201";
          identitiesOnly = true;
          identityFile = "/run/secrets/ssh/snodes";
        };
        "vps" = {
          user = "debian";
          hostname = "mail.bhasher.com";
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
          user = "git";
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
        "oa-fw" = {
          user = "bdubois";
          hostname = "192.168.0.228";
          identitiesOnly = true;
          identityFile = "/run/secrets/ssh/oa-fw";
        };
      };
    };
  };
}
