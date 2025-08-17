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
    home.packages = with pkgs; [ fzf ];

    programs.zsh = {
      enable = true;
      defaultKeymap = "emacs";
      history.share = true;
      shellAliases = {
        ls = "ls -h --color";
        ll = "ls -lh";
        ip = "ip --color";
        nv = "nvim";
        sl = "sl -adew5F";
        nbu = "echo \"nix run home-manager -- switch --flake /etc/nixos#$USERNAME\" && nix run home-manager -- switch --flake /etc/nixos#$USERNAME";
        ns = "SOPS_AGE_KEY_FILE=/etc/nixos/keys/bhasher.txt sops";
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
        {
          name = "fzf";
          src = "${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/fzf";
        }
      ];
      # TODO: Find a nix way to do this
      initContent = ''
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

                                        nb() {
                                        	local offline=false
                                        	local safe=false
                                        	local update=false
                                        	local update_only=false
                                        	local clean=false
                                        	local clean_only=false
                                        	
                                        	# Parse arguments
                                        	while [[ $# -gt 0 ]]; do
                                        		case $1 in
                                        			--offline)
                                        				offline=true
                                        				shift
                                        				;;
                                        			--safe)
                                        				safe=true
                                        				shift
                                        				;;
                                        			--update)
                                        				update=true
                                        				shift
                                        				;;
                                        			--update-only)
                                        				update_only=true
                                        				shift
                                        				;;
                                        			--clean)
                                        				clean=true
                                        				shift
                                        				;;
                                        			--clean-only)
                                        				clean_only=true
                                        				shift
                                        				;;
                                        			*)
                                        				echo "Unknown option: $1"
                                        				echo "Usage: nb [--offline] [--safe] [--update] [--update-only] [--clean] [--clean-only]"
                                        				echo "  --offline     Build without substitutes"
                                        				echo "  --safe        Ignore current specialisation"
                                        				echo "  --update      Update flake before building"
                                        				echo "  --update-only Only update flake, don't rebuild"
                                        				echo "  --clean       Clean after building"
                                        				echo "  --clean-only  Only clean, don't rebuild"
                                        				return 1
                                        				;;
                                        		esac
                                        	done
                                        	
                                        	# Handle clean-only
                                        	if [[ "$clean_only" == true ]]; then
                                        		echo "Cleaning system..."
                                        		sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d && nix-collect-garbage -d
                                        		return $?
                                        	fi
                                        	
                                        	# Handle update-only
                                        	if [[ "$update_only" == true ]]; then
                                        		echo "Updating flake..."
                                        		nix flake update --flake /etc/nixos
                                        		return $?
                                        	fi
                                        	
                                        	# Update flake if requested
                                        	if [[ "$update" == true ]]; then
                                        		echo "Updating flake..."
                                        		nix flake update --flake /etc/nixos || return 1
                                        	fi
                                        	
                                        	# Detect current specialisation
                                        	local current_spec=""
                                        	if [[ "$safe" == false ]]; then
                                						if [ ! -e /run/current-system/specialisation/light ]; then
                															current_spec="light"
        																		fi
                                        	fi
                                        	
                                        	# Build command
                                        	local cmd="nixos-rebuild switch --flake /etc/nixos#$(hostname) --sudo"
                                        	
                                        	# Add specialisation if detected and not in safe mode
                                        	if [[ -n "$current_spec" && "$safe" == false ]]; then
                                        		cmd="$cmd --specialisation $current_spec"
                                        		echo "Rebuilding with specialisation: $current_spec"
                                        	else
                                        		echo "Rebuilding default configuration"
                                        	fi
                                        	
                                        	# Add offline option
                                        	if [[ "$offline" == true ]]; then
                                        		cmd="$cmd --option substitute false"
                                        		echo "Building offline (no substitutes)"
                                        	fi
                                        	
                                        	# Execute rebuild
                                        	eval $cmd || return 1
                                        	
                                        	# Clean if requested
                                        	if [[ "$clean" == true ]]; then
                                        		echo "Cleaning system..."
                                        		sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d && nix-collect-garbage -d
                                        	fi
                                        }

                                        POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
      '';
    };
    home = {
      file.".p10k.zsh".source = ./p10k.zsh;
    };
  };
}
