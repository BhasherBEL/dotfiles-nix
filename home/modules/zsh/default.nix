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
        nb = "echo \"nixos-rebuild switch --flake /etc/nixos#$(hostname) --use-remote-sudo\" && nixos-rebuild switch --flake /etc/nixos#$(hostname) --use-remote-sudo";
        nbo = "echo \"Offline build\" && echo \"nixos-rebuild switch --flake /etc/nixos#$(hostname) --use-remote-sudo\" && nixos-rebuild switch --flake /etc/nixos#$(hostname) --use-remote-sudo --option substitute false";
        ncc = "echo \"sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d && nix-collect-garbage -d\" && sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d && nix-collect-garbage -d";
        ns = "SOPS_AGE_KEY_FILE=/etc/nixos/keys/bhasher.txt sops";
        nu = "nix flake update --flake /etc/nixos";
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

        POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
      '';
    };
    home = {
      file.".p10k.zsh".source = ./p10k.zsh;
    };
  };
}
