{ inputs, pkgs, ... }:
{
  # Enable screensharing
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
  };

  # Pipewire sound
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    xserver.displayManager = {
      defaultSession = "hyprland";
      sddm.wayland.enable = true;
    };
  };

  # Allow swaylock to unlock the screen
  security.pam.services.swaylock = { };

  environment.systemPackages = with pkgs; [
    tofi
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    wl-clipboard
    hyprshot
    swaynotificationcenter
    swayidle
    swaylock-effects
    inputs.hyprsome.packages.x86_64-linux.default
  ];

  fonts.packages = with pkgs; [ font-awesome ];

  programs.hyprland.enable = true;
}
