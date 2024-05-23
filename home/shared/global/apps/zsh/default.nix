{ pkgs, config, ... }:
{

  #home.file."${config.xdg.configHome}/zsh/custom" = {
  #  source = ./custom;
  #  recursive = true;
  #};

  programs = {
    zsh = {
      enable = true;
      defaultKeymap = "emacs";
      shellAliases = {
        ls = "ls --color";
        ll = "ls -l";
        ip = "ip --color";
        nv = "nvim";
        sl = "sl -adew5F";
      };
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "plugins/sudo/sudo";
          src = pkgs.fetchFromGitHub {
            owner = "ohmyzsh";
            repo = "ohmyzsh";
            rev = "bf713e2c112ee1f0daf10deffa1215c982513f9b";
            sha256 = "jeHhYK6mSZiLWSnElYSo/8YLcLm478/u9AP8RKZ0BWw=";
          };
        }
        {
          name = "plugins/git/git";
          src = pkgs.fetchFromGitHub {
            owner = "ohmyzsh";
            repo = "ohmyzsh";
            rev = "bf713e2c112ee1f0daf10deffa1215c982513f9b";
            sha256 = "jeHhYK6mSZiLWSnElYSo/8YLcLm478/u9AP8RKZ0BWw=";
          };
        }
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "e0165eaa730dd0fa321a6a6de74f092fe87630b0";
            sha256 = "4rW2N+ankAH4sA6Sa5mr9IKsdAg7WTgrmyqJ2V1vygQ=";
          };
        }
        {
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "c3d4e576c9c86eac62884bd47c01f6faed043fc5";
            sha256 = "B+Kz3B7d97CM/3ztpQyVkE6EfMipVF8Y4HJNfSRXHtU=";
          };
        }
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.8.0";
            sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
          };
        }
        #{
        #  name = "zsh-custom";
        #  src = "${config.xdg.configHome}/zsh/custom";
        #}
      ];
      initExtra = ''
        unset ZSH_AUTOSUGGEST_USE_ASYNC
        bindkey '^[[1;5C' forward-word
        bindkey '^[[1;5D' backward-word 
        bindkey '^[[1;5A' up-line-or-search
        bindkey '^[[1;5B' down-line-or-search
        bindkey -M emacs '^[[1;5C' forward-word
        bindkey -M emacs '^[[1;5D' backward-word 
        bindkey -M emacs '^[[1;5A' up-line-or-search
        bindkey -M emacs '^[[1;5B' down-line-or-search

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
  };

  home.file.".p10k.zsh".source = ./.p10k.zsh;
}
