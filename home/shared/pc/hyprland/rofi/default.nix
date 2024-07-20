{ pkgs, config, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland.override {
      rofi-unwrapped = pkgs.nur.repos.bhasherbel.rofi-wayland-unwrapped;
      plugins = [
        (pkgs.rofi-calc.override { rofi-unwrapped = pkgs.nur.repos.bhasherbel.rofi-wayland-unwrapped; })
        #pkgs.rofi-emoji
      ];
    };
    terminal = "kitty";
    theme = "${config.xdg.configHome}/rofi/themes/type1-style8.rasi";
    extraConfig = {
      sorting-method = "alnum";
      sort = true;
    };
  };

  home.file = {
    "${config.xdg.configHome}/rofi/themes" = {
      source = ./themes;
      recursive = true;
    };
  };
}
