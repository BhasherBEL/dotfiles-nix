{
  lib,
  config,
  pkgs,
  ...
}:
let
  zshcfg = config.modules.zsh;
in
{
  options = {
    modules.zsh.enable = lib.mkEnableOption "Enable zsh";
  };

  config = lib.mkIf zshcfg.enable {

    programs.zsh = {
      enable = true;
      defaultKeymap = "emacs";
      history.share = false;
      shellAliases = {
        ls = "ls -h --color";
        ll = "ls -lh";
        ip = "ip --color";
        nv = "nvim";
        sl = "sl -adew5F";
        firefox = "exec firefox | firefox-nightly";
      };
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "sudo";
          src = "${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/sudo";
        }
        {
          name = "git";
          src = "${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/git";
        }
        {
          name = "zsh-syntax-highlighting";
          src = "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting";
          file = "zsh-syntax-highlighting.zsh";
        }
        {
          name = "zsh-autosuggestions";
          src = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
          file = "zsh-autosuggestions.zsh";
        }
        {
          name = "nix-shell";
          src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
        }
      ];
      # TODO: Find a nix way to do this
      initExtra = ''
        unset ZSH_AUTOSUGGEST_USE_ASYNC

        autoload -U up-line-or-beginning-search
        autoload -U down-line-or-beginning-search
        zle -N up-line-or-beginning-search
        zle -N down-line-or-beginning-search

        bindkey '^[[1;5C' forward-word
        bindkey '^[[1;5D' backward-word 
        bindkey -M emacs '^[[1;5C' forward-word
        bindkey -M emacs '^[[1;5D' backward-word 

        bindkey "$key[Up]" up-line-or-beginning-search
        bindkey "$key[Down]" down-line-or-beginning-search

        setopt AUTO_PUSHD
        setopt PUSHD_MINUS

        unsetopt BEEP
        cat() {
        for arg in "$@"; do
        if [[ $arg == *.md ]]; then
        	mdcat "$arg"
        else
        	command cat "$arg"
        fi
        done
        }

        shutdown() {
        	if [ "$#" -eq 0 ]; then
        		command shutdown -P now
        	else
        		command shutdown "$@"
        	fi
        }
      '';
    };
    home = {
      file.".p10k.zsh".source = ./p10k.zsh;
    };
  };
}
