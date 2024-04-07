{ pkgs, ... }:
{
  imports = [ ./hyprland.nix ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.xserver = {
    enable = true;
    xkb.layout = "fr";
    displayManager = {
      sddm = {
        enable = true;
        autoNumlock = true;
      };
    };
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
      kitty
      pavucontrol
    ];
  };
}
