{ inputs, pkgs, ... }: {
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable screensharing
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  # sddm wayland autostart
  services.xserver = {
    enable = true;
    xkb.layout = "fr";
    displayManager = {
      defaultSession = "hyprland";
      sddm = {
        enable = true;
        wayland.enable = true;
        autoNumlock = true;
      };
    };
  };

  # Enable sound.
  sound.enable = true;
  nixpkgs.config.pulseaudio = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;

  # Allow swaylock to unlock the screen
  security.pam.services.swaylock = { };

  environment = {
    # Tell electron apps to use wayland
    sessionVariables = { NIXOS_OZONE_WL = "1"; };

    systemPackages = with pkgs; [
      pulseaudio
      kitty
      tofi
      pavucontrol
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      wl-clipboard
      hyprshot
      swaynotificationcenter
      swayidle
      swaylock-effects
      inputs.hyprsome.packages.x86_64-linux.default
    ];
  };

  programs = {
    hyprland.enable = true;
    dconf.enable = true;
  };

}
