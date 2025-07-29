{
  lib,
  config,
  pkgs,
  ...
}:
let
  themingcfg = config.modules.theming;
in
{
  options = {
    modules.theming.enable = lib.mkEnableOption "Enable theming";
  };

  config = lib.mkIf themingcfg.enable {
    stylix = {
      enable = true;
      autoEnable = true;
      image = ./assets/mountains_dark.jpg;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
      cursor = {
        name = "catppuccin-cursors";
        package = pkgs.catppuccin-cursors.macchiatoMauve;
        size = 32;
      };
    };

    home-manager.sharedModules = [
      {
        stylix.targets = {
          waybar = {
            enable = true;
            addCss = false;
          };
          rofi.enable = false;
          # Seems to be mandatory for GTK
          gnome.enable = true;
          firefox = {
            profileNames = [ "default" ];
          };
        };
      }
    ];

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "toggle-theme" ''
                                			#!/bin/sh
                											if [ -d /run/current-system/specialisation/light ]; then
                												notify-send "Switching to Light"
                												sudo /nix/var/nix/profiles/system/specialisation/light/bin/switch-to-configuration switch
        															else
                  											notify-send "Switching to Dark"
                                        sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
                											fi
                                			'')
    ];

    security.sudo = {
      enable = true;
      extraRules = [
        {
          groups = [ "wheel" ]; # <-- Replace with your actual username
          commands = [
            {
              command = "/nix/var/nix/profiles/system/specialisation/light/bin/switch-to-configuration";
              options = [ "NOPASSWD" ];
            }
            {
              command = "/nix/var/nix/profiles/system/bin/switch-to-configuration";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };

    # Slow down system
    specialisation.light.configuration = {
      stylix = {
        image = lib.mkForce ./assets/mountains_light.jpg;
        base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";
        cursor.package = lib.mkForce pkgs.catppuccin-cursors.latteMauve;
      };

      home-manager.sharedModules = [
        {

          programs.nixvim.highlightOverride.SpellBad.bg = lib.mkForce "#cccccc";
        }
      ];
    };
  };
}
