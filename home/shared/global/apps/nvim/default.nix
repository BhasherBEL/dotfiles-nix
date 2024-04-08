{ pkgs, config, ... }:
{
  programs = {
    neovim = {
      enable = true;
      withNodeJs = true;
      plugins = with pkgs.vimPlugins; [ lazy-nvim ];
      extraPackages = with pkgs; [ nodejs-slim ];
    };
  };

  home = {
    sessionVariables.EDITOR = "nvim";

    file = {
      "${config.xdg.configHome}/nvim" = {
        source = ./config/nvim;
        recursive = true;
      };
      "${config.xdg.configHome}/ranger	" = {
        source = ./config/ranger;
        recursive = true;
      };
      "${config.xdg.configHome}/coc	" = {
        source = ./config/coc;
        recursive = true;
      };
    };
  };
}
