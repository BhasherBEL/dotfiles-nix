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
          name = "zsh-history-substring-search";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-history-substring-search";
            rev = "8dd05bfcc12b0cd1ee9ea64be725b3d9f713cf64";
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
