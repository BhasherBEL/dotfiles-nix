{ pkgs, lib, ... }:
{
  imports = [ ./hyprland.nix ];

  services = {
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "gaoptout" ];

  services = {
    xserver = {
      enable = true;
      xkb.layout = "fr";
    };
    greetd.enable = true;
  };

  # Enable sound.
  #sound.enable = true;
  #nixpkgs.config.pulseaudio = true;
  #hardware.pulseaudio.enable = true;
  #hardware.pulseaudio.support32Bit = true;

  environment = {
    # Tell electron apps to use wayland
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    systemPackages = with pkgs; [
      pulseaudio
      pavucontrol
    ];
  };
}
