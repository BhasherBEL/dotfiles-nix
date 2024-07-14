{ pkgs, ... }:
{
  specialisation = {
    dark.configuration = {
      home.sessionVariables.GTK_THEME = "Adwaita:dark";
      gtk.theme = {
        name = "Adwaita:dark";
        package = pkgs.adwaita-qt;
      };
      programs = {
        kitty.theme = "Catppuccin-Macchiato";
        nixvim.colorschemes.catppuccin.settings.flavour = "macchiato";
      };
    };
    light.configuration = {
      home.sessionVariables.GTK_THEME = "Adwaita";
      gtk.theme = {
        name = "Adwaita";
        package = pkgs.adwaita-qt;
      };
      programs = {
        kitty.theme = "Catppuccin-Latte";
        nixvim.colorschemes.catppuccin.settings.flavour = "latte";
      };
    };
  };
}
