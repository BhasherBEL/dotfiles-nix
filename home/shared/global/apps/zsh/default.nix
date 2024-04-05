{ pkgs, ... }: {
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
            rev = "master";
            sha256 = "YjYajT3TjxEcWWZD4k8EXZxed3vZ3mz6gr6hnbnr+dk=";
          };
        }
        {
          name = "plugins/git/git";
          src = pkgs.fetchFromGitHub {
            owner = "ohmyzsh";
            repo = "ohmyzsh";
            rev = "master";
            sha256 = "YjYajT3TjxEcWWZD4k8EXZxed3vZ3mz6gr6hnbnr+dk=";
          };
        }
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "master";
            sha256 = "4rW2N+ankAH4sA6Sa5mr9IKsdAg7WTgrmyqJ2V1vygQ=";
          };
        }
        {
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "master";
            sha256 = "B+Kz3B7d97CM/3ztpQyVkE6EfMipVF8Y4HJNfSRXHtU=";
          };
        }
        {
          name = "zsh-history-substring-search";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-history-substring-search";
            rev = "master";
            sha256 = "houujb1CrRTjhCc+dp3PRHALvres1YylgxXwjjK6VZA=";
          };
        }
      ];
      initExtra = ''
                                        unset ZSH_AUTOSUGGEST_USE_ASYNC
                                        ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=()
                        								ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(forward-char)
        																bindkey '^[[A' history-substring-search-up
        																bindkey '^[[B' history-substring-search-down

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

  home.file.".p10k.zsh".text = builtins.readFile ./.p10k.zsh;
}
