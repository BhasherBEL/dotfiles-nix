{
  lib,
  config,
  pkgs,
  ...
}:
let
  tmuxcfg = config.modules.tmux;
in
{
  options = {
    modules.tmux.enable = lib.mkEnableOption "Enable tmux";
  };

  config = lib.mkIf tmuxcfg.enable {
    assertions = [
      {
        assertion = config.modules.zsh.enable;
        message = "tmux requires zsh to be enabled";
      }
    ];
    programs.tmux = {
      enable = true;
      disableConfirmationPrompt = true;
      newSession = true;
      escapeTime = 0;
      clock24 = true;
      shell = "${pkgs.zsh}/bin/zsh";
      mouse = true;

      extraConfig = ''
        # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
        set -g default-terminal "xterm-256color"
        set -ga terminal-overrides ",*256col*:Tc"
        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
        set-environment -g COLORTERM "truecolor"

        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"
        set-option -g mouse on
      '';

      plugins = with pkgs; [
        tmuxPlugins.resurrect
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
          '';
        }
        tmuxPlugins.vim-tmux-navigator
      ];
    };
  };
}
