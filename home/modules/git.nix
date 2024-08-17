{ lib, config, ... }:
let
  gitcfg = config.modules.git;
in
{
  options = {
    modules.git.enable = lib.mkEnableOption "Enable git";
  };

  config = lib.mkIf gitcfg.enable {
    programs.git = {
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
  };
}
