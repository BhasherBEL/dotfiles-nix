{ config, pkgs, ... }: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "bhasher";
  home.homeDirectory = "/home/bhasher";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
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
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".p10k.zsh".text = builtins.readFile ./config/zsh-.p10k.zsh;
    "${config.xdg.configHome}/nvim/init.lua".text =
      builtins.readFile ./config/neovim-init.lua;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/bhasher/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = { EDITOR = "nvim"; };

  services.syncthing.enable = true;

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
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ls = "ls --color";
        ll = "ls -l";
        ip = "ip --color";
        nv = "nvim";
        nb =
          "sudo nixos-rebuild switch --flake /home/bhasher/sync/nixos#default";
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
      ];
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
