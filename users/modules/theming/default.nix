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
        							notify-send "Switching to Light"
                			/nix/var/nix/profiles/system/specialisation/light/bin/switch-to-configuration switch
                			'')
    ];

    # security.sudo.extraRules = [
    #   {
    #     groups = [ "wheel" ];
    #     runAs = "root";
    #     commands = [
    #       {
    #         command = "/nix/var/nix/profiles/system/specialisation/light/bin/switch-to-configuration";
    #         options = [ "NOPASSWD" ];
    #       }
    #       {
    #         command = "/nix/var/nix/profiles/system/bin/switch-to-configuration";
    #         options = [ "NOPASSWD" ];
    #       }
    #     ];
    #   }
    # ];

    # Slow down system
    specialisation.light.configuration = {
      stylix = {
        image = lib.mkForce ./assets/mountains_light.jpg;
        base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";
      };

      environment.systemPackages = [
        (pkgs.writeShellScriptBin "toggle-theme" ''
                    						#!/bin/sh
          											notify-send "Switching to Dark"
                                /nix/var/nix/profiles/system/bin/switch-to-configuration switch
        '')
      ];
    };
  };
}
