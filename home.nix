{ config, pkgs, inputs, ... }: {
  home.username = "bhasher";
  home.homeDirectory = "/home/bhasher";

  home.stateVersion = "23.11";

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    zsh-powerlevel10k
    freetube
    signal-desktop
    font-awesome
    xorg.xlsclients
    stylua
    nixfmt
    prettierd
    ferdium
    nil
    thunderbird
    dnsutils
    asciinema
    onlyoffice-bin
    mdcat
  ];

  home.file = {
    ".p10k.zsh".text = builtins.readFile ./config/zsh-.p10k.zsh;
    "${config.xdg.configHome}/nvim/init.lua".text =
      builtins.readFile ./config/neovim-init.lua;
  };

  home.sessionVariables = {
    #EDITOR = "nvim";
    GTK_THEME = "Adwaita-dark";
  };

  services.syncthing.enable = true;

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
  };

  programs = {
    home-manager.enable = true;

    kitty = {
      shellIntegration.enableZshIntegration = true;
      settings.confirm_os_window_close = -1;
    };

    neovim = {
      enable = true;
      withNodeJs = true;
      plugins = with pkgs.vimPlugins; [ lazy-nvim ];
      extraPackages = with pkgs; [ nodejs-slim ];
    };

    zsh = {
      enable = true;
      defaultKeymap = "emacs";
      shellAliases = {
        ls = "ls --color";
        ll = "ls -l";
        ip = "ip --color";
        nv = "nvim";
        nb =
          "sudo nixos-rebuild switch --flake /home/bhasher/sync/nixos#default";
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

    waybar = { enable = true; };

    firefox = {
      enable = true;
      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = {
          "browser.search.defaultenginename" = "DuckDuckGo";
          "browser.search.order.1" = "DuckDuckGo";
          "browser.toolbars.bookmarks.visibility" = "always";
          "app.shield.optoutstudies.enabled" = false;
          "browser.contentblocking.category" = "custom";
          "browser.discovery.enabled" = false;
          "browser.download.useDownloadDir" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.showSearch" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.urlbar.placeholderName.private" = "DuckDuckGo";
          "datareporting.healthreport.uploadEnabled" = false;
          "doh-rollout.disable-heuristics" = true;
          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_ever_enabled" = true;
          "extensions.formautofill.creditCards.enabled" = false;
          "intl.locale.requested" = "en-GB,en-US";
          "media.eme.enabled" = true;
          "network.cookie.cookieBehavior" = 1;
          "network.trr.mode" = 5;
          "privacy.clearOnShutdown.downloads" = false;
          "privacy.clearOnShutdown.formdata" = false;
          "privacy.clearOnShutdown.history" = false;
          "privacy.clearOnShutdown.offlineApps" = true;
          "privacy.clearOnShutdown.sessions" = false;
          "privacy.donottrackheader.enabled" = true;
          "privacy.globalprivacycontrol.enabled" = true;
          "privacy.globalprivacycontrol.was_ever_enabled" = true;
          "privacy.history.custom" = true;
          "privacy.sanitize.pending" = ''
            [{"id":"shutdown","itemsToClear":["cache","cookies","offlineApps"],"options":{}}]'';
          "privacy.sanitize.sanitizeOnShutdown" = true;
          "signon.autofillForms" = false;
          "signon.firefoxRelay.feature" = "disabled";
          "signon.generation.enabled" = false;
          "signon.management.page.breach-alerts.enabled" = false;
          "signon.rememberSignons" = false;
        };
        search = {
          force = true;
          default = "DuckDuckGo";
        };
        bookmarks = [
          {
            name = "Nix sites";
            toolbar = true;
            bookmarks = [
              {
                name = "HM Search";
                url = "https://home-manager-options.extranix.com/";
              }
              {
                name = "NixOS Search";
                url = "https://search.nixos.org/packages";
              }
            ];
          }
          {
            name = "syncthing";
            url = "https://127.0.0.1:8384";
          }
        ];
      };
    };

  };
}
