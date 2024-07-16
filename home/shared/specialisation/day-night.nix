{ pkgs, config, ... }:
let
  hm-specialisation = (
    pkgs.writeShellApplication {
      name = "hm-specialisation";
      runtimeInputs = with pkgs; [
        home-manager
        swww
      ];
      text = ''
        set +o errexit
        set +o nounset
        set +o pipefail

        if [ -z "$1" ]; then
        	echo "Usage: hsp <name>"
        else
        	echo "Activating specialisation $1..."
        	gen=$(home-manager generations | head -1 | awk '{ print $NF }')
        	echo "hm generation found: $gen"
        	"$gen/specialisation/$1/activate"
        	"${pkgs.swww} img ${config.xdg.configHome}/assets/backgrounds/mountains_$1.jpg --transition-type center"
        fi
      '';
    }
  );
in
{
  specialisation = {
    dark.configuration = {
      home = {
        sessionVariables.GTK_THEME = "Adwaita:dark";
        packages = [ hm-specialisation ];
      };
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
      home = {
        sessionVariables.GTK_THEME = "Adwaita";
        packages = [ hm-specialisation ];
      };
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
