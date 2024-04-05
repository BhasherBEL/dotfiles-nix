{ pkgs, config, ... }: {
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

    file."${config.xdg.configHome}/nvim/init.lua".text =
      builtins.readFile ./init.lua;
  };
}
